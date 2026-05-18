import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'responsive_layout.dart';

/// Scrollable, full-width auth form area (login / register / forgot password).
class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = ResponsiveLayout.isWide(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final horizontal = wide ? 40.0 : 24.0;

    return ColoredBox(
      color: AppColors.cardBg,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            horizontal,
            wide ? 36 : 16,
            horizontal,
            24 + bottomInset,
          ),
          child: Align(
            alignment: wide ? Alignment.center : Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
