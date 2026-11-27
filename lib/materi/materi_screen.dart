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
import '../widgets/home_effects.dart';

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
            'screen': const K3Screen(),
          },
          {
            'title': 'Komponen Komputer',
            'subtitle': 'Mengenal komponen utama komputer',
            'screen': const KomponenKomputerScreen(),
          },
          {
            'title': 'Perangkat Jaringan',
            'subtitle': 'Mengenal perangkat yang digunakan dalam jaringan',
            'screen': const PerangkatJaringanScreen(),
          },
          {
            'title': 'Dasar Jaringan',
            'subtitle': 'Konsep dasar jaringan komputer',
            'screen': const DasarJaringanScreen(),
          },
          {
            'title': 'IP Address',
            'subtitle': 'Memahami alamat dan konfigurasi IP',
            'screen': const IpAddressScreen(),
          },
          {
            'title': 'Kabel Jaringan',
            'subtitle': 'Mengenal jenis dan penggunaan kabel jaringan',
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
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: const BrandAppBarBackground(),
          ),
          body: Stack(
            children: [
              const Positioned.fill(child: AnimatedBackdrop()),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner
                    FadeSlideIn(
                      child: AnimatedHeroCard(
                        colors: const [Color(0xFFAD8B73), Color(0xFFC4A58C)],
                        borderRadius: 24,
                        padding: const EdgeInsets.all(20),
                        shadowColor: AppTheme.primaryBrown,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.22),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${materi.length} MODUL • BERTAHAP',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Modul Pembelajaran',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Pelajari konsep TKJ secara bertahap melalui pembelajaran yang interaktif.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _sectionLabel(context, isDark, 'JALUR BELAJAR', 120),
                    const SizedBox(height: 4),
                    const FadeSlideIn(
                      delay: Duration(milliseconds: 160),
                      child: Text(
                        'Mulai dari materi dasar kemudian lanjutkan ke materi berikutnya.',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Jalur belajar bernomor
                    for (int i = 0; i < materi.length; i++)
                      _timelineItem(
                        context: context,
                        isDark: isDark,
                        index: i,
                        isLast: i == materi.length - 1,
                        title: materi[i]['title'],
                        subtitle: materi[i]['subtitle'],
                        screen: materi[i]['screen'],
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
            ],
          ),
        );
      },
    );
  }

  Widget _sectionLabel(BuildContext context, bool isDark, String text, int delayMs) {
    return FadeSlideIn(
      delay: Duration(milliseconds: delayMs),
      offset: const Offset(-20, 0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: AppTheme.primaryBrown,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 1,
              color: AppTheme.primaryBrown.withOpacity(0.18),
            ),
          ),
        ],
      ),
    );
  }

  /// Satu langkah di jalur belajar: nomor berwarna + garis penghubung + kartu.
  Widget _timelineItem({
    required BuildContext context,
    required bool isDark,
    required int index,
    required bool isLast,
    required String title,
    required String subtitle,
    required Widget screen,
  }) {
    final Color accent = kAccentPalette[index % kAccentPalette.length];
    final Color next = kAccentPalette[(index + 1) % kAccentPalette.length];

    return FadeSlideIn(
      delay: Duration(milliseconds: 200 + index * 90),
      offset: const Offset(0, 26),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // nomor + garis
            SizedBox(
              width: 44,
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [accentLightOf(accent), accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 3,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: LinearGradient(
                            colors: [
                              accent.withOpacity(0.55),
                              next.withOpacity(0.55),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // kartu
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AnimatedPressable(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => screen),
                    );
                  },
                  scaleFactor: 0.97,
                  child: SoftCard(
                    accent: accent,
                    radius: 20,
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.35,
                            color: isDark
                                ? Colors.grey.shade400
                                : AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: accent.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'MODUL ${index + 1}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: accent,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Mulai  ›',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: accent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
            const SizedBox(height: 14),
            _sectionLabel(context, isDark, 'MATERI TAMBAHAN DARI GURU', 600),
            const SizedBox(height: 4),
            const Text(
              'Modul materi tambahan yang diterbitkan langsung oleh Guru',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
            ...docs.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value.data() as Map<String, dynamic>;
              final title = data['judul'] ?? 'Materi Pembelajaran';
              final category = data['kategori'] ?? 'Umum';
              final guruName = data['guruName'] ?? 'Guru';
              final accent = kAccentPalette[(index + 3) % kAccentPalette.length];

              return FadeSlideIn(
                delay: Duration(milliseconds: 650 + index * 70),
                offset: const Offset(0, 20),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnimatedPressable(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MateriDetailLayout(
                            title: title,
                            themeColor: AppTheme.primaryBrown,
                            customMaterialContent: data['isi']?.toString() ?? '',
                            customMaterialCategory: category,
                            customMaterialGuruName: guruName,
                          ),
                        ),
                      );
                    },
                    scaleFactor: 0.97,
                    child: SoftCard(
                      accent: accent,
                      radius: 18,
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                colors: [accentLightOf(accent), accent],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
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
                          Text(
                            '›',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: accent,
                            ),
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
}
