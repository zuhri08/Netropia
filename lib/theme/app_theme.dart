import 'package:flutter/material.dart';

class AppTheme {
  // Warm Cokelat & Earthy Cream System (Warna Utama Asli Netropia)
  static const Color primaryBrown = Color(0xFFAD8B73);
  static const Color secondaryBeige = Color(0xFFCEAB93);
  static const Color accentTan = Color(0xFFE3CAA5);
  static const Color backgroundCream = Color(0xFFFFFBE9);
  static const Color deepEspresso = Color(0xFF4A3428);

  static const Color darkBrown = Color(0xFF8E6F5B);
  static const Color brownTint = Color(0xFFF5EBE6);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textMuted = Color(0xFF7F8C8D);
  static const Color surfaceCream = Color(0xFFFFFBE9);
  static const Color borderCream = Color(0xFFE9DDD3);
  static const Color accentRed = Color(0xFFC0392B);
  static const Color accentAmber = Color(0xFFD35400);

  // Aliases untuk kompatibilitas penuh (menunjuk ke Cokelat)
  static const Color primaryTeal = primaryBrown;
  static const Color darkTeal = darkBrown;
  static const Color lightTeal = secondaryBeige;
  static const Color tealTint = brownTint;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundCream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBrown,
      primary: primaryBrown,
      secondary: secondaryBeige,
      tertiary: accentTan,
      brightness: Brightness.light,
    ),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: primaryBrown,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryBrown, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: deepEspresso,
      selectedItemColor: Colors.white,
      unselectedItemColor: accentTan,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(
      seedColor: secondaryBeige,
      primary: secondaryBeige,
      secondary: primaryBrown,
      tertiary: accentTan,
      brightness: Brightness.dark,
    ),
    cardColor: const Color(0xFF1E1E1E),
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: secondaryBeige, width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBrown,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: secondaryBeige,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
