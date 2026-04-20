import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // =========================
  // 🎨 PALETTE (FROM UI)
  // =========================
  static const Color primary = Color(0xFF5F7A6A);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F6F2);
  static const Color secondary = Color(0xFF8FAE95);

  static const Color textPrimary = Color(0xFF2F3A34);
  static const Color textSecondary = Color(0xFF5F6F65);

  static const Color darkBackground = Color(0xFF1C1C1E);
  static const Color darkSurface = Color(0xFF2C2C2E);

  static const Color card = Color(0xFFF8F9F4);
  static const Color divider = Color(0xFFDADFD6);

  // =========================
  // 🔤 BASE TEXT THEME
  // =========================
  static const String fontFamily = 'Inter';

  static const double defaultFormRadius = 10;

  static TextTheme _textTheme(Color primaryText, Color secondaryText) {
    return TextTheme(
      headlineLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: primaryText,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: primaryText,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: primaryText,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primaryText,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: secondaryText,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: secondaryText,
      ),
    );
  }

  // =========================
  // ☀️ LIGHT THEME
  // =========================
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.light,

    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.light(
      primary: primary,
      surface: surface,
      background: background,
      onPrimary: Colors.white,
      onSurface: textPrimary,
    ),

    textTheme: _textTheme(textPrimary, textSecondary),

    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      foregroundColor: textPrimary,
      backgroundColor: Colors.white.withOpacity(0.95),
      shadowColor: Colors.black.withOpacity(0.25),
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: textSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      // filled: true,
      // fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      hintStyle: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        color: textSecondary,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultFormRadius),
        borderSide: const BorderSide(color: divider, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultFormRadius),
        borderSide: const BorderSide(color: divider, width: 1),
      ),
      // Border saat kursor aktif di dalam textfield
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultFormRadius),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      // Border saat ada error
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultFormRadius),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultFormRadius),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    ),
  );

  // =========================
  // 🌙 DARK THEME
  // =========================
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: primary,
      surface: darkSurface,
      background: darkBackground,
      onPrimary: Colors.white,
      onSurface: Colors.white,
    ),

    textTheme: _textTheme(Colors.white, Colors.white70),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    cardTheme: CardThemeData(
      color: darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: primary,
      unselectedItemColor: Colors.white70,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      // filled: true,
      // fillColor: darkSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      hintStyle: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        color: Colors.white60,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultFormRadius),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultFormRadius),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultFormRadius),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(defaultFormRadius),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    ),
  );
}
