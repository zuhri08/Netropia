import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../services/notification_service.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';

class TeacherPanelScreen extends StatefulWidget {
  final String? initialTab;

  const TeacherPanelScreen({
    super.key,
    this.initialTab,
  });

  @override
  State<TeacherPanelScreen> createState() => _TeacherPanelScreenState();
}

class _TeacherPanelScreenState extends State<TeacherPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers for Creating Assignment
  final _assignmentTitleController = TextEditingController();
  final _assignmentDescController = TextEditingController();
  String _selectedMateriForAssignment = 'Dasar Jaringan';

  // Controllers for Creating Quiz Question
  final _quizQuestionController = TextEditingController();
  final _quizOptionAController = TextEditingController();
  final _quizOptionBController = TextEditingController();
  final _quizOptionCController = TextEditingController();
  final _quizOptionDController = TextEditingController();
  int _quizCorrectAnswerIndex = 0;
  String _quizType = 'pre_test';
  String _selectedMateriForQuiz = 'Dasar Jaringan';

  // Controllers for Creating Material
  final _materialTitleController = TextEditingController();
  final _materialCategoryController = TextEditingController();
  final _materialContentController = TextEditingController();

  // Controllers for Creating Video / Reference
  final _videoTitleController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _videoDescController = TextEditingController();
  String _selectedMateriForVideo = 'Dasar Jaringan';

  final _refTitleController = TextEditingController();
  final _refUrlController = TextEditingController();
  final _refCategoryController = TextEditingController();
  String _selectedMateriForRef = 'Dasar Jaringan';

  // Controllers for Announcement
  final _announcementTitleController = TextEditingController();
  final _announcementContentController = TextEditingController();
  String _selectedClassForAnnouncement = 'Semua Kelas';

  // State for Gradebook
  String _selectedGradebookClass = 'X TKJ 1';

  final List<String> _materiOptions = [
    'Dasar Jaringan',
    'K3',
    'Komponen Komputer',
    'Perangkat Jaringan',
    'IP Address',
    'Kabel Jaringan',
  ];

  final List<String> _classOptions = [
    'Semua Kelas',
    'X TKJ 1',
    'X TKJ 2',
    'X TKJ 3',
  ];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCustomMateriOptions();
    _tabController = TabController(length: 6, vsync: this);
    if (widget.initialTab == 'quiz') {
      _tabController.animateTo(1);
    } else if (widget.initialTab == 'materi') {
      _tabController.animateTo(2);
    } else if (widget.initialTab == 'video') {
      _tabController.animateTo(3);
    } else if (widget.initialTab == 'pengumuman') {
      _tabController.animateTo(4);
    } else if (widget.initialTab == 'rekap') {
      _tabController.animateTo(5);
    }
  }

  Future<void> _loadCustomMateriOptions() async {
    try {
      final snapshot = await _firestore.collection('custom_materials').get();
      final customTitles = snapshot.docs
          .map((doc) => doc.data()['judul']?.toString().trim())
          .whereType<String>()
          .where((title) => title.isNotEmpty)
          .toList();

      if (mounted) {
        setState(() {
          for (final title in customTitles) {
            if (!_materiOptions.contains(title)) {
              _materiOptions.add(title);
            }
          }
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _tabController.dispose();
    _assignmentTitleController.dispose();
    _assignmentDescController.dispose();
    _quizQuestionController.dispose();
    _quizOptionAController.dispose();
    _quizOptionBController.dispose();
    _quizOptionCController.dispose();
    _quizOptionDController.dispose();
    _materialTitleController.dispose();
    _materialCategoryController.dispose();
    _materialContentController.dispose();
    _videoTitleController.dispose();
    _videoUrlController.dispose();
    _videoDescController.dispose();
    _refTitleController.dispose();
    _refUrlController.dispose();
    _refCategoryController.dispose();
    _announcementTitleController.dispose();
    _announcementContentController.dispose();
    super.dispose();
  }

  void _showMessage(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleError(dynamic e, String actionText) {
    final errStr = e.toString();
    if (errStr.contains('permission-denied')) {
      _showMessage(
        'Gagal $actionText: [Izin Firestore Ditolak]\nAtur Security Rules di Firebase Console ke: allow read, write: if request.auth != null;',
        isError: true,
      );
    } else {
      _showMessage('Gagal $actionText: $e', isError: true);
    }
  }

  // =========================================================
  // SUBMIT TUGAS BARU
  // =========================================================
  Future<void> _createAssignment() async {
    final title = _assignmentTitleController.text.trim();
    final desc = _assignmentDescController.text.trim();

    if (title.isEmpty || desc.isEmpty) {
      _showMessage('Judul dan instruksi tugas tidak boleh kosong.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _auth.currentUser;
      final docRef = _firestore.collection('assignments').doc();

      await docRef.set({
        'id': docRef.id,
        'judul': title,
        'materiTitle': _selectedMateriForAssignment,
        'deskripsi': desc,
        'deadline': Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
        'guruId': user?.uid ?? '',
        'guruName': user?.displayName ?? user?.email ?? 'Guru Netropia',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _assignmentTitleController.clear();
      _assignmentDescController.clear();

      _showMessage('Tugas baru berhasil dipublikasikan ke siswa!');
    } catch (e) {
      _handleError(e, 'membuat tugas');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // =========================================================
  // SUBMIT SOAL KUIS (PRE-TEST / POST-TEST / EVALUASI)
  // =========================================================
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
      _handleError(e, 'menambahkan soal');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // =========================================================
  // SUBMIT MATERI BARU
  // =========================================================
  Future<void> _createMaterial() async {
    final title = _materialTitleController.text.trim();
    final category = _materialCategoryController.text.trim();
    final content = _materialContentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      _showMessage('Judul dan isi materi tidak boleh kosong.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _auth.currentUser;
      final docRef = _firestore.collection('custom_materials').doc();

      await docRef.set({
        'id': docRef.id,
        'judul': title,
        'kategori': category.isEmpty ? 'Umum' : category,
        'isi': content,
        'guruId': user?.uid ?? '',
        'guruName': user?.displayName ?? user?.email ?? 'Guru Netropia',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _materialTitleController.clear();
      _materialCategoryController.clear();
      _materialContentController.clear();

      if (!_materiOptions.contains(title)) {
        setState(() {
          _materiOptions.add(title);
        });
      }

      _showMessage('Materi baru berhasil dipublikasikan!');
    } catch (e) {
      _handleError(e, 'menerbitkan materi');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // =========================================================
  // SUBMIT VIDEO PEMBELAJARAN BARU
  // =========================================================
  Future<void> _createVideo() async {
    final title = _videoTitleController.text.trim();
    final urlOrId = _videoUrlController.text.trim();
    final desc = _videoDescController.text.trim();

    if (title.isEmpty || urlOrId.isEmpty) {
      _showMessage('Judul dan Tautan/ID Video tidak boleh kosong.', isError: true);
      return;
    }

    String videoId = urlOrId;
    if (urlOrId.contains('v=')) {
      videoId = urlOrId.split('v=').last.split('&').first;
    } else if (urlOrId.contains('youtu.be/')) {
      videoId = urlOrId.split('youtu.be/').last.split('?').first;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _auth.currentUser;
      final docRef = _firestore.collection('custom_videos').doc();

      await docRef.set({
        'id': docRef.id,
        'judul': title,
        'videoId': videoId,
        'deskripsi': desc,
        'materiTitle': _selectedMateriForVideo,
        'guruId': user?.uid ?? '',
        'guruName': user?.displayName ?? user?.email ?? 'Guru Netropia',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _videoTitleController.clear();
      _videoUrlController.clear();
      _videoDescController.clear();

      _showMessage('Video pembelajaran berhasil diterbitkan!');
    } catch (e) {
      _handleError(e, 'menerbitkan video');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // =========================================================
  // SUBMIT REFERENSI PEMBELAJARAN BARU
  // =========================================================
  Future<void> _createReference() async {
    final title = _refTitleController.text.trim();
    final link = _refUrlController.text.trim();
    final category = _refCategoryController.text.trim();

    if (title.isEmpty || link.isEmpty) {
      _showMessage('Judul dan Tautan Referensi tidak boleh kosong.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _auth.currentUser;
      final docRef = _firestore.collection('custom_references').doc();

      await docRef.set({
        'id': docRef.id,
        'nama': title,
        'link': link,
        'kategori': category.isEmpty ? 'Buku / Artikel' : category,
        'materiTitle': _selectedMateriForRef,
        'guruId': user?.uid ?? '',
        'guruName': user?.displayName ?? user?.email ?? 'Guru Netropia',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _refTitleController.clear();
      _refUrlController.clear();
      _refCategoryController.clear();

      _showMessage('Referensi pembelajaran berhasil ditambahkan!');
    } catch (e) {
      _handleError(e, 'menambahkan referensi');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // =========================================================
  // SUBMIT PENGUMUMAN BARU
  // =========================================================
  Future<void> _createAnnouncement() async {
    final title = _announcementTitleController.text.trim();
    final content = _announcementContentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      _showMessage('Judul dan isi pengumuman tidak boleh kosong.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _auth.currentUser;
      final docRef = _firestore.collection('announcements').doc();

      await docRef.set({
        'id': docRef.id,
        'judul': title,
        'isi': content,
        'kelas': _selectedClassForAnnouncement,
        'guruName': user?.displayName ?? user?.email ?? 'Guru Netropia',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _announcementTitleController.clear();
      _announcementContentController.clear();

      _showMessage('Pengumuman kelas berhasil diterbitkan!');
    } catch (e) {
      _handleError(e, 'mengirim pengumuman');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // =========================================================
  // GURU BERI APRESIASI / LENCANA KEPADA SISWA
  // =========================================================
  void _showAwardBadgeDialog(String siswaUid, String namaSiswa) {
    String selectedBadge = '⭐ Siswa Paling Aktif';
    final noteController = TextEditingController();

    final badgeOptions = [
      '⭐ Siswa Paling Aktif',
      '💡 Solusi & Jawaban Terbaik',
      '🚀 Kemajuan Tercepat',
      '🥇 Nilai Sempurna',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Beri Apresiasi Kepada $namaSiswa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Jenis Lencana Apresiasi:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (context, setDialogState) {
                return DropdownButtonFormField<String>(
                  value: selectedBadge,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  items: badgeOptions.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedBadge = val);
                  },
                );
              },
            ),
            const SizedBox(height: 14),
            const Text('Catatan Pujian Guru (Opsional):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: noteController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Misal: Selamat atas kerja kerasmu di kelas!',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton.icon(
            onPressed: () async {
              final user = _auth.currentUser;
              final award = {
                'badge': selectedBadge,
                'catatan': noteController.text.trim(),
                'guruName': user?.displayName ?? user?.email ?? 'Guru Netropia',
                'createdAt': DateTime.now().toIso8601String(),
              };

              await _firestore.collection('users').doc(siswaUid).update({
                'awards': FieldValue.arrayUnion([award]),
              });

              await NotificationService().addNotification(
                title: 'Selamat! Kamu Mendapat Apresiasi Guru 🎉',
                message: 'Guru memberi kamu lencana "$selectedBadge". Buka profil untuk melihat!',
                type: NotificationType.system,
              );

              if (mounted) {
                Navigator.pop(context);
                _showMessage('Apresiasi berhasil diberikan ke $namaSiswa!');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBrown,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.star_rounded, color: Colors.amber),
            label: const Text('Kirim Lencana'),
          ),
        ],
      ),
    );
  }

  void _showSubmissionsDialog(String assignmentId, String assignmentTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.assignment_turned_in_rounded, color: AppTheme.primaryBrown),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pengumpulan Siswa: $assignmentTitle',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('assignment_submissions')
                      .where('assignmentId', isEqualTo: assignmentId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'Belum ada siswa yang mengumpulkan tugas ini.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final subDocId = docs[index].id;
                        final siswaName = data['siswaName'] ?? 'Siswa';
                        final jawaban = data['jawaban'] ?? '';
                        final nilai = data['nilai'];
                        final catatanGuru = data['catatanGuru'] ?? '';

                        final nilaiController = TextEditingController(text: nilai?.toString() ?? '');
                        final catatanController = TextEditingController(text: catatanGuru);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppTheme.primaryBrown,
                                      child: Icon(Icons.person_rounded, size: 16, color: Colors.white),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        siswaName,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ),
                                    if (nilai != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Nilai: $nilai/100',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900, fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('Jawaban Siswa:\n"$jawaban"', style: const TextStyle(fontSize: 13, height: 1.4)),
                                const SizedBox(height: 12),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primaryBrown;

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        final isEn = localizationService.isEnglish;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            title: Text(
              isEn ? 'Teacher Management Panel' : 'Panel Kelola Guru',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              isScrollable: true,
              tabs: [
                Tab(icon: const Icon(Icons.assignment_add), text: isEn ? 'Assignments' : 'Tugas'),
                Tab(icon: const Icon(Icons.quiz_rounded), text: isEn ? 'Quizzes' : 'Soal Kuis'),
                Tab(icon: const Icon(Icons.note_add_rounded), text: isEn ? 'Text Material' : 'Materi Teks'),
                Tab(icon: const Icon(Icons.video_call_rounded), text: isEn ? 'Videos & Ref' : 'Video & Referensi'),
                Tab(icon: const Icon(Icons.campaign_rounded), text: isEn ? 'Announcements' : 'Pengumuman'),
                Tab(icon: const Icon(Icons.assessment_rounded), text: isEn ? 'Gradebook & Feedback' : 'Rekap & Feedback'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildAssignmentTab(),
              _buildQuizTab(),
              _buildMaterialTab(),
              _buildVideoAndReferenceTab(),
              _buildAnnouncementTab(),
              _buildReflectionAndFeedbackTab(),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // TAB 1: KELOLA TUGAS & PENUGASAN
  // =========================================================
  Widget _buildAssignmentTab() {
    return SingleChildScrollView(
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
                  Row(
                    children: [
                      Icon(Icons.add_task_rounded, color: AppTheme.primaryBrown),
                      SizedBox(width: 8),
                      Text(
                        'Buat Penugasan Baru',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Topik Materi', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedMateriForAssignment,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    items: _materiOptions.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedMateriForAssignment = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  const Text('Judul Tugas', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _assignmentTitleController,
                    decoration: InputDecoration(
                      hintText: 'Misal: Analisis Topologi Jaringan Lab',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Instruksi & Deskripsi Tugas', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _assignmentDescController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan langkah pengerjaan, soal, dan format pengumpulan...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _createAssignment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBrown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: _isSubmitting
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.send_rounded),
                      label: Text(_isSubmitting ? 'Menerbitkan...' : 'Terbitkan Tugas ke Siswa'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Daftar Tugas Yang Diberikan Guru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('assignments').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Belum ada tugas buatan guru.', style: TextStyle(color: Colors.grey)),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final assignmentId = docs[index].id;
                  final judul = data['judul'] ?? 'Tugas';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFE8F5E9),
                              child: Icon(Icons.assignment_ind_rounded, color: Color(0xFF2E7D32)),
                            ),
                            title: Text(judul, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${data['materiTitle']} • ${data['deskripsi']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () async {
                                await _firestore.collection('assignments').doc(assignmentId).delete();
                                _showMessage('Tugas dihapus.');
                              },
                            ),
                          ),
                          const Divider(height: 1),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              onPressed: () => _showSubmissionsDialog(assignmentId, judul),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryBrown,
                                side: BorderSide(color: AppTheme.primaryBrown),
                              ),
                              icon: const Icon(Icons.rate_review_rounded, size: 16),
                              label: const Text('Lihat Jawaban & Beri Nilai Siswa'),
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
        ],
      ),
    );
  }

  // =========================================================
  // TAB 2: KELOLA SOAL KUIS (PRE-TEST / POST-TEST / EVALUASI)
  // =========================================================
  Widget _buildQuizTab() {
    return SingleChildScrollView(
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
                  Row(
                    children: [
                      Icon(Icons.quiz_rounded, color: AppTheme.primaryBrown),
                      SizedBox(width: 8),
                      Text(
                        'Tambah Soal Kuis & Evaluasi Baru',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Tipe Kuis', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _quizType,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Topik Materi', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _selectedMateriForQuiz,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              items: _materiOptions.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedMateriForQuiz = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
                  const Text('Pilihan Jawaban:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                        backgroundColor: AppTheme.primaryBrown,
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
          const Text('Daftar Soal Kuis Buatan Guru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    child: Text('Belum ada soal kuis buatan guru.', style: TextStyle(color: Colors.grey)),
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
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
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
        ],
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
          activeColor: AppTheme.primaryBrown,
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
                borderSide: BorderSide(color: isSelected ? AppTheme.primaryBrown : Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // TAB 3: BUAT MATERI PEMBELAJARAN BARU
  // =========================================================
  Widget _buildMaterialTab() {
    return SingleChildScrollView(
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
                  Row(
                    children: [
                      Icon(Icons.note_add_rounded, color: AppTheme.primaryBrown),
                      SizedBox(width: 8),
                      Text(
                        'Terbitkan Materi Pembelajaran',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Judul Materi', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _materialTitleController,
                    decoration: InputDecoration(
                      hintText: 'Misal: Panduan Konfigurasi Mikrotik RouterOS',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Kategori / Topik', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _materialCategoryController,
                    decoration: InputDecoration(
                      hintText: 'Misal: Jaringan Lanjut / Mikrotik',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Isi Lengkap Materi', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _materialContentController,
                    maxLines: 8,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan isi materi, konsep, dan langkah-langkah praktikum secara detail...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _createMaterial,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBrown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.publish_rounded),
                      label: Text(_isSubmitting ? 'Menerbitkan...' : 'Terbitkan Materi Untuk Siswa'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Materi Yang Dipublikasikan Guru', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('custom_materials').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Belum ada materi khusus buatan guru.', style: TextStyle(color: Colors.grey)),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFE3F2FD),
                        child: Icon(Icons.menu_book_rounded, color: Color(0xFF1565C0)),
                      ),
                      title: Text(data['judul'] ?? 'Materi', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Kategori: ${data['kategori']} • Oleh: ${data['guruName']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () async {
                          await _firestore.collection('custom_materials').doc(docs[index].id).delete();
                          _showMessage('Materi dihapus.');
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TAB 4: KELOLA VIDEO & REFERENSI
  // =========================================================
  Widget _buildVideoAndReferenceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form 1: Terbitkan Video
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.video_call_rounded, color: AppTheme.primaryBrown),
                      SizedBox(width: 8),
                      Text(
                        'Terbitkan Video Pembelajaran',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Topik Materi', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedMateriForVideo,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    items: _materiOptions.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedMateriForVideo = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  const Text('Judul Video', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _videoTitleController,
                    decoration: InputDecoration(
                      hintText: 'Misal: Tutorial Crimping Kabel UTP Straight',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Tautan / YouTube Video ID', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _videoUrlController,
                    decoration: InputDecoration(
                      hintText: 'Misal: https://www.youtube.com/watch?v=xxxxx atau ID Video',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Deskripsi Singkat', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _videoDescController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Penjelasan singkat isi video...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _createVideo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBrown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.video_library_rounded),
                      label: Text(_isSubmitting ? 'Menerbitkan...' : 'Terbitkan Video'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Form 2: Tambah Referensi
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.library_books_rounded, color: AppTheme.primaryBrown),
                      SizedBox(width: 8),
                      Text(
                        'Tambah Referensi / Buku Bacaan',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text('Topik Materi', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedMateriForRef,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    items: _materiOptions.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedMateriForRef = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  const Text('Judul Referensi / Buku', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _refTitleController,
                    decoration: InputDecoration(
                      hintText: 'Misal: Modul Resmi Jaringan Komputer Kemendikbud',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Tautan / URL Web', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _refUrlController,
                    decoration: InputDecoration(
                      hintText: 'Misal: https://sumberbelajar.belajar.kemdikbud.go.id/...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Kategori (Opsional)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _refCategoryController,
                    decoration: InputDecoration(
                      hintText: 'Misal: E-Book / Artikel Jurnal / Dokumentasi',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _createReference,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBrown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.bookmark_add_rounded),
                      label: Text(_isSubmitting ? 'Menyimpan...' : 'Simpan Referensi'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TAB 5: PENGUMUMAN KELAS DARI GURU
  // =========================================================
  Widget _buildAnnouncementTab() {
    return SingleChildScrollView(
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
                  Row(
                    children: [
                      Icon(Icons.campaign_rounded, color: AppTheme.primaryBrown),
                      SizedBox(width: 8),
                      Text(
                        'Buat Pengumuman Kelas',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Target Kelas', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedClassForAnnouncement,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    items: _classOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedClassForAnnouncement = val);
                    },
                  ),
                  const SizedBox(height: 14),
                  const Text('Judul Pengumuman', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _announcementTitleController,
                    decoration: InputDecoration(
                      hintText: 'Misal: Informasi Praktikum Kabel UTP Besok',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Isi Pengumuman', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _announcementContentController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan instruksi atau pesan penting untuk siswa...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _createAnnouncement,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBrown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.campaign_rounded),
                      label: Text(_isSubmitting ? 'Menerbitkan...' : 'Kirim Pengumuman Ke Siswa'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Daftar Pengumuman Aktif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('announcements').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final docs = snapshot.data!.docs;
              if (docs.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Belum ada pengumuman kelas.', style: TextStyle(color: Colors.grey)),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFFFF3E0),
                        child: Icon(Icons.campaign_rounded, color: Colors.orange),
                      ),
                      title: Text(data['judul'] ?? 'Pengumuman', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Target: ${data['kelas']} • ${data['isi']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () async {
                          await _firestore.collection('announcements').doc(docs[index].id).delete();
                          _showMessage('Pengumuman dihapus.');
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================================================
  // TAB 6: REFLEKSI & FEEDBACK SISWA + EXPORT PDF
  // =========================================================
  Future<void> _exportGradebookToPdf(List<QueryDocumentSnapshot> students) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('REKAP NILAI & KEHADIRAN SISWA NETROPIA', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Kelas: $_selectedGradebookClass', style: const pw.TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['No', 'Nama Siswa', 'Email', 'Kelas', 'Role'],
                data: students.asMap().entries.map((entry) {
                  final idx = entry.key + 1;
                  final data = entry.value.data() as Map<String, dynamic>;
                  return [
                    '$idx',
                    data['nama'] ?? '-',
                    data['email'] ?? '-',
                    data['kelas'] ?? '-',
                    (data['role'] ?? 'siswa').toString().toUpperCase(),
                  ];
                }).toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFAD8B73)),
                rowDecoration: const pw.BoxDecoration(
                  border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text('Dicetak pada: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Rekap_Siswa_$_selectedGradebookClass.pdf',
    );
  }

  Widget _buildReflectionAndFeedbackTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // EXPORT PDF REKAP
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.picture_as_pdf_rounded, color: AppTheme.primaryBrown),
                      SizedBox(width: 8),
                      Text('Export Rekap Nilai & Presensi (PDF)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Pilih kelas untuk mengekspor rekap siswa ke dokumen PDF.', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                          items: _classOptions.where((c) => c != 'Semua Kelas').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
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
                              backgroundColor: AppTheme.primaryBrown,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.print_rounded, size: 18),
                            label: const Text('Cetak / Export PDF'),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          _buildProjectSubmissionsSection(),
          _buildQuizResultsSection(),
          _buildAttendanceRecordsSection(),
          const SizedBox(height: 20),
          const Text(
            'Refleksi & Evaluasi Siswa',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tinjau hasil refleksi belajar siswa dan berikan umpan balik atau tanggapan langsung.',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('reflections').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Belum ada refleksi yang dikirim oleh siswa.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                );
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final docId = docs[index].id;
                  final namaSiswa = data['namaSiswa'] ?? 'Siswa';
                  final kelas = data['kelas'] ?? '-';
                  final materiTitle = data['materiTitle'] ?? 'Materi';
                  final mood = data['mood'] ?? '🙂';
                  final score = data['understanding'] ?? 3;
                  final newThing = data['newThing'] ?? '-';
                  final challenge = data['challenge'] ?? '-';
                  final feedbackGuru = data['feedbackGuru'] ?? '';

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
                                backgroundColor: AppTheme.primaryBrown.withOpacity(0.15),
                                child: Text(
                                  mood,
                                  style: const TextStyle(fontSize: 18),
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
                                    Text(
                                      'Materi: $materiTitle • Pemahaman: $score/5',
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          if (newThing != '-') ...[
                            Text(
                              'Hal Baru Dipelajari:',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 2),
                            Text('"$newThing"', style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                            const SizedBox(height: 8),
                          ],
                          if (challenge != '-') ...[
                            Text(
                              'Tantangan Siswa:',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 2),
                            Text(challenge, style: const TextStyle(fontSize: 13)),
                            const SizedBox(height: 8),
                          ],
                          if (feedbackGuru.toString().isNotEmpty) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(Icons.check_circle_rounded, size: 16, color: Colors.green),
                                      SizedBox(width: 6),
                                      Text(
                                        'Tanggapan / Catatan Guru:',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    feedbackGuru.toString(),
                                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () {
                                  final siswaUid = data['siswaUid']?.toString() ?? '';
                                  _showAwardBadgeDialog(siswaUid, namaSiswa);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.accentAmber,
                                  side: const BorderSide(color: AppTheme.accentAmber),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.star_rounded, size: 16, color: AppTheme.accentAmber),
                                label: const Text('Beri Lencana'),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton.icon(
                                onPressed: () => _showGiveFeedbackDialog(docId, namaSiswa, feedbackGuru.toString()),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primaryBrown,
                                  side: BorderSide(color: AppTheme.primaryBrown),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.rate_review_rounded, size: 16),
                                label: Text(feedbackGuru.toString().isEmpty ? 'Beri Tanggapan' : 'Edit Tanggapan'),
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
      ),
    );
  }

  Widget _buildQuizResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.quiz_rounded, color: AppTheme.primaryBrown),
            const SizedBox(width: 8),
            const Text(
              'Daftar Nilai Kuis & Deteksi Kecurangan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Tinjau skor kuis siswa serta laporan deteksi kecurangan (pindah aplikasi/tab saat kuis).',
          style: TextStyle(fontSize: 12.5, color: Colors.grey),
        ),
        const SizedBox(height: 12),
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
                                    'Peringatan: Siswa terdeteksi keluar dari layar ujian sebanyak $cheatCount kali saat tes!',
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

  Widget _buildProjectSubmissionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Icon(Icons.rocket_launch_rounded, color: AppTheme.primaryBrown),
            const SizedBox(width: 8),
            const Text(
              'Pengumpulan Project Praktik Siswa',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Tinjau hasil pengerjaan project, foto bukti, serta berikan penilaian & umpan balik.',
          style: TextStyle(fontSize: 12.5, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('project_submissions')
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
                      'Belum ada pengumpulan project dari siswa.',
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
                final subDocId = docs[index].id;
                final siswaName = data['siswaName'] ?? 'Siswa';
                final kelas = data['kelas'] ?? '-';
                final projectTitle = data['projectTitle'] ?? 'Project';
                final topologi = data['topologi'] ?? '-';
                final problem = data['problem'] ?? '-';
                final planning = data['planning'] ?? '-';
                final testing = data['testing'] ?? '-';
                final reflection = data['reflection'] ?? '-';
                final fileUrl = data['fileUrl']?.toString();
                final fileName = data['fileName']?.toString() ?? 'Foto Bukti';
                final nilai = data['nilai'];
                final catatanGuru = data['catatanGuru'] ?? '';

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
                              child: const Icon(Icons.rocket_launch_rounded, size: 18, color: Colors.white),
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
                                    'Project: $projectTitle • Topologi: $topologi',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                        if (problem.isNotEmpty && problem != '-') ...[
                          Text('1. Pemahaman Masalah:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                          Text('"$problem"', style: const TextStyle(fontSize: 12.5)),
                          const SizedBox(height: 8),
                        ],
                        if (planning.isNotEmpty && planning != '-') ...[
                          Text('2. Perencanaan:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                          Text('"$planning"', style: const TextStyle(fontSize: 12.5)),
                          const SizedBox(height: 8),
                        ],
                        if (testing.isNotEmpty && testing != '-') ...[
                          Text('3. Hasil Pengujian:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                          Text('"$testing"', style: const TextStyle(fontSize: 12.5)),
                          const SizedBox(height: 8),
                        ],
                        if (reflection.isNotEmpty && reflection != '-') ...[
                          Text('4. Refleksi Siswa:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                          Text('"$reflection"', style: const TextStyle(fontSize: 12.5)),
                          const SizedBox(height: 12),
                        ],

                        // Image / Attachment Preview
                        if (imageBytes != null) ...[
                          Text('Foto Bukti Praktik Project:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryBrown)),
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
                                Icon(Icons.attach_file_rounded, color: AppTheme.primaryBrown, size: 20),
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

                              await _firestore.collection('project_submissions').doc(subDocId).update({
                                'nilai': gradeVal,
                                'catatanGuru': noteVal,
                              });

                              if (mounted) {
                                _showMessage('Nilai Project berhasil disimpan untuk $siswaName!');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBrown,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.check_rounded, size: 16),
                            label: const Text('Simpan Nilai Project'),
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
      ],
    );
  }

  Widget _buildAttendanceRecordsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Row(
          children: [
            Icon(Icons.event_available_rounded, color: AppTheme.primaryBrown),
            const SizedBox(width: 8),
            const Text(
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
                            const Icon(Icons.access_time_rounded, size: 13, color: AppTheme.primaryBrown),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                fullTimeStr.isEmpty ? 'Baru saja' : fullTimeStr,
                                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppTheme.primaryBrown),
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

  void _showGiveFeedbackDialog(String docId, String namaSiswa, String currentFeedback) {
    final controller = TextEditingController(text: currentFeedback);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Umpan Balik Guru untuk $namaSiswa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Berikan evaluasi, pujian, atau saran langsung untuk siswa ini:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Misal: Penjelasanmu sangat baik! Pertahankan semangat belajarmu.',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final text = controller.text.trim();
              await _firestore.collection('reflections').doc(docId).update({
                'feedbackGuru': text,
              });
              if (mounted) {
                Navigator.pop(context);
                _showMessage('Tanggapan berhasil dikirim ke siswa!');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBrown,
              foregroundColor: Colors.white,
            ),
            child: const Text('Kirim Tanggapan'),
          ),
        ],
      ),
    );
  }
}
