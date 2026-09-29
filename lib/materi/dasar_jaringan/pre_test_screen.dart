import 'package:flutter/material.dart';
import '../../data/quiz_data.dart';
import '../../services/progress_service.dart';

class PreTestScreen extends StatefulWidget {
  final String materiId;
  final String materiTitle;
  final Color themeColor;

  const PreTestScreen({
    super.key,
    this.materiId = 'dasar_jaringan',
    this.materiTitle = 'Dasar Jaringan',
    this.themeColor = const Color(0xFF00838F),
  });

  @override
  State<PreTestScreen> createState() => _PreTestScreenState();
}

class _PreTestScreenState extends State<PreTestScreen> {
  int _currentQuestion = 0;
  late final List<Map<String, dynamic>> _questions;
  late final List<int?> _answers;

  @override
  void initState() {
    super.initState();
    _questions = QuizData.getPreTestQuestions(widget.materiId);
    _answers = List<int?>.filled(_questions.length, null);
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

  void _selectAnswer(int index) {
    setState(() {
      _answers[_currentQuestion] = index;
    });
  }

  void _nextQuestion() {
    if (_answers[_currentQuestion] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih salah satu jawaban terlebih dahulu.'),
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

  void _previousQuestion() {
    if (_currentQuestion == 0) return;
    setState(() {
      _currentQuestion--;
    });
  }

  void _showResult() {
    ProgressService().setLessonCompleted('${widget.materiId}_pre_test', true);
    ProgressService().saveActivity(
      title: 'Pre Test - ${widget.materiTitle}',
      subtitle: 'Skor: $_score / 100',
      time: 'Baru saja',
      type: 'pre_test',
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PreTestResultScreen(
          score: _score,
          correct: _correctCount,
          wrong: _wrongCount,
          questions: _questions,
          answers: _answers,
          materiId: widget.materiId,
          materiTitle: widget.materiTitle,
          themeColor: widget.themeColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Pre Test - ${widget.materiTitle}')),
        body: const Center(child: Text('Tidak ada soal tersedia.')),
      );
    }

    final question = _questions[_currentQuestion];
    final options = question['options'] as List<String>;
    final selectedAnswer = _answers[_currentQuestion];

    final progress = (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172B4D),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: Text(
          'Pre Test - ${widget.materiTitle}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                '${_currentQuestion + 1} / ${_questions.length}',
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            minHeight: 3,
            backgroundColor: const Color(0xFFE9EDF2),
            valueColor: AlwaysStoppedAnimation<Color>(widget.themeColor),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.materiTitle.toUpperCase(),
                    style: TextStyle(
                      color: widget.themeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    question['question'],
                    style: const TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 18,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ...List.generate(
                    options.length,
                    (index) {
                      return _AnswerOption(
                        label: String.fromCharCode(65 + index),
                        text: options[index],
                        selected: selectedAnswer == index,
                        themeColor: widget.themeColor,
                        onTap: () => _selectAnswer(index),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE9EDF2),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_currentQuestion > 0) ...[
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _previousQuestion,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF475467),
                    side: const BorderSide(
                      color: Color(0xFFD0D5DD),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 19,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.themeColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLastQuestion ? 'Selesai' : 'Berikutnya',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isLastQuestion
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                        size: 19,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String label;
  final String text;
  final bool selected;
  final Color themeColor;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.label,
    required this.text,
    required this.selected,
    required this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: selected ? themeColor.withOpacity(0.10) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? themeColor : const Color(0xFFE1E6EC),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? themeColor : const Color(0xFFF2F4F7),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF667085),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: selected ? themeColor : const Color(0xFF344054),
                        fontSize: 13,
                        height: 1.45,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                if (selected) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.check_circle_rounded,
                    color: themeColor,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PreTestResultScreen extends StatelessWidget {
  final int score;
  final int correct;
  final int wrong;
  final List<Map<String, dynamic>> questions;
  final List<int?> answers;
  final String materiId;
  final String materiTitle;
  final Color themeColor;

  const PreTestResultScreen({
    super.key,
    required this.score,
    required this.correct,
    required this.wrong,
    required this.questions,
    required this.answers,
    this.materiId = 'dasar_jaringan',
    this.materiTitle = 'Dasar Jaringan',
    this.themeColor = const Color(0xFF00838F),
  });

  String get _message {
    if (score >= 80) {
      return 'Kamu sudah memiliki pemahaman awal yang sangat baik untuk materi $materiTitle.';
    }
    if (score >= 60) {
      return 'Kamu sudah memiliki beberapa pengetahuan dasar $materiTitle. Mari perdalam lagi melalui modul pembelajaran.';
    }
    return 'Tidak masalah. Gunakan hasil pre test ini sebagai gambaran awal sebelum mempelajari materi $materiTitle.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF172B4D),
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          'Hasil Pre Test - $materiTitle',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Pre Test Selesai',
                    style: TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    materiTitle,
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 130,
                          height: 130,
                          child: CircularProgressIndicator(
                            value: score / 100,
                            strokeWidth: 9,
                            backgroundColor: const Color(0xFFE9EDF2),
                            valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$score',
                              style: const TextStyle(
                                color: Color(0xFF172B4D),
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              '/ 100',
                              style: TextStyle(
                                color: Color(0xFF98A2B3),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _ResultItem(
                          value: '$correct',
                          label: 'Benar',
                          icon: Icons.check_rounded,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ResultItem(
                          value: '$wrong',
                          label: 'Salah',
                          icon: Icons.close_rounded,
                          color: const Color(0xFFC62828),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ResultItem(
                          value: '${questions.length}',
                          label: 'Soal',
                          icon: Icons.assignment_outlined,
                          color: themeColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: themeColor,
                    size: 21,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _message,
                      style: const TextStyle(
                        color: Color(0xFF344054),
                        fontSize: 12.5,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Kembali ke $materiTitle',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PreTestScreen(
                        materiId: materiId,
                        materiTitle: materiTitle,
                        themeColor: themeColor,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: themeColor,
                  side: BorderSide(color: themeColor.withOpacity(0.4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Ulangi Pre Test',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ResultItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _ResultItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
