import 'package:flutter/material.dart';

class PetaKonsepK3Screen extends StatelessWidget {
  const PetaKonsepK3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF00897B);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Konsep K3'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
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
                    'assets/images/peta_konsep_k3.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Gambar peta konsep K3 belum ditemukan. '
                              'Periksa lokasi dan nama file gambar.',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: themeColor.withOpacity(0.08),
              child: const Text(
                'Cubit layar untuk memperbesar atau memperkecil peta konsep.',
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