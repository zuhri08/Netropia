import 'package:flutter/material.dart';

class PortofolioScreen extends StatefulWidget {
  const PortofolioScreen({super.key});

  @override
  State<PortofolioScreen> createState() => _PortofolioScreenState();
}

class _PortofolioScreenState extends State<PortofolioScreen> {
  static const Color primary = Color(0xFF2563EB);
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

  final List<_PortfolioItem> _items = [
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
      tag: 'Jaringan Komputer',
    ),
    _PortfolioItem(
      title: 'Rancangan Jaringan LAN',
      category: 'Proyek',
      description:
      'Rancangan jaringan LAN sederhana untuk laboratorium komputer sekolah '
          'dengan memperhatikan kebutuhan perangkat dan hubungan antarkomputer.',
      date: '15 September 2026',
      icon: Icons.hub_rounded,
      color: const Color(0xFF2563EB),
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
        backgroundColor: background,
        foregroundColor: dark,
        elevation: 0,
        title: const Text(
          'Portofolio Saya',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
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
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 100),
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
            _buildFilters(),
            const SizedBox(height: 16),
            if (_filteredItems.isEmpty)
              _buildEmptyState()
            else
              ..._filteredItems.map(
                    (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildPortfolioCard(item),
                ),
              ),
            const SizedBox(height: 12),
            _buildMotivation(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPortfolio,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah Karya',
          style: TextStyle(fontWeight: FontWeight.w800),
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
          colors: [Color(0xFF173E9B), Color(0xFF3478EF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            top: -10,
            child: Icon(
              Icons.auto_awesome_rounded,
              size: 115,
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'LEARNING JOURNEY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Setiap karya punya\ncerita dan proses.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Simpan hasil praktik, proyek, dan pencapaianmu '
                    'sebagai bukti perjalanan belajar TKJ.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(
                    Icons.collections_bookmark_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_items.length} karya tersimpan',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final practiceCount =
        _items.where((item) => item.category == 'Praktik').length;
    final projectCount =
        _items.where((item) => item.category == 'Proyek').length;
    final taskCount = _items.where((item) => item.category == 'Tugas').length;

    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.construction_rounded,
            label: 'Praktik',
            value: practiceCount.toString(),
            color: const Color(0xFF0D9488),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _statCard(
            icon: Icons.rocket_launch_rounded,
            label: 'Proyek',
            value: projectCount.toString(),
            color: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _statCard(
            icon: Icons.assignment_turned_in_rounded,
            label: 'Tugas',
            value: taskCount.toString(),
            color: const Color(0xFF9333EA),
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: dark,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
            fontSize: 19,
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

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((category) {
          final selected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(category),
              selected: selected,
              onSelected: (_) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              showCheckmark: false,
              selectedColor: primary,
              backgroundColor: Colors.white,
              side: BorderSide(
                color: selected ? primary : const Color(0xFFE2E8F0),
              ),
              labelStyle: TextStyle(
                color: selected ? Colors.white : dark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPortfolioCard(_PortfolioItem item) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => _showPortfolioDetail(item),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8EDF5)),
          ),
          child: Row(
            children: [
              Container(
                width: 88,
                height: 96,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      color: item.color.withOpacity(0.08),
                      size: 70,
                    ),
                    Icon(item.icon, color: item.color, size: 39),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        item.category.toUpperCase(),
                        style: TextStyle(
                          color: item.color,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: dark,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.tag,
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                          size: 11,
                          color: muted,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            item.date,
                            style: const TextStyle(
                              color: muted,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: primary,
                          size: 17,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.folder_open_rounded,
              color: primary,
              size: 36,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Belum ada karya di kategori ini',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: dark,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tambahkan hasil belajarmu untuk mulai membangun portofolio.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 15),
          OutlinedButton.icon(
            onPressed: _showAddPortfolio,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Tambah karya'),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: primary, size: 22),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'Tips: Dokumentasikan proses, bukan hanya hasil akhir. '
                  'Setiap percobaan dan perbaikan adalah bagian dari proses belajarmu.',
              style: TextStyle(
                color: Color(0xFF315B9D),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPortfolioDetail(_PortfolioItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8DEE8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(item.icon, color: item.color, size: 34),
                ),
                const SizedBox(height: 17),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: dark,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    _detailTag(item.category, item.color),
                    const SizedBox(width: 8),
                    _detailTag(item.tag, primary),
                  ],
                ),
                const SizedBox(height: 18),
                const Text(
                  'Tentang karya',
                  style: TextStyle(
                    color: dark,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: muted,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: muted,
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ditambahkan ${item.date}',
                      style: const TextStyle(color: muted, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void _showAddPortfolio() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String category = 'Praktik';
    String subject = 'Dasar Jaringan';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Container(
                            width: 42,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8DEE8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tambahkan karya baru',
                          style: TextStyle(
                            color: dark,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Ceritakan hasil belajar yang ingin kamu simpan.',
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                        const SizedBox(height: 20),
                        _formLabel('Judul karya'),
                        TextField(
                          controller: titleController,
                          decoration: _inputDecoration(
                            'Contoh: Praktik konfigurasi IP',
                          ),
                        ),
                        const SizedBox(height: 15),
                        _formLabel('Kategori'),
                        DropdownButtonFormField<String>(
                          value: category,
                          decoration: _inputDecoration('Pilih kategori'),
                          items: ['Praktik', 'Proyek', 'Tugas']
                              .map(
                                (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setSheetState(() => category = value);
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        _formLabel('Materi'),
                        DropdownButtonFormField<String>(
                          value: subject,
                          decoration: _inputDecoration('Pilih materi'),
                          items: [
                            'Dasar Jaringan',
                            'Komponen Komputer',
                            'Perangkat Jaringan',
                            'IP Address',
                            'Kabel Jaringan',
                            'K3',
                            'Dasar TKJ',
                          ]
                              .map(
                                (value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setSheetState(() => subject = value);
                            }
                          },
                        ),
                        const SizedBox(height: 15),
                        _formLabel('Deskripsi karya'),
                        TextField(
                          controller: descriptionController,
                          minLines: 3,
                          maxLines: 5,
                          decoration: _inputDecoration(
                            'Jelaskan proses atau hasil yang kamu kerjakan...',
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (titleController.text.trim().isEmpty ||
                                  descriptionController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Lengkapi judul dan deskripsi karya.'),
                                  ),
                                );
                                return;
                              }

                              final color = _categoryColor(category);
                              final icon = _categoryIcon(category);

                              setState(() {
                                _items.insert(
                                  0,
                                  _PortfolioItem(
                                    title: titleController.text.trim(),
                                    category: category,
                                    description: descriptionController.text.trim(),
                                    date: 'Baru saja',
                                    icon: icon,
                                    color: color,
                                    tag: subject,
                                  ),
                                );
                                _selectedCategory = 'Semua';
                              });

                              Navigator.pop(sheetContext);
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                const SnackBar(
                                  content: Text('Karya berhasil ditambahkan.'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_rounded),
                            label: const Text(
                              'Simpan karya',
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      titleController.dispose();
      descriptionController.dispose();
    });
  }

  Widget _formLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          color: dark,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFA0AAB8), fontSize: 12),
      filled: true,
      fillColor: const Color(0xFFF8FAFD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE3EAF3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE3EAF3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: primary, width: 1.4),
      ),
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Praktik':
        return const Color(0xFF0D9488);
      case 'Proyek':
        return const Color(0xFF2563EB);
      default:
        return const Color(0xFF9333EA);
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Praktik':
        return Icons.construction_rounded;
      case 'Proyek':
        return Icons.rocket_launch_rounded;
      default:
        return Icons.assignment_rounded;
    }
  }

  void _showPortfolioGuide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Tentang Portofolio',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'Portofolio adalah tempat untuk menyimpan hasil praktik, tugas, '
              'dan proyek yang telah kamu kerjakan selama belajar TKJ. '
              'Gunakan fitur Tambah Karya untuk mencatat hasil belajarmu.',
          style: TextStyle(height: 1.5),
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
}

class _PortfolioItem {
  final String title;
  final String category;
  final String description;
  final String date;
  final IconData icon;
  final Color color;
  final String tag;

  const _PortfolioItem({
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.icon,
    required this.color,
    required this.tag,
  });
}