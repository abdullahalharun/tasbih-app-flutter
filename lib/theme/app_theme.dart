import 'package:flutter/material.dart';

class AppTheme {
  // Islamic inspired colors
  static const Color primaryGreen = Color(0xFF2E7D32); // Islamic green
  static const Color goldAccent = Color(0xFFFFB300); // Islamic gold
  static const Color darkBlue = Color(0xFF1565C0); // Deep blue
  static const Color cream = Color(0xFFF5F5DC); // Cream background
  static const Color darkGray = Color(0xFF424242);
  static const Color lightGray = Color(0xFFF5F5F5);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
      primary: primaryGreen,
      secondary: goldAccent,
      surface: cream,
      background: lightGray,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: primaryGreen.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'serif',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkGray,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'serif',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primaryGreen,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'serif',
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: darkGray,
      ),
      bodyLarge: TextStyle(fontSize: 18, color: darkGray, height: 1.6),
      bodyMedium: TextStyle(fontSize: 16, color: darkGray, height: 1.5),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.dark,
      primary: primaryGreen,
      secondary: goldAccent,
      surface: const Color(0xFF1E1E1E),
      background: const Color(0xFF121212),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: primaryGreen.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 8,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: const Color(0xFF2C2C2C),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'serif',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'serif',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: goldAccent,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'serif',
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white, height: 1.6),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
    ),
  );
}
