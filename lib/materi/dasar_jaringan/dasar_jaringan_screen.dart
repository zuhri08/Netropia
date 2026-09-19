import 'package:flutter/material.dart';
import '../materi_detail_layout.dart';

class DasarJaringanScreen extends StatelessWidget {
  const DasarJaringanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MateriDetailLayout(
      title: 'Dasar Jaringan',
      themeColor: Color(0xFF00838F),
    );
  }
}