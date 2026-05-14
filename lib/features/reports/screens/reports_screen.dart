import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Reports')),
    );
  }
}
