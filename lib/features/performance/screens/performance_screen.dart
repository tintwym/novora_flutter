import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    final body = const Center(child: Text('Performance'));
    if (embeddedInShell) {
      return ColoredBox(color: AppColors.bg, child: body);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance'),
        foregroundColor: AppColors.navy,
      ),
      body: body,
    );
  }
}
