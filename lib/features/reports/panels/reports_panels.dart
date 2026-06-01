import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../shared/widgets/themed_surface_card.dart';
import '../widgets/reports_ui_helpers.dart';

typedef ReportsNavigate = void Function(String panelId);

Widget buildReportsPanel(
  String id,
  BuildContext context, {
  ReportsNavigate? onNavigate,
}) {
  return switch (id) {
    'report_centre' => const _ReportsCenterPanel(),
    'scheduled' => const _ScheduledReportsPanel(),
    'custom_builder' => const _CustomBuilderPanel(),
    _ => const _ReportsCenterPanel(),
  };
}

// =============================================================================
// Reports Center (with module tabs)
// =============================================================================

class _ReportsCenterPanel extends StatefulWidget {
  const _ReportsCenterPanel();

  @override
  State<_ReportsCenterPanel> createState() => _ReportsCenterPanelState();
}

class _ReportsCenterPanelState extends State<_ReportsCenterPanel> {
  String _selectedTab = 'overview';
  String _perfSubTab = 'level';

  @override
  Widget build(BuildContext context) {
    return _ReportsScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ReportsHeader(),
          const SizedBox(height: 18),
          _ReportsTopTabs(
            tabs: _reportTabs,
            selectedId: _selectedTab,
            onSelect: (id) => setState(() => _selectedTab = id),
          ),
          if (_selectedTab == 'performance') ...[
            const SizedBox(height: 18),
            _PerformanceSubTabs(
              selectedId: _perfSubTab,
              onSelect: (id) => setState(() => _perfSubTab = id),
            ),
          ],
          const SizedBox(height: 28),
          if (_selectedTab == 'overview')
            const _AllOverviewBody()
          else
            _ModuleTabBody(config: _moduleConfigById[_selectedTab]!),
        ],
      ),
    );
  }
}

// --- All Overview ---

class _AllOverviewBody extends StatelessWidget {
  const _AllOverviewBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 700;
            final kpis = [
              const _OverviewKpi(
                value: '48',
                valueColor: AppColors.primary,
                label: 'TOTAL REPORTS',
                sub: '10 modules',
              ),
              const _OverviewKpi(
                value: '12',
                valueColor: Color(0xFF059669),
                label: 'SCHEDULED REPORTS',
                sub: 'Next: tomorrow 06:00',
              ),
              const _OverviewKpi(
                value: '7',
                valueColor: AppColors.navy,
                label: 'CUSTOM REPORTS SAVED',
                sub: 'By HR team',
              ),
            ];
            if (!wide) {
              return Column(
                children: [
                  for (final k in kpis)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: k,
                    ),
                ],
              );
            }
            return Row(
              children: [
                for (var i = 0; i < kpis.length; i++) ...[
                  if (i > 0) const SizedBox(width: 16),
                  Expanded(child: kpis[i]),
                ],
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 900;
            final left = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SectionCaption('Most Used Reports'),
                const SizedBox(height: 10),
                _OverviewListCard(
                  rows: [
                    (
                      'Monthly payroll summary',
                      'Earnings, deductions, net pay by department',
                      _PillSpec(
                        label: 'PAYROLL',
                        bg: const Color(0xFFD1FAE5),
                        fg: const Color(0xFF065F46),
                      ),
                    ),
                    (
                      'Attendance detail report',
                      'Clock-in, clock-out, OT, absent per employee',
                      _PillSpec(
                        label: 'ATTENDANCE',
                        bg: const Color(0xFFDBEAFE),
                        fg: AppColors.primary,
                      ),
                    ),
                    (
                      'Leave balance summary',
                      'Entitlement, used, balance per leave type',
                      _PillSpec(
                        label: 'LEAVE',
                        bg: const Color(0xFFFFEDD5),
                        fg: const Color(0xFFC2410C),
                      ),
                    ),
                    (
                      'Performance appraisal results',
                      'Scores, grades, CEP ratings',
                      _PillSpec(
                        label: 'PERFORMANCE',
                        bg: const Color(0xFFEDE9FE),
                        fg: const Color(0xFF5B21B6),
                      ),
                    ),
                  ],
                ),
              ],
            );
            final right = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _SectionCaption('Recent Activity'),
                const SizedBox(height: 10),
                const _RecentActivityCard(),
                const SizedBox(height: 18),
                const _SectionCaption('Export Formats'),
                const SizedBox(height: 10),
                const _ExportFormatsCard(),
              ],
            );
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: left),
                  const SizedBox(width: 24),
                  Expanded(flex: 2, child: right),
                ],
              );
            }
            return Column(children: [left, const SizedBox(height: 20), right]);
          },
        ),
        const SizedBox(height: 28),
        const _ReportsFooterActions(),
      ],
    );
  }
}

