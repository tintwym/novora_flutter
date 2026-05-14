import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Performance reviews')),
    );
  }
}
