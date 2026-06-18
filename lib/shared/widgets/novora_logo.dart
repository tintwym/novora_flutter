import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';
import '../../core/platform/browser_target.dart';

/// Novora brand mark — platform-aware:
/// * **Web** → horizontal wordmark ([AppAssets.webLogo]), white background
/// * **Mobile / desktop app** → square launcher mark ([AppAssets.appIcon])
class NovoraLogo extends StatelessWidget {
  const NovoraLogo({
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.centerLeft,
  });

  static bool get _useWebWordmark => isBrowserPlatform;

  static String get _assetPath =>
      _useWebWordmark ? AppAssets.webLogo : AppAssets.appIcon;

  /// Natural asset ratio for the active platform asset.
  static double get aspectRatio => _useWebWordmark ? 1024 / 341 : 1;

  final double? height;
  final double? width;
  final BoxFit fit;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Image.asset(
        _assetPath,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        filterQuality: FilterQuality.high,
        semanticLabel: AppStrings.appTitle,
      ),
    );
  }
}