// --- Module tab body ---

class _ModuleTabBody extends StatelessWidget {
  const _ModuleTabBody({required this.config});

  final _ModuleConfig config;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 760;
            final left = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionCaption('${config.code} Reports Available'),
                const SizedBox(height: 10),
                _ModuleReportsCard(config: config),
              ],
            );
            final right = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                _SectionCaption('Quick Snapshot'),
                SizedBox(height: 10),
                _QuickSnapshotCard(),
              ],
            );
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: left),
                  const SizedBox(width: 24),
                  Expanded(child: right),
                ],
              );
            }
            return Column(children: [left, const SizedBox(height: 20), right]);
          },
        ),
        const SizedBox(height: 28),
        const _ReportsFooterActions(),
      ],
    );
  }
}

// --- Scheduled reports ---

class _ScheduledReportsPanel extends StatefulWidget {
  const _ScheduledReportsPanel();

  @override
  State<_ScheduledReportsPanel> createState() => _ScheduledReportsPanelState();
}

class _ScheduledReportsPanelState extends State<_ScheduledReportsPanel> {
  String _reportType = 'Monthly payroll summary';
  String _frequency = 'Daily';
  String _deliveryTime = '06:00 AM';
  String _format = 'Excel (.xlsx)';
  final _emailCtrl = TextEditingController(
    text: 'hr@novora.com, cfo@novora.com',
  );

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ReportsScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ReportsHeader(),
          const SizedBox(height: 18),
          _ReportsTopTabs(
            tabs: _reportTabs,
            selectedId: 'overview',
            onSelect: (_) {},
          ),
          const SizedBox(height: 28),
          const _SectionCaption('Schedule New Report'),
          const SizedBox(height: 10),
          _OutlinedFormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _twoColForm([
                  _FormDropdown(
                    label: 'REPORT TYPE',
                    value: _reportType,
                    items: const [
                      'Monthly payroll summary',
                      'Leave balance report',
                      'Attendance summary',
                    ],
                    onChanged: (v) => setState(() => _reportType = v),
                  ),
                  _FormDropdown(
                    label: 'FREQUENCY',
                    value: _frequency,
                    items: const ['Daily', 'Weekly', 'Monthly', 'Quarterly'],
                    onChanged: (v) => setState(() => _frequency = v),
                  ),
                  _FormDropdown(
                    label: 'DELIVERY TIME',
                    value: _deliveryTime,
                    items: const ['06:00 AM', '08:00 AM', '18:00 PM'],
                    onChanged: (v) => setState(() => _deliveryTime = v),
                  ),
                  _FormDropdown(
                    label: 'FORMAT',
                    value: _format,
                    items: const ['Excel (.xlsx)', 'PDF', 'CSV'],
                    onChanged: (v) => setState(() => _format = v),
                  ),
                ]),
                const SizedBox(height: 12),
                _FormText(label: 'RECIPIENTS (EMAIL)', controller: _emailCtrl),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const _SectionCaption('Active Schedules'),
          const SizedBox(height: 10),
          const _ActiveSchedulesCard(),
          const SizedBox(height: 28),
          const _ReportsFooterActions(),
        ],
      ),
    );
  }
}

// --- Custom builder ---

class _CustomBuilderPanel extends StatefulWidget {
  const _CustomBuilderPanel();

