import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Tentang Netropia', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // LOGO & TITLE
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFAD8B73), Color(0xFFCEAB93)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFAD8B73).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                size: 56,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Netropia',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleLarge?.color,
              ),
            ),
            const SizedBox(height: 4),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFAD8B73).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Versi 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFAD8B73),
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
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apa itu Netropia?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Netropia adalah aplikasi media pembelajaran interaktif berbasis Android untuk siswa dan guru jurusan Teknik Komputer & Jaringan (TKJ).\n\nAplikasi ini dirancang untuk mempermudah pemahaman konsep jaringan komputer, simulasi lab interaktif, kalkulasi IP subnetting, manajemen absensi, dan peminjaman alat praktikum secara digital.',
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
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fitur Utama',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildFeatureRow(Icons.menu_book_rounded, 'Materi Pembelajaran TKJ Interaktif'),
                  _buildFeatureRow(Icons.view_in_ar_rounded, 'Eksplorasi Perangkat 3D & Lab Virtual'),
                  _buildFeatureRow(Icons.calculate_rounded, 'Kalkulator Subnetting IP Jaringan'),
                  _buildFeatureRow(Icons.inventory_2_rounded, 'Sistem Peminjaman Alat Praktikum'),
                  _buildFeatureRow(Icons.fact_check_rounded, 'Presensi & Absensi Digital Selesai'),
                  _buildFeatureRow(Icons.local_fire_department_rounded, 'Streak & Progress Belajar Harian'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // INFORMATION / CREDITS CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Pengembang', 'Tim Netropia TKJ'),
                  const Divider(height: 20),
                  _buildInfoRow('Jurusan', 'Teknik Komputer & Jaringan'),
                  const Divider(height: 20),
                  _buildInfoRow('Situs Web', 'https://netropia.id'),
                  const Divider(height: 20),
                  _buildInfoRow('Lisensi', 'Open Source / Educational'),
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
                  child: const Text('Lisensi Perangkat Lunak'),
                ),
                const Text('•', style: TextStyle(color: Colors.grey)),
                TextButton(
                  onPressed: () {
                    _showTermsDialog(context);
                  },
                  child: const Text('Syarat & Ketentuan'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              '© 2026 Netropia. Hak Cipta Dilindungi Undang-Undang.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
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
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Syarat & Ketentuan'),
        content: const SingleChildScrollView(
          child: Text(
            '1. Aplikasi Netropia digunakan untuk tujuan pendidikan dan pembelajaran Teknik Komputer dan Jaringan.\n\n'
            '2. Seluruh materi, aset 3D, dan simulasi dalam aplikasi ini ditujukan sebagai sarana bantu belajar.\n\n'
            '3. Pengguna wajib menjaga kerahasiaan akun masing-masing.\n\n'
            '4. Fitur peminjaman alat wajib mematuhi peraturan praktikum yang ditetapkan oleh pihak sekolah.',
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
