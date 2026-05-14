import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Export data')),
    );
  }
}
