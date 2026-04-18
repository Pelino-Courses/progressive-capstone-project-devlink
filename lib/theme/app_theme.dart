import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._(); // Private constructor — utility class

  // ──────────────────────────────────────────────
  // DESIGN.md Colour Palette
  // ──────────────────────────────────────────────

  static const Color primary = Color(0xFF2D6A4F);           // Forest Green
  static const Color primaryContainer = Color(0xFFB7E4C7);  // Soft Sage
  static const Color secondary = Color(0xFFC17754);         // Warm Terracotta
  static const Color secondaryContainer = Color(0xFFFADED3); // Peach Cream
  static const Color background = Color(0xFFFDF6EC);        // Warm Linen
  static const Color surface = Color(0xFFFFFFFF);           // Off White
  static const Color onPrimary = Color(0xFFFFFFFF);         // White
  static const Color onBackground = Color(0xFF2C2C2C);     // Charcoal Brown
  static const Color onSurfaceVariant = Color(0xFF6B7B6E); // Muted Olive
  static const Color error = Color(0xFFC0392B);             // Warm Red
  static const Color outline = Color(0xFFD5CDBA);           // Soft Grey

  // Condition badge colors
  static const Color conditionLikeNew = Color(0xFFB7E4C7);
  static const Color conditionGood = Color(0xFFFADED3);
  static const Color conditionFair = Color(0xFFFFE8CC);

  static const Color conditionLikeNewText = Color(0xFF2D6A4F);
  static const Color conditionGoodText = Color(0xFFC17754);
  static const Color conditionFairText = Color(0xFFA0522D);

  // ──────────────────────────────────────────────
  // Material Design 3 ColorScheme
  // ──────────────────────────────────────────────

  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: primary,
    secondary: secondary,
    onSecondary: onPrimary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: secondary,
    surface: surface,
    onSurface: onBackground,
    onSurfaceVariant: onSurfaceVariant,
    error: error,
    onError: onPrimary,
    outline: outline,
    outlineVariant: outline,
  );

  // ──────────────────────────────────────────────
  // TextTheme
  // ──────────────────────────────────────────────

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 28,
      color: onBackground,
    ),
    headlineMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 22,
      color: onBackground,
    ),
    titleMedium: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: onBackground,
    ),
    bodyLarge: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: onBackground,
    ),
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: onBackground,
    ),
    labelLarge: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: onBackground,
    ),
    labelSmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: onSurfaceVariant,
    ),
  );

  // ──────────────────────────────────────────────
  // Complete ThemeData
  // ──────────────────────────────────────────────

  static ThemeData get theme => ThemeData(
        useMaterial3: true, // C4: Material Design 3 enabled
        colorScheme: colorScheme,
        textTheme: textTheme,
        scaffoldBackgroundColor: background,

        // AppBar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: onPrimary,
          ),
        ),

        // Card theme — matches DESIGN.md component styles
        cardTheme: CardThemeData(
          color: surface,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // 16px corner radius
            side: const BorderSide(color: outline, width: 1),
          ),
        ),

        // ElevatedButton theme — primary button style
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: onPrimary,
            minimumSize: const Size(double.infinity, 48), // 48px height
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // 12px corner radius
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),

        // OutlinedButton theme
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: primary),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),

        // InputDecoration theme — form field styling
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: error),
          ),
          labelStyle: const TextStyle(
            fontSize: 14,
            color: onSurfaceVariant,
          ),
          hintStyle: const TextStyle(
            fontSize: 14,
            color: onSurfaceVariant,
          ),
          errorStyle: const TextStyle(
            fontSize: 12,
            color: error,
          ),
        ),

        // Bottom Navigation Bar theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: surface,
          selectedItemColor: primary,
          unselectedItemColor: onSurfaceVariant,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
          ),
        ),

        // Chip theme — for category filters
        chipTheme: ChipThemeData(
          backgroundColor: surface,
          selectedColor: primaryContainer,
          labelStyle: const TextStyle(
            fontSize: 14,
            color: onBackground,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: outline),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      );
}