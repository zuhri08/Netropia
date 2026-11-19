import 'package:flutter/material.dart';
import '../materi_detail_layout.dart';

class K3Screen extends StatelessWidget {
  const K3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MateriDetailLayout(
      title: 'K3',
      themeColor: Color(0xFFAD8B73),
    );
  }
}
