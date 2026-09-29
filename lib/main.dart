
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';

import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // App Check untuk pengujian lokal Android.
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
  }

  runApp(
    DevicePreview(
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