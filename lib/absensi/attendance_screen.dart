import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // =========================================================
  // FIREBASE
  // =========================================================

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // =========================================================
  // CONTROLLER
  // =========================================================

  final TextEditingController codeController = TextEditingController();

  // =========================================================
  // STATE
  // =========================================================

  bool isLoading = true;
  bool isSubmitting = false;

  // =========================================================
  // DATA SISWA
  // =========================================================

  String nama = '';
  String nisn = '';
  String kelas = '';

  // =========================================================
  // DATA ABSENSI
  // =========================================================

  List<Map<String, dynamic>> activeSessions = [];
  List<Map<String, dynamic>> attendanceHistory = [];

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();
    loadAttendanceData();
  }

  // =========================================================
  // LOAD DATA ABSENSI
  // =========================================================

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
      debugPrint('====================================');
      debugPrint('MULAI LOAD ABSENSI');
      debugPrint('UID: ${user.uid}');
      debugPrint('====================================');

      // -------------------------------------------------------
      // 1. AMBIL DATA SISWA
      // -------------------------------------------------------

      debugPrint('MULAI QUERY USER');

      final userDoc = await firestore
          .collection('users')
          .doc(user.uid)
          .get();

      debugPrint('QUERY USER BERHASIL');

      if (!userDoc.exists) {
        throw Exception(
          'Data siswa tidak ditemukan.',
        );
      }

      final userData = userDoc.data()!;

      nama = userData['nama'] ?? '';
      nisn = userData['nisn'] ?? '';
      kelas = userData['kelas'] ?? '';

      debugPrint('========== DATA USER ==========');
      debugPrint('UID   : ${user.uid}');
      debugPrint('NAMA  : $nama');
      debugPrint('NISN  : $nisn');
      debugPrint('KELAS : $kelas');
      debugPrint('ROLE  : ${userData['role']}');
      debugPrint('===============================');

      // -------------------------------------------------------
      // 2. AMBIL SESI ABSENSI AKTIF
      // -------------------------------------------------------

      debugPrint(
        'MULAI QUERY ATTENDANCE SESSION',
      );

      final sessionSnapshot = await firestore
          .collection('attendance_sessions')
          .where(
        'kelas',
        isEqualTo: kelas,
      )
          .where(
        'status',
        isEqualTo: 'open',
      )
          .orderBy(
        'startTime',
        descending: true,
      )
          .get();

      debugPrint(
        'QUERY SESSION BERHASIL: '
            '${sessionSnapshot.docs.length} data',
      );

      activeSessions = sessionSnapshot.docs.map((doc) {
        final data = doc.data();

        return {
          'id': doc.id,
          ...data,
        };
      }).toList();

      // -------------------------------------------------------
      // 3. AMBIL RIWAYAT ABSENSI
      // -------------------------------------------------------

      debugPrint(
        'MULAI QUERY ATTENDANCE HISTORY',
      );

      final historySnapshot = await firestore
          .collection('attendance_records')
          .where(
        'siswaId',
        isEqualTo: user.uid,
      )
          .orderBy(
        'waktu',
        descending: true,
      )
          .limit(30)
          .get();

      debugPrint(
        'QUERY HISTORY BERHASIL: '
            '${historySnapshot.docs.length} data',
      );

      attendanceHistory =
          historySnapshot.docs.map((doc) {
            final data = doc.data();

            return {
              'id': doc.id,
              ...data,
            };
          }).toList();

      debugPrint('====================================');
      debugPrint('LOAD ABSENSI SELESAI');
      debugPrint('====================================');

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('====================================');
      debugPrint('ERROR LOAD ABSENSI: $e');
      debugPrint('====================================');

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        showMessage(
          'Gagal memuat data absensi.',
        );
      }
    }
  }

  // =========================================================
  // SUBMIT ABSENSI
  // =========================================================

  Future<void> submitAttendance() async {
    final user = auth.currentUser;

    if (user == null) {
      showMessage(
        'Silakan login terlebih dahulu.',
      );
      return;
    }

    final code = codeController.text
        .trim()
        .toUpperCase();

    if (code.isEmpty) {
      showMessage(
        'Masukkan kode absensi terlebih dahulu.',
      );
      return;
    }

    if (code.length < 4) {
      showMessage(
        'Kode absensi tidak valid.',
      );
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      // -------------------------------------------------------
      // CARI SESI BERDASARKAN KODE
      // -------------------------------------------------------

      final sessionSnapshot = await firestore
          .collection('attendance_sessions')
          .where(
        'kode',
        isEqualTo: code,
      )
          .where(
        'kelas',
        isEqualTo: kelas,
      )
          .where(
        'status',
        isEqualTo: 'open',
      )
          .limit(1)
          .get();

      if (sessionSnapshot.docs.isEmpty) {
        showMessage(
          'Kode absensi tidak ditemukan '
              'atau sudah ditutup.',
        );
        return;
      }

      final sessionDoc =
          sessionSnapshot.docs.first;

      final sessionData =
      sessionDoc.data();

      final sessionId =
          sessionDoc.id;

      // -------------------------------------------------------
      // BUAT ID RECORD
      // -------------------------------------------------------

      final recordId =
          '${sessionId}_${user.uid}';

      final recordRef = firestore
          .collection('attendance_records')
          .doc(recordId);

      // -------------------------------------------------------
      // CEK SUDAH ABSEN ATAU BELUM
      // -------------------------------------------------------

      final existingRecord =
      await recordRef.get();

      if (existingRecord.exists) {
        showMessage(
          'Kamu sudah melakukan absensi '
              'pada sesi ini.',
        );
        return;
      }

      // -------------------------------------------------------
      // SIMPAN ABSENSI
      // -------------------------------------------------------

      await recordRef.set({
        'sessionId': sessionId,
        'siswaId': user.uid,
        'nama': nama,
        'nisn': nisn,
        'kelas': kelas,
        'mataPelajaran':
        sessionData['mataPelajaran'] ?? '',
        'materi':
        sessionData['materi'] ?? '',
        'pertemuan':
        sessionData['pertemuan'] ?? '',
        'waktu':
        FieldValue.serverTimestamp(),
        'status': 'hadir',
      });

      codeController.clear();

      if (mounted) {
        showMessage(
          'Absensi berhasil! Kamu tercatat HADIR.',
        );
      }

      // Refresh data
      await loadAttendanceData();
    } catch (e) {
      debugPrint(
        'ERROR SUBMIT ABSENSI: $e',
      );

      if (mounted) {
        showMessage(
          'Gagal melakukan absensi: $e',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  // =========================================================
  // HITUNG STATUS ABSENSI
  // =========================================================

  int countStatus(String status) {
    return attendanceHistory.where((item) {
      return item['status'] == status;
    }).length;
  }

  // =========================================================
  // FORMAT TANGGAL
  // =========================================================

  String formatDate(dynamic value) {
    if (value is! Timestamp) {
      return '-';
    }

    final date = value.toDate().toLocal();

    final day =
    date.day.toString().padLeft(2, '0');

    final month =
    date.month.toString().padLeft(2, '0');

    final year =
    date.year.toString();

    final hour =
    date.hour.toString().padLeft(2, '0');

    final minute =
    date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year • $hour:$minute';
  }

  // =========================================================
  // LABEL STATUS
  // =========================================================

  String statusLabel(String status) {
    switch (status) {
      case 'hadir':
        return 'Hadir';

      case 'izin':
        return 'Izin';

      case 'sakit':
        return 'Sakit';

      case 'alpa':
        return 'Alpa';

      default:
        return status;
    }
  }

  // =========================================================
  // ICON STATUS
  // =========================================================

  IconData statusIcon(String status) {
    switch (status) {
      case 'hadir':
        return Icons.check_circle;

      case 'izin':
        return Icons.assignment;

      case 'sakit':
        return Icons.healing;

      case 'alpa':
        return Icons.cancel;

      default:
        return Icons.help_outline;
    }
  }

  // =========================================================
  // SNACKBAR
  // =========================================================

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
        behavior:
        SnackBarBehavior.floating,
      ),
    );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Absensi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh:
        loadAttendanceData,
        child:
        SingleChildScrollView(
          physics:
          const AlwaysScrollableScrollPhysics(),
          padding:
          const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =========================================
              // PROFIL SISWA
              // =========================================

              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.all(20),
                decoration:
                BoxDecoration(
                  gradient:
                  const LinearGradient(
                    colors: [
                      Color(0xFF1565C0),
                      Color(0xFF1976D2),
                    ],
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration:
                      BoxDecoration(
                        color: Colors.white
                            .withOpacity(
                          0.18,
                        ),
                        shape:
                        BoxShape.circle,
                      ),
                      child:
                      const Icon(
                        Icons.person,
                        color:
                        Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child:
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            nama.isEmpty
                                ? 'Siswa'
                                : nama,
                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                              fontSize:
                              19,
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '$nisn • $kelas',
                            style:
                            const TextStyle(
                              color:
                              Colors.white70,
                              fontSize:
                              13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // =========================================
              // RINGKASAN
              // =========================================

              const Text(
                'Ringkasan Kehadiran',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              Row(
                children: [
                  Expanded(
                    child:
                    buildSummaryCard(
                      'Hadir',
                      countStatus(
                        'hadir',
                      ),
                      Icons
                          .check_circle,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child:
                    buildSummaryCard(
                      'Izin',
                      countStatus(
                        'izin',
                      ),
                      Icons.assignment,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child:
                    buildSummaryCard(
                      'Sakit',
                      countStatus(
                        'sakit',
                      ),
                      Icons.healing,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child:
                    buildSummaryCard(
                      'Alpa',
                      countStatus(
                        'alpa',
                      ),
                      Icons.cancel,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 28,
              ),

              // =========================================
              // ABSENSI AKTIF
              // =========================================

              const Text(
                'Absensi Aktif',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              if (activeSessions
                  .isEmpty)
                buildEmptyCard(
                  icon: Icons
                      .event_available,
                  title:
                  'Belum ada absensi',
                  subtitle:
                  'Belum ada sesi absensi '
                      'yang dibuka untuk '
                      'kelas $kelas.',
                )
              else
                ...activeSessions.map(
                      (session) =>
                      buildActiveSessionCard(
                        session,
                      ),
                ),

              const SizedBox(
                height: 28,
              ),

              // =========================================
              // INPUT KODE
              // =========================================

              const Text(
                'Masukkan Kode Absensi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              TextField(
                controller:
                codeController,
                textCapitalization:
                TextCapitalization
                    .characters,
                decoration:
                const InputDecoration(
                  hintText:
                  'Contoh: TKJ1025',
                  prefixIcon:
                  Icon(
                    Icons.qr_code_2,
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              SizedBox(
                width:
                double.infinity,
                height: 52,
                child:
                ElevatedButton.icon(
                  onPressed:
                  isSubmitting
                      ? null
                      : submitAttendance,
                  icon: isSubmitting
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(
                      strokeWidth:
                      2,
                      color:
                      Colors.white,
                    ),
                  )
                      : const Icon(
                    Icons
                        .how_to_reg,
                  ),
                  label: Text(
                    isSubmitting
                        ? 'Memproses...'
                        : 'Absen Sekarang',
                    style:
                    const TextStyle(
                      fontWeight:
                      FontWeight
                          .bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              // =========================================
              // RIWAYAT ABSENSI
              // =========================================

              const Text(
                'Riwayat Absensi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              if (attendanceHistory
                  .isEmpty)
                buildEmptyCard(
                  icon: Icons.history,
                  title:
                  'Belum ada riwayat',
                  subtitle:
                  'Riwayat kehadiran '
                      'kamu akan muncul '
                      'di sini.',
                )
              else
                ...attendanceHistory.map(
                      (record) =>
                      buildHistoryCard(
                        record,
                      ),
                ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SUMMARY CARD
  // =========================================================

  Widget buildSummaryCard(
      String title,
      int value,
      IconData icon,
      ) {
    return Container(
      padding:
      const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 8,
      ),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05),
            blurRadius: 8,
            offset:
            const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color:
            const Color(0xFF1565C0),
            size: 25,
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            value.toString(),
            style:
            const TextStyle(
              fontSize: 20,
              fontWeight:
              FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            title,
            style:
            const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ACTIVE SESSION CARD
  // =========================================================

  Widget buildActiveSessionCard(
      Map<String, dynamic> session,
      ) {
    return Container(
      width: double.infinity,
      margin:
      const EdgeInsets.only(
        bottom: 12,
      ),
      padding:
      const EdgeInsets.all(18),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: const Color(
            0xFF1565C0,
          ).withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),
            blurRadius: 8,
            offset:
            const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.all(
                  10,
                ),
                decoration:
                BoxDecoration(
                  color:
                  const Color(
                    0xFFE3F2FD,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    12,
                  ),
                ),
                child: const Icon(
                  Icons.fact_check,
                  color:
                  Color(0xFF1565C0),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  session[
                  'mataPelajaran'] ??
                      'Absensi Pembelajaran',
                  style:
                  const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration:
                BoxDecoration(
                  color:
                  Colors.green.shade50,
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),
                child: Text(
                  'DIBUKA',
                  style: TextStyle(
                    color:
                    Colors.green.shade700,
                    fontSize: 10,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            session['materi'] ??
                'Materi pembelajaran',
            style:
            const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Pertemuan: '
                '${session['pertemuan'] ?? '-'}',
            style:
            const TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // HISTORY CARD
  // =========================================================

  Widget buildHistoryCard(
      Map<String, dynamic> record,
      ) {
    final status =
        record['status'] ?? '';

    return Container(
      width: double.infinity,
      margin:
      const EdgeInsets.only(
        bottom: 10,
      ),
      padding:
      const EdgeInsets.all(16),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),
            blurRadius: 7,
            offset:
            const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration:
            BoxDecoration(
              color:
              const Color(
                0xFFE3F2FD,
              ),
              borderRadius:
              BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              statusIcon(status),
              color:
              const Color(
                0xFF1565C0,
              ),
            ),
          ),
          const SizedBox(
            width: 13,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  record[
                  'mataPelajaran'] ??
                      'Pembelajaran',
                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  record['materi'] ??
                      '-',
                  style:
                  const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  formatDate(
                    record['waktu'],
                  ),
                  style:
                  const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            statusLabel(status),
            style:
            const TextStyle(
              color:
              Color(0xFF1565C0),
              fontWeight:
              FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // EMPTY CARD
  // =========================================================

  Widget buildEmptyCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(25),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 45,
            color:
            Colors.grey.shade400,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            title,
            style:
            const TextStyle(
              fontWeight:
              FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            subtitle,
            textAlign:
            TextAlign.center,
            style:
            const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}