  @override
  State<_CustomBuilderPanel> createState() => _CustomBuilderPanelState();
}

class _CustomBuilderPanelState extends State<_CustomBuilderPanel> {
  String _primaryModule = 'Employee management';
  bool _combineAttendance = true;
  bool _combineLeave = false;
  String _department = 'All departments';
  String _employmentStatus = 'Active only';
  String _sortBy = 'Employee No.';
  String _format = 'Excel (.xlsx)';
  final Map<String, bool> _employeeFields = {
    'Employee No.': true,
    'Full Name': true,
    'Department': true,
    'Position': true,
  };
  late final TextEditingController _dateFromCtrl;
  late final TextEditingController _dateToCtrl;

  @override
  void initState() {
    super.initState();
    _dateFromCtrl = TextEditingController(text: '2026-01-01');
    _dateToCtrl = TextEditingController(text: '2026-05-31');
  }

  @override
  void dispose() {
    _dateFromCtrl.dispose();
    _dateToCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ReportsScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ReportsHeader(),
          const SizedBox(height: 18),
          _ReportsTopTabs(
            tabs: _reportTabs,
            selectedId: 'overview',
            onSelect: (_) {},
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 880;
              final left = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SectionCaption('1. Data Source'),
                  const SizedBox(height: 10),
                  _OutlinedFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _FormDropdown(
                          label: 'PRIMARY MODULE',
                          value: _primaryModule,
                          items: const [
                            'Employee management',
                            'Payroll',
                            'Attendance',
                          ],
                          onChanged: (v) => setState(() => _primaryModule = v),
                        ),
                        const SizedBox(height: 14),
                        _MiniLabel('Combine with'),
                        const SizedBox(height: 6),
                        _CheckRow(
                          label: 'Attendance data',
                          value: _combineAttendance,
                          onChanged: (v) =>
                              setState(() => _combineAttendance = v),
                        ),
                        _CheckRow(
                          label: 'Leave data',
                          value: _combineLeave,
                          onChanged: (v) => setState(() => _combineLeave = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _SectionCaption('2. Select Fields'),
                  const SizedBox(height: 10),
                  _OutlinedFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'EMPLOYEE FIELDS',
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        for (final entry in _employeeFields.entries)
                          _CheckRow(
                            label: entry.key,
                            value: entry.value,
                            onChanged: (v) =>
                                setState(() => _employeeFields[entry.key] = v),
                          ),
                      ],
                    ),
                  ),
                ],
              );
              final right = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SectionCaption('3. Filters'),
                  const SizedBox(height: 10),
                  _OutlinedFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _FormText(
                                label: 'FROM',
                                controller: _dateFromCtrl,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _FormText(
                                label: 'TO',
                                controller: _dateToCtrl,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _FormDropdown(
                          label: 'DEPARTMENT',
                          value: _department,
                          items: const [
                            'All departments',
                            'Engineering',
                            'Finance',
                            'HR',
                          ],
                          onChanged: (v) => setState(() => _department = v),
                        ),
                        const SizedBox(height: 12),
                        _FormDropdown(
                          label: 'EMPLOYMENT STATUS',
                          value: _employmentStatus,
                          items: const ['Active only', 'All', 'Resigned'],
                          onChanged: (v) =>
                              setState(() => _employmentStatus = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const _SectionCaption('4. Output'),
                  const SizedBox(height: 10),
                  _OutlinedFormCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _FormDropdown(
                          label: 'SORT BY',
                          value: _sortBy,
                          items: const ['Employee No.', 'Department', 'Name'],
                          onChanged: (v) => setState(() => _sortBy = v),
                        ),
                        const SizedBox(height: 12),
                        _FormDropdown(
                          label: 'FORMAT',
                          value: _format,
                          items: const ['Excel (.xlsx)', 'PDF', 'CSV'],
                          onChanged: (v) => setState(() => _format = v),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () => showReportSnack(
                              context,
                              'Running custom report…',
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Run & Export Report',
                              style: GoogleFonts.dmSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: left),
                    const SizedBox(width: 24),
                    Expanded(child: right),
                  ],
                );
              }
              return Column(
                children: [left, const SizedBox(height: 20), right],
              );
            },
          ),
          const SizedBox(height: 28),
          const _ReportsFooterActions(),
        ],
      ),
    );
  }
}

