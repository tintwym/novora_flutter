import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Theme-aware colors for shell UI (sidebar, cards, module chrome).
extension NovoraTheme on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => theme.colorScheme;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Page / scaffold background.
  Color get pageBackground => theme.scaffoldBackgroundColor;

  /// Cards, sidebar, top bar, tab strip.
  Color get surfaceCard => colors.surface;

  Color get borderColor => colors.outline;

  Color get primaryText => colors.onSurface;

  Color get secondaryText => colors.onSurfaceVariant;

  /// Search fields, dropdown fills, inactive icon buttons.
  Color get subtleFill =>
      isDarkMode ? const Color(0xFF0B1220) : AppColors.bg;

  /// Heading row background of [DataTable] and tabular charts.
  /// Light: pale gray strip on a white card; Dark: slightly raised surface tone.
  Color get tableHeaderBg =>
      isDarkMode ? const Color(0xFF273548) : AppColors.bg;

  /// Background for an inactive / "No" status pill.
  /// In light mode this is the same light gray as the page; in dark mode we use a
  /// slightly raised tone so the pill remains visible against the card.
  Color get mutedPillBg => tableHeaderBg;

  /// Foreground (text + icon) for an inactive / "No" pill — paired with [mutedPillBg].
  Color get mutedPillText =>
      isDarkMode ? const Color(0xFFCBD5E1) : AppColors.textMuted;

  /// Period / filter chips on charts.
  Color get filterChipBg => isDarkMode
      ? AppColors.brandBlue.withValues(alpha: 0.22)
      : const Color(0xFFE3F2FD);

  Color get filterChipText =>
      isDarkMode ? AppColors.brandBlueSoft : AppColors.primary;

  Color get cardShadow =>
      Colors.black.withValues(alpha: isDarkMode ? 0.28 : 0.04);

  /// Bottom of area chart gradient (fades into card surface).
  Color get chartAreaFade => surfaceCard.withValues(alpha: 0);
}
