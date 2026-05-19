import 'package:flutter/material.dart';

/// One row inside an expandable sidebar group (e.g. Report centre).
class SidebarSubnavEntry {
  const SidebarSubnavEntry({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

/// Section header + entries shown under a parent nav item (e.g. OVERVIEW).
class SidebarSubnavSection {
  const SidebarSubnavSection({
    required this.title,
    required this.entries,
  });

  final String title;
  final List<SidebarSubnavEntry> entries;
}
