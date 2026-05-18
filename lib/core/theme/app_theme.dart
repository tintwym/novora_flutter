import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandBlue,
        brightness: Brightness.light,
      ).copyWith(
        secondary: AppColors.secondaryAccent,
        onSecondary: Colors.white,
        tertiary: AppColors.success,
        onTertiary: Colors.white,
      ),
    );

    final scheme = base.colorScheme.copyWith(
      surface: Colors.white,
      onSurface: AppColors.navy,
      onSurfaceVariant: AppColors.textMuted,
      outline: AppColors.border,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bg,
      cardColor: Colors.white,
      dividerColor: AppColors.border,
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
        bodyColor: AppColors.navy,
        displayColor: AppColors.navy,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.navy,
        titleTextStyle: AppTextStyles.appBarTitle(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  static ThemeData dark() {
    const scaffold = Color(0xFF0F172A);
    const surface = Color(0xFF1E293B);
    const border = Color(0xFF334155);

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.brandBlue,
        brightness: Brightness.dark,
        surface: surface,
      ).copyWith(
        secondary: AppColors.secondaryAccent,
        onSecondary: Colors.white,
        tertiary: AppColors.success,
        onTertiary: Colors.white,
        outline: border,
      ),
    );

    final scheme = base.colorScheme.copyWith(
      surface: surface,
      onSurface: const Color(0xFFF1F5F9),
      onSurfaceVariant: const Color(0xFF94A3B8),
      outline: border,
    );

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffold,
      cardColor: surface,
      dividerColor: border,
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(
        bodyColor: base.colorScheme.onSurface,
        displayColor: base.colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: surface,
        foregroundColor: base.colorScheme.onSurface,
        titleTextStyle: AppTextStyles.appBarTitle(
          color: base.colorScheme.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0B1220),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.brandBlueLight, width: 1.5),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return base.colorScheme.onSurfaceVariant;
          }),
        ),
      ),
    );
  }
}
