import 'package:flutter/material.dart';
import '../materi_detail_layout.dart';
import 'pengertian_kabel_screen.dart';

class KabelJaringanScreen extends StatelessWidget {
  const KabelJaringanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MateriDetailLayout(
      title: 'Kabel Jaringan',
      themeColor: const Color(0xFF5D4037),
      onMateriTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PengertianKabelScreen(),
          ),
        );
      },
    );
  }
}
