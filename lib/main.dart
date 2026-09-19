import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb dan !kReleaseMode
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // Import device_preview
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      // Frame HP hanya akan muncul saat di-run di Web atau mode Debug biasa
      enabled: kIsWeb || !kReleaseMode,
      builder: (context) => const NetropiaApp(),
    ),
  );
}

class NetropiaApp extends StatelessWidget {
  const NetropiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeManager,
      builder: (context, child) {
        return MaterialApp(
          // KODE ANTI-ERROR: Menggunakan konfigurasi builder global dari Device Preview
          locale: DevicePreview.locale(context),
          builder: (context, child) {
            return DevicePreview.appBuilder(context, child);
          },

          debugShowCheckedModeBanner: false,
          title: 'Netropia',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeManager.themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }
}
