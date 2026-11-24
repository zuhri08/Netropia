import 'package:flutter/material.dart';
import '../services/localization_service.dart';
import '../theme/app_theme.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: AppTheme.primaryBrown,
          appBar: AppBar(
            title: const Text(
              'Tentang Netropia',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBrown, AppTheme.darkBrown],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 50),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // LOGO & TITLE
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Netropia',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Versi 1.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // DESCRIPTION CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF241C17) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'APA ITU NETROPIA?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Netropia adalah aplikasi media pembelajaran interaktif berbasis Android untuk siswa dan guru jurusan Teknik Komputer & Jaringan (TKJ).\n\nAplikasi ini dirancang untuk mempermudah pemahaman konsep jaringan komputer, simulasi lab interaktif, kalkulasi IP subnetting, manajemen absensi, dan peminjaman alat praktikum secara digital.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: isDark ? Colors.white : AppTheme.textDark,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // FEATURE HIGHLIGHTS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF241C17) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FITUR UTAMA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildFeatureRow(context, Icons.menu_book_rounded, 'Materi Pembelajaran TKJ Interaktif', isDark),
                        _buildFeatureRow(context, Icons.view_in_ar_rounded, 'Eksplorasi Perangkat 3D & Lab Virtual', isDark),
                        _buildFeatureRow(context, Icons.calculate_rounded, 'Kalkulator Subnetting IP Jaringan', isDark),
                        _buildFeatureRow(context, Icons.inventory_2_rounded, 'Sistem Peminjaman Alat Praktikum', isDark),
                        _buildFeatureRow(context, Icons.fact_check_rounded, 'Presensi & Absensi Digital', isDark),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // DEVELOPERS CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF241C17) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.08) : AppTheme.borderCream,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'PENGEMBANG',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: isDark ? Colors.grey.shade400 : AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.brownTint,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(Icons.person_rounded, size: 24, color: AppTheme.primaryBrown),
                                    SizedBox(height: 6),
                                    Text(
                                      'Aziz',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.brownTint,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Column(
                                  children: [
                                    Icon(Icons.person_rounded, size: 24, color: AppTheme.primaryBrown),
                                    SizedBox(height: 6),
                                    Text(
                                      'Zuhrifal',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(context, 'Jurusan', 'Teknik Komputer & Jaringan', isDark),
                        const Divider(height: 20),
                        _buildInfoRow(context, 'Lisensi', 'Open Source / Educational', isDark),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    '© 2026 Netropia. All Rights Reserved.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureRow(BuildContext context, IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.brownTint,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: AppTheme.primaryBrown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}
