import 'package:flutter/material.dart';

import '../../core/theme/theme_colors.dart';
import 'responsive_layout.dart';

/// Scrollable auth form column (login / register / forgot password).
///
/// Background follows the active theme: white in light mode, the dark surface
/// in dark mode. The previous implementation pinned this subtree to
/// [AppTheme.light] so the inputs and labels couldn't flip — but that left the
/// page glaringly white at night for users on the Auto (sunrise/sunset) theme.
/// Honoring the real theme means input fills, borders, dividers, and labels in
/// here can all read from `context.*` getters and stay legible in both modes.
class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = ResponsiveLayout.isWide(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final horizontal = wide ? 56.0 : 24.0;

    return ColoredBox(
      color: context.surfaceCard,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                horizontal,
                wide ? 32 : 24,
                horizontal,
                24 + bottomInset,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      constraints.maxHeight - (wide ? 32 : 24) - bottomInset,
                ),
                child: Align(
                  alignment: wide ? Alignment.center : Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
