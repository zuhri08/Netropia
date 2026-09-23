import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'referensi_data.dart';

class ReferensiScreen extends StatefulWidget {
  final String materiId;
  final String materiTitle;

  const ReferensiScreen({
    super.key,
    required this.materiId,
    required this.materiTitle,
  });

  @override
  State<ReferensiScreen> createState() => _ReferensiScreenState();
}

class _ReferensiScreenState extends State<ReferensiScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ReferensiItem> get _allReferences {
    return ReferensiData.byMateri(widget.materiId);
  }

  List<String> get _categories {
    final categories = _allReferences
        .map((item) => item.kategori)
        .toSet()
        .toList();

    return ['Semua', ...categories];
  }

  List<ReferensiItem> get _filteredReferences {
    final query = _searchQuery.trim().toLowerCase();

    return _allReferences.where((item) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          item.kategori == _selectedCategory;

      final matchesSearch = query.isEmpty ||
          item.nama.toLowerCase().contains(query) ||
          item.kategori.toLowerCase().contains(query) ||
          item.deskripsi.toLowerCase().contains(query);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  Future<void> _openWebsite(String url) async {
    final uri = Uri.parse(url);

    try {
      final success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success && mounted) {
        _showMessage('Website tidak dapat dibuka.');
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage('Terjadi kesalahan saat membuka website.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final references = _filteredReferences;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF173B72),
        elevation: 0,
        titleSpacing: 20,
        title: Text(
          'Referensi',
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearch(),
            _buildCategoryFilter(),
            Expanded(
              child: references.isEmpty
                  ? _buildEmptyState()
                  : _buildReferenceList(references),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final total = _allReferences.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF123B72),
            Color(0xFF1E65B8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF123B72).withOpacity(0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.13),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PERPUSTAKAAN DIGITAL',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.materiTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$total sumber pilihan untuk memperluas pemahamanmu.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari sumber referensi...',
          hintStyle: const TextStyle(
            color: Color(0xFF98A2B3),
            fontSize: 13,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF1565C0),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            onPressed: () {
              _searchController.clear();

              setState(() {
                _searchQuery = '';
              });
            },
            icon: const Icon(
              Icons.close_rounded,
              size: 20,
            ),
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(0xFF1565C0),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final selected = category == _selectedCategory;

          return ChoiceChip(
            label: Text(category),
            selected: selected,
            onSelected: (_) {
              setState(() {
                _selectedCategory = category;
              });
            },
            labelStyle: TextStyle(
              color: selected
                  ? Colors.white
                  : const Color(0xFF526071),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            selectedColor: const Color(0xFF1565C0),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: selected
                  ? const Color(0xFF1565C0)
                  : const Color(0xFFE4E9EF),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 4,
            ),
          );
        },
      ),
    );
  }

  Widget _buildReferenceList(List<ReferensiItem> references) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      itemCount: references.length,
      itemBuilder: (context, index) {
        return _ReferenceCard(
          item: references[index],
          index: index,
          onTap: () => _openWebsite(references[index].url),
        );
      },
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
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: Color(0xFF1565C0),
                size: 34,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Referensi tidak ditemukan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF172B4D),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Coba gunakan kata kunci atau kategori lain.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF718096),
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                  _selectedCategory = 'Semua';
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1565C0),
                side: const BorderSide(
                  color: Color(0xFFB9D1F2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Tampilkan Semua',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferenceCard extends StatefulWidget {
  final ReferensiItem item;
  final int index;
  final VoidCallback onTap;

  const _ReferenceCard({
    required this.item,
    required this.index,
    required this.onTap,
  });

  @override
  State<_ReferenceCard> createState() => _ReferenceCardState();
}

class _ReferenceCardState extends State<_ReferenceCard> {
  bool _pressed = false;

  Color get _accentColor {
    switch (widget.item.kategori) {
      case 'K3 & K3LH':
        return const Color(0xFFE67E22);

      case 'Modul Pembelajaran':
        return const Color(0xFF8E44AD);

      case 'Materi Komputer':
        return const Color(0xFF1565C0);

      case 'Networking':
        return const Color(0xFF00838F);

      case 'IP Address':
        return const Color(0xFF2E7D32);

      case 'Kabel Jaringan':
        return const Color(0xFF6A4C93);

      case 'Dasar Jaringan':
        return const Color(0xFF1565C0);

      case 'Bacaan Tambahan':
        return const Color(0xFFE65100);

      case 'Teknologi':
        return const Color(0xFF2E7D32);

      default:
        return const Color(0xFF1565C0);
    }
  }

  IconData get _icon {
    switch (widget.item.kategori) {
      case 'K3 & K3LH':
        return Icons.health_and_safety_rounded;

      case 'Modul Pembelajaran':
        return Icons.menu_book_rounded;

      case 'Materi Komputer':
        return Icons.computer_rounded;

      case 'Networking':
        return Icons.account_tree_rounded;

      case 'IP Address':
        return Icons.dns_rounded;

      case 'Kabel Jaringan':
        return Icons.cable_rounded;

      case 'Dasar Jaringan':
        return Icons.lan_rounded;

      case 'Bacaan Tambahan':
        return Icons.library_books_rounded;

      case 'Teknologi':
        return Icons.code_rounded;

      default:
        return Icons.language_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _accentColor;

    return AnimatedScale(
      scale: _pressed ? 0.985 : 1,
      duration: const Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) {
              setState(() {
                _pressed = true;
              });
            },
            onTapCancel: () {
              setState(() {
                _pressed = false;
              });
            },
            onTapUp: (_) {
              setState(() {
                _pressed = false;
              });
            },
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
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _icon,
                          color: color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.nama,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF172B4D),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.08),
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.item.kategori,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_outward_rounded,
                        color: Colors.grey.shade400,
                        size: 19,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.item.deskripsi,
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 12,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Sumber belajar eksternal',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        'Kunjungi',
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: color,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}