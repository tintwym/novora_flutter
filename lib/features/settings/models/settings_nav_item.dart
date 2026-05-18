import 'package:flutter/material.dart';

class SettingsNavItem {
  const SettingsNavItem({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final IconData icon;
}

class SettingsNavSection {
  const SettingsNavSection({required this.title, required this.items});

  final String title;
  final List<SettingsNavItem> items;
}

abstract final class SettingsNav {
  static const sections = [
    SettingsNavSection(
      title: 'ORGANISATION',
      items: [
        SettingsNavItem(
          id: 'company_profile',
          label: 'Company profile',
          icon: Icons.business_outlined,
        ),
        SettingsNavItem(
          id: 'modules',
          label: 'Modules',
          icon: Icons.grid_view_rounded,
        ),
        SettingsNavItem(
          id: 'branch_location',
          label: 'Branch & location',
          icon: Icons.account_tree_outlined,
        ),
        SettingsNavItem(
          id: 'department_position',
          label: 'Department & position',
          icon: Icons.hub_outlined,
        ),
      ],
    ),
    SettingsNavSection(
      title: 'ACCESS CONTROL',
      items: [
        SettingsNavItem(
          id: 'users_accounts',
          label: 'Users & accounts',
          icon: Icons.people_outline_rounded,
        ),
        SettingsNavItem(
          id: 'roles_permissions',
          label: 'Roles & permissions',
          icon: Icons.shield_outlined,
        ),
        SettingsNavItem(
          id: 'approval_workflow',
          label: 'Approval workflow',
          icon: Icons.check_circle_outline_rounded,
        ),
      ],
    ),
    SettingsNavSection(
      title: 'SYSTEM',
      items: [
        SettingsNavItem(
          id: 'notifications',
          label: 'Notifications',
          icon: Icons.notifications_outlined,
        ),
        SettingsNavItem(
          id: 'integrations',
          label: 'Integrations',
          icon: Icons.extension_outlined,
        ),
        SettingsNavItem(
          id: 'security',
          label: 'Security',
          icon: Icons.lock_outline_rounded,
        ),
        SettingsNavItem(
          id: 'audit_log',
          label: 'Audit log',
          icon: Icons.description_outlined,
        ),
      ],
    ),
    SettingsNavSection(
      title: 'PREFERENCES',
      items: [
        SettingsNavItem(
          id: 'localisation',
          label: 'Localisation',
          icon: Icons.language_outlined,
        ),
        SettingsNavItem(
          id: 'email_templates',
          label: 'Email templates',
          icon: Icons.email_outlined,
        ),
        SettingsNavItem(
          id: 'backup_data',
          label: 'Backup & data',
          icon: Icons.storage_outlined,
        ),
      ],
    ),
  ];

  static SettingsNavItem? findById(String id) {
    for (final section in sections) {
      for (final item in section.items) {
        if (item.id == id) return item;
      }
    }
    return null;
  }
}
