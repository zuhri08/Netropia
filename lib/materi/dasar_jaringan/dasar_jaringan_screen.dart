import 'package:flutter/material.dart';

import '../materi_detail_layout.dart';
import 'pengertian_jaringan_screen.dart';

class DasarJaringanScreen extends StatelessWidget {
  const DasarJaringanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MateriDetailLayout(
      title: 'Dasar Jaringan',
      themeColor: const Color(0xFF00838F),

      onMateriTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
            const PengertianJaringanScreen(),
          ),
        );
      },
    );
  }
}