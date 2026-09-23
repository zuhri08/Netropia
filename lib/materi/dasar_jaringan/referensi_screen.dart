import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferensiScreen extends StatefulWidget {
  const ReferensiScreen({super.key});

  @override
  State<ReferensiScreen> createState() => _ReferensiScreenState();
}

class _ReferensiScreenState extends State<ReferensiScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _references = [
    {
      'nama': 'Telkom University',
      'deskripsi':
      'Referensi tentang pengertian, fungsi, cara kerja, dan jenis-jenis jaringan komputer.',
      'kategori': 'Materi TKJ',
      'icon': Icons.school_rounded,
      'color': Color(0xFF1565C0),
      'url':
      'https://telkomuniversity.ac.id/mengenal-jaringan-komputer-definisi-fungsi-cara-kerja-dan-ragam-jenisnya/',
    },
    {
      'nama': 'BINUS University',
      'deskripsi':
      'Membahas berbagai jenis jaringan komputer dan internet beserta fungsi dan manfaatnya.',
      'kategori': 'Materi TKJ',
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFF7B1FA2),
      'url':
      'https://binus.ac.id/malang/2024/07/yuk-ketahui-jenis-jenis-jaringan-komputer-dan-internet-lengkap-dengan-fungsinya/',
    },
    {
      'nama': 'Biznet Home',
      'deskripsi':
      'Referensi mengenai jaringan komputer, jenis-jenis jaringan, serta fungsi dan manfaatnya.',
      'kategori': 'Networking',
      'icon': Icons.language_rounded,
      'color': Color(0xFF00838F),
      'url':
      'https://biznethome.net/blog/yuk-kenali-jenis-jenis-jaringan-komputer-dan-internet/',
    },
    {
      'nama': 'Kumparan',
      'deskripsi':
      'Bacaan tambahan untuk memahami pengertian jaringan komputer dan internet serta jenisnya.',
      'kategori': 'Bacaan Tambahan',
      'icon': Icons.menu_book_rounded,
      'color': Color(0xFFE65100),
      'url':
      'https://kumparan.com/ragam-info/apa-pengertian-jaringan-komputer-dan-internet-ini-penjelasannya-23vNKpplFTP',
    },
    {
      'nama': 'Dicoding',
      'deskripsi':
      'Referensi teknologi untuk memperluas pemahaman mengenai jaringan komputer dan jenis-jenisnya.',
      'kategori': 'Teknologi',
      'icon': Icons.code_rounded,
      'color': Color(0xFF2E7D32),
      'url':
      'https://www.dicoding.com/blog/apa-itu-jaringan-komputer-pengertian-dan-jenisnya/',
    },
  ];

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredReferences {
    if (_searchQuery.trim().isEmpty) {
      return _references;
    }

    final query = _searchQuery.toLowerCase().trim();

    return _references.where((reference) {
      final nama = reference['nama'].toString().toLowerCase();
      final deskripsi = reference['deskripsi'].toString().toLowerCase();
      final kategori = reference['kategori'].toString().toLowerCase();

      return nama.contains(query) ||
          deskripsi.contains(query) ||
          kategori.contains(query);
    }).toList();
  }

  Future<void> _openWebsite(String url) async {
    final uri = Uri.parse(url);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Website tidak dapat dibuka.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat membuka website.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final references = _filteredReferences;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF123B7A),
        elevation: 0,
        title: const Text(
          'Referensi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Hapus pencarian',
            onPressed: _searchQuery.isEmpty
                ? null
                : () {
              _searchController.clear();

              setState(() {
                _searchQuery = '';
              });
            },
            icon: const Icon(Icons.clear_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildSearchField(),
            Expanded(
              child: references.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  4,
                  20,
                  28,
                ),
                children: [
                  _buildSectionHeader(references.length),
                  const SizedBox(height: 12),
                  ...references.map(
                        (reference) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildReferenceCard(reference),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF123B7A),
            Color(0xFF1976D2),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF123B7A).withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: Colors.white.withOpacity(0.20),
              ),
            ),
            child: const Icon(
              Icons.library_books_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PERPUSTAKAAN DIGITAL TKJ',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Perluas Pengetahuanmu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Temukan sumber belajar tambahan untuk memahami jaringan komputer lebih luas.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.link_rounded,
                      color: Colors.white70,
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      '5 sumber referensi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari referensi...',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF1565C0),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            tooltip: 'Hapus',
            onPressed: () {
              _searchController.clear();

              setState(() {
                _searchQuery = '';
              });
            },
            icon: const Icon(Icons.close_rounded),
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF1565C0),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Referensi',
              style: TextStyle(
                color: Color(0xFF172B4D),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Sumber belajar pilihan untuk Dasar Jaringan',
              style: TextStyle(
                color: Color(0xFF718096),
                fontSize: 11,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count sumber',
            style: const TextStyle(
              color: Color(0xFF1565C0),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReferenceCard(Map<String, dynamic> reference) {
    final Color color = reference['color'] as Color;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => _openWebsite(reference['url']),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE8EDF3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      reference['icon'] as IconData,
                      color: color,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reference['nama'],
                          style: const TextStyle(
                            color: Color(0xFF172B4D),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.09),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            reference['kategori'],
                            style: TextStyle(
                              color: color,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.open_in_new_rounded,
                    color: Colors.grey.shade400,
                    size: 19,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                reference['deskripsi'],
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 12,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _openWebsite(reference['url']),
                  icon: const Icon(
                    Icons.language_rounded,
                    size: 17,
                  ),
                  label: const Text(
                    'Kunjungi Website',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(
                      color: color.withOpacity(0.25),
                    ),
                    backgroundColor: color.withOpacity(0.04),
                    padding: const EdgeInsets.symmetric(
                      vertical: 11,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: Color(0xFF1565C0),
                size: 35,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Referensi Tidak Ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF172B4D),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Coba gunakan kata kunci pencarian yang berbeda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF718096),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}