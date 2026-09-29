import 'package:flutter/material.dart';
import '../materi_detail_layout.dart';

class KomponenKomputerScreen extends StatelessWidget {
  const KomponenKomputerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MateriDetailLayout(
      title: 'Komponen Komputer',
      themeColor: Color(0xFF6A1B9A),
    );
  }
}