import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../shared/widgets/themed_surface_card.dart';
import '../models/reports_nav.dart';
import '../widgets/reports_ui_helpers.dart';

typedef ReportsNavigate = void Function(String panelId);

Widget buildReportsPanel(
  String id,
  BuildContext context, {
  ReportsNavigate? onNavigate,
}) {
  return switch (id) {
    'report_centre' => _ReportCentrePanel(onNavigate: onNavigate),
    'scheduled' => const _ScheduledReportsPanel(),
    'custom_builder' => const _CustomBuilderPanel(),
    'employee' => _modulePanel(
      context,
      title: 'Employee reports',
      subtitle: 'Headcount, movement, profile and contract reports',
      snapshotTitle: 'Headcount snapshot — May 2026',
      reports: const [
        (
          'Employee headcount report',
          'Active, new joiners, resigned — by dept & branch',
        ),
        (
          'Employee movement report',
          'Transfers, promotions, demotions this period',
        ),
        ('Contract expiry report', 'Contracts expiring in 30 / 60 / 90 days'),
        ('Probation due report', 'Employees completing probation this month'),
        (
          'Employee profile export',
          'Full profile data export for all active employees',
        ),
        ('Work anniversary report', 'Service milestones by month'),
      ],
      snapshot: _employeeSnapshot(context),
    ),
    'attendance' => _modulePanel(
      context,
      title: 'Attendance reports',
      subtitle: 'Detail, summary, OT, missing swipe and roll call reports',
      snapshotTitle: 'Attendance snapshot — May 2026',
      reports: const [
        (
          'Attendance detail report',
          'Daily clock-in/out, work hours, OT per employee',
        ),
        (
          'Attendance summary report',
          'Monthly totals: present, absent, leave, late per emp.',
        ),
        ('Overtime report', 'OT hours and amount by employee and department'),
        (
          'Missing swipe report',
          'Employees with unresolved missing clock-in/out',
        ),
        ('Roll call report', 'Daily present/absent/leave status snapshot'),
        (
          'Late arrival report',
          'Employees with repeated late arrivals this period',
        ),
      ],
      snapshot: _attendanceSnapshot(context),
    ),
    'leave' => _modulePanel(
      context,
      title: 'Leave reports',
      subtitle: 'Balance, history, pending and entitlement reports',
      snapshotTitle: 'Leave snapshot — 2026 YTD',
      reports: const [
        (
          'Leave balance report',
          'Entitlement vs used vs remaining per leave type',
        ),
        (
          'Leave history report',
          'All leave requests with status, dates and approver',
        ),
        ('Leave pending report', 'All leave requests awaiting approval'),
        (
          'Leave card report',
          'Individual employee leave card — printable format',
        ),
        (
          'Annual leave encashment',
          'Unused leave eligible for encashment at year-end',
        ),
      ],
      snapshot: _leaveSnapshot(context),
    ),
    'payroll' => _modulePanel(
      context,
      title: 'Payroll reports',
      subtitle: 'Pay summary, payslip, statutory and cost reports',
      snapshotTitle: 'Payroll snapshot — May 2026',
      reports: const [
        (
          'Monthly payroll summary',
          'Total earnings, deductions, net pay by department',
        ),
        (
          'Payroll detail report',
          'Individual breakdown per employee per pay component',
        ),
        (
          'EPF / SOCSO contribution',
          'Employer & employee statutory contribution report',
        ),
        (
          'Income tax (PCB) report',
          'Monthly PCB deduction per employee for LHDN',
        ),
        (
          'Payroll cost by department',
          'Total cost including allowances and bonuses',
        ),
        ('Bank payment file', 'Export bank-ready file for salary disbursement'),
      ],
      snapshot: _payrollSnapshot(context),
    ),
    'performance' => _modulePanel(
      context,
      title: 'Performance reports',
      subtitle: 'Appraisal results, KPI scores and grade distribution',
      snapshotTitle: 'Grade distribution — Year-end 2025',
      reports: const [
        (
          'Appraisal result report',
          'Scores, grades and CEP ratings by department',
        ),
        (
          'KPI achievement report',
          'KPI target vs actual achievement per employee',
        ),
        ('Grade distribution report', 'Grade A/B/C/D breakdown by department'),
        ('Performance review history', 'All past evaluations per employee'),
        (
          'CEP / high potential list',
          'Employees flagged for succession planning',
        ),
      ],
      snapshot: _performanceSnapshot(context),
    ),
    'training' => _modulePanel(
      context,
      title: 'Training reports',
      subtitle: 'Course completion, attendance and budget reports',
      snapshotTitle: 'Training snapshot — 2026 YTD',
      reports: const [
        (
          'Training history report',
          'All training records per employee with status',
        ),
        ('Training attendance report', 'Present/absent per course session'),
        (
          'Course completion report',
          'Completion rate per course and department',
        ),
        ('Training cost report', 'Fees paid per course and per employee'),
        (
          'Training needs analysis',
          'Employees with overdue or pending training',
        ),
      ],
      snapshot: _trainingSnapshot(context),
    ),
    'claims' => _modulePanel(
      context,
      title: 'Claims reports',
      subtitle: 'Spending, approval status and policy compliance reports',
      snapshotTitle: 'Claims snapshot — May 2026',
      reports: const [
        (
          'Claims summary report',
          'Total claims by employee, category and month',
        ),
        ('Claims detail report', 'Individual claim items with receipt status'),
        (
          'Pending claims report',
          'All claims awaiting approval by approver level',
        ),
        (
          'Policy violation report',
          'Claims flagged — over limit, duplicate, late',
        ),
        (
          'Claims payroll push report',
          'Claims pushed to payroll per pay cycle',
        ),
      ],
      snapshot: _claimsSnapshot(context),
    ),
    'recruitment' => _modulePanel(
      context,
      title: 'Recruitment reports',
      subtitle: 'Pipeline, time-to-hire, cost and offer reports',
      snapshotTitle: 'Recruitment snapshot — Q2 2026',
      reports: const [
        ('Requisition status report', 'Open, filled, on hold — by department'),
        (
          'Candidate pipeline report',
          'Applicants at each stage per open position',
        ),
        (
          'Time to hire report',
          'Days from requisition open to filled by dept.',
        ),
        ('Recruitment cost report', 'Ad spend, agency fees, cost per hire'),
        (
          'Offer & acceptance report',
          'Offers extended, accepted, declined — by role',
        ),
      ],
      snapshot: _recruitmentSnapshot(context),
    ),
    'asset' => _modulePanel(
      context,
      title: 'Asset reports',
      subtitle: 'Registry, depreciation, maintenance and disposal reports',
      snapshotTitle: 'Asset snapshot — 2026',
      reports: const [
        (
          'Asset register report',
          'Full asset list with tag, category, value, status',
        ),
        (
          'Asset assignment report',
          'Assets assigned by employee and department',
        ),
        (
          'Depreciation schedule',
          'Acquisition cost, depreciation rate, book value',
        ),
        (
          'Maintenance history report',
          'All service records with cost and vendor',
        ),
        ('Disposal report', 'Disposed assets with method, value, gain/loss'),
      ],
      snapshot: _assetSnapshot(context),
    ),
    'disciplinary' => _modulePanel(
      context,
      title: 'Disciplinary reports',
      subtitle: 'Case history, warning levels and trend reports',
      snapshotTitle: 'Disciplinary snapshot — 2026 YTD',
      reports: const [
        (
          'Disciplinary case history',
          'All cases by employee, reason, action, status',
        ),
        ('Warning level distribution', 'Count of L1–L6 warnings by department'),
        (
          'Repeat offence report',
          'Employees with more than one disciplinary case',
        ),
        (
          'Disciplinary trend report',
          'Monthly case count trend by offence type',
        ),
      ],
      snapshot: _disciplinarySnapshot(context),
    ),
    _ => _ReportCentrePanel(onNavigate: onNavigate),
  };
}

