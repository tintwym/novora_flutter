import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/daylight_schedule.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/theme/theme_notifier.dart';
import '../widgets/settings_widgets.dart';

typedef SettingsPanelBuilder = Widget Function(BuildContext context);

Widget buildSettingsPanel(String id, BuildContext context) {
  return switch (id) {
    'company_profile' => const _CompanyProfilePanel(),
    'modules' => const _ModulesPanel(),
    'branch_location' => const _BranchLocationPanel(),
    'department_position' => const _DepartmentPositionPanel(),
    'users_accounts' => const _UsersAccountsPanel(),
    'roles_permissions' => const _RolesPermissionsPanel(),
    'approval_workflow' => const _ApprovalWorkflowPanel(),
    'notifications' => const _NotificationsPanel(),
    'integrations' => const _IntegrationsPanel(),
    'security' => const _SecurityPanel(),
    'audit_log' => const _AuditLogPanel(),
    'appearance' => const _AppearancePanel(),
    'language' => const _LanguagePanel(),
    'email_templates' => const _EmailTemplatesPanel(),
    'backup_data' => const _BackupDataPanel(),
    _ => const _CompanyProfilePanel(),
  };
}

/// Light / Dark / Auto switcher backed by [ThemeNotifier].
///
/// The previous auto-only behaviour was a usability gap: there was no way to
/// preview dark mode mid-day, and users in long-daylight regions had no escape
/// hatch. The radio defaults to whatever the user previously persisted (or
/// `auto` on first run).
class _AppearancePanel extends StatelessWidget {
  const _AppearancePanel();

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: ListenableBuilder(
        listenable: ThemeNotifier.instance,
        builder: (context, _) {
          final notifier = ThemeNotifier.instance;
          final tc = context;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SettingsPageHeader(
                title: 'Appearance',
                subtitle:
                    'Choose how Novora looks. Auto follows local sunrise and sunset.',
              ),
              const SizedBox(height: 24),
              SettingsCard(
                title: 'Theme',
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  children: [
                    _ThemeOption(
                      icon: Icons.brightness_auto_rounded,
                      title: 'Automatic',
                      subtitle:
                          'Light during the day, dark after sunset (currently ${notifier.mode == ThemeMode.dark ? 'dark' : 'light'}).',
                      selected: notifier.preference == ThemePreference.auto,
                      onTap: () => notifier.setPreference(ThemePreference.auto),
                    ),
                    _ThemeOption(
                      icon: Icons.light_mode_rounded,
                      title: 'Light',
                      subtitle: 'Always use the light theme.',
                      selected: notifier.preference == ThemePreference.light,
                      onTap: () =>
                          notifier.setPreference(ThemePreference.light),
                    ),
                    _ThemeOption(
                      icon: Icons.dark_mode_rounded,
                      title: 'Dark',
                      subtitle: 'Always use the dark theme.',
                      selected: notifier.preference == ThemePreference.dark,
                      onTap: () => notifier.setPreference(ThemePreference.dark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Currently active: ${notifier.mode == ThemeMode.dark ? 'Dark' : 'Light'} '
                '(${notifier.scheduleLabel.toLowerCase()})',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: tc.secondaryText,
                ),
              ),
              if (notifier.preference == ThemePreference.auto) ...[
                const SizedBox(height: 4),
                Builder(
                  builder: (_) {
                    final now = DateTime.now();
                    final today = DaylightSchedule.forDate(now);
                    String fmt(DateTime t) =>
                        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
                    final offset = now.timeZoneOffset;
                    final sign = offset.isNegative ? '-' : '+';
                    final oh = offset.inHours.abs().toString().padLeft(2, '0');
                    final om = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
                    return Text(
                      'Today (UTC$sign$oh:$om) — sunrise ${fmt(today.sunrise)}, '
                      'sunset ${fmt(today.sunset)}.',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: tc.secondaryText,
                      ),
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    final accent = AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: selected
            ? (tc.isDarkMode
                  ? AppColors.brandBlue.withValues(alpha: 0.22)
                  : const Color(0xFFEFF6FF))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: selected ? accent : tc.borderColor,
                width: selected ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: selected ? accent : tc.secondaryText,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: tc.primaryText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: tc.secondaryText,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 22,
                  color: selected ? accent : tc.secondaryText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelScroll extends StatelessWidget {
  const _PanelScroll({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
      child: child,
    );
  }
}

// --- Organisation ---

class _CompanyProfilePanel extends StatefulWidget {
  const _CompanyProfilePanel();

  @override
  State<_CompanyProfilePanel> createState() => _CompanyProfilePanelState();
}

class _CompanyProfilePanelState extends State<_CompanyProfilePanel> {
  final _name = TextEditingController(text: 'Novora HRMS PTE Ltd');
  final _reg = TextEditingController(text: '1234567-A');
  final _industry = TextEditingController(text: 'Technology & Software');
  final _size = TextEditingController(text: '1,001 – 5,000 employees');
  final _founded = TextEditingController(text: '2010');
  final _website = TextEditingController(text: 'www.novorahrms.com');
  final _addr1 = TextEditingController(
    text: 'Level 18, Novora Tower, Jalan Sultan Ismail',
  );
  final _city = TextEditingController(text: 'Kuala Lumpur');
  final _state = TextEditingController(text: 'Wilayah Persekutuan');
  final _postcode = TextEditingController(text: '50250');
  final _country = TextEditingController(text: 'Malaysia');
  final _phone = TextEditingController(text: '+60 3-2100 0000');
  final _hrEmail = TextEditingController(text: 'hr@novorahrms.com');
  final _payrollEmail = TextEditingController(text: 'payroll@novorahrms.com');
  final _epf = TextEditingController(text: 'EPF-1234567');
  final _socso = TextEditingController(text: 'SSB-1234567');
  final _tax = TextEditingController(text: 'PCB-1234567');

  @override
  void dispose() {
    for (final c in [
      _name, _reg, _industry, _size, _founded, _website,
      _addr1, _city, _state, _postcode, _country,
      _phone, _hrEmail, _payrollEmail, _epf, _socso, _tax,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SettingsPageHeader(
            title: 'Company profile',
            subtitle: 'Legal entity details and company branding',
          ),
          const SizedBox(height: 20),
          SettingsCard(
            title: 'Basic information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.apartment, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Novora HRMS PTE Ltd',
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: context.primaryText,
                            ),
                          ),
                          Text(
                            'Logo · 200×200px recommended',
                            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Change logo'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _twoCol([
                  SettingsLabeledField(label: 'Company name', controller: _name),
                  SettingsLabeledField(label: 'Registration no.', controller: _reg),
                  SettingsLabeledField(
                    label: 'Industry',
                    controller: _industry,
                    dropdownItems: const ['Technology & Software', 'Finance', 'Manufacturing'],
                  ),
                  SettingsLabeledField(
                    label: 'Company size',
                    controller: _size,
                    dropdownItems: const ['1–50 employees', '51–200 employees', '1,001 – 5,000 employees'],
                  ),
                  SettingsLabeledField(label: 'Founded year', controller: _founded),
                  SettingsLabeledField(label: 'Website', controller: _website),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SettingsCard(
            title: 'Address',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsLabeledField(label: 'Address line 1', controller: _addr1),
                const SizedBox(height: 12),
                _twoCol([
                  SettingsLabeledField(label: 'City', controller: _city),
                  SettingsLabeledField(
                    label: 'State',
                    controller: _state,
                    dropdownItems: const ['Wilayah Persekutuan', 'Selangor', 'Penang'],
                  ),
                  SettingsLabeledField(label: 'Postcode', controller: _postcode),
                  SettingsLabeledField(
                    label: 'Country',
                    controller: _country,
                    dropdownItems: const ['Malaysia', 'Singapore'],
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SettingsCard(
            title: 'Contact & tax',
            child: _twoCol([
              SettingsLabeledField(label: 'Phone no.', controller: _phone),
              SettingsLabeledField(label: 'HR email', controller: _hrEmail),
              SettingsLabeledField(label: 'Payroll email', controller: _payrollEmail),
              SettingsLabeledField(label: 'EPF employer no.', controller: _epf),
              SettingsLabeledField(label: 'SOCSO employer no.', controller: _socso),
              SettingsLabeledField(label: 'Income tax no.', controller: _tax),
            ]),
          ),
        ],
      ),
    );
  }
}

Widget _twoCol(List<Widget> fields) {
  return LayoutBuilder(
    builder: (context, c) {
      final wide = c.maxWidth > 640;
      if (!wide) {
        return Column(
          children: fields
              .map((f) => Padding(padding: const EdgeInsets.only(bottom: 12), child: f))
              .toList(),
        );
      }
      final rows = <Widget>[];
      for (var i = 0; i < fields.length; i += 2) {
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: fields[i]),
                const SizedBox(width: 16),
                Expanded(child: i + 1 < fields.length ? fields[i + 1] : const SizedBox()),
              ],
            ),
          ),
        );
      }
      return Column(children: rows);
    },
  );
}

class _ModulesPanel extends StatefulWidget {
  const _ModulesPanel();

  @override
  State<_ModulesPanel> createState() => _ModulesPanelState();
}

class _ModulesPanelState extends State<_ModulesPanel> {
  final _modules = {
    'Employee management': true,
    'Attendance': true,
    'Leave management': true,
    'Payroll': true,
    'Performance': true,
    'Disciplinary': true,
    'Training': true,
    'Claims': true,
  };

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsPageHeader(
            title: 'Modules',
            subtitle: 'Enable or disable HRMS modules company-wide',
            trailing: OutlinedButton(
              onPressed: () {},
              child: const Text('Save'),
            ),
          ),
          const SizedBox(height: 20),
          SettingsCard(
            title: 'Core modules',
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, c) {
                final cross = c.maxWidth > 700 ? 2 : 1;
                return GridView.count(
                  crossAxisCount: cross,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: cross == 2 ? 3.8 : 4.5,
                  children: _modules.entries.map((e) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: context.borderColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              e.key,
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: context.primaryText,
                              ),
                            ),
                          ),
                          Switch.adaptive(
                            value: e.value,
                            activeThumbColor: AppColors.primary,
                            activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
                            onChanged: (v) => setState(() => _modules[e.key] = v),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchLocationPanel extends StatelessWidget {
  const _BranchLocationPanel();

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsPageHeader(
            title: 'Branch & location',
            subtitle: 'Manage all company offices and sites',
            trailing: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add branch'),
            ),
          ),
          const SizedBox(height: 20),
          SettingsCard(
            title: 'Registered branches',
            child: SettingsSimpleTable(
              columns: const ['Branch name', 'City', 'Employees', 'Status', ''],
              rows: [
                [
                  const Text('Kuala Lumpur HQ'),
                  const Text('Kuala Lumpur'),
                  const Text('1,024'),
                  const SettingsPill('Main', tone: SettingsPillTone.success),
                  TextButton(onPressed: () {}, child: const Text('Edit')),
                ],
                [
                  const Text('Penang Branch'),
                  const Text('Georgetown'),
                  const Text('142'),
                  const SettingsPill('Active', tone: SettingsPillTone.info),
                  TextButton(onPressed: () {}, child: const Text('Edit')),
                ],
                [
                  const Text('Johor Branch'),
                  const Text('Johor Bahru'),
                  const Text('118'),
                  const SettingsPill('Active', tone: SettingsPillTone.info),
                  TextButton(onPressed: () {}, child: const Text('Edit')),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DepartmentPositionPanel extends StatelessWidget {
  const _DepartmentPositionPanel();

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsPageHeader(
            title: 'Department & position',
            subtitle: 'Manage departments, sections, positions and grades',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Department'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Position'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, c) {
              final sideBySide = c.maxWidth > 900;
              final dept = SettingsCard(
                title: 'Departments',
                child: SettingsSimpleTable(
                  columns: const ['Name', 'Head', 'Count'],
                  rows: [
                    [const Text('Engineering'), const Text('David Ng'), const Text('342')],
                    [const Text('Finance'), const Text('Rachel Tan'), const Text('180')],
                    [const Text('HR'), const Text('Nina Reza'), const Text('88')],
                    [const Text('Marketing'), const Text('Kevin Lim'), const Text('142')],
                    [const Text('Operations'), const Text('Malik Said'), const Text('261')],
                  ],
                ),
              );
              final grades = SettingsCard(
                title: 'Job grades',
                child: SettingsSimpleTable(
                  columns: const ['Grade', 'Min salary', 'Max salary', ''],
                  rows: [
                    [
                      const Text('G-3'),
                      const Text('MYR 2,500'),
                      const Text('MYR 4,000'),
                      TextButton(onPressed: () {}, child: const Text('Edit')),
                    ],
                    [
                      const Text('G-5'),
                      const Text('MYR 4,500'),
                      const Text('MYR 6,000'),
                      TextButton(onPressed: () {}, child: const Text('Edit')),
                    ],
                    [
                      const Text('G-7'),
                      const Text('MYR 6,500'),
                      const Text('MYR 9,000'),
                      TextButton(onPressed: () {}, child: const Text('Edit')),
                    ],
                    [
                      const Text('G-9'),
                      const Text('MYR 9,500'),
                      const Text('MYR 15,000'),
                      TextButton(onPressed: () {}, child: const Text('Edit')),
                    ],
                  ],
                ),
              );
              if (sideBySide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: dept),
                    const SizedBox(width: 16),
                    Expanded(child: grades),
                  ],
                );
              }
              return Column(children: [dept, const SizedBox(height: 16), grades]);
            },
          ),
        ],
      ),
    );
  }
}

// --- Access control ---

class _UsersAccountsPanel extends StatelessWidget {
  const _UsersAccountsPanel();

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsPageHeader(
            title: 'Users & accounts',
            subtitle: 'Manage system login accounts and access levels',
            trailing: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Invite user'),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '8 active users',
              style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          SettingsCard(
            title: 'System users',
            child: SettingsSimpleTable(
              columns: const ['User', 'Email', 'Role', 'Last login', 'Status', ''],
              rows: [
                _userRow('SA', 'Sarah Ahmad', 'sarah@novorahrms.com', 'Super admin', SettingsPillTone.info, 'Just now'),
                _userRow('NR', 'Nina Reza', 'nina@novorahrms.com', 'HR manager', SettingsPillTone.purple, '2 hrs ago'),
                _userRow('DN', 'David Ng', 'david@novorahrms.com', 'Department head', SettingsPillTone.orange, 'Yesterday'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _userRow(String initials, String name, String email, String role, SettingsPillTone tone, String login) {
    return [
      Row(
        children: [
          Builder(
            builder: (ctx) => CircleAvatar(
              radius: 14,
              backgroundColor: ctx.subtleFill,
              child: Text(initials, style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 8),
          Text(name),
        ],
      ),
      Text(email),
      SettingsPill(role, tone: tone),
      Text(login),
      const SettingsPill('Active', tone: SettingsPillTone.success),
      TextButton(onPressed: () {}, child: const Text('Edit')),
    ];
  }
}

class _RolesPermissionsPanel extends StatefulWidget {
  const _RolesPermissionsPanel();

  @override
  State<_RolesPermissionsPanel> createState() => _RolesPermissionsPanelState();
}

class _RolesPermissionsPanelState extends State<_RolesPermissionsPanel> {
  bool _superAdminOn = true;

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsPageHeader(
            title: 'Roles & permissions',
            subtitle: 'Define what each role can view or edit per module',
            trailing: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New role'),
            ),
          ),
          const SizedBox(height: 20),
          _roleCard(
            title: 'Super admin',
            subtitle: 'All modules — full access',
            badge: const SettingsPill('Full access', tone: SettingsPillTone.info),
            trailing: Switch.adaptive(
              value: _superAdminOn,
              activeThumbColor: AppColors.primary,
              activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
              onChanged: (v) => setState(() => _superAdminOn = v),
            ),
          ),
          const SizedBox(height: 12),
          _roleCard(
            title: 'HR manager',
            badge: const SettingsPill('Custom role', tone: SettingsPillTone.purple),
            permissions: const {
              'Employee mgt': 'Full',
              'Payroll': 'Full',
              'Attendance': 'Full',
              'Leave': 'Full',
              'Performance': 'View + approve',
              'Disciplinary': 'Full',
              'Training': 'Full',
              'Claims': 'View + approve',
            },
          ),
          const SizedBox(height: 12),
          _roleCard(
            title: 'Department head',
            badge: const SettingsPill('Custom role', tone: SettingsPillTone.orange),
            permissions: const {
              'Employee mgt': 'View only',
              'Payroll': 'View only',
              'Attendance': 'View + approve',
              'Leave': 'View + approve',
              'Performance': 'View + approve',
              'Claims': 'View + approve',
            },
          ),
        ],
      ),
    );
  }

  Widget _roleCard({
    required String title,
    String? subtitle,
    required Widget badge,
    Widget? trailing,
    Map<String, String>? permissions,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: context.primaryText)),
                    if (subtitle != null)
                      Text(subtitle, style: GoogleFonts.dmSans(fontSize: 12, color: context.secondaryText)),
                  ],
                ),
              ),
              badge,
              if (trailing != null) ...[const SizedBox(width: 12), trailing],
            ],
          ),
          if (permissions != null) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: permissions.entries.map((e) {
                final tone = e.value == 'Full'
                    ? SettingsPillTone.success
                    : e.value == 'View only'
                        ? SettingsPillTone.neutral
                        : SettingsPillTone.info;
                return SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      Expanded(child: Text(e.key, style: GoogleFonts.dmSans(fontSize: 13))),
                      SettingsPill(e.value, tone: tone),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ApprovalWorkflowPanel extends StatefulWidget {
  const _ApprovalWorkflowPanel();

  @override
  State<_ApprovalWorkflowPanel> createState() => _ApprovalWorkflowPanelState();
}

class _ApprovalWorkflowPanelState extends State<_ApprovalWorkflowPanel> {
  bool _leaveEmail = true;
  bool _leaveDenyReason = true;
  bool _otNotifyPayroll = true;

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsPageHeader(
            title: 'Approval workflow',
            subtitle: 'Configure routing chains per module and condition',
            trailing: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New workflow'),
            ),
          ),
          const SizedBox(height: 20),
          _workflowSection(
            title: 'Leave approval',
            rows: [
              SettingsToggleRow(
                title: 'Enable email notification on request',
                value: _leaveEmail,
                onChanged: (v) => setState(() => _leaveEmail = v),
              ),
              const SettingsKvRow(label: 'Auto-approve after 3 working days if no response', value: ''),
              SettingsToggleRow(
                title: 'Require reason when denying a request',
                value: _leaveDenyReason,
                onChanged: (v) => setState(() => _leaveDenyReason = v),
              ),
              const SettingsKvRow(label: 'Step 1', value: 'Direct manager'),
              const SettingsKvRow(label: 'Step 2 (leave > 5 days)', value: 'Department head'),
            ],
          ),
          const SizedBox(height: 16),
          _workflowSection(
            title: 'Claim approval',
            rows: const [
              SettingsKvRow(label: 'Claims < MYR 200', value: 'Manager only'),
              SettingsKvRow(label: 'Claims MYR 201 – 1,000', value: 'Manager → Dept Head'),
              SettingsKvRow(label: 'Claims > MYR 1,000', value: 'Manager → Dept Head | Finance (parallel)'),
            ],
          ),
          const SizedBox(height: 16),
          _workflowSection(
            title: 'Overtime approval',
            rows: [
              const SettingsKvRow(label: 'All OT requests', value: 'Direct manager'),
              const SettingsKvRow(label: 'OT > 4 hrs / day', value: 'Manager → HOD'),
              SettingsToggleRow(
                title: 'Notify payroll on OT approval',
                value: _otNotifyPayroll,
                onChanged: (v) => setState(() => _otNotifyPayroll = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _workflowSection({required String title, required List<Widget> rows}) {
    return SettingsCard(
      title: title,
      trailing: TextButton(onPressed: () {}, child: const Text('Edit')),
      child: Column(children: rows),
    );
  }
}

// --- System ---

class _NotificationsPanel extends StatefulWidget {
  const _NotificationsPanel();

  @override
  State<_NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<_NotificationsPanel> {
  final _toggles = <String, bool>{
    'In-app notifications': true,
    'Email notifications': true,
    'Leave request submitted': true,
    'Leave approved / denied': true,
    'Attendance — missing swipe': true,
    'Claim submitted / approved': true,
    'Payroll processed': true,
    'Performance review due': true,
    'Contract renewal upcoming (30 days)': true,
    'Probation review due': true,
  };

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsPageHeader(
            title: 'Notifications',
            subtitle: 'Control system-wide email and in-app alerts',
            trailing: FilledButton(onPressed: () {}, child: const Text('Save')),
          ),
          const SizedBox(height: 20),
          SettingsCard(
            title: 'Notification channels',
            child: Column(
              children: [
                SettingsToggleRow(
                  title: 'In-app notifications',
                  subtitle: 'Real-time bell icon alerts in the HRMS',
                  value: _toggles['In-app notifications']!,
                  onChanged: (v) => setState(() => _toggles['In-app notifications'] = v),
                ),
                SettingsToggleRow(
                  title: 'Email notifications',
                  subtitle: 'Send email for approvals, reminders, alerts',
                  value: _toggles['Email notifications']!,
                  onChanged: (v) => setState(() => _toggles['Email notifications'] = v),
                ),
                const SettingsToggleRow(
                  title: 'Mobile push (app)',
                  subtitle: 'Push alerts to the Novora mobile app',
                  value: false,
                  onChanged: _noop,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SettingsCard(
            title: 'Module-level alerts',
            child: Column(
              children: _toggles.entries
                  .where((e) => !e.key.contains('notifications'))
                  .map(
                    (e) => SettingsToggleRow(
                      title: e.key,
                      value: e.value,
                      onChanged: (v) => setState(() => _toggles[e.key] = v),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

void _noop(bool _) {}

class _IntegrationsPanel extends StatelessWidget {
  const _IntegrationsPanel();

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SettingsPageHeader(
            title: 'Integrations',
            subtitle: 'Connect external services to Novora HRMS',
          ),
          const SizedBox(height: 20),
          SettingsCard(
            title: 'Connected integrations',
            child: Column(
              children: [
                _integrationRow('Payroll – bank file export', 'Auto-generate bank file for salary disbursement', 'Connected', SettingsPillTone.success),
                _integrationRow('Biometric device (TA terminal)', 'Sync attendance swipe data from all terminals', 'Connected', SettingsPillTone.success),
                _integrationRow('Currency exchange API', 'Live FX rates for claim currency conversion', 'Connected', SettingsPillTone.success),
                _integrationRow('SMTP – email server', 'smtp.novorahrms.com · Port 587', 'Connected', SettingsPillTone.success),
                _integrationRow('EPF / SOCSO e-filing', 'Monthly statutory submission to KWSP & PERKESO', 'Pending setup', SettingsPillTone.warning),
                _integrationRow('OCR engine (receipt scan)', 'Tesseract OCR · Auto-populate claim fields', 'Connected', SettingsPillTone.success),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SettingsCard(
            title: 'API access',
            trailing: TextButton(onPressed: () {}, child: const Text('Generate new key')),
            child: const Column(
              children: [
                SettingsKvRow(
                  label: 'API key',
                  value: 'sk-aperio-********************4f21',
                ),
                SettingsKvRow(label: 'Last used', value: '6 May 2026 10:42'),
                SettingsKvRow(label: 'Rate limit', value: '1,000 req / min'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _integrationRow(String title, String sub, String status, SettingsPillTone tone) {
    return Builder(
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: ctx.primaryText)),
                  Text(sub, style: GoogleFonts.dmSans(fontSize: 12, color: ctx.secondaryText)),
                ],
              ),
            ),
            SettingsPill(status, tone: tone),
          ],
        ),
      ),
    );
  }
}

class _SecurityPanel extends StatefulWidget {
  const _SecurityPanel();

  @override
  State<_SecurityPanel> createState() => _SecurityPanelState();
}

class _SecurityPanelState extends State<_SecurityPanel> {
  bool _twoFa = true;
  bool _forceReset = true;
  bool _logAdmin = true;
  bool _upper = true;
  bool _numbers = true;
  bool _special = true;
  bool _reuse = false;

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsPageHeader(
            title: 'Security',
            subtitle: 'Authentication, session, and access policies',
            trailing: FilledButton(onPressed: () {}, child: const Text('Save')),
          ),
          const SizedBox(height: 20),
          SettingsCard(
            title: 'Authentication',
            child: Column(
              children: [
                SettingsToggleRow(
                  title: 'Two-factor authentication (2FA)',
                  subtitle: 'Require 2FA for all admin accounts',
                  value: _twoFa,
                  onChanged: (v) => setState(() => _twoFa = v),
                ),
                const SettingsToggleRow(
                  title: 'Single sign-on (SSO)',
                  subtitle: 'Allow login via Microsoft / Google SSO',
                  value: false,
                  onChanged: _noop,
                ),
                SettingsToggleRow(
                  title: 'Force password reset on first login',
                  value: _forceReset,
                  onChanged: (v) => setState(() => _forceReset = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SettingsCard(
            title: 'Password policy',
            child: LayoutBuilder(
              builder: (context, c) {
                final policy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Minimum length'),
                    const SizedBox(height: 6),
                    const _MockDropdown(value: '8 characters'),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _upper,
                      onChanged: (v) => setState(() => _upper = v ?? false),
                      title: const Text('Require uppercase & lowercase'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _numbers,
                      onChanged: (v) => setState(() => _numbers = v ?? false),
                      title: const Text('Require numbers'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _special,
                      onChanged: (v) => setState(() => _special = v ?? false),
                      title: const Text('Require special characters'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _reuse,
                      onChanged: (v) => setState(() => _reuse = v ?? false),
                      title: const Text('Prevent reuse of last 5 passwords'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ],
                );
                final expiry = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Password expiry'),
                    SizedBox(height: 6),
                    _MockDropdown(value: '90 days'),
                  ],
                );
                if (c.maxWidth > 640) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: policy),
                      const SizedBox(width: 24),
                      Expanded(child: expiry),
                    ],
                  );
                }
                return Column(children: [policy, const SizedBox(height: 16), expiry]);
              },
            ),
          ),
          const SizedBox(height: 16),
          SettingsCard(
            title: 'Session & access',
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(child: _MockDropdown(value: '30 minutes', label: 'Session timeout')),
                    SizedBox(width: 16),
                    Expanded(child: _MockDropdown(value: '5 attempts', label: 'Max failed login attempts')),
                  ],
                ),
                const SizedBox(height: 8),
                const SettingsKvRow(label: 'IP whitelist (restrict access to known IPs)', value: ''),
                SettingsToggleRow(
                  title: 'Log all admin actions',
                  value: _logAdmin,
                  onChanged: (v) => setState(() => _logAdmin = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MockDropdown extends StatelessWidget {
  const _MockDropdown({required this.value, this.label});

  final String value;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 6),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: context.borderColor),
            borderRadius: BorderRadius.circular(8),
            color: context.subtleFill,
          ),
          child: Row(
            children: [
              Expanded(child: Text(value, style: GoogleFonts.dmSans(fontSize: 14))),
              const Icon(Icons.expand_more, color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _AuditLogPanel extends StatelessWidget {
  const _AuditLogPanel();

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsPageHeader(
            title: 'Audit log',
            subtitle: 'Permanent record of all system actions and changes',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(onPressed: () {}, child: const Text('Filter')),
                const SizedBox(width: 8),
                FilledButton(onPressed: () {}, child: const Text('Export log')),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SettingsCard(
            title: 'Recent actions',
            child: SettingsSimpleTable(
              columns: const ['Timestamp', 'User', 'Action', 'Module', 'IP'],
              rows: [
                [
                  const Text('6 May 10:42'),
                  const Text('David Ng'),
                  const Text('Approved claim MYR 120.00'),
                  const SettingsPill('Claims', tone: SettingsPillTone.orange),
                  const Text('192.168.1.24'),
                ],
                [
                  const Text('6 May 09:15'),
                  const Text('HR Admin'),
                  const Text('Updated payroll – May 2026'),
                  const SettingsPill('Payroll', tone: SettingsPillTone.success),
                  const Text('192.168.1.10'),
                ],
                [
                  const Text('5 May 18:30'),
                  const Text('Nina Reza'),
                  const Text('Added disciplinary case EMP-0187'),
                  const SettingsPill('Disciplinary', tone: SettingsPillTone.warning),
                  const Text('192.168.1.14'),
                ],
                [
                  const Text('5 May 16:00'),
                  const Text('HR Admin'),
                  const Text('Deleted user account (EMP-0199)'),
                  const SettingsPill('Users', tone: SettingsPillTone.info),
                  const Text('192.168.1.10'),
                ],
                [
                  const Text('4 May 11:00'),
                  const Text('HR Admin'),
                  const Text('Exported payroll report Apr 2026'),
                  const SettingsPill('Payroll', tone: SettingsPillTone.success),
                  const Text('192.168.1.10'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Preferences ---

class _LanguagePanel extends StatefulWidget {
  const _LanguagePanel();

  @override
  State<_LanguagePanel> createState() => _LanguagePanelState();
}

class _LanguagePanelState extends State<_LanguagePanel> {
  String _selectedLanguage = 'english';
  bool _autoTranslate = true;

  static const _languages = [
    ('english', 'English', 'Default system language'),
    ('burmese', 'Burmese (မြန်မာဘာသာ)', 'Burmese (Myanmar)'),
    ('chinese', 'Chinese (简体中文)', 'Simplified Chinese'),
  ];

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SettingsPageHeader(
            title: 'Language & Interface',
            subtitle:
                'Manage your primary language and display preferences for the platform.',
          ),
          const SizedBox(height: 24),
          _SectionLabel('System Language'),
          const SizedBox(height: 10),
          Column(
            children: [
              for (final (id, name, desc) in _languages)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _LanguageOptionTile(
                    title: name,
                    subtitle: desc,
                    selected: _selectedLanguage == id,
                    onTap: () => setState(() => _selectedLanguage = id),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          SettingsToggleRow(
            title: 'Auto-translate Content',
            subtitle:
                'Automatically translate user comments into your selected language',
            value: _autoTranslate,
            onChanged: (v) => setState(() => _autoTranslate = v),
          ),
          Divider(height: 24, color: context.borderColor),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Character Encoding',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.primaryText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Unicode (Recommended for Burmese support)',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Change',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionLabel('Regional Preferences'),
          const SizedBox(height: 6),
          Text(
            'Configure timezone and date formatting based on your main operations.',
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.subtleFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.borderColor),
            ),
            child: _twoCol(const [
              _MockDropdown(value: 'Asia/Kuala_Lumpur (UTC+8)', label: 'TIMEZONE'),
              _MockDropdown(value: 'DD/MM/YYYY', label: 'DATE FORMAT'),
              _MockDropdown(value: '12-hour (AM/PM)', label: 'TIME FORMAT'),
              _MockDropdown(value: 'MYR — Malaysian Ringgit', label: 'PRIMARY CURRENCY'),
            ]),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedLanguage = 'english';
                    _autoTranslate = true;
                  });
                },
                child: Text(
                  'Reset to Default',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save_outlined, size: 18),
                label: const Text('Save Changes'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.textMuted,
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: context.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : context.borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.primaryText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: context.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : context.borderColor,
                  width: selected ? 6 : 1.5,
                ),
                color: context.surfaceCard,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailTemplatesPanel extends StatelessWidget {
  const _EmailTemplatesPanel();

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SettingsPageHeader(
            title: 'Email templates',
            subtitle: 'Customise system-generated email notifications',
            trailing: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New template'),
            ),
          ),
          const SizedBox(height: 20),
          SettingsCard(
            title: 'Active templates',
            child: SettingsSimpleTable(
              columns: const ['Template name', 'Trigger', 'Last edited', ''],
              rows: [
                [
                  const Text('Leave request submitted'),
                  const Text('On leave request'),
                  const Text('2 Mar 2026'),
                  TextButton(onPressed: () {}, child: const Text('Edit')),
                ],
                [
                  const Text('Payslip available'),
                  const Text('On payroll confirm'),
                  const Text('1 Jan 2026'),
                  TextButton(onPressed: () {}, child: const Text('Edit')),
                ],
                [
                  const Text('Claim approved'),
                  const Text('On claim approval'),
                  const Text('15 Feb 2026'),
                  TextButton(onPressed: () {}, child: const Text('Edit')),
                ],
                [
                  const Text('Welcome – new employee'),
                  const Text('On employee creation'),
                  const Text('10 Jan 2026'),
                  TextButton(onPressed: () {}, child: const Text('Edit')),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackupDataPanel extends StatelessWidget {
  const _BackupDataPanel();

  @override
  Widget build(BuildContext context) {
    return _PanelScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SettingsPageHeader(
            title: 'Backup & data',
            subtitle: 'Export, retention and data management policies',
          ),
          const SizedBox(height: 20),
          SettingsCard(
            title: 'Automated backups',
            child: Column(
              children: [
                const SettingsKvRow(label: 'Last backup', value: '6 May 2026 · 02:00'),
                const SettingsKvRow(label: 'Frequency', value: 'Daily at 02:00 (UTC+8)'),
                const SettingsKvRow(label: 'Retention', value: '90 days'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton(onPressed: () {}, child: const Text('Run backup now')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SettingsCard(
            title: 'Data export',
            child: Column(
              children: [
                const SettingsKvRow(label: 'Employee records', value: 'CSV / Excel'),
                const SettingsKvRow(label: 'Payroll history', value: 'PDF / CSV'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(onPressed: () {}, child: const Text('Request export')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
