import 'package:flutter/material.dart';
import '../materi_detail_layout.dart';

class KabelJaringanScreen extends StatelessWidget {
  const KabelJaringanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MateriDetailLayout(
      title: 'Kabel Jaringan',
      themeColor: Color(0xFF5D4037),
    );
  }
}