import 'package:flutter/material.dart';

import '../../core/theme/theme_colors.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return Material(
      color: tc.surfaceCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: tc.borderColor),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
