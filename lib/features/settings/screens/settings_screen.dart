import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Settings')),
    );
  }
}
