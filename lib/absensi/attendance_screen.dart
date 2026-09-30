import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController codeController = TextEditingController();

  bool isLoading = true;
  bool isSubmitting = false;

  String nama = '';
  String nisn = '';
  String kelas = '';

  List<Map<String, dynamic>> activeSessions = [];
  List<Map<String, dynamic>> attendanceHistory = [];

  @override
  void initState() {
    super.initState();
    loadAttendanceData();
  }

  Future<void> loadAttendanceData() async {
    final user = auth.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }

    try {
      final userDoc = await firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('Data siswa tidak ditemukan.');
      }

      final userData = userDoc.data()!;
      nama = userData['nama'] ?? '';
      nisn = userData['nisn'] ?? '';
      kelas = userData['kelas'] ?? '';

      final sessionSnapshot = await firestore
          .collection('attendance_sessions')
          .where('kelas', isEqualTo: kelas)
          .where('status', isEqualTo: 'open')
          .orderBy('startTime', descending: true)
          .get();

      activeSessions = sessionSnapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, ...data};
      }).toList();

      final historySnapshot = await firestore
          .collection('attendance_records')
          .where('siswaId', isEqualTo: user.uid)
          .get();

      final docs = [...historySnapshot.docs];

      docs.sort((a, b) {
        final aTime = a.data()['waktu'] as Timestamp?;
        final bTime = b.data()['waktu'] as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      attendanceHistory = docs.map((doc) => doc.data()).toList();

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> submitAttendance() async {
    final inputCode = codeController.text.trim().toUpperCase();

    if (inputCode.isEmpty) {
      showMessage(localizationService.isEnglish ? 'Enter attendance code first.' : 'Masukkan kode absensi terlebih dahulu.');
      return;
    }

    final user = auth.currentUser;

    if (user == null) {
      showMessage(localizationService.isEnglish ? 'Please log in first.' : 'Silakan login terlebih dahulu.');
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      final sessionQuery = await firestore
          .collection('attendance_sessions')
          .where('code', isEqualTo: inputCode)
          .where('status', isEqualTo: 'open')
          .limit(1)
          .get();

      if (sessionQuery.docs.isEmpty) {
        showMessage(localizationService.isEnglish ? 'Attendance code invalid or session closed.' : 'Kode absensi tidak valid atau sesi sudah ditutup.');
        return;
      }

      final sessionDoc = sessionQuery.docs.first;
      final sessionData = sessionDoc.data();
      final sessionId = sessionDoc.id;
      final sessionKelas = sessionData['kelas'] ?? '';

      if (kelas.isNotEmpty && sessionKelas.isNotEmpty && kelas != sessionKelas) {
        showMessage(localizationService.isEnglish ? 'This session is not for your class.' : 'Sesi absensi ini bukan untuk kelas kamu.');
        return;
      }

      final recordId = '${sessionId}_${user.uid}';
      final recordRef = firestore.collection('attendance_records').doc(recordId);
      final existingRecord = await recordRef.get();

      if (existingRecord.exists) {
        showMessage(localizationService.isEnglish ? 'You have already recorded attendance for this session.' : 'Kamu sudah melakukan absensi pada sesi ini.');
        return;
      }

      await recordRef.set({
        'sessionId': sessionId,
        'siswaId': user.uid,
        'nama': nama,
        'nisn': nisn,
        'kelas': kelas,
        'mataPelajaran': sessionData['mataPelajaran'] ?? '',
        'materi': sessionData['materi'] ?? '',
        'pertemuan': sessionData['pertemuan'] ?? '',
        'waktu': FieldValue.serverTimestamp(),
        'status': 'hadir',
      });

      codeController.clear();

      if (mounted) {
        showMessage(localizationService.isEnglish ? 'Attendance recorded! Status: PRESENT.' : 'Absensi berhasil! Kamu tercatat HADIR.');
      }

      await loadAttendanceData();
    } catch (e) {
      if (mounted) {
        showMessage('Gagal melakukan absensi: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  int countStatus(String status) {
    return attendanceHistory.where((item) => item['status'] == status).length;
  }

  String formatDate(dynamic value) {
    if (value is! Timestamp) {
      return '-';
    }

    final date = value.toDate().toLocal();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year • $hour:$minute';
  }

  String statusLabel(String status) {
    if (localizationService.isEnglish) {
      switch (status) {
        case 'hadir': return 'Present';
        case 'izin': return 'Permission';
        case 'sakit': return 'Sick';
        case 'alpa': return 'Absent';
        default: return status;
      }
    }
    switch (status) {
      case 'hadir': return 'Hadir';
      case 'izin': return 'Izin';
      case 'sakit': return 'Sakit';
      case 'alpa': return 'Alpa';
      default: return status;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case 'hadir': return Icons.check_circle;
      case 'izin': return Icons.assignment;
      case 'sakit': return Icons.healing;
      case 'alpa': return Icons.cancel;
      default: return Icons.help_outline;
    }
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              localizationService.translate('attendance'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFAD8B73),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFAD8B73)))
              : RefreshIndicator(
                  color: const Color(0xFFAD8B73),
                  onRefresh: loadAttendanceData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PROFIL SISWA
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFAD8B73), Color(0xFFCEAB93)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.18),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person, color: Colors.white, size: 32),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama.isEmpty ? 'Siswa' : nama,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '$nisn • $kelas',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // RINGKASAN
                        Text(
                          localizationService.isEnglish ? 'Attendance Summary' : 'Ringkasan Kehadiran',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(child: buildSummaryCard(localizationService.isEnglish ? 'Present' : 'Hadir', countStatus('hadir'), Icons.check_circle)),
                            const SizedBox(width: 10),
                            Expanded(child: buildSummaryCard(localizationService.isEnglish ? 'Permit' : 'Izin', countStatus('izin'), Icons.assignment)),
                            const SizedBox(width: 10),
                            Expanded(child: buildSummaryCard(localizationService.isEnglish ? 'Sick' : 'Sakit', countStatus('sakit'), Icons.healing)),
                            const SizedBox(width: 10),
                            Expanded(child: buildSummaryCard(localizationService.isEnglish ? 'Absent' : 'Alpa', countStatus('alpa'), Icons.cancel)),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // ABSENSI AKTIF
                        Text(
                          localizationService.isEnglish ? 'Active Session' : 'Absensi Aktif',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (activeSessions.isEmpty)
                          buildEmptyCard(
                            icon: Icons.event_available,
                            title: localizationService.isEnglish ? 'No active session' : 'Belum ada absensi',
                            subtitle: localizationService.isEnglish ? 'No attendance session opened for class $kelas.' : 'Belum ada sesi absensi yang dibuka untuk kelas $kelas.',
                          )
                        else
                          ...activeSessions.map((session) => buildActiveSessionCard(session)),

                        const SizedBox(height: 28),

                        // INPUT KODE
                        Text(
                          localizationService.isEnglish ? 'Enter Attendance Code' : 'Masukkan Kode Absensi',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextField(
                          controller: codeController,
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                          decoration: InputDecoration(
                            hintText: localizationService.isEnglish ? 'Example: TKJ1025' : 'Contoh: TKJ1025',
                            prefixIcon: const Icon(Icons.qr_code_2),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: isSubmitting ? null : submitAttendance,
                            icon: isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.how_to_reg),
                            label: Text(
                              isSubmitting
                                  ? (localizationService.isEnglish ? 'Processing...' : 'Memproses...')
                                  : (localizationService.isEnglish ? 'Check In Now' : 'Absen Sekarang'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // RIWAYAT ABSENSI
                        Text(
                          localizationService.isEnglish ? 'Attendance History' : 'Riwayat Absensi',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (attendanceHistory.isEmpty)
                          buildEmptyCard(
                            icon: Icons.history,
                            title: localizationService.isEnglish ? 'No history yet' : 'Belum ada riwayat',
                            subtitle: localizationService.isEnglish ? 'Your attendance history will appear here.' : 'Riwayat kehadiran kamu akan muncul di sini.',
                          )
                        else
                          ...attendanceHistory.map((record) => buildHistoryCard(record)),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget buildSummaryCard(String title, int value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFAD8B73), size: 25),
          const SizedBox(height: 7),
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget buildActiveSessionCard(Map<String, dynamic> session) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFAD8B73).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFAD8B73).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.fact_check, color: Color(0xFFAD8B73)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  session['mataPelajaran'] ?? (localizationService.isEnglish ? 'Attendance Session' : 'Absensi Pembelajaran'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildEmptyCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildHistoryCard(Map<String, dynamic> record) {
    final status = record['status']?.toString() ?? 'hadir';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(statusIcon(status), color: const Color(0xFFAD8B73), size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record['mataPelajaran'] ?? (localizationService.isEnglish ? 'Attendance' : 'Absensi'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatDate(record['waktu']),
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFAD8B73).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              statusLabel(status),
              style: const TextStyle(
                color: Color(0xFFAD8B73),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
