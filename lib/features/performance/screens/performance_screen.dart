import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Performance')),
    );
  }
}
