import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BorrowingScreen extends StatefulWidget {
  const BorrowingScreen({super.key});

  @override
  State<BorrowingScreen> createState() => _BorrowingScreenState();
}

class _BorrowingScreenState extends State<BorrowingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String _selectedCategory = 'Semua';
  String _searchQuery = '';

  String _nama = 'azer';
  String _nisn = '3781537399';
  String _kelas = 'X TKJ 2';

  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          final data = userDoc.data() ?? {};
          _nama = data['nama']?.toString() ?? 'azer';
          _nisn = data['nisn']?.toString() ?? '3781537399';
          _kelas = data['kelas']?.toString() ?? 'X TKJ 2';
        }
      }

      final itemSnapshot = await _firestore.collection('items').orderBy('nama').get();
      _items = itemSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'nama': data['nama']?.toString() ?? 'APAR',
          'kategori': data['kategori']?.toString() ?? 'K3 & ESD',
          'stok': _toInt(data['stok']),
          'tersedia': _toInt(data['tersedia']),
          'kondisi': data['kondisi']?.toString() ?? 'Baik',
          'status': data['status']?.toString() ?? 'tersedia',
          'deskripsi': data['deskripsi']?.toString() ?? 'Alat Pemadam Api Ringan. Lab TKJ',
        };
      }).toList();

      if (_items.isEmpty) {
        _items = [
          {
            'id': '1',
            'nama': 'APAR',
            'kategori': 'K3 & ESD',
            'stok': 3,
            'tersedia': 3,
            'kondisi': 'Baik',
            'status': 'tersedia',
            'deskripsi': 'Alat Pemadam Api Ringan. Lab TKJ',
          },
          {
            'id': '2',
            'nama': 'Access Point',
            'kategori': 'Perangkat Jaringan',
            'stok': 5,
            'tersedia': 4,
            'kondisi': 'Baik',
            'status': 'tersedia',
            'deskripsi': 'Access Point Dual Band Wireless.',
          },
        ];
      }

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  List<Map<String, dynamic>> get _filteredItems {
    return _items.where((item) {
      final nama = item['nama'].toString().toLowerCase();
      final kategori = item['kategori'].toString();
      final matchSearch = _searchQuery.isEmpty || nama.contains(_searchQuery);
      final matchCategory = _selectedCategory == 'Semua' || kategori == _selectedCategory;
      return matchSearch && matchCategory;
    }).toList();
  }

  List<String> get _categories => ['Semua', 'K3 & ESD', 'Perangkat Jaringan'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildMyLoansSection(bool isDark) {
    final user = _auth.currentUser;
    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('loans')
          .where('siswaId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final docs = snapshot.data!.docs;

        return Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : AppTheme.borderCream,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Riwayat & Status Peminjaman Saya',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.tealTint,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${docs.length} Pengajuan',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final namaItem = data['namaItem']?.toString() ?? 'Alat';
                final jumlah = data['jumlah'] ?? 1;
                final status = data['status']?.toString() ?? 'menunggu';
                final tglKembali = data['tanggalKembali'];

                String tglStr = '-';
                if (tglKembali is Timestamp) {
                  final dt = tglKembali.toDate();
                  tglStr = '${dt.day}/${dt.month}/${dt.year}';
                }

                Color statusColor;
                String statusText;

                switch (status) {
                  case 'menunggu':
                    statusColor = AppTheme.accentAmber;
                    statusText = 'Menunggu';
                    break;
                  case 'disetujui':
                    statusColor = AppTheme.primaryTeal;
                    statusText = 'Disetujui';
                    break;
                  case 'dipinjam':
                    statusColor = Colors.green;
                    statusText = 'Dipinjam';
                    break;
                  case 'dikembalikan':
                    statusColor = Colors.grey;
                    statusText = 'Dikembalikan';
                    break;
                  case 'ditolak':
                  default:
                    statusColor = AppTheme.accentRed;
                    statusText = 'Ditolak Guru';
                    break;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: status == 'ditolak'
                        ? AppTheme.accentRed.withValues(alpha: 0.05)
                        : (isDark ? Colors.white.withValues(alpha: 0.04) : AppTheme.surfaceCream),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: status == 'ditolak'
                          ? AppTheme.accentRed.withValues(alpha: 0.3)
                          : AppTheme.borderCream,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$namaItem (${jumlah}x)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                    color: isDark ? Colors.white : AppTheme.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Batas Kembali: $tglStr',
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: statusColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (status == 'ditolak') ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.accentRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.cancel_outlined, color: AppTheme.accentRed, size: 16),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Pengajuan peminjaman alat ini telah ditolak oleh Guru.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.accentRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredItems = _filteredItems;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Peminjaman', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryTeal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryTeal))
          : RefreshIndicator(
              color: AppTheme.primaryTeal,
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 50),
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryTeal, AppTheme.darkTeal],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Peminjaman Perangkat', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text('$_nama · $_kelas', style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Barang Sedang Dipinjam & Status Peminjaman
                  _buildMyLoansSection(isDark),

                  const SizedBox(height: 18),

                  // Search
                  TextField(
                    controller: _searchController,
                    style: TextStyle(color: isDark ? Colors.white : AppTheme.textDark),
                    decoration: InputDecoration(
                      hintText: 'Cari perangkat...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryTeal),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppTheme.borderCream)),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Filter Categories
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final selected = cat == _selectedCategory;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: selected,
                          onSelected: (_) => setState(() => _selectedCategory = cat),
                          labelStyle: TextStyle(color: selected ? Colors.white : (isDark ? Colors.white : AppTheme.textDark), fontSize: 11, fontWeight: FontWeight.bold),
                          selectedColor: AppTheme.primaryTeal,
                          backgroundColor: isDark ? const Color(0xFF162522) : AppTheme.surfaceCream,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PERANGKAT TERSEDIA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                        ),
                      ),
                      Text('${filteredItems.length} item', style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted)),
                    ],
                  ),

                  const SizedBox(height: 10),

                  ...filteredItems.map((item) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(color: AppTheme.tealTint, borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(Icons.inventory_2_rounded, color: AppTheme.primaryTeal, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item['nama'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textDark)),
                                      const SizedBox(height: 2),
                                      Text('${item['kategori']} • Stok: ${item['stok']}', style: const TextStyle(fontSize: 11.5, color: AppTheme.textMuted)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                                  child: Text('${item['tersedia']} tersedia', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.green)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(item['deskripsi'], style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final user = _auth.currentUser;
                                  if (user != null) {
                                    await _firestore.collection('loans').add({
                                      'siswaId': user.uid,
                                      'namaSiswa': _nama,
                                      'nisn': _nisn,
                                      'kelas': _kelas,
                                      'itemId': item['id'] ?? '',
                                      'namaItem': item['nama'] ?? 'Alat TKJ',
                                      'kategori': item['kategori'] ?? 'Umum',
                                      'jumlah': 1,
                                      'tanggalPinjam': FieldValue.serverTimestamp(),
                                      'tanggalKembali': Timestamp.fromDate(DateTime.now().add(const Duration(days: 3))),
                                      'catatan': 'Peminjaman alat laboratorium TKJ',
                                      'status': 'menunggu',
                                      'createdAt': FieldValue.serverTimestamp(),
                                    });
                                  }
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Pengajuan peminjaman berhasil dikirim ke Guru!'), behavior: SnackBarBehavior.floating),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryTeal,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Ajukan Peminjaman', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