// --- Report centre ---

class _ReportCentrePanel extends StatelessWidget {
  const _ReportCentrePanel({this.onNavigate});

  final ReportsNavigate? onNavigate;

  @override
  Widget build(BuildContext context) {
    void snack(String m) => showReportSnack(context, m);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PageHeader(
            title: 'Report centre',
            subtitle: 'All reports across every HRMS module in one place.',
            actions: [
              OutlinedButton(
                onPressed: () => onNavigate?.call('scheduled'),
                child: const Text('+ Schedule'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => onNavigate?.call('custom_builder'),
                child: const Text('+ Custom report'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ThemedSurfaceCard(
            child: Row(
              children: const [
                ReportKpiTile(
                  value: '48',
                  label: 'Total reports',
                  sub: '10 modules',
                ),
                VerticalDivider(width: 1),
                ReportKpiTile(
                  value: '12',
                  label: 'Scheduled reports',
                  sub: 'Next: tomorrow 06:00',
                ),
                VerticalDivider(width: 1),
                ReportKpiTile(
                  value: '7',
                  label: 'Custom reports saved',
                  sub: 'By HR team',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 900;
              final left = ThemedSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ReportSectionTitle('Most used reports'),
                    _centreReportRow(
                      context,
                      'Monthly payroll summary',
                      'Earnings, deductions, net pay by department',
                      ReportModule.payroll,
                      () => snack('Running Monthly payroll summary…'),
                    ),
                    Divider(height: 1, color: context.borderColor),
                    _centreReportRow(
                      context,
                      'Attendance detail report',
                      'Clock-in, clock-out, OT, absent per employee',
                      ReportModule.attendance,
                      () => snack('Running Attendance detail report…'),
                    ),
                    Divider(height: 1, color: context.borderColor),
                    _centreReportRow(
                      context,
                      'Leave balance summary',
                      'Entitlement, used, balance per leave type',
                      ReportModule.leave,
                      () => snack('Running Leave balance summary…'),
                    ),
                    Divider(height: 1, color: context.borderColor),
                    _centreReportRow(
                      context,
                      'Performance appraisal results',
                      'Scores, grades, CEP ratings by department',
                      ReportModule.performance,
                      () => snack('Running Performance appraisal results…'),
                    ),
                    Divider(height: 1, color: context.borderColor),
                    _centreReportRow(
                      context,
                      'Employee headcount report',
                      'Active, new, resigned by dept and branch',
                      ReportModule.employee,
                      () => snack('Running Employee headcount report…'),
                    ),
                  ],
                ),
              );
              final right = Column(
                children: [
                  ThemedSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const ReportSectionTitle('Recent activity'),
                        _activityRow(
                          context,
                          'Monthly payroll summary',
                          'HR Admin • 6 May 10:30',
                          () => snack('Downloading…'),
                        ),
                        Divider(height: 1, color: context.borderColor),
                        _activityRow(
                          context,
                          'Leave balance report',
                          'Auto-scheduled • 1 May 06:00',
                          () => snack('Downloading…'),
                        ),
                        Divider(height: 1, color: context.borderColor),
                        _activityRow(
                          context,
                          'Attendance summary — Apr',
                          'Nina Reza • 30 Apr 18:00',
                          () => snack('Downloading…'),
                        ),
                        Divider(height: 1, color: context.borderColor),
                        _activityRow(
                          context,
                          'Training history export',
                          'HR Admin • 28 Apr 14:22',
                          () => snack('Downloading…'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ThemedSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const ReportSectionTitle('Export formats'),
                        for (final f in [
                          'Excel (.xlsx)',
                          'PDF',
                          'CSV',
                          'On-screen preview',
                        ])
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    f,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 13,
                                      color: context.primaryText,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD1FAE5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'All reports',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF065F46),
                                    ),
                                  ),
                                ),
                              ],
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
                    Expanded(flex: 3, child: left),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: right),
                  ],
                );
              }
              return Column(
                children: [left, const SizedBox(height: 16), right],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _centreReportRow(
    BuildContext context,
    String title,
    String sub,
    ReportModule module,
    VoidCallback onRun,
  ) {
    return ReportListTile(
      title: title,
      subtitle: sub,
      trailing: ReportModulePill(module),
      onRun: onRun,
    );
  }

  Widget _activityRow(
    BuildContext context,
    String title,
    String meta,
    VoidCallback onDownload,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.primaryText,
                  ),
                ),
                Text(
                  meta,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: context.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onDownload, child: const Text('Download')),
        ],
      ),
    );
  }
}

