import 'package:flutter/material.dart';

import '../../core/theme/theme_colors.dart';
import 'novora_logo.dart';

/// Logo + optional spacing for auth forms.
///
/// Defaults are tuned to keep the full login / register form within a typical
/// 13" laptop viewport (~700 px tall) so the scaffold's scrollbar only kicks
/// in on phones or very short browser windows.
///
/// The wordmark PNG ships with dark navy text on a transparent background. In
/// dark mode that text would disappear into the dark scaffold, so we sit the
/// logo on a small white tile that reads as an intentional brand chip rather
/// than a stray white rectangle.
class AuthFormHeader extends StatelessWidget {
  const AuthFormHeader({super.key, this.logoWidth = 160});

  final double logoWidth;

  @override
  Widget build(BuildContext context) {
    final logo = NovoraLogo(width: logoWidth);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Align(
        alignment: Alignment.centerLeft,
        child: context.isDarkMode
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: logo,
              )
            : logo,
      ),
    );
  }
}
