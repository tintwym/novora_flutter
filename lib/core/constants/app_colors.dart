import 'package:flutter/material.dart';

/// Novora HRMS — cohesive **blue + slate** system (B2B SaaS). Charts use a tight blue/indigo pair.
abstract final class AppColors {
  // --- Brand core (single hue family) ---
  static const Color brandBlue = Color(0xFF2563EB);
  static const Color brandBlueDeep = Color(0xFF1E40AF);
  static const Color brandBlueLight = Color(0xFF3B82F6);
  static const Color brandBlueSoft = Color(0xFF93C5FD);

  static const Color primary = brandBlueDeep;
  static const Color primaryLight = brandBlueLight;

  /// Secondary accent for Material / highlights (teal, still enterprise-safe).
  static const Color secondaryAccent = Color(0xFF0D9488);
  static const Color purple = secondaryAccent;

  static const Color navy = Color(0xFF0F172A);
  static const Color navyMid = Color(0xFF1E293B);
  static const Color accent = Color(0xFF2563EB);
  static const Color success = Color(0xFF059669);
  static const Color warning = Color(0xFFD97706);
  static const Color danger = Color(0xFFEF4444);

  /// Light fill behind error SnackBars / inline alerts (pairs with [danger] text).
  static const Color errorSurface = Color(0xFFFEE2E2);
  static const Color muted = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color bg = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);

  /// Chart / dual-series tints (blue family, readable on white).
  static const Color purple2 = Color(0xFF60A5FA);
  static const Color purple3 = Color(0xFF818CF8);
  static const Color purple4 = Color(0xFFA5B4FC);

  /// Primary CTA: subtle blue depth (no multi-hue rainbow).
  static const LinearGradient primaryGrad = LinearGradient(
    colors: [brandBlueDeep, brandBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Auth hero: deep slate–indigo (no brown / forest mix).
  static const LinearGradient navyGrad = LinearGradient(
    colors: [Color(0xFF0B1220), Color(0xFF111C38), Color(0xFF172554)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
