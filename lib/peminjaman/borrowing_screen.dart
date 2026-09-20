import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  String _nama = '';
  String _nisn = '';
  String _kelas = '';

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

  // =========================================================
  // LOAD DATA
  // =========================================================

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;

      if (user == null) {
        _showMessage('Silakan login terlebih dahulu.');
        return;
      }

      // -----------------------------------------------------
      // LOAD DATA SISWA
      // -----------------------------------------------------

      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() ?? {};

        _nama = data['nama']?.toString() ?? '';
        _nisn = data['nisn']?.toString() ?? '';
        _kelas = data['kelas']?.toString() ?? '';
      }

      // -----------------------------------------------------
      // LOAD DATA BARANG
      // -----------------------------------------------------

      final itemSnapshot = await _firestore
          .collection('items')
          .orderBy('nama')
          .get();

      _items = itemSnapshot.docs.map((doc) {
        final data = doc.data();

        return {
          'id': doc.id,
          'nama': data['nama']?.toString() ?? 'Tanpa Nama',
          'kategori': data['kategori']?.toString() ?? 'Lainnya',
          'stok': _toInt(data['stok']),
          'tersedia': _toInt(data['tersedia']),
          'kondisi': data['kondisi']?.toString() ?? 'Baik',
          'status': data['status']?.toString() ?? 'tersedia',
          'deskripsi': data['deskripsi']?.toString() ?? '',
          'lokasi': data['lokasi']?.toString() ?? '',
          'gambar': data['gambar']?.toString() ?? '',
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('ERROR LOAD PEMINJAMAN: $e');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      _showMessage(
        'Gagal memuat data peminjaman.\n$e',
        isError: true,
      );
    }
  }

  // =========================================================
  // HELPER INTEGER
  // =========================================================

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  // =========================================================
  // FILTER DATA
  // =========================================================

  List<Map<String, dynamic>> get _filteredItems {
    return _items.where((item) {
      final nama = item['nama'].toString().toLowerCase();
      final kategori = item['kategori'].toString();

      final matchSearch =
          _searchQuery.isEmpty || nama.contains(_searchQuery);

      final matchCategory =
          _selectedCategory == 'Semua' ||
              kategori == _selectedCategory;

      return matchSearch && matchCategory;
    }).toList();
  }

  List<String> get _categories {
    final categories = <String>{'Semua'};

    for (final item in _items) {
      final kategori = item['kategori']?.toString();

      if (kategori != null && kategori.isNotEmpty) {
        categories.add(kategori);
      }
    }

    return categories.toList();
  }

  // =========================================================
  // AJUKAN PEMINJAMAN
  // =========================================================

  Future<void> _showBorrowDialog(
      Map<String, dynamic> item,
      ) async {
    final int tersedia = item['tersedia'] ?? 0;

    if (tersedia <= 0) {
      _showMessage(
        'Barang "${item['nama']}" sedang tidak tersedia.',
        isError: true,
      );
      return;
    }

    int jumlah = 1;

    DateTime tanggalPinjam = DateTime.now();

    DateTime tanggalKembali =
    DateTime.now().add(const Duration(days: 1));

    final catatanController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Ajukan Peminjaman',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------------------------------------------------
                    // NAMA BARANG
                    // -------------------------------------------------

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Barang',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['nama'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tersedia: $tersedia',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // -------------------------------------------------
                    // JUMLAH
                    // -------------------------------------------------

                    const Text(
                      'Jumlah',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        IconButton(
                          onPressed: jumlah > 1
                              ? () {
                            setDialogState(() {
                              jumlah--;
                            });
                          }
                              : null,
                          icon: const Icon(
                            Icons.remove_circle_outline,
                          ),
                        ),
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Text(
                            '$jumlah',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: jumlah < tersedia
                              ? () {
                            setDialogState(() {
                              jumlah++;
                            });
                          }
                              : null,
                          icon: const Icon(
                            Icons.add_circle_outline,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // -------------------------------------------------
                    // TANGGAL PINJAM
                    // -------------------------------------------------

                    const Text(
                      'Tanggal Pinjam',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    _datePickerButton(
                      context: context,
                      date: tanggalPinjam,
                      onTap: () async {
                        final selected =
                        await showDatePicker(
                          context: context,
                          initialDate: tanggalPinjam,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );

                        if (selected != null) {
                          setDialogState(() {
                            tanggalPinjam = selected;

                            if (tanggalKembali
                                .isBefore(tanggalPinjam)) {
                              tanggalKembali = tanggalPinjam
                                  .add(const Duration(days: 1));
                            }
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    // -------------------------------------------------
                    // TANGGAL KEMBALI
                    // -------------------------------------------------

                    const Text(
                      'Tanggal Kembali',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    _datePickerButton(
                      context: context,
                      date: tanggalKembali,
                      onTap: () async {
                        final selected =
                        await showDatePicker(
                          context: context,
                          initialDate: tanggalKembali,
                          firstDate: tanggalPinjam,
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );

                        if (selected != null) {
                          setDialogState(() {
                            tanggalKembali = selected;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 14),

                    // -------------------------------------------------
                    // CATATAN
                    // -------------------------------------------------

                    const Text(
                      'Catatan',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: catatanController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText:
                        'Contoh: Untuk praktikum jaringan',
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    await _submitBorrowing(
                      item: item,
                      jumlah: jumlah,
                      tanggalPinjam: tanggalPinjam,
                      tanggalKembali: tanggalKembali,
                      catatan: catatanController.text.trim(),
                    );
                  },
                  child: const Text('Ajukan'),
                ),
              ],
            );
          },
        );
      },
    );

    catatanController.dispose();
  }

  // =========================================================
  // DATE PICKER BUTTON
  // =========================================================

  Widget _datePickerButton({
    required BuildContext context,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: Color(0xFF1565C0),
            ),
            const SizedBox(width: 10),
            Text(
              _formatDate(date),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SAVE PEMINJAMAN
  // =========================================================

  Future<void> _submitBorrowing({
    required Map<String, dynamic> item,
    required int jumlah,
    required DateTime tanggalPinjam,
    required DateTime tanggalKembali,
    required String catatan,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      _showMessage(
        'Silakan login terlebih dahulu.',
        isError: true,
      );
      return;
    }

    if (jumlah <= 0) {
      _showMessage(
        'Jumlah peminjaman tidak valid.',
        isError: true,
      );
      return;
    }

    if (tanggalKembali.isBefore(tanggalPinjam)) {
      _showMessage(
        'Tanggal kembali tidak boleh sebelum tanggal pinjam.',
        isError: true,
      );
      return;
    }

    try {
      // -------------------------------------------------------
      // CEK USER TERBARU
      // -------------------------------------------------------

      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userDoc.data() ?? {};

      final nama = userData['nama']?.toString() ?? _nama;
      final nisn = userData['nisn']?.toString() ?? _nisn;
      final kelas = userData['kelas']?.toString() ?? _kelas;

      // -------------------------------------------------------
      // CEK STOK TERBARU
      // -------------------------------------------------------

      final itemRef =
      _firestore.collection('items').doc(item['id']);

      final itemDoc = await itemRef.get();

      if (!itemDoc.exists) {
        _showMessage(
          'Data barang sudah tidak tersedia.',
          isError: true,
        );
        return;
      }

      final itemData = itemDoc.data() ?? {};

      final tersediaTerbaru =
      _toInt(itemData['tersedia']);

      if (tersediaTerbaru < jumlah) {
        _showMessage(
          'Stok tersedia tidak mencukupi.',
          isError: true,
        );
        return;
      }

      // -------------------------------------------------------
      // BUAT PENGAJUAN
      // -------------------------------------------------------

      final loanRef =
      _firestore.collection('loans').doc();

      await loanRef.set({
        'id': loanRef.id,
        'siswaId': user.uid,
        'namaSiswa': nama,
        'nisn': nisn,
        'kelas': kelas,
        'itemId': item['id'],
        'namaItem': itemData['nama']?.toString() ??
            item['nama'],
        'kategori':
        itemData['kategori']?.toString() ??
            item['kategori'],
        'jumlah': jumlah,
        'tanggalPinjam':
        Timestamp.fromDate(tanggalPinjam),
        'tanggalKembali':
        Timestamp.fromDate(tanggalKembali),
        'catatan': catatan,
        'status': 'menunggu',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      _showMessage(
        'Pengajuan peminjaman berhasil dikirim.',
      );

      setState(() {});
    } catch (e) {
      debugPrint('ERROR SUBMIT PEMINJAMAN: $e');

      if (!mounted) return;

      _showMessage(
        'Gagal mengajukan peminjaman.\n$e',
        isError: true,
      );
    }
  }

  // =========================================================
  // STATUS BARANG
  // =========================================================

  Color _getAvailabilityColor(int tersedia) {
    if (tersedia <= 0) {
      return Colors.red;
    }

    if (tersedia <= 2) {
      return Colors.orange;
    }

    return Colors.green;
  }

  String _getAvailabilityText(int tersedia) {
    if (tersedia <= 0) {
      return 'Tidak tersedia';
    }

    return '$tersedia tersedia';
  }

  // =========================================================
  // FORMAT DATE
  // =========================================================

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // =========================================================
  // MESSAGE
  // =========================================================

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peminjaman'),
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // =================================================
            // HEADER
            // =================================================

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.15),
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Peminjaman Perangkat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _nama.isEmpty
                              ? 'Siswa'
                              : _nama,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        if (_kelas.isNotEmpty)
                          Text(
                            _kelas,
                            style:
                            const TextStyle(
                              color:
                              Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // SEARCH
            // =================================================

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari perangkat...',
                prefixIcon: const Icon(
                  Icons.search,
                ),
                suffixIcon:
                _searchController.text.isNotEmpty
                    ? IconButton(
                  onPressed: () {
                    _searchController
                        .clear();
                  },
                  icon: const Icon(
                    Icons.clear,
                  ),
                )
                    : null,
              ),
            ),

            const SizedBox(height: 14),

            // =================================================
            // CATEGORY
            // =================================================

            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) =>
                const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category =
                  _categories[index];

                  final selected =
                      category ==
                          _selectedCategory;

                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory =
                            category;
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // =================================================
            // TITLE
            // =================================================

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Perangkat Tersedia',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${filteredItems.length} item',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // =================================================
            // EMPTY STATE
            // =================================================

            if (filteredItems.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 45,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Belum ada perangkat',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _items.isEmpty
                          ? 'Data perangkat belum ditambahkan ke Firestore.'
                          : 'Perangkat yang dicari tidak ditemukan.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

            // =================================================
            // ITEM LIST
            // =================================================

            ...filteredItems.map(
                  (item) => _buildItemCard(item),
            ),

            const SizedBox(height: 24),

            // =================================================
            // INFO
            // =================================================

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius:
                BorderRadius.circular(15),
              ),
              child: const Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFF1565C0),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Pengajuan peminjaman akan diperiksa oleh guru sebelum disetujui.',
                      style: TextStyle(
                        color: Color(0xFF0D47A1),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =================================================
            // RIWAYAT PEMINJAMAN
            // =================================================

            const Text(
              'Pengajuan Saya',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _buildLoanHistory(),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // ITEM CARD
  // =========================================================

  Widget _buildItemCard(
      Map<String, dynamic> item,
      ) {
    final int tersedia = item['tersedia'] ?? 0;
    final int stok = item['stok'] ?? 0;

    final availabilityColor =
    _getAvailabilityColor(tersedia);

    final status = item['status']?.toString() ??
        'tersedia';

    final bool canBorrow =
        tersedia > 0 && status == 'tersedia';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // ---------------------------------------------------
              // ICON / IMAGE
              // ---------------------------------------------------

              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius:
                  BorderRadius.circular(15),
                ),
                child: item['gambar']
                    .toString()
                    .isNotEmpty
                    ? ClipRRect(
                  borderRadius:
                  BorderRadius.circular(15),
                  child: Image.network(
                    item['gambar'],
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) {
                      return const Icon(
                        Icons.devices,
                        color:
                        Color(0xFF1565C0),
                        size: 32,
                      );
                    },
                  ),
                )
                    : const Icon(
                  Icons.devices,
                  color: Color(0xFF1565C0),
                  size: 32,
                ),
              ),

              const SizedBox(width: 14),

              // ---------------------------------------------------
              // INFO
              // ---------------------------------------------------

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['nama'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      item['kategori'],
                      style: const TextStyle(
                        color: Color(0xFF1565C0),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 15,
                          color: availabilityColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _getAvailabilityText(
                            tersedia,
                          ),
                          style: TextStyle(
                            color: availabilityColor,
                            fontSize: 12,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Stok: $stok',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Kondisi: ${item['kondisi']}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (item['deskripsi']
              .toString()
              .isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item['deskripsi'],
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ],

          if (item['lokasi']
              .toString()
              .isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item['lokasi'],
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // -------------------------------------------------------
          // BUTTON
          // -------------------------------------------------------

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: canBorrow
                  ? () => _showBorrowDialog(item)
                  : null,
              icon: const Icon(
                Icons.assignment_outlined,
                size: 19,
              ),
              label: Text(
                canBorrow
                    ? 'Ajukan Peminjaman'
                    : 'Tidak Tersedia',
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // HISTORY
  // =========================================================

  Widget _buildLoanHistory() {
    final user = _auth.currentUser;

    if (user == null) {
      return const SizedBox();
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestore
          .collection('loans')
          .where(
        'siswaId',
        isEqualTo: user.uid,
      )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Gagal memuat pengajuan: ${snapshot.error}',
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 13,
              ),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
                SizedBox(height: 10),
                Text(
                  'Belum ada pengajuan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pengajuan peminjaman kamu akan muncul di sini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        final sortedDocs = [...docs];

        sortedDocs.sort((a, b) {
          final aData = a.data();
          final bData = b.data();

          final aTimestamp =
          aData['createdAt'] as Timestamp?;

          final bTimestamp =
          bData['createdAt'] as Timestamp?;

          final aDate =
              aTimestamp?.toDate() ??
                  DateTime(2000);

          final bDate =
              bTimestamp?.toDate() ??
                  DateTime(2000);

          return bDate.compareTo(aDate);
        });

        return Column(
          children: sortedDocs.map((doc) {
            final data = doc.data();

            return _buildLoanCard(data);
          }).toList(),
        );
      },
    );
  }

  // =========================================================
  // LOAN CARD
  // =========================================================

  Widget _buildLoanCard(
      Map<String, dynamic> data,
      ) {
    final status =
        data['status']?.toString() ?? 'menunggu';

    final statusInfo =
    _getLoanStatusInfo(status);

    final tanggalPinjam =
    data['tanggalPinjam'] as Timestamp?;

    final tanggalKembali =
    data['tanggalKembali'] as Timestamp?;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data['namaItem']?.toString() ??
                      'Barang',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusInfo.color
                      .withOpacity(0.1),
                  borderRadius:
                  BorderRadius.circular(20),
                ),
                child: Text(
                  statusInfo.label,
                  style: TextStyle(
                    color: statusInfo.color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            'Jumlah: ${data['jumlah'] ?? 1}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),

          if (tanggalPinjam != null)
            Text(
              'Pinjam: ${_formatDate(tanggalPinjam.toDate())}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

          if (tanggalKembali != null)
            Text(
              'Kembali: ${_formatDate(tanggalKembali.toDate())}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),

          if ((data['catatan'] ?? '')
              .toString()
              .isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Catatan: ${data['catatan']}',
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================
  // LOAN STATUS
  // =========================================================

  _LoanStatusInfo _getLoanStatusInfo(
      String status,
      ) {
    switch (status) {
      case 'disetujui':
        return const _LoanStatusInfo(
          label: 'Disetujui',
          color: Colors.blue,
        );

      case 'dipinjam':
        return const _LoanStatusInfo(
          label: 'Sedang Dipinjam',
          color: Colors.orange,
        );

      case 'dikembalikan':
        return const _LoanStatusInfo(
          label: 'Dikembalikan',
          color: Colors.green,
        );

      case 'ditolak':
        return const _LoanStatusInfo(
          label: 'Ditolak',
          color: Colors.red,
        );

      case 'menunggu':
      default:
        return const _LoanStatusInfo(
          label: 'Menunggu',
          color: Colors.orange,
        );
    }
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// =============================================================
// LOAN STATUS INFO
// =============================================================

class _LoanStatusInfo {
  final String label;
  final Color color;

  const _LoanStatusInfo({
    required this.label,
    required this.color,
  });
}