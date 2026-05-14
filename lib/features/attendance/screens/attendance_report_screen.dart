import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

/// Attendance reports (placeholder — wire to API when available).
class AttendanceReportScreen extends StatelessWidget {
  const AttendanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance report'),
        foregroundColor: AppColors.navy,
      ),
      body: const Center(child: Text('Attendance report')),
    );
  }
}
