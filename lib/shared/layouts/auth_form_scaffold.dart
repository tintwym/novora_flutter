import 'package:flutter/material.dart';

import '../../core/theme/theme_colors.dart';
import 'responsive_layout.dart';

/// Auth form column (login / register / forgot password).
///
/// Wide split-screen: fixed, vertically centred — no page scroll (keyboard open
/// re-enables scroll so fields stay reachable). Narrow/mobile: scrolls as before.
class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = ResponsiveLayout.isWide(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final horizontal = wide ? 56.0 : 24.0;
    final vertical = wide ? 24.0 : 24.0;
    final padding = EdgeInsets.fromLTRB(
      horizontal,
      vertical,
      horizontal,
      24 + bottomInset,
    );

    final form = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: child,
    );

    return ColoredBox(
      color: context.surfaceCard,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final fixedWide = wide && bottomInset == 0;
            if (fixedWide) {
              return Padding(
                padding: padding,
                child: Center(child: form),
              );
            }
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: padding,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - vertical - bottomInset,
                ),
                child: Align(
                  alignment: wide ? Alignment.center : Alignment.topCenter,
                  child: form,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
