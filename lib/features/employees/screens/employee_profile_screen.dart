import 'package:flutter/material.dart';
import '../../../shared/widgets/module_shell_background.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/employee_profile_detail_model.dart';
import '../../../shared/widgets/avatar_widget.dart';

/// Full employee profile (design: Employee Directory mockups — Sarah Lim / EMP-0021).
class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key, this.employeeId, this.embeddedInShell = false});

  /// Reserved for future API lookup; mock profile is shown for any id.
  final String? employeeId;

  /// When true, shown inside [DashboardScreen] shell stack (sidebar + top bar remain).
  final bool embeddedInShell;

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 8, vsync: this);
  late final EmployeeProfileDetailModel _data = EmployeeProfileDetailModel.mockDefault();

  static const _tabLabels = [
    'Summary',
    'Personal',
    'Family',
    'Biometric',
    'Pay Rate',
    'Career',
    'Education',
    'Documents',
  ];

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ProfileToolbar(
          onBack: () => Navigator.of(context).maybePop(),
          onDelete: () => _toast('Delete employee — connect API when ready'),
          onResetPassword: () => _toast('Reset password — connect API when ready'),
          onSave: () => _toast('Changes saved (mock)'),
        ),
        Expanded(
          child: NestedScrollView(
            headerSliverBuilder: (context, inner) => [
              SliverToBoxAdapter(child: _ProfileHeaderCard(data: _data.header)),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tab,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textMuted,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 2.5,
                    labelStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 13),
                    unselectedLabelStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w500, fontSize: 13),
                    tabs: _tabLabels.map((t) => Tab(text: t)).toList(),
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tab,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _SummaryTab(data: _data.summary),
                _PersonalTab(data: _data.personal),
                _FamilyTab(data: _data.family),
                _BiometricTab(data: _data.biometric),
                _PayRateTab(data: _data.payRate),
                _CareerTab(data: _data.career),
                _EducationTab(data: _data.education),
                _DocumentsTab(data: _data.documents),
              ],
            ),
          ),
        ),
      ],
    );

    if (widget.embeddedInShell) {
      return ModuleShellBackground(child: content);
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(child: content),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: overlapsContent ? 1 : 0,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => tabBar != oldDelegate.tabBar;
}

class _ProfileToolbar extends StatelessWidget {
  const _ProfileToolbar({
    required this.onBack,
    required this.onDelete,
    required this.onResetPassword,
    required this.onSave,
  });

  final VoidCallback onBack;
  final VoidCallback onDelete;
  final VoidCallback onResetPassword;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 12, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final narrow = c.maxWidth < 720;
          return Row(
            children: [
              TextButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.chevron_left_rounded, color: AppColors.navy),
                label: Text(
                  'Employee Directory',
                  style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: AppColors.navy),
                ),
              ),
              const Spacer(),
              if (narrow)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz, color: AppColors.navy),
                  onSelected: (v) {
                    if (v == 'd') {
                      onDelete();
                    } else if (v == 'r') {
                      onResetPassword();
                    } else if (v == 's') {
                      onSave();
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'd', child: Text('Delete employee')),
                    const PopupMenuItem(value: 'r', child: Text('Reset password')),
                    const PopupMenuItem(value: 's', child: Text('Save changes')),
                  ],
                )
              else ...[
                OutlinedButton(
                  onPressed: onDelete,
                  child: Text('Delete Employee', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onResetPassword,
                  child: Text('Reset Password', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: onSave,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Save Changes', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert, color: AppColors.muted),
                  tooltip: 'More',
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({required this.data});

  final ProfileHeader data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final stack = c.maxWidth < 900;
          final metrics = _HeaderMetrics(data: data);
          final identity = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AvatarWidget(
                initials: data.initials,
                size: 72,
                gradient: LinearGradient(
                  colors: [AppColors.brandBlueSoft, AppColors.brandBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(child: _HeaderIdentity(data: data)),
            ],
          );
          if (stack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                identity,
                const SizedBox(height: 20),
                metrics,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: identity),
              const SizedBox(width: 24),
              metrics,
            ],
          );
        },
      ),
    );
  }
}

