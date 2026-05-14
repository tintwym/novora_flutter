import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Reusable attendance grid (placeholder).
class AttendanceTable extends StatelessWidget {
  const AttendanceTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('Attendance table'),
    );
  }
}
