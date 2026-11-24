import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';

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
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        nama = userData['nama'] ?? '';
        nisn = userData['nisn'] ?? '';
        kelas = userData['kelas'] ?? '';
      }

      final sessionSnapshot = await firestore
          .collection('attendance_sessions')
          .where('kelas', isEqualTo: kelas)
          .where('status', isEqualTo: 'open')
          .get();

      activeSessions = sessionSnapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      final historySnapshot = await firestore
          .collection('attendance_records')
          .where('siswaId', isEqualTo: user.uid)
          .get();

      final docs = [...historySnapshot.docs];
      attendanceHistory = docs.map((doc) => doc.data()).toList();

      if (mounted) setState(() => isLoading = false);
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> submitAttendance() async {
    final inputCode = codeController.text.trim().toUpperCase();
    if (inputCode.isEmpty) {
      showMessage('Masukkan atau scan kode absensi terlebih dahulu.');
      return;
    }

    final user = auth.currentUser;
    if (user == null) return;

    setState(() => isSubmitting = true);

    try {
      final codeQuery = await firestore
          .collection('attendance_sessions')
          .where('kode', isEqualTo: inputCode)
          .limit(1)
          .get();

      if (codeQuery.docs.isEmpty) {
        showMessage('Kode absensi "$inputCode" tidak ditemukan.');
        return;
      }

      final sessionDoc = codeQuery.docs.first;
      final sessionData = sessionDoc.data();
      final sessionId = sessionDoc.id;

      final now = DateTime.now();
      final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
      final months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];

      final hari = days[now.weekday - 1];
      final tanggal = now.day;
      final bulan = months[now.month - 1];
      final tahun = now.year;
      final jam = now.hour.toString().padLeft(2, '0');
      final menit = now.minute.toString().padLeft(2, '0');
      final detik = now.second.toString().padLeft(2, '0');
      final formatWaktuLengkap = '$hari, $tanggal $bulan $tahun - $jam:$menit:$detik WIB';

      final recordId = '${sessionId}_${user.uid}';
      final recordRef = firestore.collection('attendance_records').doc(recordId);

      await recordRef.set({
        'sessionId': sessionId,
        'siswaId': user.uid,
        'nama': nama,
        'nisn': nisn,
        'kelas': kelas,
        'mataPelajaran': sessionData['mataPelajaran'] ?? '',
        'pertemuan': sessionData['pertemuan'] ?? '1',
        'materi': sessionData['materi'] ?? '',
        'waktu': FieldValue.serverTimestamp(),
        'hari': hari,
        'tanggal': tanggal,
        'bulan': bulan,
        'tahun': tahun,
        'jam': jam,
        'menit': menit,
        'detik': detik,
        'formatWaktuLengkap': formatWaktuLengkap,
        'status': 'hadir',
      });

      codeController.clear();
      if (mounted) {
        showMessage('Absensi berhasil! Kamu tercatat HADIR.');
      }
      await loadAttendanceData();
    } catch (e) {
      if (mounted) showMessage('Gagal melakukan absensi: $e');
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  int countStatus(String status) {
    return attendanceHistory.where((item) => item['status'] == status).length;
  }

  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _showQrScannerModal() {
    final TextEditingController qrInputCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.borderCream, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text(
              'Scan QR Code Presensi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryBrown),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pindai QR Code dari layar HP Guru atau masukkan kode yang tertera di QR.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.brownTint,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryBrown.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.qr_code_scanner_rounded, size: 70, color: AppTheme.primaryBrown),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: qrInputCtrl,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'Masukkan 6 Digit Kode QR (Contoh: ABC123)',
                prefixIcon: const Icon(Icons.qr_code_2_rounded, color: AppTheme.primaryBrown),
                filled: true,
                fillColor: AppTheme.surfaceCream,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  final code = qrInputCtrl.text.trim();
                  if (code.isNotEmpty) {
                    codeController.text = code;
                    Navigator.pop(context);
                    submitAttendance();
                  }
                },
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text('Gunakan Kode QR Ini', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('Absensi Siswa', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppTheme.primaryBrown,
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.qr_code_scanner_rounded),
                tooltip: 'Scan QR Presensi',
                onPressed: _showQrScannerModal,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryBrown))
              : RefreshIndicator(
                  color: AppTheme.primaryBrown,
                  onRefresh: loadAttendanceData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // PROFILE CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppTheme.primaryBrown, AppTheme.darkBrown],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.18),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama.isEmpty ? 'azer' : nama,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '$nisn · $kelas',
                                      style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // SUMMARY
                        Text(
                          'RINGKASAN KEHADIRAN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: buildSummaryCard('Hadir', countStatus('hadir'), isDark)),
                            const SizedBox(width: 8),
                            Expanded(child: buildSummaryCard('Izin', countStatus('izin'), isDark)),
                            const SizedBox(width: 8),
                            Expanded(child: buildSummaryCard('Sakit', countStatus('sakit'), isDark)),
                            const SizedBox(width: 8),
                            Expanded(child: buildSummaryCard('Alpa', countStatus('alpa'), isDark)),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // SCAN QR BUTTON / CODE INPUT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'MASUKKAN KODE / SCAN QR',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                                color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _showQrScannerModal,
                              icon: const Icon(Icons.qr_code_scanner_rounded, size: 16),
                              label: const Text('Scan QR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              style: TextButton.styleFrom(foregroundColor: AppTheme.primaryBrown),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: codeController,
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark),
                          decoration: InputDecoration(
                            hintText: 'Contoh: TKJ1025',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.qr_code_scanner_rounded, color: AppTheme.primaryBrown),
                              onPressed: _showQrScannerModal,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: AppTheme.borderCream),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: isSubmitting ? null : submitAttendance,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBrown,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Absen Sekarang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // RIWAYAT ABSENSI
                        Text(
                          'RIWAYAT ABSENSI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (attendanceHistory.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('Belum ada riwayat absensi.', style: TextStyle(color: AppTheme.textMuted, fontSize: 12.5)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget buildSummaryCard(String title, int value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : AppTheme.borderCream,
        ),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}
