import 'package:flutter/material.dart';
import '../materi_detail_layout.dart';

class DasarTkjScreen extends StatelessWidget {
  const DasarTkjScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MateriDetailLayout(
      title: 'Dasar TKJ',
      themeColor: Color(0xFF1565C0),
    );
  }
}