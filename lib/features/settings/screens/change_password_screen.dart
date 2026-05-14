import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change password'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Change password')),
    );
  }
}
