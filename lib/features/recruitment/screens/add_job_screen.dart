import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class AddJobScreen extends StatelessWidget {
  const AddJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add job'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Add job')),
    );
  }
}
