import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../theme/app_theme.dart';

class TeacherResultsScreen extends StatefulWidget {
  const TeacherResultsScreen({super.key});

  @override
  State<TeacherResultsScreen> createState() => _TeacherResultsScreenState();
}

class _TeacherResultsScreenState extends State<TeacherResultsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedClassFilter = 'Semua Kelas';

  final List<String> _classOptions = [
    'Semua Kelas',
    'X TKJ 1',
    'X TKJ 2',
    'X TKJ 3',
    'XI TKJ 1',
    'XI TKJ 2',
    'XI TKJ 3',
    'XII TKJ 1',
    'XII TKJ 2',
    'XII TKJ 3',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _exportResultsToPdf() async {
    final pdf = pw.Document();

    final QuerySnapshot studentsSnap = _selectedClassFilter == 'Semua Kelas'
        ? await _firestore.collection('users').where('role', isEqualTo: 'siswa').get()
        : await _firestore.collection('users').where('kelas', isEqualTo: _selectedClassFilter).get();

    final students = studentsSnap.docs;

    final quizSnap = await _firestore.collection('quiz_results').get();
    final quizMap = <String, Map<String, dynamic>>{};
    for (final doc in quizSnap.docs) {
      final d = doc.data() as Map<String, dynamic>;
      final uid = d['siswaId']?.toString() ?? doc.id;
      quizMap[uid] = d;
    }

    final assignmentSnap = await _firestore.collection('assignment_submissions').get();
    final assignmentMap = <String, Map<String, dynamic>>{};
    for (final doc in assignmentSnap.docs) {
      final d = doc.data() as Map<String, dynamic>;
      final uid = d['siswaId']?.toString() ?? doc.id;
      assignmentMap[uid] = d;
    }

    final projectSnap = await _firestore.collection('project_submissions').get();
    final projectMap = <String, Map<String, dynamic>>{};
    for (final doc in projectSnap.docs) {
      final d = doc.data() as Map<String, dynamic>;
      final uid = d['siswaId']?.toString() ?? doc.id;
      projectMap[uid] = d;
    }

    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';

    final tableData = students.asMap().entries.map((entry) {
      final idx = entry.key + 1;
      final data = entry.value.data() as Map<String, dynamic>;
      final uid = entry.value.id;

      final name = data['nama']?.toString() ?? 'Siswa';
      final nisn = data['nisn']?.toString() ?? '-';
      final kelasStr = data['kelas']?.toString() ?? _selectedClassFilter;

      final qData = quizMap[uid];
      final int quizScore = (qData?['score'] as num?)?.toInt() ?? 0;
      final int cheatCount = (qData?['cheatViolations'] as num?)?.toInt() ?? 0;
      final String cheatStatus = qData == null
          ? 'Belum'
          : (cheatCount > 0 ? 'Curang ($cheatCount x)' : 'Jujur');

      final aData = assignmentMap[uid];
      final int taskScore = (aData?['nilai'] as num?)?.toInt() ?? 0;
      final String taskStatus = aData != null
          ? (aData['nilai'] != null ? '$taskScore' : 'Terkumpul')
          : 'Belum';

      final pData = projectMap[uid];
      final int projScore = (pData?['nilai'] as num?)?.toInt() ?? 0;
      final String projStatus = pData != null
          ? (pData['nilai'] != null ? '$projScore' : 'Terkumpul')
          : 'Belum';

      int activeScores = 0;
      int scoreSum = 0;
      if (qData != null) { scoreSum += quizScore; activeScores++; }
      if (aData?['nilai'] != null) { scoreSum += taskScore; activeScores++; }
      if (pData?['nilai'] != null) { scoreSum += projScore; activeScores++; }

      final double avg = activeScores > 0 ? (scoreSum / activeScores) : 0;

      String predikat = '-';
      if (avg >= 85) {
        predikat = 'Sangat Baik (A)';
      } else if (avg >= 75) {
        predikat = 'Baik (B)';
      } else if (avg >= 60) {
        predikat = 'Cukup (C)';
      } else if (activeScores > 0) {
        predikat = 'Perlu Bimbingan';
      }

      return [
        '$idx',
        name,
        nisn,
        kelasStr,
        qData != null ? '$quizScore' : '-',
        taskStatus,
        projStatus,
        cheatStatus,
        activeScores > 0 ? avg.toStringAsFixed(1) : '-',
        predikat,
      ];
    }).toList();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFF1F5C56),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'LAPORAN REKAPITULASI HASIL KUIS, TUGAS, & PROJECT SISWA',
                          style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Text(
                          'NETROPIA - Media Pembelajaran Interaktif TKJ SMK',
                          style: const pw.TextStyle(fontSize: 9, color: PdfColors.white),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Kelas: $_selectedClassFilter', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                        pw.Text('Cetak: $dateStr', style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.white)),
                      ],
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 12),

              pw.TableHelper.fromTextArray(
                headers: [
                  'No',
                  'Nama Siswa',
                  'NISN',
                  'Kelas',
                  'Kuis',
                  'Tugas',
                  'Project',
                  'Kejujuran',
                  'Rata2',
                  'Predikat',
                ],
                data: tableData,
                border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8.5),
                headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF0E3B37)),
                cellStyle: const pw.TextStyle(fontSize: 8),
                cellAlignment: pw.Alignment.centerLeft,
                columnWidths: {
                  0: const pw.FixedColumnWidth(20),
                  1: const pw.FlexColumnWidth(2.5),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.2),
                  4: const pw.FlexColumnWidth(1.0),
                  5: const pw.FlexColumnWidth(1.2),
                  6: const pw.FlexColumnWidth(1.2),
                  7: const pw.FlexColumnWidth(1.6),
                  8: const pw.FlexColumnWidth(1.0),
                  9: const pw.FlexColumnWidth(1.8),
                },
              ),

              pw.SizedBox(height: 20),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('Guru Mata Pelajaran TKJ,', style: const pw.TextStyle(fontSize: 9.5)),
                    pw.SizedBox(height: 30),
                    pw.Text('________________________', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9.5)),
                    pw.Text('NIP / NUPTK: ________________', style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Laporan_Hasil_$_selectedClassFilter.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Hasil Kuis & Tugas Siswa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded),
            tooltip: 'Cetak / Unduh PDF Laporan',
            onPressed: _exportResultsToPdf,
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.quiz_rounded), text: 'Hasil Kuis'),
            Tab(icon: Icon(Icons.assignment_turned_in_rounded), text: 'Pengumpulan Tugas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQuizResultsTab(),
          _buildTaskSubmissionsTab(),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          const Icon(Icons.filter_list_rounded, color: AppTheme.primaryBrown, size: 20),
          const SizedBox(width: 10),
          const Text('Filter Kelas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedClassFilter,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _classOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedClassFilter = val);
              },
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TAB 1: HASIL KUIS (PRE-TEST & POST-TEST)
  // =========================================================
  Widget _buildQuizResultsTab() {
    return Column(
      children: [
        _buildFilterDropdown(),
        const Divider(height: 1),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('quiz_results')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allDocs = snapshot.data?.docs ?? [];
              final docs = _selectedClassFilter == 'Semua Kelas'
                  ? allDocs
                  : allDocs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['kelas']?.toString() == _selectedClassFilter;
                    }).toList();

              if (docs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Belum ada hasil kuis yang masuk.', style: TextStyle(color: AppTheme.textMuted)),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
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
                                      style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isCheated ? AppTheme.accentRed.withValues(alpha: 0.12) : Colors.green.withValues(alpha: 0.12),
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
                                color: AppTheme.accentRed.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.accentRed.withValues(alpha: 0.3)),
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
        ),
      ],
    );
  }

  // =========================================================
  // TAB 2: PENGUMPULAN TUGAS SISWA
  // =========================================================
  Widget _buildTaskSubmissionsTab() {
    return Column(
      children: [
        _buildFilterDropdown(),
        const Divider(height: 1),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('assignment_submissions')
                .orderBy('submittedAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final allDocs = snapshot.data?.docs ?? [];
              final docs = _selectedClassFilter == 'Semua Kelas'
                  ? allDocs
                  : allDocs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return data['kelas']?.toString() == _selectedClassFilter;
                    }).toList();

              if (docs.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Belum ada pengumpulan tugas dari siswa.', style: TextStyle(color: AppTheme.textMuted)),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final subDocId = docs[index].id;
                  final siswaName = data['siswaName'] ?? 'Siswa';
                  final kelas = data['kelas'] ?? '-';
                  final materiTitle = data['materiTitle'] ?? 'Tugas';
                  final jawaban = data['jawaban'] ?? '';
                  final nilai = data['nilai'];
                  final catatanGuru = data['catatanGuru'] ?? '';
                  final fileUrl = data['fileUrl']?.toString();
                  final fileName = data['fileName']?.toString() ?? 'Foto Bukti';

                  final nilaiController = TextEditingController(text: nilai?.toString() ?? '');
                  final catatanController = TextEditingController(text: catatanGuru);

                  Uint8List? imageBytes;
                  if (fileUrl != null && fileUrl.contains('data:image')) {
                    try {
                      final base64String = fileUrl.split(',').last;
                      imageBytes = base64Decode(base64String);
                    } catch (_) {}
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.primaryBrown,
                                child: const Icon(Icons.person_rounded, size: 18, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$siswaName ($kelas)',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Tugas: $materiTitle',
                                      style: const TextStyle(fontSize: 12, color: AppTheme.textMuted),
                                    ),
                                  ],
                                ),
                              ),
                              if (nilai != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Nilai: $nilai/100',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          const Divider(height: 20),
                          Text('Jawaban Siswa:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                          const SizedBox(height: 2),
                          Text('"$jawaban"', style: const TextStyle(fontSize: 13, height: 1.4)),
                          const SizedBox(height: 12),

                          // Foto / File Attachment Preview
                          if (imageBytes != null) ...[
                            const Text('Foto Bukti Jawaban Siswa:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBrown)),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                imageBytes,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ] else if (fileUrl != null) ...[
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.brownTint,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.attach_file_rounded, color: AppTheme.primaryBrown, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(fileName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          Row(
                            children: [
                              SizedBox(
                                width: 100,
                                child: TextField(
                                  controller: nilaiController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Nilai (0-100)',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: catatanController,
                                  decoration: const InputDecoration(
                                    labelText: 'Catatan Guru (Opsional)',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                final gradeVal = int.tryParse(nilaiController.text.trim());
                                final noteVal = catatanController.text.trim();

                                await _firestore.collection('assignment_submissions').doc(subDocId).update({
                                  'nilai': gradeVal,
                                  'catatanGuru': noteVal,
                                });

                                if (mounted) {
                                  _showMessage('Nilai berhasil disimpan untuk $siswaName!');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBrown,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.check_rounded, size: 16),
                              label: const Text('Simpan Nilai'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