// --- Scheduled ---

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
  String _department = 'All departments';
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PageHeader(
            title: 'Scheduled reports',
            subtitle: 'Auto-generated and emailed on a set schedule.',
            actions: [
              FilledButton(
                onPressed: () {},
                child: const Text('+ Schedule new'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ThemedSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'New scheduled report',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: context.primaryText,
                  ),
                ),
                const SizedBox(height: 16),
                _formGrid(context, [
                  _dropdown(
                    'Report type',
                    _reportType,
                    const [
                      'Monthly payroll summary',
                      'Leave balance report',
                      'Attendance summary',
                    ],
                    (v) => setState(() => _reportType = v!),
                  ),
                  _dropdown('Frequency', _frequency, const [
                    'Daily',
                    'Weekly',
                    'Monthly',
                    'Quarterly',
                  ], (v) => setState(() => _frequency = v!)),
                  _dropdown(
                    'Delivery time',
                    _deliveryTime,
                    const ['06:00 AM', '08:00 AM', '18:00 PM'],
                    (v) => setState(() => _deliveryTime = v!),
                  ),
                  _textField('Send to (email)', _emailCtrl),
                  _dropdown('Format', _format, const [
                    'Excel (.xlsx)',
                    'PDF',
                    'CSV',
                  ], (v) => setState(() => _format = v!)),
                  _dropdown(
                    'Department filter',
                    _department,
                    const ['All departments', 'Engineering', 'Finance', 'HR'],
                    (v) => setState(() => _department = v!),
                  ),
                  _dateField(context, 'Start from', '01/06/2026'),
                ]),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => showReportSnack(context, 'Schedule saved.'),
                  child: const Text('Save schedule'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ThemedSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Active scheduled reports',
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: context.primaryText,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '12 active',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF065F46),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingTextStyle: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.muted,
                    ),
                    dataTextStyle: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: context.primaryText,
                    ),
                    columns: const [
                      DataColumn(label: Text('Report name')),
                      DataColumn(label: Text('Module')),
                      DataColumn(label: Text('Frequency')),
                      DataColumn(label: Text('Next run')),
                      DataColumn(label: Text('Recipients')),
                      DataColumn(label: Text('Format')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      _scheduleRow(
                        context,
                        'Monthly payroll summary',
                        ReportModule.payroll,
                        'Monthly',
                        '1 Jun 06:00',
                        'HR Admin, CFO',
                        'Excel',
                      ),
                      _scheduleRow(
                        context,
                        'Attendance summary',
                        ReportModule.attendance,
                        'Weekly',
                        'Tomorrow 08:00',
                        'HR Admin',
                        'PDF',
                      ),
                      _scheduleRow(
                        context,
                        'Leave balance',
                        ReportModule.leave,
                        'Monthly',
                        '1 Jun 06:00',
                        'HR Admin',
                        'Excel',
                      ),
                      _scheduleRow(
                        context,
                        'Headcount report',
                        ReportModule.employee,
                        'Quarterly',
                        '1 Jul 06:00',
                        'CFO',
                        'PDF',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _scheduleRow(
    BuildContext context,
    String name,
    ReportModule module,
    String freq,
    String next,
    String recipients,
    String format,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(name)),
        DataCell(ReportModulePill(module)),
        DataCell(Text(freq)),
        DataCell(Text(next)),
        DataCell(Text(recipients)),
        DataCell(ReportFormatPill(format)),
        const DataCell(ReportStatusPill('Active')),
        DataCell(
          TextButton(
            onPressed: () => showReportSnack(context, 'Edit $name'),
            child: const Text('Edit'),
          ),
        ),
      ],
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
  bool _attendance = true;
  bool _payroll = true;
  String _sortBy = 'Employee no.';
  String _groupBy = 'None';
  String _exportFormat = 'Excel (.xlsx)';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PageHeader(
            title: 'Custom report builder',
            subtitle:
                'Build your own report by selecting modules, fields and filters',
            actions: [
              TextButton(onPressed: () {}, child: const Text('Load saved')),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () =>
                    showReportSnack(context, 'Running custom report…'),
                child: const Text('Run report'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 900;
              final step1 = _builderStep(context, 'Step 1 — Data source', [
                _dropdown(
                  'Primary module',
                  _primaryModule,
                  const ['Employee management', 'Payroll', 'Attendance'],
                  (v) => setState(() => _primaryModule = v!),
                ),
                const SizedBox(height: 12),
                Text(
                  'Combine with (optional)',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: context.secondaryText,
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Attendance data'),
                  value: _attendance,
                  onChanged: (v) => setState(() => _attendance = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Payroll data'),
                  value: _payroll,
                  onChanged: (v) => setState(() => _payroll = v ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Leave data'),
                  value: false,
                  onChanged: null,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ]);
              final step2 = _builderStep(context, 'Step 2 — Select fields', [
                _fieldGroup(context, 'Employee fields', const [
                  ('Employee no.', true),
                  ('Full name', true),
                  ('Department', true),
                  ('Position', true),
                  ('Job grade', false),
                ]),
                _fieldGroup(context, 'Payroll fields', const [
                  ('Basic salary', true),
                  ('Net pay', true),
                  ('Total deductions', false),
                ]),
                _fieldGroup(context, 'Attendance fields', const [
                  ('Work days', true),
                  ('Present days', true),
                  ('OT hours', false),
                ]),
              ]);
              final step3 = _builderStep(
                context,
                'Step 3 — Filters & date range',
                [
                  Row(
                    children: [
                      Expanded(
                        child: _dateField(context, 'Date from', '01/01/2026'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dateField(context, 'Date to', '31/05/2026'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _dropdown('Department', 'All departments', const [
                    'All departments',
                    'Engineering',
                    'Finance',
                  ], (_) {}),
                  const SizedBox(height: 8),
                  _dropdown('Branch / location', 'All branches', const [
                    'All branches',
                  ], (_) {}),
                  const SizedBox(height: 8),
                  _dropdown('Employment status', 'Active only', const [
                    'Active only',
                    'All',
                  ], (_) {}),
                ],
              );
              final step4 = _builderStep(context, 'Step 4 — Output settings', [
                Row(
                  children: [
                    Expanded(
                      child: _dropdown('Sort by', _sortBy, const [
                        'Employee no.',
                        'Department',
                        'Name',
                      ], (v) => setState(() => _sortBy = v!)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _dropdown('Group by', _groupBy, const [
                        'None',
                        'Department',
                      ], (v) => setState(() => _groupBy = v!)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _dropdown(
                  'Export format',
                  _exportFormat,
                  const ['Excel (.xlsx)', 'PDF', 'CSV'],
                  (v) => setState(() => _exportFormat = v!),
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Report name',
                    hintText: 'e.g. Employee payroll + attendance May 2026',
                  ),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Save as custom template'),
                  value: false,
                  onChanged: null,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Schedule this report'),
                  value: false,
                  onChanged: null,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ]);
              if (wide) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: step1),
                        const SizedBox(width: 16),
                        Expanded(child: step2),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: step3),
                        const SizedBox(width: 16),
                        Expanded(child: step4),
                      ],
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  step1,
                  const SizedBox(height: 16),
                  step2,
                  const SizedBox(height: 16),
                  step3,
                  const SizedBox(height: 16),
                  step4,
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () {}, child: const Text('Preview')),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => showReportSnack(context, 'Export started.'),
                child: const Text('Run & export'),
              ),
              const SizedBox(width: 16),
              Text(
                'Saved custom reports',
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '7 saved',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _builderStep(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: context.primaryText,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _fieldGroup(
    BuildContext context,
    String title,
    List<(String, bool)> fields,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          for (final (label, checked) in fields)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(label, style: const TextStyle(fontSize: 13)),
              value: checked,
              onChanged: (_) {},
              controlAffinity: ListTileControlAffinity.leading,
            ),
        ],
      ),
    );
  }
}

// --- Module template ---

Widget _modulePanel(
  BuildContext context, {
  required String title,
  required String subtitle,
  required String snapshotTitle,
  required List<(String, String)> reports,
  required Widget snapshot,
}) {
  void run(String name) => showReportSnack(context, 'Running $name…');
  void pdf(String name) => showReportSnack(context, 'Exporting $name as PDF…');

  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PageHeader(
          title: title,
          subtitle: subtitle,
          actions: [
            OutlinedButton(onPressed: () {}, child: const Text('Schedule')),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () => showReportSnack(context, 'Generate report'),
              child: const Text('Generate report'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 800;
            final listCard = ThemedSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ReportSectionTitle('Available reports'),
                  for (var i = 0; i < reports.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: context.borderColor),
                    ReportListTile(
                      title: reports[i].$1,
                      subtitle: reports[i].$2,
                      onRun: () => run(reports[i].$1),
                      onPdf: () => pdf(reports[i].$1),
                    ),
                  ],
                ],
              ),
            );
            final snapCard = ThemedSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    snapshotTitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: context.primaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  snapshot,
                ],
              ),
            );
            if (wide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: listCard),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: snapCard),
                ],
              );
            }
            return Column(
              children: [listCard, const SizedBox(height: 16), snapCard],
            );
          },
        ),
      ],
    ),
  );
}

