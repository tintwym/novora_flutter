import 'package:flutter/material.dart';

import '../../../shared/models/sidebar_subnav.dart';

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

  static List<ReportsNavSection> get sections => [overview];

  static List<SidebarSubnavSection> get sidebarSections => sections
      .map(
        (s) => SidebarSubnavSection(
          title: s.title,
          entries: s.items
              .map(
                (i) => SidebarSubnavEntry(
                  id: i.id,
                  label: i.label,
                  icon: i.icon,
                ),
              )
              .toList(),
        ),
      )
      .toList();

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
