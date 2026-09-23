import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color darkBlue = Color(0xFF123B7A);
  static const Color backgroundColor = Color(0xFFF7F9FB);

  final TextEditingController _searchController =
  TextEditingController();

  String _searchQuery = '';

  final List<Map<String, dynamic>> _videos = [
    {
      'number': '01',
      'materi': 'Materi 01',
      'judul': 'Pengertian Jaringan Komputer',
      'deskripsi':
      'Memahami pengertian dan konsep dasar jaringan komputer.',
      'videoId': 'xT58k6AB7gk',
      'color': const Color(0xFF1565C0),
    },
    {
      'number': '02',
      'materi': 'Materi 02',
      'judul': 'Tujuan dan Manfaat Jaringan',
      'deskripsi':
      'Mengenal tujuan serta manfaat jaringan komputer.',
      'videoId': 'KLrqNfSfXzo',
      'color': const Color(0xFF009688),
    },
    {
      'number': '03',
      'materi': 'Materi 03',
      'judul': 'Cara Kerja Jaringan',
      'deskripsi':
      'Memahami bagaimana data dapat dikirim melalui jaringan.',
      'videoId': 'G0U632DDqqU',
      'color': const Color(0xFF673AB7),
    },
    {
      'number': '04',
      'materi': 'Materi 04',
      'judul': 'Jenis Jaringan',
      'deskripsi':
      'Mengenal berbagai jenis jaringan berdasarkan cakupannya.',
      'videoId': 'G0U632DDqqU',
      'color': const Color(0xFFFF9800),
    },
    {
      'number': '05',
      'materi': 'Materi 05',
      'judul': 'Topologi Jaringan',
      'deskripsi':
      'Mengenal bentuk dan susunan perangkat dalam jaringan.',
      'videoId': '7Ut4u8qVwRU',
      'color': const Color(0xFFE91E63),
    },
    {
      'number': '06',
      'materi': 'Materi 06',
      'judul': 'Protokol Jaringan',
      'deskripsi':
      'Memahami fungsi protokol dalam komunikasi jaringan.',
      'videoId': 'jtqp4tnA5bE',
      'color': const Color(0xFF0288D1),
    },
    {
      'number': '07',
      'materi': 'Materi 07',
      'judul': 'Keamanan Jaringan',
      'deskripsi':
      'Mengenal dasar-dasar keamanan dalam penggunaan jaringan.',
      'videoId': 'zlVtbPXDDA4',
      'color': const Color(0xFF5E35B1),
    },
    {
      'number': '08',
      'materi': 'Materi 08',
      'judul': 'Penerapan Jaringan',
      'deskripsi':
      'Melihat contoh penerapan jaringan dalam kehidupan sehari-hari.',
      'videoId': 'D30i_hmXZK0',
      'color': const Color(0xFF1976D2),
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
    if (_searchQuery.trim().isEmpty) {
      return _videos;
    }

    return _videos.where((video) {
      final judul =
      video['judul'].toString().toLowerCase();
      final materi =
      video['materi'].toString().toLowerCase();
      final deskripsi =
      video['deskripsi'].toString().toLowerCase();

      return judul.contains(_searchQuery) ||
          materi.contains(_searchQuery) ||
          deskripsi.contains(_searchQuery);
    }).toList();
  }

  Future<void> _openYoutube(String videoId) async {
    final uri = Uri.parse(
      'https://www.youtube.com/watch?v=$videoId',
    );

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && mounted) {
        _showMessage('Tidak dapat membuka YouTube.');
      }
    } catch (e) {
      debugPrint('ERROR OPEN YOUTUBE: $e');

      if (!mounted) return;

      _showMessage(
        'Terjadi kesalahan saat membuka video.',
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredVideos = _filteredVideos;

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkBlue,
        elevation: 0,
        centerTitle: false,

        title: const Text(
          'Video Dasar Jaringan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: darkBlue,
          ),
        ),

        actions: [
          IconButton(
            tooltip: 'Cari video',
            icon: const Icon(
              Icons.search_rounded,
              size: 27,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: VideoSearchDelegate(
                  videos: _videos,
                  onVideoTap: _openYoutube,
                ),
              );
            },
          ),

          IconButton(
            tooltip: 'Informasi',
            icon: const Icon(
              Icons.more_vert_rounded,
            ),
            onPressed: () {
              _showInfoDialog();
            },
          ),

          const SizedBox(width: 6),
        ],
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            _buildHeroBanner(),

            const SizedBox(height: 24),

            _buildSectionHeader(),

            const SizedBox(height: 12),

            if (filteredVideos.isEmpty)
              _buildEmptySearch()
            else
              ...filteredVideos.map(
                    (video) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 14,
                  ),
                  child: _buildVideoCard(video),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),

        gradient: const LinearGradient(
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
            Color(0xFF42A5F5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        boxShadow: [
          BoxShadow(
            color: primaryBlue.withValues(alpha: 0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -20,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          Positioned(
            right: 20,
            bottom: -35,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.16,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: 0.15,
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                    SizedBox(width: 7),
                    Text(
                      '8 Video Pembelajaran',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Kuasi Dasar Jaringan\nMelalui Video!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Tonton video pembelajaran yang sudah '
                    'disiapkan untuk memperdalam pemahamanmu '
                    'tentang dasar jaringan komputer.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: 0.14,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Belajar lebih mudah, kapan saja!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: primaryBlue.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.video_library_rounded,
            color: primaryBlue,
            size: 24,
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daftar Video',
                style: TextStyle(
                  color: darkBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Pilih materi yang ingin kamu tonton',
                style: TextStyle(
                  color: Color(0xFF718096),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF4FF),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                color: primaryBlue,
                size: 18,
              ),
              SizedBox(width: 4),
              Text(
                '8 Video',
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(
      Map<String, dynamic> video,
      ) {
    final Color color = video['color'];

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(22),

        onTap: () {
          _openYoutube(video['videoId']);
        },

        child: Container(
          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),

            border: Border.all(
              color: const Color(0xFFE8EDF3),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.035,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [
              // Nomor
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(13),
                ),
                alignment: Alignment.center,
                child: Text(
                  video['number'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(15),

                child: SizedBox(
                  width: 112,
                  height: 76,

                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://img.youtube.com/vi/'
                            '${video['videoId']}/hqdefault.jpg',

                        fit: BoxFit.cover,

                        errorBuilder: (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return _buildThumbnailFallback(
                            color,
                          );
                        },
                      ),

                      // Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(
                                alpha: 0.05,
                              ),
                              Colors.black.withValues(
                                alpha: 0.35,
                              ),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // Play button
                      Center(
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: 0.92,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: color,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Informasi
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                      child: Text(
                        video['materi'],
                        style: TextStyle(
                          color: color,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      video['judul'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: darkBlue,
                        fontSize: 14,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      video['deskripsi'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 10,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Tombol
              Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 76,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _openYoutube(
                          video['videoId'],
                        );
                      },

                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        size: 17,
                      ),

                      label: const Text(
                        'Tonton',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailFallback(Color color) {
    return Container(
      color: color.withValues(alpha: 0.12),
      child: Icon(
        Icons.network_check_rounded,
        color: color,
        size: 35,
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Container(
      padding: const EdgeInsets.all(35),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 55,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'Video tidak ditemukan',
            style: TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Coba gunakan kata kunci lain.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: primaryBlue,
              ),
              SizedBox(width: 10),
              Text('Tentang Video'),
            ],
          ),
          content: const Text(
            'Video pembelajaran ini digunakan sebagai '
                'media pendukung untuk memperdalam materi '
                'Dasar Jaringan.\n\n'
                'Tekan kartu atau tombol Tonton untuk membuka '
                'video melalui YouTube.',
            style: TextStyle(
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Mengerti'),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// SEARCH DELEGATE
// ============================================================

class VideoSearchDelegate
    extends SearchDelegate<Map<String, dynamic>?> {
  final List<Map<String, dynamic>> videos;
  final Future<void> Function(String videoId) onVideoTap;

  VideoSearchDelegate({
    required this.videos,
    required this.onVideoTap,
  });

  @override
  String get searchFieldLabel => 'Cari video...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear_rounded),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults();
  }

  Widget _buildResults() {
    final results = videos.where((video) {
      final judul =
      video['judul'].toString().toLowerCase();

      final materi =
      video['materi'].toString().toLowerCase();

      return judul.contains(query.toLowerCase()) ||
          materi.contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          'Video tidak ditemukan',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final video = results[index];

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding:
            const EdgeInsets.all(10),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://img.youtube.com/vi/'
                    '${video['videoId']}/hqdefault.jpg',
                width: 80,
                height: 55,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              video['judul'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              video['materi'],
            ),
            trailing: const Icon(
              Icons.play_circle_fill_rounded,
              color: Color(0xFF1565C0),
            ),
            onTap: () {
              onVideoTap(video['videoId']);
            },
          ),
        );
      },
    );
  }
}