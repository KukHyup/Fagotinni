import 'package:flutter/material.dart';

class FagotinniTheme {
  static const Color background = Color(0xFF12100E);
  static const Color surface = Color(0xFF1C1916);
  static const Color surfaceHigh = Color(0xFF26211C);
  static const Color bronze = Color(0xFFC4A574);
  static const Color bronzeDark = Color(0xFF8B5A3C);
  static const Color cream = Color(0xFFF3E6D4);
  static const Color muted = Color(0xFFB8A894);
  static const Color inTune = Color(0xFF7CB89A);
  static const Color sharp = Color(0xFFE08A6A);
  static const Color flat = Color(0xFF6BA3C9);

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: bronze,
      onPrimary: Color(0xFF1A1208),
      secondary: bronzeDark,
      onSecondary: cream,
      surface: surface,
      onSurface: cream,
      error: sharp,
      onError: cream,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Segoe UI',
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: cream,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: bronze.withValues(alpha: 0.22),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? bronze : muted,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: bronze,
          foregroundColor: const Color(0xFF1A1208),
          minimumSize: const Size.fromHeight(56),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: cream,
          minimumSize: const Size.fromHeight(56),
          side: const BorderSide(color: bronze, width: 1.4),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: bronze,
        thumbColor: cream,
        inactiveTrackColor: bronze.withValues(alpha: 0.25),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceHigh,
        hintStyle: const TextStyle(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
