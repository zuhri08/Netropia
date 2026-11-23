import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/localization_service.dart';
import '../../theme/app_theme.dart';
import 'video_player_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _videos = [
    {
      'number': '01',
      'materi': 'Materi 01',
      'judul': 'Pengertian Jaringan Komputer',
      'deskripsi': 'Memahami pengertian dan konsep dasar jaringan komputer.',
      'videoId': 'xT58k6AB7gk',
      'color': AppTheme.primaryTeal,
    },
    {
      'number': '02',
      'materi': 'Materi 02',
      'judul': 'Tujuan dan Manfaat Jaringan',
      'deskripsi': 'Mengenal tujuan serta manfaat jaringan komputer.',
      'videoId': 'KLrqNfSfXzo',
      'color': AppTheme.primaryTeal,
    },
    {
      'number': '03',
      'materi': 'Materi 03',
      'judul': 'Cara Kerja Jaringan',
      'deskripsi': 'Memahami bagaimana data dapat dikirim melalui jaringan.',
      'videoId': 'G0U632DDqqU',
      'color': AppTheme.primaryTeal,
    },
    {
      'number': '04',
      'materi': 'Materi 04',
      'judul': 'Jenis Jaringan',
      'deskripsi': 'Mengenal berbagai jenis jaringan berdasarkan cakupannya.',
      'videoId': 'G0U632DDqqU',
      'color': AppTheme.primaryTeal,
    },
    {
      'number': '05',
      'materi': 'Materi 05',
      'judul': 'Topologi Jaringan',
      'deskripsi': 'Mengenal bentuk dan susunan perangkat dalam jaringan.',
      'videoId': '7Ut4u8qVwRU',
      'color': AppTheme.primaryTeal,
    },
    {
      'number': '06',
      'materi': 'Materi 06',
      'judul': 'Protokol Jaringan',
      'deskripsi': 'Memahami fungsi protokol dalam komunikasi jaringan.',
      'videoId': 'jtqp4tnA5bE',
      'color': AppTheme.primaryTeal,
    },
    {
      'number': '07',
      'materi': 'Materi 07',
      'judul': 'Keamanan Jaringan',
      'deskripsi': 'Mengenal dasar-dasar keamanan dalam penggunaan jaringan.',
      'videoId': 'zlVtbPXDDA4',
      'color': AppTheme.primaryTeal,
    },
    {
      'number': '08',
      'materi': 'Materi 08',
      'judul': 'Penerapan Jaringan',
      'deskripsi': 'Melihat contoh penerapan jaringan dalam kehidupan sehari-hari.',
      'videoId': 'D30i_hmXZK0',
      'color': AppTheme.primaryTeal,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredVideos {
    if (_searchQuery.trim().isEmpty) return _videos;
    return _videos.where((video) {
      final judul = video['judul'].toString().toLowerCase();
      final materi = video['materi'].toString().toLowerCase();
      final deskripsi = video['deskripsi'].toString().toLowerCase();
      return judul.contains(_searchQuery) || materi.contains(_searchQuery) || deskripsi.contains(_searchQuery);
    }).toList();
  }

  void _openVideoPlayer(String title, String videoId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          title: title,
          videoId: videoId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredVideos = _filteredVideos;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: AppTheme.primaryTeal,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            title: const Text(
              'Video Pembelajaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 50),
              children: [
                _buildHeroBanner(),
                const SizedBox(height: 22),
                _buildSectionHeader(isDark),
                const SizedBox(height: 12),
                if (filteredVideos.isEmpty)
                  _buildEmptySearch()
                else
                  ...filteredVideos.map(
                    (video) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildVideoCard(video, isDark),
                    ),
                  ),
                _buildTeacherCustomVideos(isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryTeal,
            AppTheme.darkTeal,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryTeal.withOpacity(0.22),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text(
                  '8 Video Pembelajaran',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Kuasai Dasar Jaringan\nMelalui Video!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tonton video pembelajaran yang sudah disiapkan untuk memperdalam pemahamanmu tentang dasar jaringan komputer.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Belajar lebih mudah, kapan saja!',
              style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DAFTAR VIDEO',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Pilih video untuk mulai menonton',
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video, bool isDark) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openVideoPlayer(video['judul'], video['videoId']),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.tealTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    video['number'],
                    style: const TextStyle(
                      color: AppTheme.primaryTeal,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['materi'],
                      style: const TextStyle(
                        color: AppTheme.primaryTeal,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      video['judul'],
                      style: TextStyle(
                        color: isDark ? Colors.white : AppTheme.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      video['deskripsi'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppTheme.tealTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppTheme.primaryTeal,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySearch() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Video tidak ditemukan.',
          style: TextStyle(color: AppTheme.textMuted),
        ),
      ),
    );
  }

  Widget _buildTeacherCustomVideos(bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('custom_videos').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox();
        }

        final docs = List<QueryDocumentSnapshot>.from(snapshot.data!.docs);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'VIDEO DARI GURU',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            ...docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildVideoCard({
                  'number': 'GURU',
                  'materi': 'Video Guru',
                  'judul': data['judul'] ?? 'Video',
                  'deskripsi': data['deskripsi'] ?? '',
                  'videoId': data['videoId'] ?? '',
                  'color': AppTheme.primaryTeal,
                }, isDark),
              );
            }),
          ],
        );
      },
    );
  }
}
