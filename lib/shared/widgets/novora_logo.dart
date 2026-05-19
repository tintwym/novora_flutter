import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_strings.dart';

/// Official Novora wordmark (icon + NOVORA + HRMS SOFTWARE) from [AppAssets.logoSvg].
class NovoraLogo extends StatelessWidget {
  const NovoraLogo({
    super.key,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.centerLeft,
  });

  /// Natural asset ratio (511×273).
  static const double aspectRatio = 511 / 273;

  final double? height;
  final double? width;
  final BoxFit fit;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: SvgPicture.asset(
        AppAssets.logoSvg,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        semanticsLabel: AppStrings.appTitle,
      ),
    );
  }
}