// =============================================================================
// Shared layout primitives
// =============================================================================

class _ReportsScaffold extends StatelessWidget {
  const _ReportsScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(40, 32, 40, 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: child,
      ),
    );
  }
}

class _ReportsHeader extends StatelessWidget {
  const _ReportsHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Novora Reports Center',
          style: GoogleFonts.sora(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: context.primaryText,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Insights, analytics, and auto-generated data exports across all modules.',
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: context.secondaryText,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _ReportsTopTabs extends StatelessWidget {
  const _ReportsTopTabs({
    required this.tabs,
    required this.selectedId,
    required this.onSelect,
  });

  final List<({String id, String label})> tabs;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.borderColor)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final tab in tabs)
              _TabItem(
                label: tab.label,
                selected: tab.id == selectedId,
                onTap: () => onSelect(tab.id),
              ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.primary : context.secondaryText,
            ),
          ),
        ),
      ),
    );
  }
}

class _PerformanceSubTabs extends StatelessWidget {
  const _PerformanceSubTabs({required this.selectedId, required this.onSelect});

  final String selectedId;
  final ValueChanged<String> onSelect;

  static const _items = <({String id, String label})>[
    (id: 'level', label: 'Perf. level'),
    (id: 'grade', label: 'Perf. grade'),
    (id: 'kpi', label: 'KPI setting'),
    (id: 'eval_type', label: 'Eval. type'),
    (id: 'eval_category', label: 'Eval. category'),
    (id: 'eval_setup', label: 'Eval. setup'),
    (id: 'grant', label: 'Grant permissions'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final i in _items)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => onSelect(i.id),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: selectedId == i.id
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: Text(
                    i.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: selectedId == i.id
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: selectedId == i.id
                          ? AppColors.primary
                          : context.secondaryText,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionCaption extends StatelessWidget {
  const _SectionCaption(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.muted,
      ),
    );
  }
}

class _OutlinedFormCard extends StatelessWidget {
  const _OutlinedFormCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: child,
    );
  }
}

class _MiniLabel extends StatelessWidget {
  const _MiniLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: context.secondaryText,
      ),
    );
  }
}

class _FormDropdown extends StatelessWidget {
  const _FormDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: items.contains(value) ? value : items.first,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.navy),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}

class _FormText extends StatelessWidget {
  const _FormText({required this.label, required this.controller});

  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.navy),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                activeColor: AppColors.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.navy),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _twoColForm(List<Widget> fields) {
  return LayoutBuilder(
    builder: (context, c) {
      final wide = c.maxWidth > 520;
      if (!wide) {
        return Column(
          children: fields
              .map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: f,
                ),
              )
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
                Expanded(
                  child: i + 1 < fields.length
                      ? fields[i + 1]
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        );
      }
      return Column(children: rows);
    },
  );
}

