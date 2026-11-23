import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PortofolioScreen extends StatefulWidget {
  final String materiId;
  final String materiTitle;

  const PortofolioScreen({
    super.key,
    this.materiId = 'dasar_jaringan',
    this.materiTitle = 'Dasar Jaringan',
  });

  @override
  State<PortofolioScreen> createState() => _PortofolioScreenState();
}

class _PortofolioScreenState extends State<PortofolioScreen> {
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Praktik',
    'Proyek',
    'Tugas',
  ];

  late final List<_PortfolioItem> _items = [
    _PortfolioItem(
      title: 'Membuat Kabel UTP',
      category: 'Praktik',
      description:
          'Dokumentasi praktik pembuatan kabel UTP straight dan cross. Karya ini berisi proses penyusunan warna kabel, pemasangan konektor RJ45, dan pengujian menggunakan LAN tester.',
      date: '12 September 2026',
      icon: Icons.cable_rounded,
      color: AppTheme.primaryTeal,
      tag: 'Kabel Jaringan',
    ),
    _PortfolioItem(
      title: 'Rancangan Jaringan LAN',
      category: 'Proyek',
      description:
          'Rancangan jaringan LAN sederhana untuk laboratorium komputer sekolah dengan memperhatikan kebutuhan perangkat dan hubungan antarkomputer.',
      date: '15 September 2026',
      icon: Icons.hub_rounded,
      color: AppTheme.primaryTeal,
      tag: 'Dasar Jaringan',
    ),
  ];

  List<_PortfolioItem> get _filteredItems {
    if (_selectedCategory == 'Semua') return _items;
    return _items.where((item) => item.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Portofolio Saya',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            const SizedBox(height: 18),
            _buildStats(isDark),
            const SizedBox(height: 22),
            Text(
              'GALERI KARYA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Kumpulan proses dan hasil belajarmu.',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 12),
            _buildFilterChips(isDark),
            const SizedBox(height: 14),
            _buildPortfolioList(isDark),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddWorkDialog,
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah karya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [AppTheme.primaryTeal, AppTheme.darkTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'PORTOFOLIO BELAJAR · ${widget.materiTitle.toUpperCase()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Dokumentasikan\nkarya terbaikmu!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Simpan tugas, hasil praktik, dan proyek ${widget.materiTitle} sebagai rekam jejak prestasimu.',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(bool isDark) {
    return Row(
      children: [
        _statCard('Total Karya', '${_items.length}', Icons.work_history_rounded, AppTheme.primaryTeal, isDark),
        const SizedBox(width: 10),
        _statCard('Praktik', '${_items.where((e) => e.category == 'Praktik').length}', Icons.build_rounded, AppTheme.primaryTeal, isDark),
        const SizedBox(width: 10),
        _statCard('Proyek', '${_items.where((e) => e.category == 'Proyek').length}', Icons.account_tree_rounded, AppTheme.accentAmber, isDark),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.textDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((category) {
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: AppTheme.primaryTeal,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (isDark ? Colors.white : AppTheme.textDark),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11.5,
              ),
              backgroundColor: isDark ? const Color(0xFF162522) : AppTheme.surfaceCream,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isSelected ? AppTheme.primaryTeal : AppTheme.borderCream,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPortfolioList(bool isDark) {
    final filtered = _filteredItems;
    if (filtered.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('Belum ada karya dalam kategori ini.', style: TextStyle(color: AppTheme.textMuted)),
        ),
      );
    }

    return Column(
      children: filtered.map((item) => _buildPortfolioCard(item, isDark)).toList(),
    );
  }

  Widget _buildPortfolioCard(_PortfolioItem item, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.tealTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: AppTheme.primaryTeal, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppTheme.textDark,
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.date,
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.tealTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.category,
                  style: const TextStyle(
                    color: AppTheme.primaryTeal,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.description,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F322E) : AppTheme.surfaceCream,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '# ${item.tag}',
              style: TextStyle(color: isDark ? Colors.white70 : AppTheme.textDark, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddWorkDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = 'Praktik';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Text('Tambah Karya Baru', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(hintText: 'Judul Karya'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: category,
                items: ['Praktik', 'Proyek', 'Tugas']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setDialogState(() => category = val);
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Deskripsi karya...'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    _items.insert(
                      0,
                      _PortfolioItem(
                        title: titleCtrl.text.trim(),
                        category: category,
                        description: descCtrl.text.trim().isEmpty ? 'Dokumentasi karya.' : descCtrl.text.trim(),
                        date: 'Hari ini',
                        icon: Icons.star_rounded,
                        color: AppTheme.primaryTeal,
                        tag: widget.materiTitle,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortfolioItem {
  final String title;
  final String category;
  final String description;
  final String date;
  final IconData icon;
  final Color color;
  final String tag;

  _PortfolioItem({
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.icon,
    required this.color,
    required this.tag,
  });
}
