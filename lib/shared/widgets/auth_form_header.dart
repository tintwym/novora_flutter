import 'package:flutter/material.dart';

import 'novora_logo.dart';

/// Logo + optional spacing for auth forms (white background; PNG wordmark).
///
/// Defaults are tuned to keep the full login / register form within a typical
/// 13" laptop viewport (~700 px tall) so the scaffold's scrollbar only kicks
/// in on phones or very short browser windows.
class AuthFormHeader extends StatelessWidget {
  const AuthFormHeader({super.key, this.logoWidth = 160});

  final double logoWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: NovoraLogo(width: logoWidth),
    );
  }
}
