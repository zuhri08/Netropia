import 'package:flutter/material.dart';

class DasarJaringanScreen extends StatelessWidget {
  const DasarJaringanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dasar Jaringan'),
      ),
      body: const Center(
        child: Text(
          'Materi Dasar Jaringan',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}