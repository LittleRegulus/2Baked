import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFF080C12);
  static const backgroundSoft = Color(0xFF0D131C);
  static const surface = Color(0xFF111923);
  static const surfaceRaised = Color(0xFF18222E);
  static const border = Color(0xFF263342);
  static const text = Color(0xFFF4F6F8);
  static const muted = Color(0xFF9AA8B8);
  static const ember = Color(0xFFFF5A4F);
  static const emberSoft = Color(0xFFFF8A65);
  static const ice = Color(0xFF37C8FF);
  static const iceSoft = Color(0xFF82DDFF);
  static const lime = Color(0xFFB8F05A);
  static const cream = Color(0xFFFFE9BA);
  static const logoLeaf = Color(0xFF9BEA2D);
  static const logoEye = Color(0xFFFF4B55);
}

ThemeData buildAppTheme() {
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.ember,
        brightness: Brightness.dark,
        surface: AppColors.surface,
      ).copyWith(
        primary: AppColors.ember,
        secondary: AppColors.ice,
        tertiary: AppColors.lime,
        onSurface: AppColors.text,
        outline: AppColors.border,
      );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    splashFactory: InkSparkle.splashFactory,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.text,
        fontSize: 52,
        height: 1.02,
        fontWeight: FontWeight.w900,
        letterSpacing: -2.4,
      ),
      displayMedium: TextStyle(
        color: AppColors.text,
        fontSize: 40,
        height: 1.05,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.8,
      ),
      headlineLarge: TextStyle(
        color: AppColors.text,
        fontSize: 30,
        height: 1.1,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
      ),
      headlineMedium: TextStyle(
        color: AppColors.text,
        fontSize: 23,
        height: 1.15,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        color: AppColors.text,
        fontSize: 18,
        height: 1.2,
        fontWeight: FontWeight.w800,
      ),
      titleMedium: TextStyle(
        color: AppColors.text,
        fontSize: 15,
        height: 1.3,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(color: AppColors.text, fontSize: 16, height: 1.5),
      bodyMedium: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.45),
      labelLarge: TextStyle(
        color: AppColors.text,
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
      ),
    ),
    dividerColor: AppColors.border,
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundSoft,
      hintStyle: const TextStyle(color: AppColors.muted),
      labelStyle: const TextStyle(color: AppColors.muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.ice, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.ember,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.backgroundSoft,
      selectedColor: AppColors.ice.withValues(alpha: 0.18),
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      labelStyle: const TextStyle(
        color: AppColors.text,
        fontWeight: FontWeight.w700,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
    ),
  );
}
