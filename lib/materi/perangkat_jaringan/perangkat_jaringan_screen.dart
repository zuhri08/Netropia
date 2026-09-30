import 'package:flutter/material.dart';
import '../materi_detail_layout.dart';
import 'perangkat_jaringan_materi_screen.dart';

class PerangkatJaringanScreen extends StatelessWidget {
  const PerangkatJaringanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MateriDetailLayout(
      title: 'Perangkat Jaringan',
      themeColor: const Color(0xFFEF6C00),
      onMateriTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PerangkatJaringanMateriScreen(),
          ),
        );
      },
    );
  }
}