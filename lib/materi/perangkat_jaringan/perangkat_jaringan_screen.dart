import 'package:flutter/material.dart';
import '../materi_detail_layout.dart';

class PerangkatJaringanScreen extends StatelessWidget {
  const PerangkatJaringanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MateriDetailLayout(
      title: 'Perangkat Jaringan',
      themeColor: Color(0xFFEF6C00),
    );
  }
}