import 'package:flutter/material.dart';

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
  static const Color primary = Color(0xFFAD8B73);
  static const Color dark = Color(0xFF172B4D);
  static const Color muted = Color(0xFF718096);
  static const Color background = Color(0xFFF4F7FB);

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
      'Dokumentasi praktik pembuatan kabel UTP straight dan cross. '
          'Karya ini berisi proses penyusunan warna kabel, pemasangan konektor RJ45, '
          'dan pengujian menggunakan LAN tester.',
      date: '12 September 2026',
      icon: Icons.cable_rounded,
      color: const Color(0xFF0D9488),
      tag: 'Kabel Jaringan',
    ),
    _PortfolioItem(
      title: 'Rancangan Jaringan LAN',
      category: 'Proyek',
      description:
      'Rancangan jaringan LAN sederhana untuk laboratorium komputer sekolah '
          'dengan memperhatikan kebutuhan perangkat dan hubungan antarkomputer.',
      date: '15 September 2026',
      icon: Icons.hub_rounded,
      color: const Color(0xFFAD8B73),
      tag: 'Dasar Jaringan',
    ),
    _PortfolioItem(
      title: 'Identifikasi Komponen PC',
      category: 'Tugas',
      description:
      'Catatan hasil identifikasi komponen komputer beserta fungsi dasar '
          'dari setiap perangkat keras.',
      date: '18 September 2026',
      icon: Icons.memory_rounded,
      color: const Color(0xFF9333EA),
      tag: 'Komponen Komputer',
    ),
    _PortfolioItem(
      title: 'Analisis Subnetting IP',
      category: 'Tugas',
      description:
      'Perhitungan subnetting dan pembagian segmen IP address untuk ruang kelas.',
      date: '20 September 2026',
      icon: Icons.calculate_rounded,
      color: const Color(0xFFEA8A18),
      tag: 'IP Address',
    ),
  ];

  List<_PortfolioItem> get _filteredItems {
    if (_selectedCategory == 'Semua') return _items;
    return _items.where((item) => item.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Portofolio Saya - ${widget.materiTitle}',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: _showPortfolioGuide,
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Panduan portofolio',
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHero(),
            const SizedBox(height: 20),
            _buildStats(),
            const SizedBox(height: 28),
            _buildSectionTitle(
              'Galeri karya',
              'Kumpulan proses dan hasil belajarmu.',
            ),
            const SizedBox(height: 14),
            _buildFilterChips(),
            const SizedBox(height: 16),
            _buildPortfolioList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddWorkDialog,
        backgroundColor: primary,
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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFAD8B73), Color(0xFFCEAB93)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -4,
            child: Icon(
              Icons.folder_special_rounded,
              size: 110,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'PORTOFOLIO BELAJAR • ${widget.materiTitle.toUpperCase()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Dokumentasikan\nkarya terbaikmu!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  height: 1.18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Simpan tugas, hasil praktik, dan proyek ${widget.materiTitle} sebagai rekam jejak prestasimu.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _statCard('Total karya', '${_items.length}', Icons.work_history_rounded, primary),
        const SizedBox(width: 10),
        _statCard('Praktik', '${_items.where((e) => e.category == 'Praktik').length}', Icons.build_rounded, const Color(0xFF0D9488)),
        const SizedBox(width: 10),
        _statCard('Proyek', '${_items.where((e) => e.category == 'Proyek').length}', Icons.account_tree_rounded, const Color(0xFFEA8A18)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE8EDF5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                color: dark,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: dark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(color: muted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
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
              selectedColor: primary.withOpacity(0.15),
              checkmarkColor: primary,
              labelStyle: TextStyle(
                color: isSelected ? primary : dark,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected ? primary : const Color(0xFFE8EDF5),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPortfolioList() {
    final filtered = _filteredItems;

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Icon(Icons.folder_off_rounded, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              const Text(
                'Belum ada karya dalam kategori ini',
                style: TextStyle(color: dark, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: filtered.map((item) => _buildPortfolioCard(item)).toList(),
    );
  }

  Widget _buildPortfolioCard(_PortfolioItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: dark,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.date,
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.category,
                  style: const TextStyle(
                    color: primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.description,
            style: const TextStyle(
              color: muted,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '# ${item.tag}',
                  style: const TextStyle(color: dark, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPortfolioGuide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Panduan Portofolio', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'Portofolio adalah tempat mengumpulkan hasil karya belajarmu. '
          'Kamu bisa mendokumentasikan tugas praktik, proyek jaringan, maupun hasil kuis terbaikmu.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Tambah Karya Baru', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Judul Karya', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    hintText: 'Misal: Praktik Kabel UTP',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFD),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Kategori', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: category,
                  items: ['Praktik', 'Proyek', 'Tugas']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => category = val);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF8FAFD),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Deskripsi Karya', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Jelaskan singkat proses atau hasil karya...',
                    filled: true,
                    fillColor: const Color(0xFFF8FAFD),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isNotEmpty) {
                  setState(() {
                    _items.insert(
                      0,
                      _PortfolioItem(
                        title: titleCtrl.text.trim(),
                        category: category,
                        description: descCtrl.text.trim().isEmpty
                            ? 'Dokumentasi karya siswa.'
                            : descCtrl.text.trim(),
                        date: 'Hari ini',
                        icon: Icons.star_rounded,
                        color: primary,
                        tag: widget.materiTitle,
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Karya berhasil ditambahkan ke portofolio!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
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
