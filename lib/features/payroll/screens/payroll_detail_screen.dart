import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PayrollDetailScreen extends StatelessWidget {
  const PayrollDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll detail'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Payroll detail')),
    );
  }
}
