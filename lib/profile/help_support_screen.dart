import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _faqs = [
    {
      'question': 'Bagaimana cara mengakses Materi Pembelajaran?',
      'answer':
          'Kamu dapat mengakses materi dari menu "Materi TKJ" di Dashboard. Pilih bab atau modul yang ingin dipelajari, seperti Dasar Jaringan, K3LH, IP Address, atau Kabel Jaringan.',
      'category': 'Materi',
    },
    {
      'question': 'Bagaimana cara menggunakan Kalkulator Subnetting?',
      'answer':
          'Buka menu "Kalkulator Subnet" di Dashboard, masukkan IP Address dan Subnet Mask (CIDR), lalu tekan tombol "Hitung" untuk melihat detail Subnet, Broadcast, Range IP, dan jumlah Host.',
      'category': 'Fitur',
    },
    {
      'question': 'Bagaimana proses Peminjaman Perangkat TKJ?',
      'answer':
          'Pilih menu "Peminjaman" di Dashboard, cari alat yang kamu butuhkan (seperti Tang Crimping, Switch, atau Router), lalu isi formulir jumlah dan tanggal pengembalian. Pengajuan akan ditinjau oleh guru.',
      'category': 'Peminjaman',
    },
    {
      'question': 'Bagaimana cara melakukan Absensi Harian?',
      'answer':
          'Buka menu "Absen" di Dashboard saat sesi absensi dibuka oleh guru, pilih status kehadiran kamu (Hadir/Izin/Sakit), dan tekan konfirmasi.',
      'category': 'Absensi',
    },
    {
      'question': 'Bagaimana cara menjaga Streak Belajar tetap aktif?',
      'answer':
          'Streak belajar akan bertambah setiap hari ketika kamu membaca materi, melakukan kuis, atau membuka fitur pembelajaran di Netropia minimal satu kali sehari.',
      'category': 'Akun',
    },
    {
      'question': 'Bagaimana cara mengubah nama atau foto profil?',
      'answer':
          'Buka menu Profil, lalu tekan tombol "Edit Profil" di bagian atas atau masuk melalui menu Pengaturan > Edit Nama / Edit Foto.',
      'category': 'Akun',
    },
  ];

  List<Map<String, String>> get _filteredFaqs {
    if (_searchQuery.trim().isEmpty) return _faqs;
    return _faqs.where((faq) {
      final q = faq['question']!.toLowerCase();
      final a = faq['answer']!.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return q.contains(query) || a.contains(query);
    }).toList();
  }

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.feedback_rounded, color: Color(0xFFAD8B73)),
            SizedBox(width: 8),
            Text('Kirim Masukan'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Punya kendala, saran, atau pertanyaan lain? Tuliskan pesanmu di bawah ini.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tuliskan pesan kamu di sini...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_feedbackController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _feedbackController.clear();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Terima kasih! Masukan kamu telah terkirim.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAD8B73),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Bantuan & Layanan', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SEARCH BAR
            TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Cari pertanyaan bantuan...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFAD8B73)),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // HUBUNGI KAMI CONTACT CARDS
            Text(
              'Layanan Bantuan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildContactCard(
                    icon: Icons.email_rounded,
                    color: const Color(0xFF0277BD),
                    title: 'Email',
                    subtitle: 'support@netropia.id',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Email support: support@netropia.id')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildContactCard(
                    icon: Icons.chat_rounded,
                    color: const Color(0xFF2E7D32),
                    title: 'Live Chat',
                    subtitle: 'Hubungi Admin',
                    onTap: _showFeedbackDialog,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // FAQ SECTION
            Text(
              'Pertanyaan Sering Diajukan (FAQ)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 12),

            _filteredFaqs.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'Tidak ada pertanyaan yang sesuai',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredFaqs.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.grey.withOpacity(0.15),
                      ),
                      itemBuilder: (context, index) {
                        final faq = _filteredFaqs[index];
                        return ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFAD8B73).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.help_outline_rounded,
                              color: Color(0xFFAD8B73),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            faq['question']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Text(
                                faq['answer']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.8),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 25),

            // KIRIM FEEDBACK CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFAD8B73), Color(0xFFCEAB93)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Masih butuh bantuan?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kirimkan pertanyaan atau saran kamu ke tim pengembang.',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _showFeedbackDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFAD8B73),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Hubungi', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
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
}
