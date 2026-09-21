import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TeacherBorrowingScreen extends StatelessWidget {
  const TeacherBorrowingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Peminjaman'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('loans')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Gagal memuat data peminjaman.\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada pengajuan peminjaman',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];

              return _LoanCard(
                loanId: doc.id,
                data: doc.data(),
              );
            },
          );
        },
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  final String loanId;
  final Map<String, dynamic> data;

  const _LoanCard({
    required this.loanId,
    required this.data,
  });

  String _formatTimestamp(dynamic value) {
    if (value is Timestamp) {
      final date = value.toDate();

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year}';
    }

    return '-';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'menunggu':
        return Colors.orange;
      case 'disetujui':
        return Colors.blue;
      case 'dipinjam':
        return Colors.green;
      case 'dikembalikan':
        return Colors.teal;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'menunggu':
        return 'Menunggu';
      case 'disetujui':
        return 'Disetujui';
      case 'dipinjam':
        return 'Sedang Dipinjam';
      case 'dikembalikan':
        return 'Dikembalikan';
      case 'ditolak':
        return 'Ditolak';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = data['status']?.toString() ?? 'menunggu';

    final namaSiswa = data['namaSiswa']?.toString() ?? '-';
    final nisn = data['nisn']?.toString() ?? '-';
    final kelas = data['kelas']?.toString() ?? '-';
    final namaItem = data['namaItem']?.toString() ?? '-';
    final kategori = data['kategori']?.toString() ?? '-';
    final jumlah = (data['jumlah'] as num?)?.toInt() ?? 0;
    final catatan = data['catatan']?.toString() ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.inventory_2_rounded,
                    color: Colors.blue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaItem,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        kategori,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(status),
                    style: TextStyle(
                      color: _statusColor(status),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Divider(),

            const SizedBox(height: 10),

            _InfoRow(
              icon: Icons.person_outline,
              label: 'Siswa',
              value: namaSiswa,
            ),

            _InfoRow(
              icon: Icons.badge_outlined,
              label: 'NISN',
              value: nisn,
            ),

            _InfoRow(
              icon: Icons.school_outlined,
              label: 'Kelas',
              value: kelas,
            ),

            _InfoRow(
              icon: Icons.numbers_outlined,
              label: 'Jumlah',
              value: '$jumlah unit',
            ),

            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Tanggal Pinjam',
              value: _formatTimestamp(data['tanggalPinjam']),
            ),

            _InfoRow(
              icon: Icons.event_outlined,
              label: 'Tanggal Kembali',
              value: _formatTimestamp(data['tanggalKembali']),
            ),

            if (catatan.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Catatan: $catatan',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            _buildActions(context, status, jumlah),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(
      BuildContext context,
      String status,
      int jumlah,
      ) {
    if (status == 'menunggu') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                _tolakPeminjaman(context);
              },
              icon: const Icon(Icons.close),
              label: const Text('Tolak'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _setujuiPeminjaman(context, jumlah);
              },
              icon: const Icon(Icons.check),
              label: const Text('Setujui'),
            ),
          ),
        ],
      );
    }

    if (status == 'disetujui') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            _tandaiDipinjam(context);
          },
          icon: const Icon(Icons.inventory),
          label: const Text('Tandai Sudah Dipinjam'),
        ),
      );
    }

    if (status == 'dipinjam') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            _tandaiDikembalikan(context, jumlah);
          },
          icon: const Icon(Icons.assignment_return),
          label: const Text('Tandai Dikembalikan'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _setujuiPeminjaman(
      BuildContext context,
      int jumlah,
      ) async {
    try {
      await FirebaseFirestore.instance.runTransaction(
            (transaction) async {
          final loanRef = FirebaseFirestore.instance
              .collection('loans')
              .doc(loanId);

          final loanSnapshot = await transaction.get(loanRef);

          if (!loanSnapshot.exists) {
            throw Exception('Data peminjaman tidak ditemukan.');
          }

          final loanData = loanSnapshot.data()!;

          final currentStatus =
              loanData['status']?.toString() ?? 'menunggu';

          if (currentStatus != 'menunggu') {
            throw Exception(
              'Peminjaman ini sudah diproses sebelumnya.',
            );
          }

          final itemId = loanData['itemId']?.toString();

          if (itemId == null || itemId.isEmpty) {
            throw Exception(
              'ID alat tidak ditemukan pada data peminjaman.',
            );
          }

          final itemRef = FirebaseFirestore.instance
              .collection('items')
              .doc(itemId);

          final itemSnapshot = await transaction.get(itemRef);

          if (!itemSnapshot.exists) {
            throw Exception(
              'Data alat tidak ditemukan.',
            );
          }

          final itemData = itemSnapshot.data()!;

          final tersedia =
              (itemData['tersedia'] as num?)?.toInt() ?? 0;

          if (tersedia < jumlah) {
            throw Exception(
              'Stok tersedia tidak mencukupi. '
                  'Tersedia: $tersedia unit, '
                  'diminta: $jumlah unit.',
            );
          }

          final stokBaru = tersedia - jumlah;

          transaction.update(
            itemRef,
            {
              'tersedia': stokBaru,
              'status': stokBaru > 0
                  ? 'tersedia'
                  : 'habis',
              'updatedAt': FieldValue.serverTimestamp(),
            },
          );

          transaction.update(
            loanRef,
            {
              'status': 'disetujui',
              'updatedAt': FieldValue.serverTimestamp(),
            },
          );
        },
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Peminjaman disetujui dan stok berhasil dikurangi.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _tolakPeminjaman(
      BuildContext context,
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection('loans')
          .doc(loanId)
          .update({
        'status': 'ditolak',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Peminjaman ditolak.'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menolak peminjaman: $e'),
        ),
      );
    }
  }

  Future<void> _tandaiDipinjam(
      BuildContext context,
      ) async {
    try {
      await FirebaseFirestore.instance
          .collection('loans')
          .doc(loanId)
          .update({
        'status': 'dipinjam',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Peminjaman ditandai sebagai sedang dipinjam.'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui status: $e'),
        ),
      );
    }
  }

  Future<void> _tandaiDikembalikan(
      BuildContext context,
      int jumlah,
      ) async {
    try {
      await FirebaseFirestore.instance.runTransaction(
            (transaction) async {
          final loanRef = FirebaseFirestore.instance
              .collection('loans')
              .doc(loanId);

          final loanSnapshot = await transaction.get(loanRef);

          if (!loanSnapshot.exists) {
            throw Exception(
              'Data peminjaman tidak ditemukan.',
            );
          }

          final loanData = loanSnapshot.data()!;

          final currentStatus =
              loanData['status']?.toString() ?? '';

          if (currentStatus != 'dipinjam') {
            throw Exception(
              'Peminjaman belum berstatus sedang dipinjam.',
            );
          }

          final itemId = loanData['itemId']?.toString();

          if (itemId == null || itemId.isEmpty) {
            throw Exception(
              'ID alat tidak ditemukan.',
            );
          }

          final itemRef = FirebaseFirestore.instance
              .collection('items')
              .doc(itemId);

          final itemSnapshot = await transaction.get(itemRef);

          if (!itemSnapshot.exists) {
            throw Exception(
              'Data alat tidak ditemukan.',
            );
          }

          final itemData = itemSnapshot.data()!;

          final tersedia =
              (itemData['tersedia'] as num?)?.toInt() ?? 0;

          final stok =
              (itemData['stok'] as num?)?.toInt() ?? tersedia;

          final tersediaBaru = tersedia + jumlah;

          final tersediaAman =
          tersediaBaru > stok ? stok : tersediaBaru;

          transaction.update(
            itemRef,
            {
              'tersedia': tersediaAman,
              'status': tersediaAman > 0
                  ? 'tersedia'
                  : 'habis',
              'updatedAt': FieldValue.serverTimestamp(),
            },
          );

          transaction.update(
            loanRef,
            {
              'status': 'dikembalikan',
              'updatedAt': FieldValue.serverTimestamp(),
            },
          );
        },
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Alat berhasil dikembalikan dan stok diperbarui.',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}