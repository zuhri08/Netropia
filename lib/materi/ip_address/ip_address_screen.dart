import 'package:flutter/material.dart';
import '../materi_detail_layout.dart';

class IpAddressScreen extends StatelessWidget {
  const IpAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MateriDetailLayout(
      title: 'IP Address',
      themeColor: Color(0xFFC62828),
    );
  }
}