import 'package:flutter/material.dart';

class ReportsNavItem {
  const ReportsNavItem({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

class ReportsNavSection {
  const ReportsNavSection({required this.title, required this.items});

  final String title;
  final List<ReportsNavItem> items;
}

abstract final class ReportsNav {
  static const overview = ReportsNavSection(
    title: 'OVERVIEW',
    items: [
      ReportsNavItem(
        id: 'report_centre',
        label: 'Report centre',
        icon: Icons.grid_view_rounded,
      ),
      ReportsNavItem(
        id: 'scheduled',
        label: 'Scheduled reports',
        icon: Icons.schedule_rounded,
      ),
      ReportsNavItem(
        id: 'custom_builder',
        label: 'Custom builder',
        icon: Icons.tune_rounded,
      ),
    ],
  );

  static const modules = ReportsNavSection(
    title: 'BY MODULE',
    items: [
      ReportsNavItem(
        id: 'employee',
        label: 'Employee',
        icon: Icons.person_outline_rounded,
      ),
      ReportsNavItem(
        id: 'attendance',
        label: 'Attendance',
        icon: Icons.schedule_rounded,
      ),
      ReportsNavItem(
        id: 'leave',
        label: 'Leave',
        icon: Icons.beach_access_outlined,
      ),
      ReportsNavItem(
        id: 'payroll',
        label: 'Payroll',
        icon: Icons.payments_outlined,
      ),
      ReportsNavItem(
        id: 'performance',
        label: 'Performance',
        icon: Icons.insights_outlined,
      ),
      ReportsNavItem(
        id: 'training',
        label: 'Training',
        icon: Icons.school_outlined,
      ),
      ReportsNavItem(
        id: 'claims',
        label: 'Claims',
        icon: Icons.receipt_long_outlined,
      ),
      ReportsNavItem(
        id: 'recruitment',
        label: 'Recruitment',
        icon: Icons.group_add_outlined,
      ),
      ReportsNavItem(
        id: 'asset',
        label: 'Asset',
        icon: Icons.inventory_2_outlined,
      ),
      ReportsNavItem(
        id: 'disciplinary',
        label: 'Disciplinary',
        icon: Icons.gavel_outlined,
      ),
    ],
  );

  static List<ReportsNavSection> get sections => [overview, modules];

  static ReportsNavItem? findById(String id) {
    for (final s in sections) {
      for (final i in s.items) {
        if (i.id == id) return i;
      }
    }
    return null;
  }
}

enum ReportModule {
  payroll,
  attendance,
  leave,
  performance,
  employee,
  claims,
  training,
  recruitment,
  asset,
  disciplinary,
}
