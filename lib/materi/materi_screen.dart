import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'k3/k3_screen.dart';
import 'komponen_komputer/komponen_komputer_screen.dart';
import 'perangkat_jaringan/perangkat_jaringan_screen.dart';
import 'dasar_jaringan/dasar_jaringan_screen.dart';
import 'ip_address/ip_address_screen.dart';
import 'kabel_jaringan/kabel_jaringan_screen.dart';
import 'materi_detail_layout.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_pressable.dart';

class MateriScreen extends StatelessWidget {
  const MateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        final List<Map<String, dynamic>> materi = [
          {
            'title': 'K3',
            'subtitle': 'Keselamatan dan kesehatan kerja di bidang TKJ',
            'icon': Icons.health_and_safety_rounded,
            'color': AppTheme.primaryTeal,
            'screen': const K3Screen(),
          },
          {
            'title': 'Komponen Komputer',
            'subtitle': 'Mengenal komponen utama komputer',
            'icon': Icons.memory_rounded,
            'color': AppTheme.primaryTeal,
            'screen': const KomponenKomputerScreen(),
          },
          {
            'title': 'Perangkat Jaringan',
            'subtitle': 'Mengenal perangkat yang digunakan dalam jaringan',
            'icon': Icons.router_rounded,
            'color': AppTheme.primaryTeal,
            'screen': const PerangkatJaringanScreen(),
          },
          {
            'title': 'Dasar Jaringan',
            'subtitle': 'Konsep dasar jaringan komputer',
            'icon': Icons.account_tree_rounded,
            'color': AppTheme.primaryTeal,
            'screen': const DasarJaringanScreen(),
          },
          {
            'title': 'IP Address',
            'subtitle': 'Memahami alamat dan konfigurasi IP',
            'icon': Icons.language_rounded,
            'color': AppTheme.primaryTeal,
            'screen': const IpAddressScreen(),
          },
          {
            'title': 'Kabel Jaringan',
            'subtitle': 'Mengenal jenis dan penggunaan kabel jaringan',
            'icon': Icons.cable_rounded,
            'color': AppTheme.primaryTeal,
            'screen': const KabelJaringanScreen(),
          },
        ];

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text(
              'Materi TKJ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppTheme.primaryTeal,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryTeal, AppTheme.darkTeal],
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
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Modul Pembelajaran',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Pelajari konsep TKJ secara bertahap melalui pembelajaran yang interaktif.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                Text(
                  'PILIH MATERI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Mulai dari materi dasar kemudian lanjutkan ke materi berikutnya.',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                ...materi.map(
                  (item) => _materiCard(
                    context: context,
                    isDark: isDark,
                    title: item['title'],
                    subtitle: item['subtitle'],
                    icon: item['icon'],
                    color: item['color'],
                    screen: item['screen'],
                  ),
                ),
                _buildTeacherCustomMaterials(context, isDark),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    'Netropia • Pembelajaran TKJ SMK Kelas X',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeacherCustomMaterials(BuildContext context, bool isDark) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('custom_materials').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox();
        }

        final docs = List<QueryDocumentSnapshot>.from(snapshot.data!.docs);
        docs.sort((a, b) {
          final dataA = a.data() as Map<String, dynamic>;
          final dataB = b.data() as Map<String, dynamic>;
          final tsA = dataA['createdAt'];
          final tsB = dataB['createdAt'];
          DateTime dtA = (tsA is Timestamp) ? tsA.toDate() : DateTime.now();
          DateTime dtB = (tsB is Timestamp) ? tsB.toDate() : DateTime.now();
          return dtB.compareTo(dtA);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 22),
            Text(
              'MATERI TAMBAHAN DARI GURU',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
                color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Modul materi tambahan yang diterbitkan langsung oleh Guru',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            ...docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final title = data['judul'] ?? 'Materi Pembelajaran';
              final category = data['kategori'] ?? 'Umum';
              final guruName = data['guruName'] ?? 'Guru';

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MateriDetailLayout(
                            title: title,
                            themeColor: AppTheme.primaryTeal,
                            customMaterialContent: data['isi']?.toString() ?? '',
                            customMaterialCategory: category,
                            customMaterialGuruName: guruName,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.tealTint,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.note_alt_rounded,
                              color: AppTheme.primaryTeal,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : AppTheme.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Kategori: $category • Oleh: $guruName',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                            color: AppTheme.textMuted,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _materiCard({
    required BuildContext context,
    required bool isDark,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return AnimatedPressable(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        );
      },
      scaleFactor: 0.96,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.tealTint,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryTeal,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppTheme.textMuted,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppTheme.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
