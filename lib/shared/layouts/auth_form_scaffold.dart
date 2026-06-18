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
    final keyboardOpen = bottomInset > 0;

    final form = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: child,
    );

    return ColoredBox(
      color: context.surfaceCard,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Wide + no keyboard: pin the form dead-centre in the left panel.
            if (wide && !keyboardOpen) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontal),
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: Center(child: form),
                ),
              );
            }

            final padding = EdgeInsets.fromLTRB(
              horizontal,
              24,
              horizontal,
              24 + bottomInset,
            );
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: padding,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - padding.vertical,
                ),
                child: Align(
                  alignment: Alignment.center,
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
