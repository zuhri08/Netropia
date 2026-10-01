import 'package:flutter/material.dart';

class PetaKonsepKomputerScreen extends StatelessWidget {
  const PetaKonsepKomputerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF1565C0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Konsep Komponen Komputer'),
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
                    'assets/images/peta_konsep_komponen_komputer.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Gambar peta konsep Komponen Komputer belum ditemukan. '
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