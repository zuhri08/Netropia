import 'package:flutter/material.dart';

class PerangkatJaringanScreen extends StatelessWidget {
  const PerangkatJaringanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perangkat Jaringan'),
      ),
      body: const Center(
        child: Text(
          'Materi Perangkat Jaringan',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}