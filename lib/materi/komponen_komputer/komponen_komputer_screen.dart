import 'package:flutter/material.dart';

class KomponenKomputerScreen extends StatelessWidget {
  const KomponenKomputerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Komponen Komputer'),
      ),
      body: const Center(
        child: Text(
          'Materi Komponen Komputer',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}