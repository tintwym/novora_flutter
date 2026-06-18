import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';
import '../../core/platform/browser_target.dart';
import '../../core/theme/theme_colors.dart';

/// Novora brand mark — platform- and theme-aware:
/// * **Web** → horizontal wordmark (blue on light surfaces, light text on dark)
/// * **Mobile / desktop app** → square launcher mark ([AppAssets.appIcon])
class NovoraLogo extends StatelessWidget {
  const NovoraLogo({
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.centerLeft,
    /// When true, always picks the variant for dark surfaces (e.g. navy hero).
    this.onDarkSurface = false,
  });

  static bool get _useWebWordmark => isBrowserPlatform;

  /// Natural asset ratio for the active platform asset.
  static double get aspectRatio => _useWebWordmark ? 1024 / 341 : 1;

  final double? height;
  final double? width;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final bool onDarkSurface;

  String _assetFor(BuildContext context) {
    if (!_useWebWordmark) return AppAssets.appIcon;
    final dark = onDarkSurface || context.isDarkMode;
    return dark ? AppAssets.webLogoDark : AppAssets.webLogo;
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cacheHeight = height != null ? (height! * dpr).round() : null;
    final cacheWidth = width != null
        ? (width! * dpr).round()
        : (height != null ? (height! * aspectRatio * dpr).round() : null);

    return Align(
      alignment: alignment,
      child: Image.asset(
        _assetFor(context),
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        filterQuality: FilterQuality.high,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        semanticLabel: AppStrings.appTitle,
      ),
    );
  }
}