class _ReportsFooterActions extends StatelessWidget {
  const _ReportsFooterActions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Reset to Default',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: () => showReportSnack(context, 'Changes saved.'),
            icon: const Icon(Icons.save_outlined, size: 18),
            label: const Text('Save Changes'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.navy,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// All Overview cards
// =============================================================================

class _OverviewKpi extends StatelessWidget {
  const _OverviewKpi({
    required this.value,
    required this.label,
    required this.sub,
    required this.valueColor,
  });

  final String value;
  final String label;
  final String sub;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.sora(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: valueColor,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: context.primaryText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _PillSpec {
  const _PillSpec({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;
}

class _OverviewListCard extends StatelessWidget {
  const _OverviewListCard({required this.rows});

  final List<(String, String, _PillSpec)> rows;

  @override
  Widget build(BuildContext context) {
    return ThemedSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: context.borderColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rows[i].$1,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: context.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rows[i].$2,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: context.secondaryText,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _Pill(spec: rows[i].$3),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.spec});
  final _PillSpec spec;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: spec.bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        spec.label,
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: spec.fg,
        ),
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard();

  static const _entries = <(String, String)>[
    ('Monthly payroll summary', 'HR Admin · 6 May 10:30'),
    ('Leave balance report', 'Auto-scheduled · 1 May 06:00'),
    ('Attendance summary — Apr', 'Nina Reza · 30 Apr 18:00'),
  ];

  @override
  Widget build(BuildContext context) {
    return ThemedSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < _entries.length; i++) ...[
            if (i > 0) Divider(height: 1, color: context.borderColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _entries[i].$1,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: context.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _entries[i].$2,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: context.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => showReportSnack(context, 'Downloading…'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Download',
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExportFormatsCard extends StatelessWidget {
  const _ExportFormatsCard();

  @override
  Widget build(BuildContext context) {
    return ThemedSurfaceCard(
      child: Row(
        children: const [
          _ExportPill(label: 'EXCEL', fg: Color(0xFF059669)),
          SizedBox(width: 8),
          _ExportPill(label: 'PDF', fg: Color(0xFFDC2626)),
          SizedBox(width: 8),
          _ExportPill(label: 'CSV', fg: Color(0xFF7C3AED)),
        ],
      ),
    );
  }
}

class _ExportPill extends StatelessWidget {
  const _ExportPill({required this.label, required this.fg});
  final String label;
  final Color fg;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: fg,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

// =============================================================================
// Module tab content
// =============================================================================

class _ModuleReportsCard extends StatelessWidget {
  const _ModuleReportsCard({required this.config});

  final _ModuleConfig config;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      (
        '${config.titleNoun} Summary',
        'Aggregated ${config.lowerCode} data for the selected period.',
      ),
      (
        '${config.titleNoun} Detail Log',
        'Individual transaction and activity logs for ${config.lowerCode}.',
      ),
      (
        'Historical Trend',
        'Year-on-year comparisons and growth tracking analytics.',
      ),
    ];
    return ThemedSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: context.borderColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rows[i].$1,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: context.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rows[i].$2,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: context.secondaryText,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _Pill(
                    spec: _PillSpec(
                      label: config.code,
                      bg: config.pillBg,
                      fg: config.pillFg,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickSnapshotCard extends StatelessWidget {
  const _QuickSnapshotCard();

  @override
  Widget build(BuildContext context) {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _kv(context, 'Total Records', '1,284', valueBold: true),
          const SizedBox(height: 14),
          _kv(
            context,
            'Last Updated',
            '6 May 10:42',
            valueColor: const Color(0xFF059669),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Auto-Run Status',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: context.secondaryText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'ACTIVE',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _DeptBar(label: 'Engineering', value: 342, color: AppColors.primary),
          _DeptBar(
            label: 'Operations',
            value: 261,
            color: const Color(0xFF059669),
          ),
          _DeptBar(
            label: 'Finance',
            value: 180,
            color: const Color(0xFF7C3AED),
          ),
        ],
      ),
    );
  }

  Widget _kv(
    BuildContext context,
    String k,
    String v, {
    Color? valueColor,
    bool valueBold = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            k,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: context.secondaryText,
            ),
          ),
        ),
        Text(
          v,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: valueBold ? FontWeight.w800 : FontWeight.w700,
            color: valueColor ?? context.primaryText,
          ),
        ),
      ],
    );
  }
}

class _DeptBar extends StatelessWidget {
  const _DeptBar({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const max = 400;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: context.secondaryText,
                  ),
                ),
              ),
              Text(
                '$value',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: context.primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / max,
              minHeight: 6,
              backgroundColor: context.subtleFill,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Active schedules table
// =============================================================================

class _ActiveSchedulesCard extends StatelessWidget {
  const _ActiveSchedulesCard();

  static const _rows = <(String, String, String)>[
    ('Monthly payroll summary', 'Monthly', '1 Jun 06:00'),
    ('Attendance summary', 'Monthly', '1 Jun 06:00'),
    ('Leave balance report', 'Monthly', '1 Jun 06:00'),
  ];

  @override
  Widget build(BuildContext context) {
    return ThemedSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(flex: 4, child: _ColHead('Report Name')),
                Expanded(flex: 2, child: _ColHead('Frequency')),
                Expanded(flex: 2, child: _ColHead('Next Run')),
                SizedBox(
                  width: 60,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _ColHead('Action'),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: context.borderColor),
          for (var i = 0; i < _rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: context.borderColor),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      _rows[i].$1,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: context.primaryText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      _rows[i].$2,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: context.secondaryText,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      _rows[i].$3,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: context.secondaryText,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            showReportSnack(context, 'Edit ${_rows[i].$1}'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Edit',
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ColHead extends StatelessWidget {
  const _ColHead(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.dmSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: AppColors.muted,
      ),
    );
  }
}

// =============================================================================
// Tabs + module config data
// =============================================================================

const _reportTabs = <({String id, String label})>[
  (id: 'overview', label: 'All Overview'),
  (id: 'employee', label: 'Employee'),
  (id: 'attendance', label: 'Attendance'),
  (id: 'leave', label: 'Leave'),
  (id: 'payroll', label: 'Payroll'),
  (id: 'performance', label: 'Performance'),
  (id: 'training', label: 'Training'),
  (id: 'claims', label: 'Claims'),
  (id: 'recruitment', label: 'Recruitment'),
  (id: 'asset', label: 'Asset'),
  (id: 'disciplinary', label: 'Disciplinary'),
];

class _ModuleConfig {
  const _ModuleConfig({
    required this.titleNoun,
    required this.code,
    required this.pillBg,
    required this.pillFg,
  });

  final String titleNoun;
  final String code;
  final Color pillBg;
  final Color pillFg;

  String get lowerCode => code.toLowerCase();
}

final _moduleConfigById = <String, _ModuleConfig>{
  'employee': _ModuleConfig(
    titleNoun: 'Emp',
    code: 'EMP',
    pillBg: const Color(0xFFE2E8F0),
    pillFg: const Color(0xFF475569),
  ),
  'attendance': _ModuleConfig(
    titleNoun: 'Att',
    code: 'ATT',
    pillBg: const Color(0xFFDBEAFE),
    pillFg: AppColors.primary,
  ),
  'leave': _ModuleConfig(
    titleNoun: 'Lv',
    code: 'LV',
    pillBg: const Color(0xFFFFEDD5),
    pillFg: const Color(0xFFC2410C),
  ),
  'payroll': _ModuleConfig(
    titleNoun: 'Pay',
    code: 'PAY',
    pillBg: const Color(0xFFD1FAE5),
    pillFg: const Color(0xFF065F46),
  ),
  'performance': _ModuleConfig(
    titleNoun: 'Perf',
    code: 'PERF',
    pillBg: const Color(0xFFEDE9FE),
    pillFg: const Color(0xFF5B21B6),
  ),
  'training': _ModuleConfig(
    titleNoun: 'Trn',
    code: 'TRN',
    pillBg: const Color(0xFFE0F2FE),
    pillFg: const Color(0xFF0369A1),
  ),
  'claims': _ModuleConfig(
    titleNoun: 'Clm',
    code: 'CLM',
    pillBg: const Color(0xFFFCE7F3),
    pillFg: const Color(0xFF9D174D),
  ),
  'recruitment': _ModuleConfig(
    titleNoun: 'Rec',
    code: 'REC',
    pillBg: const Color(0xFFFEF3C7),
    pillFg: const Color(0xFFB45309),
  ),
  'asset': _ModuleConfig(
    titleNoun: 'Ast',
    code: 'AST',
    pillBg: const Color(0xFFE2E8F0),
    pillFg: const Color(0xFF475569),
  ),
  'disciplinary': _ModuleConfig(
    titleNoun: 'Dis',
    code: 'DIS',
    pillBg: const Color(0xFFFEE2E2),
    pillFg: const Color(0xFF991B1B),
  ),
};
