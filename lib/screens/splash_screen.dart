import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'main_screen.dart';
import '../widgets/brand_background.dart';
import '../widgets/home_effects.dart';
import '../widgets/netropia_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Pindah halaman dengan transisi memudar yang halus
  Route<void> _fadeRoute(Widget page) {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 700),
    );
  }

  Future<void> _checkLoginStatus() async {
    // beri waktu animasi logo selesai
    await Future.delayed(const Duration(milliseconds: 4400));
    if (!mounted) return;

    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && mounted) {
          final data = userDoc.data() as Map<String, dynamic>;
          final String nama = data['nama'] ?? 'Pengguna';
          final String role = data['role'] ?? 'siswa';

          Navigator.pushReplacement(
            context,
            _fadeRoute(MainScreen(username: nama, role: role)),
          );
          return;
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    }

    if (mounted) {
      Navigator.pushReplacement(context, _fadeRoute(const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    const String title = 'NETROPIA';

    return Scaffold(
      body: BrandBackground(
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo beranimasi
                const NetropiaLogoGif(width: 300),

                const SizedBox(height: 8),

                // Nama aplikasi: huruf muncul satu per satu
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < title.length; i++)
                      FadeSlideIn(
                        delay: Duration(milliseconds: 2000 + i * 70),
                        offset: const Offset(0, 18),
                        duration: const Duration(milliseconds: 450),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1.5),
                          child: Text(
                            title[i],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                              shadows: [
                                Shadow(
                                  color: Color(0x33000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                const FadeSlideIn(
                  delay: Duration(milliseconds: 2800),
                  offset: Offset(0, 10),
                  child: Text(
                    'Interactive TKJ Learning',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 44),

                const FadeSlideIn(
                  delay: Duration(milliseconds: 3000),
                  offset: Offset(0, 10),
                  child: Column(
                    children: [
                      NetropiaLoadingBar(width: 150),
                      SizedBox(height: 12),
                      Text(
                        'Mempersiapkan pembelajaran...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
