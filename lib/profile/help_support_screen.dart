import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';

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
            'Buka menu "Absen" di Dashboard saat sesi absensi dibuka oleh guru, masukkan kode absensi, dan tekan konfirmasi.',
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
      builder: (dialogContext) {
        bool isSending = false;

        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.feedback_rounded,
                  color: AppTheme.primaryBrown,
                ),
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
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _feedbackController,
                  maxLines: 4,
                  maxLength: 500,
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
                onPressed: isSending ? null : () => Navigator.pop(dialogContext),
                child: Text(localizationService.translate('cancel')),
              ),
              ElevatedButton(
                onPressed: isSending
                    ? null
                    : () async {
                        final message = _feedbackController.text.trim();
                        if (message.isEmpty) return;
                        final user = FirebaseAuth.instance.currentUser;
                        if (user == null) return;

                        setDialogState(() {
                          isSending = true;
                        });

                        try {
                          await FirebaseFirestore.instance.collection('masukan').add({
                            'isi': message,
                            'uid': user.uid,
                            'email': user.email,
                            'createdAt': FieldValue.serverTimestamp(),
                            'status': 'baru',
                          });

                          if (!mounted || !dialogContext.mounted) return;
                          _feedbackController.clear();
                          Navigator.pop(dialogContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Masukan berhasil dikirim. Terima kasih!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;
                        } finally {
                          if (dialogContext.mounted) {
                            setDialogState(() {
                              isSending = false;
                            });
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBrown,
                  foregroundColor: Colors.white,
                ),
                child: isSending
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Kirim'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(
              'Bantuan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppTheme.primaryBrown,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER BANNER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryBrown, AppTheme.darkBrown],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.help_center_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Ada yang bisa kami bantu?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Temukan jawaban untuk pertanyaan umum seputar Netropia di bawah ini.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // SEARCH BAR
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(
                    color: isDark ? Colors.white : AppTheme.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari pertanyaan...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppTheme.primaryBrown,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppTheme.borderCream),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'PERTANYAAN SERING DIAJUKAN (FAQ)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 10),

                ..._filteredFaqs.map((faq) => _buildFaqCard(faq, isDark)),

                const SizedBox(height: 22),

                // CONTACT & FEEDBACK CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppTheme.brownTint,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.support_agent_rounded,
                          size: 32,
                          color: AppTheme.primaryBrown,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Masih butuh bantuan?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Kirimkan pertanyaan atau masukan kamu langsung kepada tim pengembang.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: _showFeedbackDialog,
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: const Text('Kirim Masukan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBrown,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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

  Widget _buildFaqCard(Map<String, String> faq, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          faq['question']!,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textDark,
          ),
        ),
        iconColor: AppTheme.primaryBrown,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            faq['answer']!,
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? Colors.grey.shade300 : AppTheme.textDark.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
