import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/progress_service.dart';

class LearningFeatureScreen extends StatefulWidget {
  final String materiId;
  final String materiTitle;
  final String feature;
  final Color themeColor;

  const LearningFeatureScreen({
    super.key,
    required this.materiId,
    required this.materiTitle,
    required this.feature,
    required this.themeColor,
  });

  @override
  State<LearningFeatureScreen> createState() => _LearningFeatureScreenState();
}

class _LearningFeatureScreenState extends State<LearningFeatureScreen> {
  final ProgressService _progressService = ProgressService();
  bool _isCompleted = false;
  bool _isLoading = true;

  // Forum Diskusi State
  final TextEditingController _forumController = TextEditingController();

  // Feedback State
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 5;
  bool _feedbackSubmitted = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
    if (widget.feature == 'Forum Diskusi') {
      _seedCaseStudiesIfNeeded(widget.materiId);
    } else if (widget.feature == 'Feedback') {
      _loadFeedback();
    }
  }

  String get _activityKey {
    final featureKey = widget.feature.toLowerCase().replaceAll(' ', '_');
    return '${widget.materiId}_$featureKey';
  }

  Future<void> _checkStatus() async {
    final status = await _progressService.isLessonCompleted(_activityKey);
    if (mounted) {
      setState(() {
        _isCompleted = status;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleCompleted() async {
    final newStatus = !_isCompleted;
    await _progressService.setLessonCompleted(_activityKey, newStatus);
    if (newStatus) {
      await _progressService.saveActivity(
        title: '${widget.feature} - ${widget.materiTitle}',
        subtitle: 'Status: Selesai',
        time: 'Baru saja',
        type: widget.feature.toLowerCase().replaceAll(' ', '_'),
      );
    }
    if (mounted) {
      setState(() {
        _isCompleted = newStatus;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus
                ? 'Aktivitas ${widget.feature} ditandai selesai!'
                : 'Status selesai dibatalkan.',
          ),
          backgroundColor: newStatus ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ==========================================
  // SEED CASE STUDIES FOR TKJ DEPARTMENT
  // ==========================================
  Future<void> _seedCaseStudiesIfNeeded(String materiId) async {
    try {
      final ref = FirebaseFirestore.instance
          .collection('discussions')
          .doc(materiId)
          .collection('messages');

      final snapshot = await ref.limit(1).get();
      if (snapshot.docs.isNotEmpty) return;

      final caseStudies = _getCaseStudiesForModule(materiId);

      for (final cs in caseStudies) {
        await ref.add({
          'name': 'Tim Kurikulum TKJ',
          'role': 'Guru / Admin',
          'message': cs['message']!,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {}
  }

  List<Map<String, String>> _getCaseStudiesForModule(String materiId) {
    switch (materiId) {
      case 'k3':
        return [
          {
            'message': '📌 STUDI KASUS 1: Saat melakukan crimping kabel UTP menggunakan crimping tool, tangan seorang siswa tidak sengaja tergores pin konektor RJ45 yang tajam hingga berdarah. Apa tindakan P3K pertama yang harus dilakukan dan prosedur K3 apa yang terlewat?',
          },
          {
            'message': '📌 STUDI KASUS 2: Ruang server sekolah mengalami korsleting listrik akibat kabel power server yang terkelupas dan bersentuhan dengan lantai yang lembab. Bagaimana cara penanganan darurat yang tepat sebelum teknisi datang?',
          },
        ];
      case 'komponen_komputer':
        return [
          {
            'message': '📌 STUDI KASUS 1: Komputer lab sering mengalami Blue Screen of Death (BSOD) secara mendadak saat menjalankan aplikasi berat, dan terkadang berbunyi beep panjang berulang. Langkah diagnostik apa yang harus kita lakukan pada RAM dan motherboard?',
          },
          {
            'message': '📌 STUDI KASUS 2: Suhu prosesor (CPU) mencapai 95°C saat idle. Setelah dicek, kipas pendingin berputar tapi pasta termal sudah kering dan mengeras. Seberapa besar pengaruh thermal paste terhadap performa dan usia hardware?',
          },
        ];
      case 'perangkat_jaringan':
        return [
          {
            'message': '📌 STUDI KASUS 1: Di sebuah lab komputer sekolah, terjadi broadcast storm karena ada siswa yang tidak sengaja menghubungkan dua port pada switch yang sama menggunakan kabel patch cord (looping). Bagaimana cara switch modern mencegah hal ini dan apa dampaknya pada jaringan?',
          },
          {
            'message': '📌 STUDI KASUS 2: Access Point di lorong sekolah sering mengalami disconnect saat jumlah pengguna melebihi 30 perangkat, meskipun sinyal Wi-Fi penuh. Pengaturan apa yang perlu dioptimalkan pada Access Point tersebut?',
          },
        ];
      case 'dasar_jaringan':
        return [
          {
            'message': '📌 STUDI KASUS 1: Kantor cabang ingin menghubungkan dua gedung berjarak 200 meter dengan topologi star yang handal dan tahan terhadap gangguan elektromagnetik dari trafo listrik di sekitar. Topologi dan media transmisi apa yang paling tepat dipilih?',
          },
          {
            'message': '📌 STUDI KASUS 2: Sebuah jaringan LAN menggunakan protokol TCP dan UDP secara bersamaan. Mengapa video streaming menggunakan UDP sedangkan transfer file penting menggunakan TCP? Berikan analisis Anda.',
          },
        ];
      case 'ip_address':
        return [
          {
            'message': '📌 STUDI KASUS 1: Sebuah perusahaan memiliki network ID 192.168.1.0/24 dan ingin membaginya menjadi 4 subnet untuk departemen (Admin, HR, Produksi, Gudang). Berapa subnet mask baru dan range IP usable untuk departemen Produksi?',
          },
          {
            'message': '📌 STUDI KASUS 2: Dua PC dalam satu switch yang sama tidak bisa saling ping, padahal konfigurasi IP satu adalah 192.168.1.10/24 dan satu lagi 192.168.2.15/24. Apa penyebab utama masalah ini dan bagaimana memperbaikinya?',
          },
        ];
      case 'kabel_jaringan':
        return [
          {
            'message': '📌 STUDI KASUS 1: Teknisi selesai memasang kabel UTP sepanjang 90 meter antara lantai 1 dan lantai 3. Saat diuji dengan LAN tester, lampu indikator nomor 3 dan 6 tidak menyala. Apa kemungkinan kesalahan pada susunan warna pin RJ45?',
          },
          {
            'message': '📌 STUDI KASUS 2: Kapan kita harus memilih kabel Straight-through dan kapan menggunakan Crossover dalam instalasi jaringan lokal? Apakah switch modern saat ini masih memerlukan kabel Crossover?',
          },
        ];
      default:
        return [
          {
            'message': '📌 STUDI KASUS: Diskusikan penerapan konsep materi ini dalam studi kasus nyata di dunia industri jaringan komputer.',
          },
        ];
    }
  }

  // ==========================================
  // FORUM DISKUSI LOGIC (FIRESTORE - 1 JURUSAN TKJ)
  // ==========================================
  Future<void> _sendFirestoreForumPost() async {
    final text = _forumController.text.trim();
    if (text.isEmpty) return;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan login terlebih dahulu untuk berdiskusi.')),
        );
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userDoc.data();
      final name = userData?['nama'] ?? user.displayName ?? 'Siswa TKJ';
      final role = userData?['role'] ?? 'Siswa';

      await FirebaseFirestore.instance
          .collection('discussions')
          .doc(widget.materiId)
          .collection('messages')
          .add({
        'name': name,
        'role': role,
        'message': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _forumController.clear();

      if (!_isCompleted) {
        await _toggleCompleted();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim pesan: $e')),
        );
      }
    }
  }

  String _formatTimestamp(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    return '${time.day}/${time.month}/${time.year}';
  }

  // ==========================================
  // FEEDBACK LOGIC
  // ==========================================
  Future<void> _loadFeedback() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRating = prefs.getInt('feedback_rating_${widget.materiId}');
    final savedComment = prefs.getString('feedback_comment_${widget.materiId}');
    if (savedComment != null) {
      setState(() {
        _rating = savedRating ?? 5;
        _feedbackController.text = savedComment;
        _feedbackSubmitted = true;
      });
    }
  }

  Future<void> _submitFeedback() async {
    final comment = _feedbackController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan isi komentar feedback terlebih dahulu.')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('feedback_rating_${widget.materiId}', _rating);
    await prefs.setString('feedback_comment_${widget.materiId}', comment);

    setState(() {
      _feedbackSubmitted = true;
    });

    if (!_isCompleted) {
      await _toggleCompleted();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terima kasih! Feedback Anda berhasil dikirim.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.feature} - ${widget.materiTitle}'),
        backgroundColor: widget.themeColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.feature == 'Forum Diskusi'
              ? _buildForumDiskusiView()
              : widget.feature == 'Feedback'
                  ? _buildFeedbackView()
                  : _buildDefaultFeatureView(),
    );
  }

  // ==========================================
  // DEFAULT FEATURE VIEW
  // ==========================================
  Widget _buildDefaultFeatureView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.themeColor.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(
                  _getFeatureIcon(widget.feature),
                  size: 48,
                  color: widget.themeColor,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.feature,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.themeColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Materi: ${widget.materiTitle}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deskripsi Fitur',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _getFeatureDescription(widget.feature, widget.materiTitle),
                    style: const TextStyle(fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _toggleCompleted,
              icon: Icon(
                _isCompleted ? Icons.check_circle : Icons.circle_outlined,
              ),
              label: Text(
                _isCompleted ? 'Selesai (Klik untuk Batal)' : 'Tandai Selesai',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isCompleted ? Colors.green : widget.themeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // REALTIME GLOBAL FORUM DISKUSI VIEW (1 JURUSAN TKJ)
  // ==========================================
  Widget _buildForumDiskusiView() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: widget.themeColor.withOpacity(0.1),
          child: Row(
            children: [
              Icon(Icons.people_rounded, size: 18, color: widget.themeColor),
              const SizedBox(width: 8),
              Text(
                'Forum Diskusi 1 Jurusan TKJ (${widget.materiTitle})',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: widget.themeColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('discussions')
                .doc(widget.materiId)
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.forum_outlined, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      const Text(
                        'Belum ada diskusi untuk materi ini.',
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Jadilah yang pertama memulai diskusi dengan seluruh siswa TKJ!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              final docs = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final name = data['name'] ?? 'Siswa TKJ';
                  final role = data['role'] ?? 'Siswa';
                  final message = data['message'] ?? '';
                  final timestamp = data['timestamp'] as Timestamp?;
                  final timeStr = timestamp != null
                      ? _formatTimestamp(timestamp.toDate())
                      : 'Baru saja';

                  final isTeacher = role.toLowerCase() == 'guru' || role.toLowerCase() == 'admin';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isTeacher ? widget.themeColor.withOpacity(0.5) : Colors.grey.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: widget.themeColor.withOpacity(0.2),
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: widget.themeColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    Text(
                                      role,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isTeacher ? widget.themeColor : Colors.grey,
                                        fontWeight: isTeacher ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              timeStr,
                              style: const TextStyle(fontSize: 10.5, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          message,
                          style: const TextStyle(fontSize: 13.5, height: 1.4),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _forumController,
                  decoration: InputDecoration(
                    hintText: 'Tulis pesan untuk jurusan TKJ...',
                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: _sendFirestoreForumPost,
                icon: const Icon(Icons.send_rounded),
                color: widget.themeColor,
                style: IconButton.styleFrom(
                  backgroundColor: widget.themeColor.withOpacity(0.12),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // INTERACTIVE FEEDBACK VIEW
  // ==========================================
  Widget _buildFeedbackView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.themeColor.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.feedback_rounded,
                  size: 48,
                  color: widget.themeColor,
                ),
                const SizedBox(height: 12),
                Text(
                  'Feedback Pembelajaran',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: widget.themeColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Materi: ${widget.materiTitle}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Beri Penilaian (Rating)',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starVal = index + 1;
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _rating = starVal;
                          });
                        },
                        icon: Icon(
                          starVal <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 36,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Komentar & Masukan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 4,
                    enabled: !_feedbackSubmitted,
                    decoration: InputDecoration(
                      hintText: 'Tuliskan kesan, masukan, atau bagian yang belum dipahami...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _feedbackSubmitted ? null : _submitFeedback,
                      icon: Icon(_feedbackSubmitted ? Icons.check_circle_rounded : Icons.send_rounded),
                      label: Text(
                        _feedbackSubmitted ? 'Feedback Telah Dikirim' : 'Kirim Umpan Balik',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _feedbackSubmitted ? Colors.green : widget.themeColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  if (_feedbackSubmitted) ...[
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _feedbackSubmitted = false;
                          });
                        },
                        child: const Text('Edit Feedback', style: TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFeatureIcon(String feature) {
    switch (feature) {
      case 'Peta Konsep':
        return Icons.account_tree_rounded;
      case 'Pre Test':
        return Icons.assignment_rounded;
      case 'Post Test':
        return Icons.assignment_turned_in_rounded;
      case 'Penugasan':
        return Icons.task_rounded;
      case 'Portofolio':
        return Icons.folder_shared_rounded;
      case 'Forum Diskusi':
        return Icons.forum_rounded;
      case 'Refleksi':
        return Icons.psychology_rounded;
      case 'Evaluasi':
        return Icons.assessment_rounded;
      case 'Feedback':
        return Icons.feedback_rounded;
      default:
        return Icons.school_rounded;
    }
  }

  String _getFeatureDescription(String feature, String materi) {
    switch (feature) {
      case 'Peta Konsep':
        return 'Peta konsep memberikan gambaran visual mengenai hubungan antarkonsep dalam materi $materi.';
      case 'Pre Test':
        return 'Pre test digunakan untuk mengukur pemahaman awal Anda sebelum mempelajari materi $materi.';
      case 'Post Test':
        return 'Post test menguji sejauh mana Anda menguasai materi $materi setelah pembelajaran selesai.';
      case 'Penugasan':
        return 'Tugas mandiri atau kelompok untuk memperdalam pemahaman konsep $materi secara praktis.';
      case 'Portofolio':
        return 'Kumpulan hasil karya, laporan, atau proyek yang berhubungan dengan materi $materi.';
      case 'Forum Diskusi':
        return 'Ruang untuk berdiskusi, bertanya, dan berbagi informasi bersama teman dan guru mengenai $materi.';
      case 'Refleksi':
        return 'Renungkan apa yang telah dipelajari, kesulitan yang dihadapi, serta rencana perbaikan dalam $materi.';
      case 'Evaluasi':
        return 'Penilaian menyeluruh terhadap proses dan hasil belajar materi $materi.';
      case 'Feedback':
        return 'Berikan masukan dan tanggapan mengenai materi dan pembelajaran $materi.';
      default:
        return 'Fitur pembelajaran untuk materi $materi.';
    }
  }
}
