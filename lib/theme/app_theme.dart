import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF2D6A4F);
  static const Color primaryContainer = Color(0xFFB7E4C7);
  static const Color secondary = Color(0xFFC17754);
  static const Color secondaryContainer = Color(0xFFFADED3);
  static const Color background = Color(0xFFFDF6EC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF2C2C2C);
  static const Color onSurfaceVariant = Color(0xFF6B7B6E);
  static const Color error = Color(0xFFC0392B);
  static const Color outline = Color(0xFFD5CDBA);

  static const Color conditionLikeNew = Color(0xFFB7E4C7);
  static const Color conditionGood = Color(0xFFFADED3);
  static const Color conditionFair = Color(0xFFFFE8CC);
  static const Color conditionLikeNewText = Color(0xFF2D6A4F);
  static const Color conditionGoodText = Color(0xFFC17754);
  static const Color conditionFairText = Color(0xFFA0522D);

  // ── LIGHT THEME ──
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          brightness: Brightness.light, primary: primary, onPrimary: onPrimary,
          primaryContainer: primaryContainer, onPrimaryContainer: primary,
          secondary: secondary, onSecondary: onPrimary,
          secondaryContainer: secondaryContainer, onSecondaryContainer: secondary,
          surface: surface, onSurface: onBackground, onSurfaceVariant: onSurfaceVariant,
          error: error, onError: onPrimary, outline: outline, outlineVariant: outline,
        ),
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: background,
        appBarTheme: const AppBarTheme(backgroundColor: primary, foregroundColor: onPrimary, elevation: 0, centerTitle: true),
        cardTheme: CardThemeData(color: surface, elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: outline, width: 1))),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: onPrimary,
                minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(foregroundColor: primary, minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: primary))),
        inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: outline)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: outline)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primary, width: 2)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: error))),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: surface, selectedItemColor: primary, unselectedItemColor: onSurfaceVariant, type: BottomNavigationBarType.fixed),
      );

  // ── DARK THEME ──
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: primaryContainer, onPrimary: const Color(0xFF1A1A1A),
          primaryContainer: primary, onPrimaryContainer: primaryContainer,
          secondary: const Color(0xFFE8A88A), onSecondary: const Color(0xFF1A1A1A),
          secondaryContainer: const Color(0xFF5C3A2A), onSecondaryContainer: secondaryContainer,
          surface: const Color(0xFF1E1E1E), onSurface: const Color(0xFFE0E0E0),
          onSurfaceVariant: const Color(0xFF9E9E9E),
          error: const Color(0xFFEF5350), onError: Colors.white,
          outline: const Color(0xFF3A3A3A), outlineVariant: const Color(0xFF2A2A2A),
        ),
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1E1E1E), foregroundColor: Color(0xFFE0E0E0), elevation: 0, centerTitle: true),
        cardTheme: CardThemeData(color: const Color(0xFF1E1E1E), elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFF3A3A3A), width: 1))),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: primaryContainer, foregroundColor: const Color(0xFF1A1A1A),
                minimumSize: const Size(double.infinity, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
        inputDecorationTheme: InputDecorationTheme(filled: true, fillColor: const Color(0xFF1E1E1E),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3A3A3A))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3A3A3A))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryContainer, width: 2))),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: const Color(0xFF1E1E1E), selectedItemColor: primaryContainer,
            unselectedItemColor: const Color(0xFF9E9E9E), type: BottomNavigationBarType.fixed),
      );
}