import 'package:flutter/material.dart';

import '../../core/theme/theme_colors.dart';

/// Auth form column (login / register / forgot password).
///
/// Vertically centres the form in the panel; scrolls when content is taller than
/// the viewport (register) or when the keyboard is open.
class AuthFormScaffold extends StatelessWidget {
  const AuthFormScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final keyboardOpen = bottomInset > 48;
    final horizontal = MediaQuery.sizeOf(context).width >= 900 ? 56.0 : 24.0;

    final form = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: child,
    );

    return ColoredBox(
      color: context.surfaceCard,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final panelHeight = constraints.maxHeight;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                horizontal,
                0,
                horizontal,
                keyboardOpen ? bottomInset + 24 : 0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: panelHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [form],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
