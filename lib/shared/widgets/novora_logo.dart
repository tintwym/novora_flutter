import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';

/// Official Novora wordmark (icon + NOVORA + HRMS SOFTWARE).
class NovoraLogo extends StatelessWidget {
  const NovoraLogo({
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.centerLeft,
  });

  /// Natural asset ratio (790×356).
  static const double aspectRatio = 790 / 356;

  final double? height;
  final double? width;
  final BoxFit fit;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Image.asset(
        AppAssets.logoFull,
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
