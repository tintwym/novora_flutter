import 'package:flutter/material.dart';

import '../../core/theme/theme_colors.dart';

/// Wraps embedded module content with the themed scaffold background.
class ModuleShellBackground extends StatelessWidget {
  const ModuleShellBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: context.pageBackground, child: child);
  }
}