// --- Snapshots ---

Widget _employeeSnapshot(BuildContext context) {
  return Column(
    children: [
      const ReportSnapshotRow(label: 'Total employees', value: '1,284'),
      const ReportSnapshotRow(
        label: 'Active',
        value: '1,201',
        valueColor: Color(0xFF059669),
      ),
      const ReportSnapshotRow(
        label: 'On probation',
        value: '48',
        valueColor: Color(0xFFD97706),
      ),
      const ReportSnapshotRow(
        label: 'New joiners this month',
        value: '12',
        valueColor: AppColors.primary,
      ),
      const ReportSnapshotRow(
        label: 'Resigned this month',
        value: '4',
        valueColor: AppColors.danger,
      ),
      const ReportSnapshotRow(label: 'Contracts expiring 30d', value: '7'),
      const ReportSnapshotRow(label: 'Turnover rate YTD', value: '3.2%'),
      const SizedBox(height: 12),
      _headcountBar(context, 'Engineering', 342, AppColors.primary),
      _headcountBar(context, 'Operations', 261, const Color(0xFF0D9488)),
      _headcountBar(context, 'Finance', 180, const Color(0xFF7C3AED)),
      _headcountBar(context, 'Marketing', 142, const Color(0xFFD97706)),
      _headcountBar(context, 'HR', 88, const Color(0xFFDB2777)),
    ],
  );
}

