import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class EmployeeDetailScreen extends StatelessWidget {
  const EmployeeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee detail'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Employee detail')),
    );
  }
}
