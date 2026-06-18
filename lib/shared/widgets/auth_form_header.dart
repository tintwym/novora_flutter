import 'package:flutter/material.dart';

import '../../core/platform/browser_target.dart';
import 'novora_logo.dart';

/// Brand mark above auth forms (login / register / forgot password).
///
/// Sits on the light/dark **form** panel — not the navy hero — so the web
/// wordmark's baked-in white background reads correctly.
class AuthFormHeader extends StatelessWidget {
  const AuthFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    if (isBrowserPlatform) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: NovoraLogo(width: 200),
      );
    }
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: NovoraLogo(height: 52),
    );
  }
}
