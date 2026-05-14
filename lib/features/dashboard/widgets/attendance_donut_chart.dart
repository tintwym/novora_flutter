import 'package:flutter/material.dart';

import '../../../data/repositories/dashboard_repository.dart';
import 'dept_chart.dart';

/// Attendance donut / overview for the dashboard shell.
class AttendanceDonutChart extends StatelessWidget {
  const AttendanceDonutChart({super.key, required this.repository});

  final DashboardRepository repository;

  @override
  Widget build(BuildContext context) {
    return AttendanceOverviewChart(repository: repository);
  }
}
