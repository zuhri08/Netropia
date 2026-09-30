import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  String _searchQuery = '';

  List<Map<String, String>> get _faqs {
    if (localizationService.isEnglish) {
      return [
        {
          'question': 'How to access Learning Materials?',
          'answer': 'You can access materials from the "TKJ Materials" menu on the Dashboard. Select the module you want to study.',
          'category': 'Materials',
        },
        {
          'question': 'How to use Subnet Calculator?',
          'answer': 'Open the "Subnet Calculator" menu on the Dashboard, enter the IP Address and Subnet Mask (CIDR), then press "Calculate".',
          'category': 'Features',
        },
        {
          'question': 'How does TKJ Equipment Borrowing work?',
          'answer': 'Select the "Borrowing" menu on the Dashboard, search for the tool you need, and submit a borrowing request.',
          'category': 'Borrowing',
        },
        {
          'question': 'How to perform Daily Attendance?',
          'answer': 'Open "Attendance" on the Dashboard when an active session is opened by your teacher, enter the attendance code and confirm.',
          'category': 'Attendance',
        },
        {
          'question': 'How to keep Learning Streak active?',
          'answer': 'Your streak increases each day when you read materials, complete quizzes, or open learning features in Netropia at least once a day.',
          'category': 'Account',
        },
      ];
    }
    return [
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
    ];
  }

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
        title: Row(
          children: [
            const Icon(Icons.feedback_rounded, color: Color(0xFFAD8B73)),
            const SizedBox(width: 8),
            Text(localizationService.isEnglish ? 'Send Feedback' : 'Kirim Masukan'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizationService.isEnglish
                  ? 'Have an issue or suggestion? Write your message below.'
                  : 'Punya kendala, saran, atau pertanyaan lain? Tuliskan pesanmu di bawah ini.',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: localizationService.isEnglish ? 'Write your message here...' : 'Tuliskan pesan kamu di sini...',
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
            child: Text(localizationService.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              if (_feedbackController.text.trim().isNotEmpty) {
                _feedbackController.clear();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(localizationService.isEnglish ? 'Feedback sent! Thank you.' : 'Masukan kamu telah terkirim! Terima kasih.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAD8B73),
              foregroundColor: Colors.white,
            ),
            child: Text(localizationService.isEnglish ? 'Send' : 'Kirim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              localizationService.translate('help'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: const Color(0xFFAD8B73),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER BANNER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFAD8B73), Color(0xFFCEAB93)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.help_center_rounded, color: Colors.white, size: 40),
                      const SizedBox(height: 12),
                      Text(
                        localizationService.isEnglish ? 'How can we help you?' : 'Ada yang bisa kami bantu?',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localizationService.isEnglish ? 'Find answers to your questions below.' : 'Temukan jawaban untuk pertanyaan umum seputar Netropia di bawah ini.',
                        style: const TextStyle(fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // SEARCH BAR
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                  decoration: InputDecoration(
                    hintText: localizationService.isEnglish ? 'Search questions...' : 'Cari pertanyaan...',
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFFAD8B73)),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Text(
                  localizationService.isEnglish ? 'Frequently Asked Questions (FAQ)' : 'Pertanyaan Sering Diajukan (FAQ)',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 12),

                ..._filteredFaqs.map((faq) => _buildFaqCard(faq)),

                const SizedBox(height: 25),

                // CONTACT & FEEDBACK CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.support_agent_rounded, size: 40, color: Color(0xFFAD8B73)),
                      const SizedBox(height: 10),
                      Text(
                        localizationService.isEnglish ? 'Still need help?' : 'Masih butuh bantuan?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        localizationService.isEnglish ? 'Send your questions or feedback to our team.' : 'Kirimkan pertanyaan atau masukan kamu langsung kepada tim pengembang.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton.icon(
                          onPressed: _showFeedbackDialog,
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: Text(localizationService.isEnglish ? 'Send Feedback' : 'Kirim Masukan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFAD8B73),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      },
    );
  }

  Widget _buildFaqCard(Map<String, String> faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        title: Text(
          faq['question']!,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        iconColor: const Color(0xFFAD8B73),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            faq['answer']!,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