Widget _attendanceSnapshot(BuildContext context) {
  return Column(
    children: const [
      ReportSnapshotRow(
        label: 'Avg. attendance rate',
        value: '93.2%',
        valueColor: Color(0xFF059669),
      ),
      ReportSnapshotRow(label: 'Total OT hours (month)', value: '1,248h'),
      ReportSnapshotRow(
        label: 'Missing swipes (unresolved)',
        value: '7',
        valueColor: AppColors.danger,
      ),
      ReportSnapshotRow(
        label: 'Employees with 3+ lates',
        value: '18',
        valueColor: AppColors.danger,
      ),
      ReportSnapshotRow(
        label: 'Absent (no-show) today',
        value: '23',
        valueColor: AppColors.danger,
      ),
      SizedBox(height: 12),
      ReportDeptBar(label: 'Engineering', pct: 94, color: AppColors.primary),
      ReportDeptBar(label: 'Finance', pct: 96, color: Color(0xFF059669)),
      ReportDeptBar(label: 'HR', pct: 89, color: Color(0xFF7C3AED)),
      ReportDeptBar(label: 'Operations', pct: 91, color: Color(0xFFD97706)),
    ],
  );
}

Widget _leaveSnapshot(BuildContext context) {
  return const Column(
    children: [
      ReportSnapshotRow(label: 'Total leave days taken', value: '4,821 days'),
      ReportSnapshotRow(
        label: 'Annual leave utilisation',
        value: '64%',
        valueColor: AppColors.primary,
      ),
      ReportSnapshotRow(label: 'Medical leave days', value: '1,244 days'),
      ReportSnapshotRow(
        label: 'Pending approval',
        value: '6',
        valueColor: AppColors.danger,
      ),
      ReportSnapshotRow(
        label: 'Employees with 0 leave taken',
        value: '42',
        valueColor: AppColors.danger,
      ),
      ReportSnapshotRow(label: 'Unpaid leave days', value: '18 days'),
    ],
  );
}

