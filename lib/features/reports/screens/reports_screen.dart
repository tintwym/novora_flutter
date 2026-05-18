import 'package:flutter/material.dart';
import '../../../shared/widgets/module_shell_background.dart';

import '../../../core/constants/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    final body = const Center(child: Text('Reports'));
    if (embeddedInShell) {
      return ModuleShellBackground(child: body);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        foregroundColor: AppColors.navy,
      ),
      body: body,
    );
  }
}