class _HeaderIdentity extends StatelessWidget {
  const _HeaderIdentity({required this.data});

  final ProfileHeader data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 6,
          children: [
            Text(
              data.fullName,
              style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
            _Pill(data.statusLabel, bg: const Color(0xFFD1FAE5), fg: const Color(0xFF065F46)),
          ],
        ),
        const SizedBox(height: 10),
        _iconLine(Icons.badge_outlined, data.employeeCode),
        const SizedBox(height: 4),
        _iconLine(Icons.location_on_outlined, data.location),
        const SizedBox(height: 4),
        Text(
          data.departmentTitle,
          style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navyMid),
        ),
        const SizedBox(height: 4),
        Text(
          'Reports to: ${data.reportsTo}',
          style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _iconLine(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.muted),
        const SizedBox(width: 6),
        Text(text, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted)),
      ],
    );
  }
}

class _HeaderMetrics extends StatelessWidget {
  const _HeaderMetrics({required this.data});

  final ProfileHeader data;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Tenure', data.tenureLabel),
      ('Pay Grade', data.payGradeLabel),
      ('Leave Left', data.leaveLeftLabel),
      ('Performance', data.performanceLabel),
    ];
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const VerticalDivider(width: 24, color: AppColors.border),
            _metricCol(items[i].$1, items[i].$2),
          ],
        ],
      ),
    );
  }

  Widget _metricCol(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy)),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label, {required this.bg, required this.fg});

  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.title, this.trailing, required this.child});

  final String title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.sora(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SummaryTab extends StatelessWidget {
  const _SummaryTab({required this.data});

  final ProfileSummary data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        LayoutBuilder(
          builder: (context, c) {
            final narrow = c.maxWidth < 960;
            final leftCol = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileCard(
                  title: 'Employment details',
                  trailing: TextButton(onPressed: () {}, child: const Text('Edit')),
                  child: Column(
                    children: data.employment.map((e) {
                      if (e.key == 'Employment status') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(e.key, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: _Pill(e.value, bg: const Color(0xFFD1FAE5), fg: const Color(0xFF065F46)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return _kvRow(e.key, e.value);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _ProfileCard(
                  title: 'Leave balance',
                  child: Column(
                    children: data.leaveBalances.map((r) => _LeaveBalanceTile(row: r)).toList(),
                  ),
                ),
              ],
            );
            final rightCol = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileCard(
                  title: 'Performance overview',
                  child: Column(
                    children: [
                      ...data.performanceSkills.map((s) => _SkillBar(row: s)),
                      const Divider(height: 28),
                      _kvRow('Last appraisal', data.lastAppraisal),
                      _kvRow('Next review', data.nextReview),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _ProfileCard(
                  title: 'HR notes',
                  trailing: TextButton(onPressed: () {}, child: const Text('Edit')),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.hrNotes,
                        style: GoogleFonts.dmSans(fontSize: 13, height: 1.5, color: AppColors.navyMid),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Text('Blacklisted', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
                          const SizedBox(width: 8),
                          Text(
                            data.blacklisted ? 'Yes' : 'No',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: data.blacklisted ? AppColors.danger : AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 28),
                          Text('Auto clock-in', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
                          const SizedBox(width: 8),
                          Text(
                            data.autoClockIn ? 'Enabled' : 'Disabled',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
            if (narrow) {
              return Column(children: [leftCol, const SizedBox(height: 16), rightCol]);
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: leftCol),
                const SizedBox(width: 16),
                Expanded(flex: 5, child: rightCol),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _kvRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(k, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
          ),
          Expanded(child: Text(v, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _LeaveBalanceTile extends StatelessWidget {
  const _LeaveBalanceTile({required this.row});

  final LeaveBalanceRow row;

  Color _color() {
    switch (row.colorKey) {
      case 'green':
        return AppColors.success;
      case 'orange':
        return AppColors.warning;
      case 'blue':
      default:
        return AppColors.brandBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = row.total == 0 ? 0.0 : row.used / row.total;
    final c = _color();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(row.label, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
              Text(
                '${row.used} / ${row.total} days',
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: p,
              minHeight: 8,
              backgroundColor: AppColors.border,
              color: c,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({required this.row});

  final PerformanceSkillRow row;

  Color _color() {
    switch (row.colorKey) {
      case 'green':
        return AppColors.success;
      case 'purple':
        return AppColors.purple3;
      case 'blue':
      default:
        return AppColors.brandBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(row.label, style: GoogleFonts.dmSans(fontSize: 13)),
              Text('${row.percent}%', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: row.percent / 100,
              minHeight: 8,
              backgroundColor: AppColors.border,
              color: _color(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalTab extends StatelessWidget {
  const _PersonalTab({required this.data});

  final ProfilePersonal data;

  @override
  Widget build(BuildContext context) {
    Widget grid2(List<(String, String)> pairs) {
      return LayoutBuilder(
        builder: (context, c) {
          final w = (c.maxWidth - 16) / 2;
          return Wrap(
            spacing: 16,
            runSpacing: 12,
            children: pairs
                .map(
                  (e) => SizedBox(
                    width: c.maxWidth >= 560 ? w.clamp(200.0, 480.0) : c.maxWidth,
                    child: _fieldCell(e.$1, e.$2),
                  ),
                )
                .toList(),
          );
        },
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _ProfileCard(
          title: 'Personal information',
          trailing: TextButton(onPressed: () {}, child: const Text('Edit')),
          child: grid2([
            ('Full name', data.fullName),
            ('Date of birth', data.dateOfBirth),
            ('Gender', data.gender),
            ('Nationality', data.nationality),
            ('NRIC / ID No.', data.nric),
            ('Religion', data.religion),
            ('Marital status', data.maritalStatus),
            ('Personal email', data.personalEmail),
            ('Mobile no.', data.mobile),
            ('Race', data.race),
          ]),
        ),
        const SizedBox(height: 16),
        _ProfileCard(
          title: 'Passport details',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(value: data.passportEnabled, onChanged: (_) {}),
              Text('Enable', style: GoogleFonts.dmSans(fontSize: 13)),
            ],
          ),
          child: grid2([
            ('Passport no.', data.passportNo),
            ('Country of issue', data.passportCountry),
            ('Issue date', data.passportIssue),
            ('Expiry date', data.passportExpiry),
          ]),
        ),
        const SizedBox(height: 16),
        _ProfileCard(
          title: 'Current address',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              grid2([
                ('Address line 1', data.addr1),
                ('Address line 2', data.addr2),
                ('City', data.city),
                ('State', data.state),
                ('Postcode', data.postcode),
                ('Country', data.country),
              ]),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(value: data.sameAsPermanent, onChanged: (_) {}),
                  Text('Same as permanent address', style: GoogleFonts.dmSans(fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fieldCell(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _FamilyTab extends StatelessWidget {
  const _FamilyTab({required this.data});

  final ProfileFamily data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _ProfileCard(
          title: 'Family members',
          trailing: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add member'),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.bg),
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Relationship')),
                DataColumn(label: Text('Date of birth')),
                DataColumn(label: Text('NRIC / ID')),
                DataColumn(label: Text('Tax exempt')),
                DataColumn(label: Text('Passport')),
                DataColumn(label: Text('')),
              ],
              rows: data.members
                  .map(
                    (m) => DataRow(
                      cells: [
                        DataCell(Text(m.name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
                        DataCell(_Pill(m.relationship, bg: AppColors.bg, fg: AppColors.navyMid)),
                        DataCell(Text(m.dob)),
                        DataCell(Text(m.nric)),
                        DataCell(
                          _Pill(
                            m.taxExempt ? 'Yes' : 'No',
                            bg: m.taxExempt ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                            fg: m.taxExempt ? const Color(0xFF065F46) : AppColors.danger,
                          ),
                        ),
                        DataCell(Text(m.passport)),
                        DataCell(TextButton(onPressed: () {}, child: const Text('Edit'))),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ProfileCard(
          title: 'Next of kin / emergency contact',
          trailing: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add'),
          ),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.bg),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Relationship')),
              DataColumn(label: Text('Contact no.')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('')),
            ],
            rows: data.emergencyContacts
                .map(
                  (m) => DataRow(
                    cells: [
                      DataCell(Text(m.name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
                      DataCell(_Pill(m.relationship, bg: AppColors.bg, fg: AppColors.navyMid)),
                      DataCell(Text(m.phone)),
                      DataCell(Text(m.address)),
                      DataCell(TextButton(onPressed: () {}, child: const Text('Edit'))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _BiometricTab extends StatelessWidget {
  const _BiometricTab({required this.data});

  final ProfileBiometric data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _ProfileCard(
          title: 'Biometric device registration',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(value: data.enabled, onChanged: (_) {}),
              Text('Enabled', style: GoogleFonts.dmSans(fontSize: 13)),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add device'),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.bg),
              columns: const [
                DataColumn(label: Text('TA Number')),
                DataColumn(label: Text('Terminal name')),
                DataColumn(label: Text('Device type')),
                DataColumn(label: Text('Location')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('')),
              ],
              rows: data.devices
                  .map(
                    (d) => DataRow(
                      cells: [
                        DataCell(Text(d.taNumber)),
                        DataCell(Text(d.terminal)),
                        DataCell(Text(d.deviceType)),
                        DataCell(Text(d.location)),
                        DataCell(_Pill('Active', bg: const Color(0xFFD1FAE5), fg: const Color(0xFF065F46))),
                        DataCell(TextButton(onPressed: () {}, child: const Text('Edit'))),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _ProfileCard(
          title: 'Attendance settings',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _checkLine('Auto clock-in / clock-out', 'System auto-records attendance based on shift', data.autoClock),
              _checkLine('Ignore missing swipe', 'Suppress missing swipe alerts', data.ignoreMissingSwipe),
              _checkLine('Ignore rota deduction', 'Skip deduction rules for this employee', data.ignoreRotaDeduction),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Assigned shift', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
                    Text(
                      data.assignedShift,
                      style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _checkLine(String title, String subtitle, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(value: value, onChanged: (_) {}),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                Text(subtitle, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PayFieldCell {
  const _PayFieldCell(this.label, this.value, {this.highlight = false});

  final String label;
  final String value;
  final bool highlight;
}

class _PayRateTab extends StatelessWidget {
  const _PayRateTab({required this.data});

  final ProfilePayRate data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            children: [
              _ProfileCard(
                title: 'Base pay rate',
                trailing: TextButton(onPressed: () {}, child: const Text('Edit')),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final fields = [
                      _PayFieldCell('Pay grade', data.payGrade),
                      _PayFieldCell('Pay type', data.payType),
                      _PayFieldCell('Currency', data.currency),
                      _PayFieldCell('Basic salary', '${data.currency} ${data.basicSalary}', highlight: true),
                      _PayFieldCell('Effective date', data.effectiveDate),
                      _PayFieldCell('Bank account', data.bankMasked),
                    ];
                    return Wrap(
                      spacing: 16,
                      runSpacing: 14,
                      children: fields.map((e) {
                        final w = c.maxWidth >= 720 ? (c.maxWidth - 16) / 2 : c.maxWidth;
                        return SizedBox(
                          width: w.clamp(160.0, 520),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.label, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
                              const SizedBox(height: 4),
                              Text(
                                e.value,
                                style: GoogleFonts.dmSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: e.highlight ? AppColors.primary : AppColors.navy,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              _payTable('Allowances', '+ Add', data.allowances, showTaxable: true),
              const SizedBox(height: 16),
              _payTable('Deductions', '+ Add', data.deductions, showTaxable: false),
            ],
          ),
        ),
        _NetPayBar(currency: data.currency, amount: data.estimatedNetMonthly),
      ],
    );
  }

  Widget _payTable(String title, String addLabel, List<PayLineRow> rows, {required bool showTaxable}) {
    return _ProfileCard(
      title: title,
      trailing: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add, size: 18),
        label: Text(addLabel),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.bg),
          columns: [
            const DataColumn(label: Text('Type')),
            const DataColumn(label: Text('Amount (MYR)')),
            const DataColumn(label: Text('Frequency')),
            if (showTaxable) const DataColumn(label: Text('Taxable')),
            if (!showTaxable) const DataColumn(label: Text('Reference')),
            const DataColumn(label: Text('Status')),
          ],
          rows: rows
              .map(
                (r) => DataRow(
                  cells: [
                    DataCell(Text(r.label, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
                    DataCell(Text(r.amount)),
                    DataCell(Text(r.frequency)),
                    if (showTaxable)
                      DataCell(Text(r.taxable == true ? 'Yes' : 'No'))
                    else
                      DataCell(Text(r.ref ?? '—')),
                    DataCell(_Pill('Active', bg: const Color(0xFFD1FAE5), fg: const Color(0xFF065F46))),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _NetPayBar extends StatelessWidget {
  const _NetPayBar({required this.currency, required this.amount});

  final String currency;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE0F2FE),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: LayoutBuilder(
          builder: (context, c) {
            final narrow = c.maxWidth < 640;
            return Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated net pay (monthly)',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.navy),
                      ),
                      Text(
                        'Basic + Allowances − Deductions',
                        style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                if (!narrow) const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.muted),
                Text(
                  '$currency $amount',
                  style: GoogleFonts.sora(
                    fontSize: narrow ? 18 : 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CareerTab extends StatelessWidget {
  const _CareerTab({required this.data});

  final ProfileCareer data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _ProfileCard(
          title: 'Career history',
          trailing: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add'),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.bg),
              columns: const [
                DataColumn(label: Text('Company')),
                DataColumn(label: Text('Position')),
                DataColumn(label: Text('From')),
                DataColumn(label: Text('To')),
                DataColumn(label: Text('Reason for leaving')),
              ],
              rows: data.rows
                  .map(
                    (r) => DataRow(
                      cells: [
                        DataCell(Text(r.company, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
                        DataCell(Text(r.position)),
                        DataCell(Text(r.fromLabel)),
                        DataCell(Text(r.toLabel)),
                        DataCell(Text(r.reason)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _EducationTab extends StatelessWidget {
  const _EducationTab({required this.data});

  final ProfileEducation data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _ProfileCard(
          title: 'Education',
          trailing: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add'),
          ),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.bg),
            columns: const [
              DataColumn(label: Text('Institution')),
              DataColumn(label: Text('Qualification')),
              DataColumn(label: Text('Field of study')),
              DataColumn(label: Text('Year')),
              DataColumn(label: Text('Grade')),
            ],
            rows: data.rows
                .map(
                  (r) => DataRow(
                    cells: [
                      DataCell(Text(r.institution, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
                      DataCell(Text(r.qualification)),
                      DataCell(Text(r.field)),
                      DataCell(Text(r.year)),
                      DataCell(_Pill(r.gradeLabel, bg: const Color(0xFFD1FAE5), fg: const Color(0xFF065F46))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _DocumentsTab extends StatelessWidget {
  const _DocumentsTab({required this.data});

  final ProfileDocuments data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _ProfileCard(
          title: 'Employee documents',
          trailing: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Upload'),
          ),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.bg),
            columns: const [
              DataColumn(label: Text('Document name')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Uploaded')),
              DataColumn(label: Text('Expiry')),
              DataColumn(label: Text('')),
            ],
            rows: data.rows
                .map(
                  (r) => DataRow(
                    cells: [
                      DataCell(Text(r.name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
                      DataCell(_Pill(r.type, bg: AppColors.bg, fg: AppColors.navyMid)),
                      DataCell(Text(r.uploaded)),
                      DataCell(Text(r.expiry)),
                      DataCell(OutlinedButton(onPressed: () {}, child: const Text('View'))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
