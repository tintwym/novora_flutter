import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class TrainingDetailScreen extends StatelessWidget {
  const TrainingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training detail'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Training detail')),
    );
  }
}
