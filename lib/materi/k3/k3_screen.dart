import 'package:flutter/material.dart';

class K3Screen extends StatelessWidget {
  const K3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('K3'),
      ),
      body: const Center(
        child: Text(
          'Materi K3',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}