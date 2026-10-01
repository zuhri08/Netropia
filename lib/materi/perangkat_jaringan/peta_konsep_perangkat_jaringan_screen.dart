import 'package:flutter/material.dart';

class PetaKonsepPerangkatJaringanScreen extends StatelessWidget {
  const PetaKonsepPerangkatJaringanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF00897B);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Konsep Perangkat Jaringan'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4,
                child: Center(
                  child: Image.asset(
                    'assets/images/peta_konsep_perangkat_jaringan.jpg',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Gambar peta konsep Perangkat Jaringan tidak ditemukan.',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Gunakan dua jari untuk memperbesar atau memperkecil gambar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}