import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Summary strip for payroll runs (placeholder).
class PayrollSummaryWidget extends StatelessWidget {
  const PayrollSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text('Payroll summary'),
    );
  }
}
