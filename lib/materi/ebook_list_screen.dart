import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_pressable.dart';
import 'pdf_flipbook_reader_screen.dart';

class EbookListScreen extends StatefulWidget {
  const EbookListScreen({super.key});

  @override
  State<EbookListScreen> createState() => _EbookListScreenState();
}

class _EbookListScreenState extends State<EbookListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  static const List<Map<String, String>> _allEbooks = [
    {
      'title': 'Jaringan Dasar 1',
      'class': 'Kelas 10 SMK',
      'category': 'Kelas X',
      'asset': 'assets/ebook/Kelas_10_SMK_Jaringan_Dasar_1.pdf',
      'description': 'Modul resmi konsep dasar jaringan komputer, topologi, dan OSI Layer.',
    },
    {
      'title': 'Jaringan Dasar 2',
      'class': 'Kelas 10 SMK',
      'category': 'Kelas X',
      'asset': 'assets/ebook/Kelas_10_SMK_Jaringan_Dasar_2.pdf',
      'description': 'Pengalamatan IP Address IPv4, Subnetting, dan konfigurasi jaringan.',
    },
    {
      'title': 'Perakitan Komputer 1',
      'class': 'Kelas 10 SMK',
      'category': 'Kelas X',
      'asset': 'assets/ebook/Kelas_10_SMK_Perakitan_Komputer_1.pdf',
      'description': 'Mengenal komponen hardware utama, Processor, RAM, Motherboard, dan Power Supply.',
    },
    {
      'title': 'Perakitan Komputer 2',
      'class': 'Kelas 10 SMK',
      'category': 'Kelas X',
      'asset': 'assets/ebook/Kelas_10_SMK_Perakitan_Komputer_2.pdf',
      'description': 'Langkah praktikum perakitan PC, troubleshooting hardware, dan BIOS.',
    },
    {
      'title': 'Sistem Operasi 1',
      'class': 'Kelas 10 SMK',
      'category': 'Kelas X',
      'asset': 'assets/ebook/Kelas_10_SMK_Sistem_Operasi_1.pdf',
      'description': 'Konsep dasar Sistem Operasi GUI & CLI (Windows & Linux).',
    },
    {
      'title': 'Sistem Operasi 2',
      'class': 'Kelas 10 SMK',
      'category': 'Kelas X',
      'asset': 'assets/ebook/Kelas_10_SMK_Sistem_Operasi_2.pdf',
      'description': 'Instalasi, manajemen berkas, serta utilitas sistem operasi.',
    },
    {
      'title': 'Pemrograman Web 1',
      'class': 'Kelas 10 SMK',
      'category': 'Kelas X',
      'asset': 'assets/ebook/Kelas_10_SMK_Pemrograman_Web_1.pdf',
      'description': 'Dasar HTML, CSS, dan pembuatan layout halaman web interaktif.',
    },
    {
      'title': 'Simulasi Digital 1',
      'class': 'Kelas 10 SMK',
      'category': 'Kelas X',
      'asset': 'assets/ebook/Kelas_10_SMK_Simulasi_Digital_1.pdf',
      'description': 'Komunikasi dalam jaringan, penelusuran informasi, dan kolaborasi digital.',
    },
    {
      'title': 'Simulasi Digital 2',
      'class': 'Kelas 10 SMK',
      'category': 'Kelas X',
      'asset': 'assets/ebook/Kelas_10_SMK_Simulasi_Digital_2.pdf',
      'description': 'Pembuatan e-book, presentasi video, dan publikasi digital.',
    },
    {
      'title': 'Sistem Operasi Jaringan 1',
      'class': 'Kelas 11 SMK',
      'category': 'Kelas XI',
      'asset': 'assets/ebook/Kelas_11_SMK_Sistem_Operasi_Jaringan_1.pdf',
      'description': 'Administrasi server Linux/Windows, DHCP, DNS, dan Web Server.',
    },
    {
      'title': 'Sistem Operasi Jaringan 2',
      'class': 'Kelas 11 SMK',
      'category': 'Kelas XI',
      'asset': 'assets/ebook/Kelas_11_SMK_Sistem_Operasi_Jaringan_2.pdf',
      'description': 'FTP, Mail Server, Remote Server, dan keamanan sistem operasi jaringan.',
    },
    {
      'title': 'Basis Data 2',
      'class': 'Kelas 11 SMK',
      'category': 'Kelas XI',
      'asset': 'assets/ebook/Kelas_11_SMK_Basis_Data_2.pdf',
      'description': 'Perancangan ERD, SQL query, Joins, dan DDL/DML database.',
    },
    {
      'title': 'Desain Grafis',
      'class': 'Kelas 11 SMK',
      'category': 'Kelas XI',
      'asset': 'assets/ebook/Kelas_11_SMK_Desain_Grafis.pdf',
      'description': 'Prinsip desain vektor & bitmap menggunakan Photoshop & CorelDraw.',
    },
    {
      'title': 'Desain Multimedia 1',
      'class': 'Kelas 11 SMK',
      'category': 'Kelas XI',
      'asset': 'assets/ebook/Kelas_11_SMK_Desain_Multimedia_1.pdf',
      'description': 'Alir produksi multimedia, animasi 2D/3D, dan pengolahan audio video.',
    },
    {
      'title': 'Desain Multimedia 2',
      'class': 'Kelas 11 SMK',
      'category': 'Kelas XI',
      'asset': 'assets/ebook/Kelas_11_SMK_Desain_Multimedia_2.pdf',
      'description': 'Interaktivitas multimedia, authoring tools, dan rendering.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredEbooks = _allEbooks.where((ebook) {
      final matchesCategory = _selectedCategory == 'Semua' || ebook['category'] == _selectedCategory;
      final matchesQuery = ebook['title']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          ebook['description']!.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Perpustakaan E-Book TKJ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryBrown, AppTheme.darkBrown],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBrown.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Flipbook E-Book TKJ',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Baca modul SMK secara interaktif dengan efek membalik halaman 3D seperti buku fisik.',
                          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11.5, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Cari judul e-book atau modul...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryBrown),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: isDark ? Colors.white.withOpacity(0.1) : AppTheme.borderCream),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category Tabs
            Row(
              children: ['Semua', 'Kelas X', 'Kelas XI'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryBrown,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // E-Book Cards List
            if (filteredEbooks.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded, size: 50, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      const Text(
                        'E-Book tidak ditemukan',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filteredEbooks.map((ebook) {
                return _buildEbookCard(context, isDark, ebook);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildEbookCard(BuildContext context, bool isDark, Map<String, String> ebook) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Book Cover Badge
            Container(
              width: 58,
              height: 76,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryBrown, AppTheme.darkBrown],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBrown.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book_rounded, color: Colors.white, size: 28),
                  SizedBox(height: 4),
                  Text(
                    'PDF',
                    style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.brownTint,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          ebook['class']!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBrown,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ebook['title']!,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ebook['description']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppTheme.textMuted,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Open Flipbook Button
                  AnimatedPressable(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PdfFlipbookReaderScreen(
                            assetPath: ebook['asset']!,
                            title: ebook['title']!,
                          ),
                        ),
                      );
                    },
                    scaleFactor: 0.95,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBrown,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flip_to_front_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Baca Flipbook 3D',
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
}
