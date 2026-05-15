import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    final body = const Center(child: Text('Recruitment'));
    if (embeddedInShell) {
      return ColoredBox(color: AppColors.bg, child: body);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recruitment'),
        foregroundColor: AppColors.navy,
      ),
      body: body,
    );
  }
}

typedef RecruitmentScreen = JobListScreen;
