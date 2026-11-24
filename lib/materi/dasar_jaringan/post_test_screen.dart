import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/quiz_data.dart';
import '../../services/progress_service.dart';
import '../../theme/app_theme.dart';

class PostTestScreen extends StatefulWidget {
  final String materiId;
  final String materiTitle;
  final Color themeColor;

  const PostTestScreen({
    super.key,
    this.materiId = 'dasar_jaringan',
    this.materiTitle = 'Dasar Jaringan',
    this.themeColor = AppTheme.primaryBrown,
  });

  @override
  State<PostTestScreen> createState() => _PostTestScreenState();
}

class _PostTestScreenState extends State<PostTestScreen> with WidgetsBindingObserver {
  int _currentQuestion = 0;
  late final List<Map<String, dynamic>> _questions;
  late final List<int?> _answers;
  int _cheatViolations = 0;

  // Countdown Timer
  Timer? _timer;
  int _remainingSeconds = 600; // 10 menit
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _questions = QuizData.getPostTestQuestions(widget.materiId);
    _answers = List<int?>.filled(_questions.length, null);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        _timer?.cancel();
        if (!_isSubmitted && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Waktu ujian telah habis! Jawaban otomatis dikumpulkan.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          _showResult();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _triggerCheatAlert();
    }
  }

  void _triggerCheatAlert() {
    if (_isSubmitted) return;
    _cheatViolations++;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.accentRed, size: 28),
            SizedBox(width: 8),
            Text(
              'DETEKSI KECURANGAN!',
              style: TextStyle(color: AppTheme.accentRed, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kamu terdeteksi meninggalkan layar ujian / membuka aplikasi atau tab lain (Pelanggaran ke-$_cheatViolations).',
              style: const TextStyle(fontSize: 13, height: 1.4, color: AppTheme.textDark),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.accentRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Aktivitas kecurangan ini telah dicatat ke database Guru!',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentRed),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Saya Mengerti'),
          ),
        ],
      ),
    );
  }

  bool get _isLastQuestion => _currentQuestion == _questions.length - 1;

  int get _correctCount {
    int count = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i]['answer']) {
        count++;
      }
    }
    return count;
  }

  int get _wrongCount => _questions.length - _correctCount;

  int get _score {
    if (_questions.isEmpty) return 0;
    return ((_correctCount / _questions.length) * 100).round();
  }

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _selectAnswer(int index) {
    setState(() {
      _answers[_currentQuestion] = index;
    });
  }

  void _nextQuestion() {
    if (_answers[_currentQuestion] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih salah satu jawaban untuk melanjutkan.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_isLastQuestion) {
      _showResult();
    } else {
      setState(() {
        _currentQuestion++;
      });
    }
  }

  Future<void> _saveQuizResultToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final userData = userDoc.data() ?? {};

      final String nama = userData['nama']?.toString() ?? 'Siswa';
      final String nisn = userData['nisn']?.toString() ?? '-';
      final String kelas = userData['kelas']?.toString() ?? 'X TKJ 1';

      final docRef = FirebaseFirestore.instance.collection('quiz_results').doc();

      await docRef.set({
        'id': docRef.id,
        'siswaId': user.uid,
        'namaSiswa': nama,
        'nisn': nisn,
        'kelas': kelas,
        'materiId': widget.materiId,
        'materiTitle': widget.materiTitle,
        'testType': 'Post-Test',
        'score': _score,
        'correct': _correctCount,
        'wrong': _wrongCount,
        'totalQuestions': _questions.length,
        'cheatViolations': _cheatViolations,
        'isCheated': _cheatViolations > 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving quiz result to firestore: $e');
    }
  }

  void _showResult() async {
    if (_isSubmitted) return;
    _isSubmitted = true;
    _timer?.cancel();

    await _saveQuizResultToFirestore();

    ProgressService().setLessonCompleted('${widget.materiId}_post_test', true);
    ProgressService().saveActivity(
      title: 'Post Test - ${widget.materiTitle}',
      subtitle: 'Skor: $_score / 100',
      time: 'Baru saja',
      type: 'post_test',
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PostTestResultScreen(
          score: _score,
          correct: _correctCount,
          wrong: _wrongCount,
          questions: _questions,
          answers: _answers,
          materiId: widget.materiId,
          materiTitle: widget.materiTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Post-Test - ${widget.materiTitle}')),
        body: const Center(child: Text('Tidak ada soal tersedia.')),
      );
    }

    final question = _questions[_currentQuestion];
    final options = question['options'] as List<String>;
    final selectedAnswer = _answers[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Post-Test - ${widget.materiTitle}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Timer Widget
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _remainingSeconds < 60 ? AppTheme.accentRed : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_rounded, size: 16, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  _formatTimer(_remainingSeconds),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Text(
                '${_currentQuestion + 1}/${_questions.length}',
                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: AppTheme.borderCream,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentAmber),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.brownTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.materiTitle.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.primaryBrown,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    question['question'],
                    style: TextStyle(
                      color: isDark ? Colors.white : AppTheme.textDark,
                      fontSize: 17,
                      height: 1.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pilih satu jawaban yang paling tepat.',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(
                    options.length,
                    (index) {
                      final label = String.fromCharCode(65 + index);
                      final isSelected = selectedAnswer == index;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.brownTint
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryBrown : AppTheme.borderCream,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => _selectAnswer(index),
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppTheme.primaryBrown : AppTheme.surfaceCream,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : AppTheme.textDark,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      options[index],
                                      style: TextStyle(
                                        color: isSelected ? AppTheme.primaryBrown : (isDark ? Colors.white : AppTheme.textDark),
                                        fontSize: 13.5,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: const Border(top: BorderSide(color: AppTheme.borderCream)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_isLastQuestion ? 'Selesai' : 'Selanjutnya', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 6),
                    Icon(_isLastQuestion ? Icons.check_rounded : Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostTestResultScreen extends StatelessWidget {
  final int score;
  final int correct;
  final int wrong;
  final List<Map<String, dynamic>> questions;
  final List<int?> answers;
  final String materiId;
  final String materiTitle;

  const PostTestResultScreen({
    super.key,
    required this.score,
    required this.correct,
    required this.wrong,
    required this.questions,
    required this.answers,
    required this.materiId,
    required this.materiTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Hasil Post-Test - $materiTitle', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderCream),
              ),
              child: Column(
                children: [
                  Text(
                    '$score',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.primaryBrown),
                  ),
                  const Text('Skor Akhir', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('$correct', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                          const Text('Benar', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('$wrong', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.accentRed)),
                          const Text('Salah', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali ke Modul'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
