import 'package:flutter/material.dart';

import 'k3/k3_screen.dart';
import 'komponen_komputer/komponen_komputer_screen.dart';
import 'perangkat_jaringan/perangkat_jaringan_screen.dart';
import 'dasar_jaringan/dasar_jaringan_screen.dart';
import 'ip_address/ip_address_screen.dart';
import 'kabel_jaringan/kabel_jaringan_screen.dart';
import '../services/localization_service.dart';

class MateriScreen extends StatelessWidget {
  const MateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localizationService,
      builder: (context, child) {
        final List<Map<String, dynamic>> materi = [
          {
            'title': 'K3',
            'subtitle': 'Keselamatan dan kesehatan kerja di bidang TKJ',
            'icon': Icons.health_and_safety_rounded,
            'color': const Color(0xFF2E7D32),
            'screen': const K3Screen(),
          },
          {
            'title': 'Komponen Komputer',
            'subtitle': 'Mengenal komponen utama komputer',
            'icon': Icons.memory_rounded,
            'color': const Color(0xFF6A1B9A),
            'screen': const KomponenKomputerScreen(),
          },
          {
            'title': 'Perangkat Jaringan',
            'subtitle': 'Mengenal perangkat yang digunakan dalam jaringan',
            'icon': Icons.router_rounded,
            'color': const Color(0xFFEF6C00),
            'screen': const PerangkatJaringanScreen(),
          },
          {
            'title': 'Dasar Jaringan',
            'subtitle': 'Konsep dasar jaringan komputer',
            'icon': Icons.account_tree_rounded,
            'color': const Color(0xFF00838F),
            'screen': const DasarJaringanScreen(),
          },
          {
            'title': 'IP Address',
            'subtitle': 'Memahami alamat dan konfigurasi IP',
            'icon': Icons.language_rounded,
            'color': const Color(0xFFC62828),
            'screen': const IpAddressScreen(),
          },
          {
            'title': 'Kabel Jaringan',
            'subtitle': 'Mengenal jenis dan penggunaan kabel jaringan',
            'icon': Icons.cable_rounded,
            'color': const Color(0xFF5D4037),
            'screen': const KabelJaringanScreen(),
          },
        ];

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              localizationService.translate('study_materials'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFAD8B73),
                        Color(0xFFCEAB93),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        localizationService.translate('learning_module'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        localizationService.isEnglish
                            ? 'Learn TKJ concepts step by step through interactive learning.'
                            : 'Pelajari konsep TKJ secara bertahap melalui pembelajaran yang interaktif.',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  localizationService.translate('select_materi'),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  localizationService.translate('start_materi_desc'),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                ...materi.map(
                  (item) => _materiCard(
                    context: context,
                    title: item['title'],
                    subtitle: item['subtitle'],
                    icon: item['icon'],
                    color: item['color'],
                    screen: item['screen'],
                  ),
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    'Netropia • Pembelajaran TKJ SMK Kelas X',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _materiCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screen,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 17,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
