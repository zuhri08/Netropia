import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFAD8B73),
          appBar: AppBar(
            title: Text(
              localizationService.translate('about_netropia'),
              style: const TextStyle(fontWeight: FontWeight.bold),
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
                colors: [Color(0xFFAD8B73), Color(0xFFCEAB93)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // LOGO & TITLE
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Netropia',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      localizationService.isEnglish ? 'Version 1.0.0' : 'Versi 1.0.0',
                      style: const TextStyle(
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
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizationService.isEnglish ? 'What is Netropia?' : 'Apa itu Netropia?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizationService.isEnglish
                              ? 'Netropia is an Android-based interactive learning media application for students and teachers in Computer and Network Engineering (TKJ).\n\nDesigned to facilitate understanding of computer network concepts, interactive lab simulations, IP subnetting calculations, attendance management, and digital equipment borrowing.'
                              : 'Netropia adalah aplikasi media pembelajaran interaktif berbasis Android untuk siswa dan guru jurusan Teknik Komputer & Jaringan (TKJ).\n\nAplikasi ini dirancang untuk mempermudah pemahaman konsep jaringan komputer, simulasi lab interaktif, kalkulasi IP subnetting, manajemen absensi, dan peminjaman alat praktikum secara digital.',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FEATURE HIGHLIGHTS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizationService.isEnglish ? 'Key Features' : 'Fitur Utama',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _buildFeatureRow(context, Icons.menu_book_rounded, localizationService.isEnglish ? 'Interactive TKJ Learning Materials' : 'Materi Pembelajaran TKJ Interaktif'),
                        _buildFeatureRow(context, Icons.view_in_ar_rounded, localizationService.isEnglish ? '3D Devices & Virtual Lab Exploration' : 'Eksplorasi Perangkat 3D & Lab Virtual'),
                        _buildFeatureRow(context, Icons.calculate_rounded, localizationService.isEnglish ? 'IP Subnetting Calculator' : 'Kalkulator Subnetting IP Jaringan'),
                        _buildFeatureRow(context, Icons.inventory_2_rounded, localizationService.isEnglish ? 'Equipment Borrowing System' : 'Sistem Peminjaman Alat Praktikum'),
                        _buildFeatureRow(context, Icons.fact_check_rounded, localizationService.isEnglish ? 'Digital Attendance Management' : 'Presensi & Absensi Digital Selesai'),
                        _buildFeatureRow(context, Icons.local_fire_department_rounded, localizationService.isEnglish ? 'Daily Learning Streak & Progress' : 'Streak & Progress Belajar Harian'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // INFORMATION / CREDITS CARD (AZIZ LEFT, ZUHRIFAL RIGHT)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          localizationService.isEnglish ? 'Developer' : 'Pengembang',
                          style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.person_rounded, size: 24, color: Color(0xFFAD8B73)),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Aziz',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                      textAlign: TextAlign.center,
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
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.person_rounded, size: 24, color: Color(0xFFAD8B73)),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Zuhrifal',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).textTheme.bodyLarge?.color,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildInfoRow(context, localizationService.isEnglish ? 'Major' : 'Jurusan', 'Teknik Komputer & Jaringan'),
                        const Divider(height: 20),
                        _buildInfoRow(context, localizationService.isEnglish ? 'Website' : 'Situs Web', 'https://netropia.id'),
                        const Divider(height: 20),
                        _buildInfoRow(context, localizationService.isEnglish ? 'License' : 'Lisensi', 'Open Source / Educational'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ACTION BUTTONS: LICENSE & TERMS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          showLicensePage(
                            context: context,
                            applicationName: 'Netropia',
                            applicationVersion: '1.0.0',
                          );
                        },
                        child: Text(
                          localizationService.isEnglish ? 'Software License' : 'Lisensi Perangkat Lunak',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const Text('•', style: TextStyle(color: Colors.white70)),
                      TextButton(
                        onPressed: () {
                          _showTermsDialog(context);
                        },
                        child: Text(
                          localizationService.isEnglish ? 'Terms & Conditions' : 'Syarat & Ketentuan',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

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

  Widget _buildFeatureRow(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFAD8B73).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFFAD8B73)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(localizationService.isEnglish ? 'Terms & Conditions' : 'Syarat & Ketentuan'),
        content: SingleChildScrollView(
          child: Text(
            localizationService.isEnglish
                ? '1. Netropia is used for educational and learning purposes in Computer and Network Engineering.\n\n'
                  '2. All materials, 3D assets, and simulations in this application are intended as learning tools.\n\n'
                  '3. Users must maintain account confidentiality.\n\n'
                  '4. Equipment borrowing must comply with school laboratory regulations.'
                : '1. Aplikasi Netropia digunakan untuk tujuan pendidikan dan pembelajaran Teknik Komputer dan Jaringan.\n\n'
                  '2. Seluruh materi, aset 3D, dan simulasi dalam aplikasi ini ditujukan sebagai sarana bantu belajar.\n\n'
                  '3. Pengguna wajib menjaga kerahasiaan akun masing-masing.\n\n'
                  '4. Fitur peminjaman alat wajib mematuhi peraturan praktikum yang ditetapkan oleh pihak sekolah.',
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizationService.translate('close')),
          ),
        ],
      ),
    );
  }
}
