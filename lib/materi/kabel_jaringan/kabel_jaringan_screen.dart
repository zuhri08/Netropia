import 'package:flutter/material.dart';

class KabelJaringanScreen extends StatelessWidget {
  const KabelJaringanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kabel Jaringan'),
      ),
      body: const Center(
        child: Text(
          'Materi Kabel Jaringan',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}