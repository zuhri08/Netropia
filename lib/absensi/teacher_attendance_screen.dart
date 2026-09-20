import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState
    extends State<TeacherAttendanceScreen> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final TextEditingController _subjectController =
  TextEditingController();

  final TextEditingController _materialController =
  TextEditingController();

  final TextEditingController _meetingController =
  TextEditingController();

  final List<String> _classOptions = [
    'X TKJ 1',
    'X TKJ 2',
    'X TKJ 3',
  ];

  String? _selectedClass;

  bool _loading = true;

  String? _activeSessionId;
  String? _activeCode;
  String? _activeClass;
  String? _activeSubject;
  String? _activeMaterial;
  String? _activeMeeting;

  @override
  void initState() {
    super.initState();
    _checkActiveSession();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _materialController.dispose();
    _meetingController.dispose();
    super.dispose();
  }

  // =========================================================
  // CEK ABSENSI AKTIF
  // =========================================================

  Future<void> _checkActiveSession() async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          _loading = false;
        });

        return;
      }

      final snapshot = await _firestore
          .collection('attendance_sessions')
          .where(
        'guruId',
        isEqualTo: user.uid,
      )
          .where(
        'status',
        isEqualTo: 'open',
      )
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();

        if (!mounted) return;

        setState(() {
          _activeSessionId = doc.id;
          _activeCode = data['kode'];
          _activeClass = data['kelas'];
          _activeSubject = data['mataPelajaran'];
          _activeMaterial = data['materi'];
          _activeMeeting = data['pertemuan'];

          _loading = false;
        });
      } else {
        if (!mounted) return;

        setState(() {
          _activeSessionId = null;
          _activeCode = null;
          _activeClass = null;
          _activeSubject = null;
          _activeMaterial = null;
          _activeMeeting = null;

          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('ERROR CEK ABSENSI GURU: $e');

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal memuat data absensi.',
          ),
        ),
      );
    }
  }

  // =========================================================
  // GENERATE KODE ABSENSI
  // =========================================================

  String _generateAttendanceCode() {
    const characters =
        'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

    final random = Random();

    return List.generate(
      6,
          (index) =>
      characters[random.nextInt(characters.length)],
    ).join();
  }

  // =========================================================
  // BUKA ABSENSI
  // =========================================================

  Future<void> _openAttendance() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    if (_selectedClass == null ||
        _selectedClass!.isEmpty) {
      _showMessage(
        'Silakan pilih kelas terlebih dahulu.',
      );
      return;
    }

    if (_subjectController.text.trim().isEmpty) {
      _showMessage(
        'Silakan isi mata pelajaran.',
      );
      return;
    }

    if (_materialController.text.trim().isEmpty) {
      _showMessage(
        'Silakan isi materi.',
      );
      return;
    }

    if (_meetingController.text.trim().isEmpty) {
      _showMessage(
        'Silakan isi pertemuan.',
      );
      return;
    }

    try {
      setState(() {
        _loading = true;
      });

      // Cek apakah guru masih memiliki absensi aktif
      final activeSnapshot = await _firestore
          .collection('attendance_sessions')
          .where(
        'guruId',
        isEqualTo: user.uid,
      )
          .where(
        'status',
        isEqualTo: 'open',
      )
          .limit(1)
          .get();

      if (activeSnapshot.docs.isNotEmpty) {
        if (!mounted) return;

        setState(() {
          _loading = false;
        });

        _showMessage(
          'Masih ada absensi yang aktif. Tutup absensi tersebut terlebih dahulu.',
        );

        return;
      }

      final code = _generateAttendanceCode();

      final docRef = await _firestore
          .collection('attendance_sessions')
          .add({
        'guruId': user.uid,
        'kelas': _selectedClass,
        'mataPelajaran':
        _subjectController.text.trim(),
        'materi':
        _materialController.text.trim(),
        'pertemuan':
        _meetingController.text.trim(),
        'kode': code,
        'startTime':
        FieldValue.serverTimestamp(),
        'endTime': null,
        'status': 'open',
        'createdAt':
        FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() {
        _activeSessionId = docRef.id;
        _activeCode = code;
        _activeClass = _selectedClass;
        _activeSubject =
            _subjectController.text.trim();
        _activeMaterial =
            _materialController.text.trim();
        _activeMeeting =
            _meetingController.text.trim();

        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Absensi berhasil dibuka.',
          ),
        ),
      );
    } catch (e) {
      debugPrint('ERROR BUKA ABSENSI: $e');

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'Gagal membuka absensi.',
      );
    }
  }

  // =========================================================
  // TUTUP ABSENSI
  // =========================================================

  Future<void> _closeAttendance() async {
    final sessionId = _activeSessionId;
    if (sessionId == null) {
      return;
    }

    try {
      setState(() {
        _loading = true;
      });

      // Melakukan update status sesi menjadi closed
      await _firestore
          .collection('attendance_sessions')
          .doc(sessionId)
          .update({
        'status': 'closed',
        'endTime': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() {
        _activeSessionId = null;
        _activeCode = null;
        _activeClass = null;
        _activeSubject = null;
        _activeMaterial = null;
        _activeMeeting = null;

        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Absensi berhasil ditutup.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('ERROR TUTUP ABSENSI: $e');

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      // Menampilkan error yang lebih detail agar mudah didebug
      _showMessage(
        'Gagal menutup absensi: ${e.toString()}',
      );
    }
  }

  // =========================================================
  // PESAN
  // =========================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // =========================================================
  // DIALOG KONFIRMASI TUTUP
  // =========================================================

  Future<void> _confirmCloseAttendance() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Tutup Absensi?',
          ),
          content: const Text(
            'Setelah ditutup, siswa tidak dapat melakukan absensi lagi pada sesi ini.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Batal',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Tutup Absensi',
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _closeAttendance();
    }
  }

  // =========================================================
  // FORM BUAT ABSENSI
  // =========================================================

  Widget _buildCreateAttendance() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            'Buat Absensi',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Buat sesi absensi untuk siswa.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 24),

          // KELAS
          DropdownButtonFormField<String>(
            value: _selectedClass,
            decoration: const InputDecoration(
              labelText: 'Kelas',
              prefixIcon: Icon(
                Icons.school_rounded,
              ),
            ),
            items: _classOptions.map(
                  (kelas) {
                return DropdownMenuItem<String>(
                  value: kelas,
                  child: Text(kelas),
                );
              },
            ).toList(),
            onChanged: (value) {
              setState(() {
                _selectedClass = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // MATA PELAJARAN
          TextField(
            controller: _subjectController,
            decoration: const InputDecoration(
              labelText: 'Mata Pelajaran',
              hintText: 'Contoh: Dasar-Dasar TJKT',
              prefixIcon: Icon(
                Icons.menu_book_rounded,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // MATERI
          TextField(
            controller: _materialController,
            decoration: const InputDecoration(
              labelText: 'Materi',
              hintText: 'Contoh: IP Address',
              prefixIcon: Icon(
                Icons.topic_rounded,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // PERTEMUAN
          TextField(
            controller: _meetingController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Pertemuan',
              hintText: 'Contoh: 5',
              prefixIcon: Icon(
                Icons.event_note_rounded,
              ),
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed:
              _loading ? null : _openAttendance,
              icon: const Icon(
                Icons.qr_code_2_rounded,
              ),
              label: const Text(
                'BUKA ABSENSI',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // QR CODE
  // =========================================================

  Widget _buildQrCode() {
    if (_activeCode == null) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'SCAN QR CODE',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Minta siswa memindai QR Code ini',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: QrImageView(
              data: _activeCode!,
              version: QrVersions.auto,
              size: 230,
              backgroundColor: Colors.white,
              errorCorrectionLevel:
              QrErrorCorrectLevel.H,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'KODE ABSENSI',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            _activeCode!,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 6,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Kode dapat digunakan jika QR tidak dapat dipindai.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ABSENSI AKTIF
  // =========================================================

  Widget _buildActiveAttendance() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                'ABSENSI SEDANG AKTIF',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // INFORMASI ABSENSI
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.05),
                  blurRadius: 12,
                  offset:
                  const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  Icons.school_rounded,
                  'Kelas',
                  _activeClass ?? '-',
                ),

                const Divider(height: 24),

                _buildInfoRow(
                  Icons.menu_book_rounded,
                  'Mata Pelajaran',
                  _activeSubject ?? '-',
                ),

                const Divider(height: 24),

                _buildInfoRow(
                  Icons.topic_rounded,
                  'Materi',
                  _activeMaterial ?? '-',
                ),

                const Divider(height: 24),

                _buildInfoRow(
                  Icons.event_note_rounded,
                  'Pertemuan',
                  _activeMeeting ?? '-',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // QR CODE
          _buildQrCode(),

          const SizedBox(height: 24),

          // TUTUP ABSENSI
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: _loading
                  ? null
                  : _confirmCloseAttendance,
              icon: const Icon(
                Icons.stop_circle_outlined,
              ),
              label: const Text(
                'TUTUP ABSENSI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(
                  color: Colors.red,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INFO ROW
  // =========================================================

  Widget _buildInfoRow(
      IconData icon,
      String title,
      String value,
      ) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius:
            BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1565C0),
            size: 22,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Absensi Guru',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _activeSessionId != null
          ? _buildActiveAttendance()
          : _buildCreateAttendance(),
    );
  }
}