Widget _payrollSnapshot(BuildContext context) {
  return Column(
    children: [
      const ReportSnapshotRow(
        label: 'Total gross payroll',
        value: 'MYR 4,820,000',
        valueColor: AppColors.primary,
      ),
      const ReportSnapshotRow(
        label: 'Total deductions',
        value: 'MYR 842,000',
        valueColor: AppColors.danger,
      ),
      const ReportSnapshotRow(
        label: 'Total net payroll',
        value: 'MYR 3,978,000',
        valueColor: Color(0xFF059669),
      ),
      const ReportSnapshotRow(
        label: 'EPF employer total',
        value: 'MYR 578,400',
      ),
      const ReportSnapshotRow(label: 'SOCSO total', value: 'MYR 24,100'),
      const ReportSnapshotRow(
        label: 'PCB / income tax total',
        value: 'MYR 239,500',
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Text(
            'Payroll status',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: context.secondaryText,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Pending confirmation',
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFFC2410C),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _performanceSnapshot(BuildContext context) {
  return const Column(
    children: [
      ReportGradeBar(
        label: 'Grade A — Excellent',
        count: 186,
        color: AppColors.primary,
        max: 542,
      ),
      ReportGradeBar(
        label: 'Grade B — Good',
        count: 542,
        color: Color(0xFF059669),
        max: 542,
      ),
      ReportGradeBar(
        label: 'Grade C — Satisfactory',
        count: 398,
        color: Color(0xFFD97706),
        max: 542,
      ),
      ReportGradeBar(
        label: 'Grade D — Needs impr.',
        count: 158,
        color: AppColors.danger,
        max: 542,
      ),
    ],
  );
}

Widget _trainingSnapshot(BuildContext context) {
  return const Column(
    children: [
      ReportSnapshotRow(label: 'Total sessions', value: '48'),
      ReportSnapshotRow(
        label: 'Employees trained',
        value: '312',
        valueColor: Color(0xFF059669),
      ),
      ReportSnapshotRow(
        label: 'Completion rate',
        value: '87%',
        valueColor: AppColors.primary,
      ),
      ReportSnapshotRow(label: 'Total training cost', value: 'MYR 48,200'),
      ReportSnapshotRow(
        label: 'Mandatory training overdue',
        value: '14 employees',
        valueColor: AppColors.danger,
      ),
    ],
  );
}

Widget _claimsSnapshot(BuildContext context) {
  return const Column(
    children: [
      ReportSnapshotRow(
        label: 'Total claimed',
        value: 'MYR 14,820',
        valueColor: AppColors.primary,
      ),
      ReportSnapshotRow(
        label: 'Approved & pushed',
        value: 'MYR 9,340',
        valueColor: Color(0xFF059669),
      ),
      ReportSnapshotRow(
        label: 'Pending approval',
        value: 'MYR 5,480',
        valueColor: Color(0xFFD97706),
      ),
      ReportSnapshotRow(
        label: 'Policy flags this month',
        value: '8 flags',
        valueColor: AppColors.danger,
      ),
      ReportSnapshotRow(label: 'Rejected claims value', value: 'MYR 1,240'),
    ],
  );
}

Widget _recruitmentSnapshot(BuildContext context) {
  return const Column(
    children: [
      ReportSnapshotRow(
        label: 'Open requisitions',
        value: '12',
        valueColor: AppColors.primary,
      ),
      ReportSnapshotRow(
        label: 'Filled this quarter',
        value: '5',
        valueColor: Color(0xFF059669),
      ),
      ReportSnapshotRow(label: 'Avg. time to hire', value: '28 days'),
      ReportSnapshotRow(
        label: 'Offer acceptance rate',
        value: '82%',
        valueColor: Color(0xFF059669),
      ),
      ReportSnapshotRow(
        label: 'Total recruitment cost',
        value: 'MYR 8,400',
        bold: true,
      ),
    ],
  );
}

Widget _assetSnapshot(BuildContext context) {
  return const Column(
    children: [
      ReportSnapshotRow(label: 'Total assets', value: '1,847'),
      ReportSnapshotRow(
        label: 'Total acquisition cost',
        value: 'MYR 4.2M',
        valueColor: AppColors.primary,
      ),
      ReportSnapshotRow(
        label: 'Current book value',
        value: 'MYR 2.8M',
        valueColor: Color(0xFF059669),
      ),
      ReportSnapshotRow(label: 'Maintenance cost YTD', value: 'MYR 38,400'),
      ReportSnapshotRow(
        label: 'Assets disposed YTD',
        value: '23',
        valueColor: AppColors.danger,
      ),
      ReportSnapshotRow(
        label: 'Net disposal gain/loss',
        value: '-MYR 1,830',
        valueColor: AppColors.danger,
      ),
    ],
  );
}

Widget _disciplinarySnapshot(BuildContext context) {
  return const Column(
    children: [
      ReportSnapshotRow(label: 'Total cases opened', value: '14'),
      ReportSnapshotRow(
        label: 'Open / pending',
        value: '3',
        valueColor: Color(0xFFD97706),
      ),
      ReportSnapshotRow(
        label: 'Acknowledged',
        value: '6',
        valueColor: Color(0xFF059669),
      ),
      ReportSnapshotRow(label: 'Closed', value: '5'),
      ReportSnapshotRow(
        label: 'Most common offence',
        value: 'Unauthorised absence',
      ),
      ReportSnapshotRow(label: 'Most warnings dept', value: 'Operations'),
      ReportSnapshotRow(
        label: 'Repeat offenders',
        value: '2 employees',
        valueColor: AppColors.danger,
      ),
    ],
  );
}

// --- Shared form helpers ---

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.sora(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: context.primaryText,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: context.secondaryText,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        ...actions,
      ],
    );
  }
}

Widget _formGrid(BuildContext context, List<Widget> children) {
  return LayoutBuilder(
    builder: (context, c) {
      final cols = c.maxWidth >= 700 ? 2 : 1;
      return Wrap(
        spacing: 16,
        runSpacing: 12,
        children: children
            .map(
              (w) => SizedBox(
                width: cols == 2 ? (c.maxWidth - 16) / 2 : c.maxWidth,
                child: w,
              ),
            )
            .toList(),
      );
    },
  );
}

Widget _headcountBar(
  BuildContext context,
  String label,
  int count,
  Color color,
) {
  const max = 342;
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: context.secondaryText,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: count / max,
              minHeight: 8,
              backgroundColor: context.subtleFill,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$count',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.primaryText,
          ),
        ),
      ],
    ),
  );
}

Widget _dropdown(
  String label,
  String value,
  List<String> items,
  ValueChanged<String?> onChanged,
) {
  return DropdownButtonFormField<String>(
    initialValue: value,
    decoration: InputDecoration(labelText: label, isDense: true),
    items: items
        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList(),
    onChanged: onChanged,
  );
}

Widget _textField(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(labelText: label, isDense: true),
  );
}

Widget _dateField(BuildContext context, String label, String hint) {
  return TextField(
    readOnly: true,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      isDense: true,
      suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
    ),
    onTap: () => showReportSnack(context, 'Date picker — $label'),
  );
}
