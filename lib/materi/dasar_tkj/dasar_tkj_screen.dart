import 'package:flutter/material.dart';

class DasarTkjScreen extends StatelessWidget {
  const DasarTkjScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dasar TKJ'),
      ),
      body: const Center(
        child: Text(
          'Materi Dasar TKJ',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}