import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../theme/app_theme.dart';

class TeacherGradebookScreen extends StatefulWidget {
  const TeacherGradebookScreen({super.key});

  @override
  State<TeacherGradebookScreen> createState() => _TeacherGradebookScreenState();
}

class _TeacherGradebookScreenState extends State<TeacherGradebookScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedGradebookClass = 'X TKJ 1';

  final List<String> _classOptions = [
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

  Future<void> _exportGradebookToPdf(List<QueryDocumentSnapshot> students) async {
    final quizSnap = await _firestore
        .collection('quiz_results')
        .where('kelas', isEqualTo: _selectedGradebookClass)
        .get();
    final quizMap = <String, Map<String, dynamic>>{};
    for (final doc in quizSnap.docs) {
      final d = doc.data();
      final uid = d['siswaId']?.toString() ?? doc.id;
      quizMap[uid] = d;
    }

    final assignmentSnap = await _firestore
        .collection('assignment_submissions')
        .where('kelas', isEqualTo: _selectedGradebookClass)
        .get();
    final assignmentMap = <String, Map<String, dynamic>>{};
    for (final doc in assignmentSnap.docs) {
      final d = doc.data();
      final uid = d['siswaId']?.toString() ?? doc.id;
      assignmentMap[uid] = d;
    }

    final projectSnap = await _firestore
        .collection('project_submissions')
        .where('kelas', isEqualTo: _selectedGradebookClass)
        .get();
    final projectMap = <String, Map<String, dynamic>>{};
    for (final doc in projectSnap.docs) {
      final d = doc.data();
      final uid = d['siswaId']?.toString() ?? doc.id;
      projectMap[uid] = d;
    }

    final attendanceSnap = await _firestore
        .collection('attendance_records')
        .where('kelas', isEqualTo: _selectedGradebookClass)
        .get();
    final attendanceCountMap = <String, int>{};
    for (final doc in attendanceSnap.docs) {
      final d = doc.data();
      final uid = d['siswaId']?.toString() ?? '';
      if (uid.isNotEmpty) {
        attendanceCountMap[uid] = (attendanceCountMap[uid] ?? 0) + 1;
      }
    }

    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';

    double totalClassScore = 0;
    int ratedStudentsCount = 0;

    final tableData = students.asMap().entries.map((entry) {
      final idx = entry.key + 1;
      final data = entry.value.data() as Map<String, dynamic>;
      final uid = entry.value.id;

      final name = data['nama']?.toString() ?? 'Siswa';
      final nisn = data['nisn']?.toString() ?? '-';

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

      final int attendCount = attendanceCountMap[uid] ?? 0;

      int activeScores = 0;
      int scoreSum = 0;
      if (qData != null) { scoreSum += quizScore; activeScores++; }
      if (aData?['nilai'] != null) { scoreSum += taskScore; activeScores++; }
      if (pData?['nilai'] != null) { scoreSum += projScore; activeScores++; }

      final double avg = activeScores > 0 ? (scoreSum / activeScores) : 0;
      if (activeScores > 0) {
        totalClassScore += avg;
        ratedStudentsCount++;
      }

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
        qData != null ? '$quizScore' : '-',
        taskStatus,
        projStatus,
        '$attendCount Hadir',
        cheatStatus,
        activeScores > 0 ? avg.toStringAsFixed(1) : '-',
        predikat,
      ];
    }).toList();

    final double classAvg = ratedStudentsCount > 0 ? (totalClassScore / ratedStudentsCount) : 0;

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
                          'REKAPITULASI NILAI & CAPAIAN HASIL BELAJAR SISWA',
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
                        pw.Text('Kelas: $_selectedGradebookClass', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                        pw.Text('Cetak: $dateStr', style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.white)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Siswa: ${students.length} Orang', style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold)),
                  pw.Text('Rata-Rata Kelas: ${classAvg.toStringAsFixed(1)} / 100', style: pw.TextStyle(fontSize: 9.5, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF1F5C56))),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headers: [
                  'No',
                  'Nama Siswa',
                  'NISN',
                  'Kuis',
                  'Tugas',
                  'Project',
                  'Presensi',
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
                  3: const pw.FlexColumnWidth(1.0),
                  4: const pw.FlexColumnWidth(1.2),
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
      name: 'Rekap_Nilai_$_selectedGradebookClass.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Rekap Nilai & Apresiasi', style: TextStyle(fontWeight: FontWeight.bold)),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.picture_as_pdf_rounded, color: AppTheme.primaryTeal),
                        SizedBox(width: 8),
                        Text('Export Rekap Nilai & Presensi (PDF)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text('Pilih kelas untuk mengekspor rekap siswa ke dokumen PDF resmi.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedGradebookClass,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            items: _classOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedGradebookClass = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        StreamBuilder<QuerySnapshot>(
                          stream: _firestore.collection('users').where('kelas', isEqualTo: _selectedGradebookClass).snapshots(),
                          builder: (context, snapshot) {
                            final students = snapshot.data?.docs ?? [];
                            return ElevatedButton.icon(
                              onPressed: students.isEmpty ? null : () => _exportGradebookToPdf(students),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryTeal,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.print_rounded, size: 18),
                              label: const Text('Export PDF'),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildAttendanceRecordsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceRecordsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.event_available_rounded, color: AppTheme.primaryTeal),
            SizedBox(width: 8),
            Text(
              'Daftar Presensi Lengkap Siswa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Detail riwayat presensi siswa lengkap dengan waktu presisi (Hari, Tgl, Bulan, Tahun - Jam:Menit:Detik WIB).',
          style: TextStyle(fontSize: 12.5, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('attendance_records')
              .orderBy('waktu', descending: true)
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
                      'Belum ada data presensi siswa.',
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
                final namaSiswa = data['nama'] ?? 'Siswa';
                final nisnSiswa = data['nisn'] ?? '-';
                final kelasSiswa = data['kelas'] ?? '-';
                final mapel = data['mataPelajaran'] ?? '-';
                final formatWaktu = data['formatWaktuLengkap']?.toString();
                final waktuVal = data['waktu'];

                String fullTimeStr = formatWaktu ?? '';
                if (fullTimeStr.isEmpty && waktuVal is Timestamp) {
                  final dt = waktuVal.toDate();
                  final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
                  final months = [
                    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
                    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
                  ];
                  final hari = days[dt.weekday - 1];
                  final tgl = dt.day;
                  final bln = months[dt.month - 1];
                  final thn = dt.year;
                  final jam = dt.hour.toString().padLeft(2, '0');
                  final mnt = dt.minute.toString().padLeft(2, '0');
                  final det = dt.second.toString().padLeft(2, '0');
                  fullTimeStr = '$hari, $tgl $bln $thn - $jam:$mnt:$det WIB';
                }

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(Icons.check_rounded, color: Colors.green, size: 20),
                    ),
                    title: Text(
                      '$namaSiswa ($kelasSiswa)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text('NISN: $nisnSiswa • Mapel: $mapel', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 13, color: AppTheme.primaryTeal),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                fullTimeStr.isEmpty ? 'Baru saja' : fullTimeStr,
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.primaryTeal),
                              ),
                            ),
                          ],
                        ),
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
