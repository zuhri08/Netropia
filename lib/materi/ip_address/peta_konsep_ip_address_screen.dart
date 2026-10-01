import 'package:flutter/material.dart';

class PetaKonsepIpAddressScreen extends StatelessWidget {
  const PetaKonsepIpAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF00897B);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Konsep IP Address'),
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
                    'assets/images/peta_konsep_ip_address.jpg',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Gambar peta konsep IP Address tidak ditemukan.',
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