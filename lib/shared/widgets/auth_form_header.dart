import 'package:flutter/material.dart';

import 'novora_logo.dart';

/// Logo + optional spacing for auth forms (white background; PNG wordmark).
class AuthFormHeader extends StatelessWidget {
  const AuthFormHeader({super.key, this.logoWidth = 200});

  final double logoWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: NovoraLogo(width: logoWidth),
    );
  }
}
