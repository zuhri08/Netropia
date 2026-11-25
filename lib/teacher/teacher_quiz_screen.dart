import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TeacherQuizScreen extends StatefulWidget {
  const TeacherQuizScreen({super.key});

  @override
  State<TeacherQuizScreen> createState() => _TeacherQuizScreenState();
}

class _TeacherQuizScreenState extends State<TeacherQuizScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _quizQuestionController = TextEditingController();
  final _quizOptionAController = TextEditingController();
  final _quizOptionBController = TextEditingController();
  final _quizOptionCController = TextEditingController();
  final _quizOptionDController = TextEditingController();

  int _quizCorrectAnswerIndex = 0;
  String _quizType = 'pre_test';
  String _selectedMateriForQuiz = 'Dasar Jaringan';

  final List<String> _materiOptions = [
    'Dasar Jaringan',
    'K3',
    'Komponen Komputer',
    'Perangkat Jaringan',
    'IP Address',
    'Kabel Jaringan',
  ];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _quizQuestionController.dispose();
    _quizOptionAController.dispose();
    _quizOptionBController.dispose();
    _quizOptionCController.dispose();
    _quizOptionDController.dispose();
    super.dispose();
  }

  void _showMessage(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppTheme.accentRed : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _createQuizQuestion() async {
    final question = _quizQuestionController.text.trim();
    final optA = _quizOptionAController.text.trim();
    final optB = _quizOptionBController.text.trim();
    final optC = _quizOptionCController.text.trim();
    final optD = _quizOptionDController.text.trim();

    if (question.isEmpty || optA.isEmpty || optB.isEmpty || optC.isEmpty || optD.isEmpty) {
      _showMessage('Semua bidang soal dan 4 pilihan jawaban harus diisi.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final docRef = _firestore.collection('custom_quizzes').doc();

      await docRef.set({
        'id': docRef.id,
        'question': question,
        'options': [optA, optB, optC, optD],
        'answer': _quizCorrectAnswerIndex,
        'type': _quizType,
        'materiTitle': _selectedMateriForQuiz,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _quizQuestionController.clear();
      _quizOptionAController.clear();
      _quizOptionBController.clear();
      _quizOptionCController.clear();
      _quizOptionDController.clear();

      _showMessage('Soal kuis baru berhasil ditambahkan!');
    } catch (e) {
      _showMessage('Gagal menambahkan soal: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Kelola Kuis & Hasil Ujian', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.quiz_rounded, color: AppTheme.primaryTeal),
                        SizedBox(width: 8),
                        Text(
                          'Tambah Soal Kuis Baru',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Tipe Kuis', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _quizType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'pre_test', child: Text('Pre-Test')),
                        DropdownMenuItem(value: 'post_test', child: Text('Post-Test')),
                        DropdownMenuItem(value: 'evaluasi', child: Text('Evaluasi Akhir')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _quizType = val);
                      },
                    ),
                    const SizedBox(height: 14),
                    const Text('Topik Materi', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedMateriForQuiz,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      items: _materiOptions.map((m) => DropdownMenuItem(value: m, child: Text(m, overflow: TextOverflow.ellipsis))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedMateriForQuiz = val);
                      },
                    ),
                    const SizedBox(height: 14),
                    const Text('Pertanyaan / Soal', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _quizQuestionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Tuliskan kalimat soal...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Pilihan Jawaban (Pilih Kunci Jawaban):', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildOptionInput('A', _quizOptionAController, 0),
                    const SizedBox(height: 8),
                    _buildOptionInput('B', _quizOptionBController, 1),
                    const SizedBox(height: 8),
                    _buildOptionInput('C', _quizOptionCController, 2),
                    const SizedBox(height: 8),
                    _buildOptionInput('D', _quizOptionDController, 3),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _createQuizQuestion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        label: Text(_isSubmitting ? 'Menyimpan...' : 'Simpan Soal Ke Database Kuis'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'DAFTAR SOAL KUIS BUATAN GURU',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('custom_quizzes').orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: Text('Belum ada soal kuis buatan guru.', style: TextStyle(color: Colors.grey))),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final typeLabel = data['type'] == 'pre_test' ? 'Pre-Test' : (data['type'] == 'post_test' ? 'Post-Test' : 'Evaluasi');
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: data['type'] == 'pre_test' ? Colors.orange.shade100 : Colors.green.shade100,
                          child: Text(typeLabel[0], style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        title: Text(data['question'] ?? 'Soal', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Tipe: $typeLabel • Topik: ${data['materiTitle']} • Kunci: Opsi #${(data['answer'] ?? 0) + 1}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppTheme.accentRed),
                          onPressed: () async {
                            await _firestore.collection('custom_quizzes').doc(docs[index].id).delete();
                            _showMessage('Soal dihapus.');
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            _buildQuizResultsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionInput(String label, TextEditingController controller, int index) {
    final isSelected = _quizCorrectAnswerIndex == index;
    return Row(
      children: [
        Radio<int>(
          value: index,
          groupValue: _quizCorrectAnswerIndex,
          activeColor: AppTheme.primaryTeal,
          onChanged: (val) {
            if (val != null) setState(() => _quizCorrectAnswerIndex = val);
          },
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Jawaban $label ${isSelected ? '(KUNCI JAWABAN)' : ''}',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: isSelected ? AppTheme.primaryTeal : Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HASIL PRE-TEST & POST-TEST SISWA',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('quiz_results')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];
            if (docs.isEmpty) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'Belum ada hasil kuis yang dikumpulkan oleh siswa.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final namaSiswa = data['namaSiswa'] ?? 'Siswa';
                final kelas = data['kelas'] ?? '-';
                final materiTitle = data['materiTitle'] ?? 'Kuis';
                final testType = data['testType'] ?? 'Tes';
                final score = data['score'] ?? 0;
                final correct = data['correct'] ?? 0;
                final total = data['totalQuestions'] ?? 25;
                final cheatCount = data['cheatViolations'] ?? 0;
                final isCheated = cheatCount > 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: score >= 75 ? Colors.green.shade100 : Colors.orange.shade100,
                              child: Text(
                                '$score',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: score >= 75 ? Colors.green.shade900 : Colors.orange.shade900,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$namaSiswa ($kelas)',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$testType: $materiTitle • Benar $correct dari $total',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isCheated ? AppTheme.accentRed.withOpacity(0.12) : Colors.green.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isCheated ? '⚠️ Curang ($cheatCount x)' : '✅ Jujur',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isCheated ? AppTheme.accentRed : Colors.green.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (isCheated) ...[
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.accentRed.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppTheme.accentRed.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, color: AppTheme.accentRed, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Peringatan: Siswa terdeteksi keluar dari layar kuis sebanyak $cheatCount kali saat tes!',
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.accentRed),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
