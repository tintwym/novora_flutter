import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class RunPayrollScreen extends StatelessWidget {
  const RunPayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Run payroll'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Run payroll')),
    );
  }
}
