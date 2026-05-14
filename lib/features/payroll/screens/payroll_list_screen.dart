import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PayrollListScreen extends StatelessWidget {
  const PayrollListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payroll'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Payroll')),
    );
  }
}

typedef PayrollScreen = PayrollListScreen;
