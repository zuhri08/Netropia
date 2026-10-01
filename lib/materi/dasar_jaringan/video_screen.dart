import 'package:flutter/material.dart';
import '../../services/localization_service.dart';
import 'video_player_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  static const Color primaryBrown = Color(0xFFAD8B73);

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  final List<Map<String, dynamic>> _videos = [
    {
      'number': '01',
      'materi': 'Materi 01',
      'judul': 'Pengertian Jaringan Komputer',
      'deskripsi': 'Memahami pengertian dan konsep dasar jaringan komputer.',
      'videoId': 'xT58k6AB7gk',
      'color': const Color(0xFFAD8B73),
    },
    {
      'number': '02',
      'materi': 'Materi 02',
      'judul': 'Tujuan dan Manfaat Jaringan',
      'deskripsi': 'Mengenal tujuan serta manfaat jaringan komputer.',
      'videoId': 'KLrqNfSfXzo',
      'color': const Color(0xFF009688),
    },
    {
      'number': '03',
      'materi': 'Materi 03',
      'judul': 'Cara Kerja Jaringan',
      'deskripsi': 'Memahami bagaimana data dapat dikirim melalui jaringan.',
      'videoId': 'G0U632DDqqU',
      'color': const Color(0xFF673AB7),
    },
    {
      'number': '04',
      'materi': 'Materi 04',
      'judul': 'Jenis Jaringan',
      'deskripsi': 'Mengenal berbagai jenis jaringan berdasarkan cakupannya.',
      'videoId': 'G0U632DDqqU',
      'color': const Color(0xFFFF9800),
    },
    {
      'number': '05',
      'materi': 'Materi 05',
      'judul': 'Topologi Jaringan',
      'deskripsi': 'Mengenal bentuk dan susunan perangkat dalam jaringan.',
      'videoId': '7Ut4u8qVwRU',
      'color': const Color(0xFFE91E63),
    },
    {
      'number': '06',
      'materi': 'Materi 06',
      'judul': 'Protokol Jaringan',
      'deskripsi': 'Memahami fungsi protokol dalam komunikasi jaringan.',
      'videoId': 'jtqp4tnA5bE',
      'color': const Color(0xFF0288D1),
    },
    {
      'number': '07',
      'materi': 'Materi 07',
      'judul': 'Keamanan Jaringan',
      'deskripsi': 'Mengenal dasar-dasar keamanan dalam penggunaan jaringan.',
      'videoId': 'zlVtbPXDDA4',
      'color': const Color(0xFF5E35B1),
    },
    {
      'number': '08',
      'materi': 'Materi 08',
      'judul': 'Penerapan Jaringan',
      'deskripsi': 'Melihat contoh penerapan jaringan dalam kehidupan sehari-hari.',
      'videoId': 'D30i_hmXZK0',
      'color': const Color(0xFFCEAB93),
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
      final judul = video['judul'].toString().toLowerCase();
      final materi = video['materi'].toString().toLowerCase();
      final deskripsi = video['deskripsi'].toString().toLowerCase();

      return judul.contains(_searchQuery) ||
          materi.contains(_searchQuery) ||
          deskripsi.contains(_searchQuery);
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

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: primaryBrown,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            title: Text(
              localizationService.isEnglish ? 'Learning Videos' : 'Video Pembelajaran',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [
              IconButton(
                tooltip: localizationService.isEnglish ? 'Search video' : 'Cari video',
                icon: const Icon(
                  Icons.search_rounded,
                  size: 27,
                ),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: VideoSearchDelegate(
                      videos: _videos,
                      onVideoSelected: (title, videoId) => _openVideoPlayer(title, videoId),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: localizationService.isEnglish ? 'Information' : 'Informasi',
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
      },
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
            Color(0xFFAD8B73),
            Color(0xFFCEAB93),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryBrown.withValues(alpha: 0.20),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 19,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      localizationService.isEnglish ? '8 Learning Videos' : '8 Video Pembelajaran',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                localizationService.isEnglish
                    ? 'Master Network Basics\nThrough Video!'
                    : 'Kuasi Dasar Jaringan\nMelalui Video!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                localizationService.isEnglish
                    ? 'Watch educational videos prepared to deepen your understanding of computer networking basics.'
                    : 'Tonton video pembelajaran yang sudah disiapkan untuk memperdalam pemahamanmu tentang dasar jaringan komputer.',
                style: const TextStyle(
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      localizationService.isEnglish ? 'Learn easier, anytime!' : 'Belajar lebih mudah, kapan saja!',
                      style: const TextStyle(
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
            color: primaryBrown.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.video_library_rounded,
            color: primaryBrown,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizationService.isEnglish ? 'Video List' : 'Daftar Video',
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                localizationService.isEnglish ? 'Select a video to start watching' : 'Pilih video untuk mulai menonton',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => _openVideoPlayer(video['judul'], video['videoId']),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: (video['color'] as Color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    video['number'],
                    style: TextStyle(
                      color: video['color'] as Color,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: (video['color'] as Color).withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        video['materi'],
                        style: TextStyle(
                          color: video['color'] as Color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      video['judul'],
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video['deskripsi'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: primaryBrown.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: primaryBrown,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySearch() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 54,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              localizationService.isEnglish ? 'Video not found' : 'Video tidak ditemukan',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              localizationService.isEnglish
                  ? 'Try using another keyword.'
                  : 'Coba gunakan kata kunci lain.',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          localizationService.isEnglish ? 'About Learning Videos' : 'Tentang Video Pembelajaran',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          localizationService.isEnglish
              ? 'These videos are curated to help you understand computer networking concepts visually and interactively.'
              : 'Video-video ini dikurasi untuk membantu Anda memahami materi jaringan komputer secara visual dan interaktif.',
          style: const TextStyle(fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizationService.translate('close')),
          ),
        ],
      ),
    );
  }
}

class VideoSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> videos;
  final Function(String title, String videoId) onVideoSelected;

  VideoSearchDelegate({
    required this.videos,
    required this.onVideoSelected,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_rounded),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final results = videos.where((video) {
      final q = query.toLowerCase();
      return video['judul'].toString().toLowerCase().contains(q) ||
          video['materi'].toString().toLowerCase().contains(q) ||
          video['deskripsi'].toString().toLowerCase().contains(q);
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final video = results[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (video['color'] as Color).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  video['number'],
                  style: TextStyle(
                    color: video['color'] as Color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              video['judul'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              video['deskripsi'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.play_arrow_rounded),
            onTap: () {
              close(context, '');
              onVideoSelected(video['judul'], video['videoId']);
            },
          ),
        );
      },
    );
  }
}
