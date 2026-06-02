import 'dart:math' show max;

import 'package:flutter/material.dart';
import '../../../shared/widgets/module_shell_background.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/hr_full_width_data_table.dart';
import '../../../shared/widgets/hr_module_header.dart';
import '../../../shared/widgets/hr_pill_segmented_control.dart';
import '../widgets/my_check_in_tab.dart';

/// Time & Attendance — mock-aligned tabs (Duty roster through Report).
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 9, vsync: this);

  String _rosterGranularity = 'week';
  final Set<int> _unknownSelected = {};
  final Map<String, String> _attendanceFilterDd = {};
  final Map<int, String> _unknownAssignShift = {};
  bool _reportDetail = true;

  static const int _unknownSwipeRowCount = 5;

  bool? get _unknownSelectAllValue {
    if (_unknownSelected.isEmpty) return false;
    if (_unknownSelected.length == _unknownSwipeRowCount) return true;
    return null;
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HrModuleHeader(
          moduleSubtitle: 'TIME & ATTENDANCE',
          showPeriodFilter: true,
          showMoreMenu: true,
        ),
        Material(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            controller: _tab,
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            tabs: [
              const Tab(text: 'Check-in'),
              const Tab(text: 'Duty roster'),
              const Tab(text: 'Timesheet'),
              const Tab(text: 'Shift pattern'),
              const Tab(text: 'Roll call'),
              const Tab(text: 'Manual punch'),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Unknown swipes', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.errorSurface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '7',
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Tab(text: 'Overtime'),
              const Tab(text: 'Report'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const MyCheckInTab(),
              _dutyRosterTab(),
              _timesheetTab(),
              _shiftPatternTab(),
              _rollCallTab(),
              const _ManualPunchTab(),
              _unknownSwipesTab(),
              _overtimeTab(),
              _reportTab(),
            ],
          ),
        ),
      ],
    );

    if (widget.embeddedInShell) {
      return ModuleShellBackground(child: body);
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Attendance', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: body,
    );
  }

  void _toast(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Widget _dutyRosterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _whiteCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Week: 5 – 11 May 2026',
                        style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.navy),
                      ),
                      OutlinedButton(onPressed: () => _toast('Previous week'), child: const Text('< Prev')),
                      OutlinedButton(onPressed: () => _toast('Next week'), child: const Text('Next >')),
                      HrPillSegmentedControl(
                        segments: const [
                          HrPillSegment(value: 'week', label: 'Week'),
                          HrPillSegment(value: 'day', label: 'Day'),
                          HrPillSegment(value: 'month', label: 'Month'),
                        ],
                        selected: _rosterGranularity,
                        onChanged: (v) => setState(() => _rosterGranularity = v),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _toast('Import data'),
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
                  label: const Text('Import data'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LayoutBuilder(
                  builder: (context, c) {
                    const minTable = 1120.0;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minWidth: max(minTable, c.maxWidth)),
                        child: const _RosterTable(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: _legendRow(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timesheetTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _whiteCard(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _filterDropdown('ts_shift', 'Single shift', const ['Single shift', 'Split shift']),
                    _filterDropdown('ts_dept', 'All departments', const ['All departments', 'HR', 'Engineering']),
                    _filterDropdown('ts_pattern', 'Standard 9–6', const ['Standard 9–6', 'Night shift']),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(onPressed: () => _toast('Copy timesheet'), child: const Text('Copy timesheet')),
                    OutlinedButton.icon(
                      onPressed: () => _toast('Create timesheet'),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Create timesheet'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: LayoutBuilder(
              builder: (context, c) {
                final table = DataTable(
                  headingRowColor: WidgetStateProperty.all(AppColors.bg),
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 72,
                  horizontalMargin: 12,
                  columns: const [
                    DataColumn(label: Text('Employee')),
                    DataColumn(label: Text('Department')),
                    DataColumn(label: Text('Shift')),
                    DataColumn(label: Text('Date from')),
                    DataColumn(label: Text('Date to')),
                    DataColumn(label: Text('Days')),
                    DataColumn(label: Text('On duty days')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('')),
                  ],
                  rows: [
                    _timesheetRow(
                      initials: 'SL',
                      name: 'Sarah Lim',
                      dept: 'Engineering',
                      shift: 'Standard',
                      fromTo: ('1 May', '31 May'),
                      days: '22',
                      duty: 'Mon–Fri',
                      status: 'Active',
                      statusBg: const Color(0xFFD1FAE5),
                      statusFg: const Color(0xFF065F46),
                    ),
                    _timesheetRow(
                      initials: 'RK',
                      name: 'Raj Kumar',
                      dept: 'Engineering',
                      shift: 'Std + OT',
                      fromTo: ('1 May', '31 May'),
                      days: '22',
                      duty: 'Mon–Fri',
                      status: 'Active',
                      statusBg: const Color(0xFFD1FAE5),
                      statusFg: const Color(0xFF065F46),
                    ),
                    _timesheetRow(
                      initials: 'MT',
                      name: 'Maya Tan',
                      dept: 'HR',
                      shift: 'Standard',
                      fromTo: ('1 May', '31 May'),
                      days: '22',
                      duty: 'Mon–Fri',
                      status: 'On leave',
                      statusBg: const Color(0xFFFEF3C7),
                      statusFg: const Color(0xFF92400E),
                    ),
                    _timesheetRow(
                      initials: 'AL',
                      name: 'Ahmad Luqman',
                      dept: 'Operations',
                      shift: 'Night shift',
                      fromTo: ('1 May', '31 May'),
                      days: '22',
                      duty: 'Mon–Fri',
                      status: 'Active',
                      statusBg: const Color(0xFFD1FAE5),
                      statusFg: const Color(0xFF065F46),
                    ),
                    _timesheetRow(
                      initials: 'ZN',
                      name: 'Zara Nor',
                      dept: 'Marketing',
                      shift: 'Standard',
                      fromTo: ('1 May', '31 May'),
                      days: '22',
                      duty: 'Mon–Fri',
                      status: 'Active',
                      statusBg: const Color(0xFFD1FAE5),
                      statusFg: const Color(0xFF065F46),
                    ),
                  ],
                );
                if (c.maxWidth < 1100) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: c.maxWidth),
                      child: table,
                    ),
                  );
                }
                return table;
              },
            ),
          ),
        ],
      ),
    );
  }

  DataRow _timesheetRow({
    required String initials,
    required String name,
    required String dept,
    required String shift,
    required (String, String) fromTo,
    required String days,
    required String duty,
    required String status,
    required Color statusBg,
    required Color statusFg,
  }) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Text(initials, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 10),
              Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        DataCell(Text(dept, style: GoogleFonts.dmSans(fontSize: 13))),
        DataCell(Text(shift, style: GoogleFonts.dmSans(fontSize: 13))),
        DataCell(Text(fromTo.$1, style: GoogleFonts.dmSans(fontSize: 13))),
        DataCell(Text(fromTo.$2, style: GoogleFonts.dmSans(fontSize: 13))),
        DataCell(Text(days, style: GoogleFonts.dmSans(fontSize: 13))),
        DataCell(Text(duty, style: GoogleFonts.dmSans(fontSize: 13))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
            child: Text(status, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: statusFg)),
          ),
        ),
        DataCell(OutlinedButton(onPressed: () => _toast('Edit $name'), child: const Text('Edit'))),
      ],
    );
  }

  Widget _shiftPatternTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Shift patterns defined:', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('4 patterns', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
              Spacer(),
              OutlinedButton.icon(
                onPressed: () => _toast('New shift pattern'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New shift pattern'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final cross = c.maxWidth >= 900 ? 2 : 1;
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: cross,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: cross == 2 ? 1.15 : 1.05,
                children: [
                  _shiftCard(
                    title: 'Standard shift',
                    activeColor: const Color(0xFF059669),
                    rows: const [
                      ('Work hours', '09:00 – 18:00'),
                      ('Break time', '1h · 12:30–13:30'),
                      ('Nearest time (in)', '08:30 – 09:15'),
                      ('Nearest time (out)', '17:45 – 18:30'),
                      ('Allow in OT', '30 min'),
                      ('Allow out OT', '60 min'),
                      ('Night shift', 'No'),
                    ],
                    assign: '892 employees',
                  ),
                  _shiftCard(
                    title: 'Night shift',
                    activeColor: const Color(0xFF7C3AED),
                    rows: const [
                      ('Work hours', '22:00 – 07:00'),
                      ('Break time', '1h · 03:00–04:00'),
                      ('Nearest time (in)', '21:30 – 22:15'),
                      ('Nearest time (out)', '06:45 – 07:30'),
                      ('Allow in OT', '30 min'),
                      ('Allow out OT', '60 min'),
                      ('Night shift', 'Yes'),
                    ],
                    assign: '124 employees',
                    highlightNight: true,
                  ),
                  _shiftCard(
                    title: 'Split shift',
                    activeColor: const Color(0xFFEA580C),
                    rows: const [
                      ('Work hours', '08:00–13:00 / 14:00–18:00'),
                      ('Break time', '1h between blocks'),
                      ('Nearest time (in)', 'Per block'),
                      ('Nearest time (out)', 'Per block'),
                      ('Allow in OT', '15 min'),
                      ('Allow out OT', '30 min'),
                      ('Night shift', 'No'),
                    ],
                    assign: '68 employees',
                  ),
                  _shiftCard(
                    title: 'Half day (AM)',
                    activeColor: const Color(0xFF059669),
                    rows: const [
                      ('Work hours', '09:00 – 13:00'),
                      ('Break time', 'No break'),
                      ('Nearest time (in)', '08:30 – 09:15'),
                      ('Nearest time (out)', '12:45 – 13:15'),
                      ('Allow in OT', '—'),
                      ('Allow out OT', '—'),
                      ('Night shift', 'No'),
                    ],
                    assign: 'Fri only',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _shiftCard({
    required String title,
    required Color activeColor,
    required List<(String, String)> rows,
    required String assign,
    bool highlightNight = false,
  }) {
    return Container(
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
              Expanded(child: Text(title, style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: activeColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                child: Text('Active', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: activeColor)),
              ),
            ],
          ),
          const Divider(height: 20),
          ...rows.map((r) {
            final isNightRow = r.$1 == 'Night shift' && highlightNight && r.$2 == 'Yes';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(r.$1, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
                  ),
                  Expanded(
                    child: Text(
                      r.$2,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isNightRow ? AppColors.success : AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _toast('Assigned: $assign'),
              child: Text(assign, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rollCallTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _whiteCard(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    _filterDropdown('rc_date', '06/05/2026', const ['06/05/2026', '07/05/2026']),
                    _filterDropdown('rc_dept', 'All departments', const ['All departments', 'HR']),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _summaryPill('Present', '1,148', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                    _summaryPill('Absent', '23', AppColors.errorSurface, AppColors.danger),
                    _summaryPill('On leave', '47', const Color(0xFFFEF3C7), const Color(0xFF92400E)),
                    OutlinedButton(onPressed: () => _toast('Export roll call'), child: const Text('Export roll call')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: LayoutBuilder(
              builder: (context, c) {
                final table = DataTable(
                  headingRowColor: WidgetStateProperty.all(AppColors.bg),
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 72,
                  horizontalMargin: 12,
                  columns: const [
                    DataColumn(label: Text('Employee')),
                    DataColumn(label: Text('Department')),
                    DataColumn(label: Text('Shift')),
                    DataColumn(label: Text('Clock in')),
                    DataColumn(label: Text('Clock out')),
                    DataColumn(label: Text('Work hrs')),
                    DataColumn(label: Text('In office?')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: [
                    _rollRow('SL', 'Sarah Lim', 'Engineering', 'Standard', '08:58', '—', '—', 'Yes', true, 'In office', const Color(0xFFDBEAFE), const Color(0xFF1E40AF)),
                    _rollRow('NC', 'Nadia Chen', 'Marketing', 'Standard', '08:54', '17:12', '8h 18m', 'No', false, 'Completed', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                    _rollRow('AL', 'Ahmad L', 'Operations', 'Standard', '09:28', '—', '—', 'Yes', true, 'Late', const Color(0xFFEDE9FE), const Color(0xFF5B21B6)),
                    _rollRow('ZN', 'Zara Nor', 'Operations', 'Standard', '—', '—', '—', '—', false, 'Absent', AppColors.errorSurface, AppColors.danger),
                  ],
                );
                if (c.maxWidth < 960) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: c.maxWidth),
                      child: table,
                    ),
                  );
                }
                return table;
              },
            ),
          ),
        ],
      ),
    );
  }

  DataRow _rollRow(
    String initials,
    String name,
    String dept,
    String shift,
    String inT,
    String outT,
    String hrs,
    String office,
    bool officeYes,
    String status,
    Color statusBg,
    Color statusFg,
  ) {
    Widget officeCell;
    if (office == '—') {
      officeCell = Text('—', style: GoogleFonts.dmSans(color: AppColors.muted));
    } else {
      officeCell = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: officeYes ? const Color(0xFFD1FAE5) : AppColors.bg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          office,
          style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: officeYes ? const Color(0xFF065F46) : AppColors.textMuted),
        ),
      );
    }
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.brandBlueSoft,
                child: Text(initials, style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.navy)),
              ),
              const SizedBox(width: 8),
              Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        DataCell(Text(dept, style: GoogleFonts.dmSans(fontSize: 13))),
        DataCell(Text(shift)),
        DataCell(Text(inT)),
        DataCell(Text(outT)),
        DataCell(Text(hrs)),
        DataCell(officeCell),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: statusFg)),
          ),
        ),
      ],
    );
  }

  Widget _unknownSwipesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _whiteCard(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    _filterDropdown('unk_dept', 'All departments', const ['All departments', 'HR']),
                    _filterDropdown('unk_date', '06/05/2026', const ['06/05/2026', '05/05/2026']),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    FilledButton.tonal(onPressed: () => _toast('Resolve selected'), child: const Text('Resolve selected')),
                    FilledButton.tonal(onPressed: () => _toast('Resolve all'), child: const Text('Resolve all')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: LayoutBuilder(
              builder: (context, c) {
                final table = DataTable(
                  headingRowColor: WidgetStateProperty.all(AppColors.bg),
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 72,
                  horizontalMargin: 8,
                  columns: [
                    DataColumn(
                      label: Checkbox(
                        value: _unknownSelectAllValue,
                        tristate: true,
                        onChanged: (v) {
                          setState(() {
                            _unknownSelected.clear();
                            if (v == true) {
                              for (var i = 0; i < _unknownSwipeRowCount; i++) {
                                _unknownSelected.add(i);
                              }
                            }
                          });
                        },
                      ),
                    ),
                    const DataColumn(label: Text('TA number')),
                    const DataColumn(label: Text('Employee')),
                    const DataColumn(label: Text('Swipe time')),
                    const DataColumn(label: Text('Terminal')),
                    const DataColumn(label: Text('Issue')),
                    const DataColumn(label: Text('Assign to shift')),
                    const DataColumn(label: Text('Actions')),
                  ],
                  rows: [
                    _unknownRow(0, 'TA-00451', 'SL', 'Sarah Lim', '07:44 AM', 'Main lobby', 'Outside nearest', const Color(0xFFFEF3C7), const Color(0xFF92400E)),
                    _unknownRow(1, 'Unknown', '—', '—', '08:12 AM', 'Level 3', 'No TA match', AppColors.errorSurface, AppColors.danger),
                    _unknownRow(2, 'TA-00452', 'AL', 'Ahmad Luqman', '08:05 AM', 'Main lobby', 'Multi swipe', const Color(0xFFFEF3C7), const Color(0xFF92400E)),
                    _unknownRow(3, 'TA-00389', 'NC', 'Nadia Chen', '07:58 AM', 'Car park', 'Outside nearest', const Color(0xFFFEF3C7), const Color(0xFF92400E)),
                    _unknownRow(4, 'TA-00412', 'RK', 'Raj Kumar', '06:50 AM', 'Main lobby', 'No TA match', AppColors.errorSurface, AppColors.danger),
                  ],
                );
                if (c.maxWidth < 1000) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: c.maxWidth),
                      child: table,
                    ),
                  );
                }
                return table;
              },
            ),
          ),
        ],
      ),
    );
  }

  DataRow _unknownRow(
    int id,
    String ta,
    String initials,
    String name,
    String time,
    String terminal,
    String issue,
    Color issueBg,
    Color issueFg,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Checkbox(
            value: _unknownSelected.contains(id),
            onChanged: (v) {
              setState(() {
                if (v == true) {
                  _unknownSelected.add(id);
                } else {
                  _unknownSelected.remove(id);
                }
              });
            },
          ),
        ),
        DataCell(Text(ta, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.danger))),
        DataCell(
          name == '—'
              ? Text('—', style: GoogleFonts.dmSans(color: AppColors.muted))
              : Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.bg,
                      child: Text(initials, style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 8),
                    Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                  ],
                ),
        ),
        DataCell(Text(time)),
        DataCell(Text(terminal)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: issueBg, borderRadius: BorderRadius.circular(8)),
            child: Text(issue, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: issueFg)),
          ),
        ),
        DataCell(
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _unknownAssignValue(id),
              icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
              items: const [
                DropdownMenuItem(value: '-- Assign', child: Text('-- Assign')),
                DropdownMenuItem(value: 'std', child: Text('Standard')),
                DropdownMenuItem(value: 'night', child: Text('Night')),
              ],
              onChanged: (nv) {
                if (nv != null) {
                  setState(() => _unknownAssignShift[id] = nv);
                }
              },
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(onPressed: () => _toast('Saved'), child: const Text('Save')),
              IconButton(onPressed: () => _toast('More'), icon: const Icon(Icons.more_vert, size: 20)),
            ],
          ),
        ),
      ],
    );
  }

  static const _unknownAssignChoices = ['-- Assign', 'std', 'night'];

  String _unknownAssignValue(int id) {
    final v = _unknownAssignShift[id];
    if (v != null && _unknownAssignChoices.contains(v)) return v;
    return '-- Assign';
  }

  Widget _overtimeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _whiteCard(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    _filterDropdown('ot_dept', 'All departments', const ['All departments', 'HR']),
                    _filterDropdown('ot_date', '06/05/2026', const ['06/05/2026', '05/05/2026']),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(onPressed: () => _toast('OT policy settings'), child: const Text('OT policy settings')),
                    OutlinedButton.icon(
                      onPressed: () => _toast('Add OT setup'),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add OT setup'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final narrow = c.maxWidth < 960;
              final policy = _otPolicyCard();
              final records = _whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Specific overtime records', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(AppColors.bg),
                        dataRowMinHeight: 48,
                        dataRowMaxHeight: 64,
                        columns: const [
                          DataColumn(label: Text('Employee')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('OT start')),
                          DataColumn(label: Text('OT end')),
                          DataColumn(label: Text('Hours')),
                        ],
                        rows: [
                          _otRow('RK', 'Raj K', '6 May', '18:00', '20:00', '2h'),
                          _otRow('SL', 'Sarah L', '5 May', '18:00', '19:30', '1.5h'),
                          _otRow('NC', 'Nadia C', '4 May', '18:30', '20:00', '1.5h'),
                          _otRow('ZN', 'Zara N', '3 May', '22:00', '23:30', '1.5h'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    records,
                    const SizedBox(height: 16),
                    policy,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: records),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: policy),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  DataRow _otRow(String initials, String name, String d, String s, String e, String h) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: const Color(0xFFD1FAE5), child: Text(initials, style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w800))),
              const SizedBox(width: 8),
              Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        DataCell(Text(d)),
        DataCell(Text(s)),
        DataCell(Text(e)),
        DataCell(Text(h)),
      ],
    );
  }

  Widget _otPolicyCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('OT policy — current settings', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700))),
              OutlinedButton(onPressed: () => _toast('Edit policy'), child: const Text('Edit')),
            ],
          ),
          const Divider(height: 20),
          _policyKv('Allow in OT (pre-shift)', '60 mins'),
          _policyKv('Allow out OT (post-shift)', '60 mins'),
          _policyKv('OT rounding block', '30 min'),
          _policyKv('Min OT threshold', '30 mins'),
          _policyKv('Weekday OT rate', '1.0x'),
          _policyKv('Weekend OT rate', '1.5x'),
          _policyKv('Public holiday OT', '2.0x'),
          _policyKvRich('Shift allowance on OT', 'Yes', AppColors.success),
          _policyKvRich('Supper allowance on OT', 'Yes', AppColors.success),
        ],
      ),
    );
  }

  Widget _policyKv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(k, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted))),
          Text(v, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _policyKvRich(String k, String v, Color vColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(k, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted))),
          Text(v, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700, color: vColor)),
        ],
      ),
    );
  }

  Widget _reportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _whiteCard(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                HrPillSegmentedControl(
                  width: 368,
                  segments: const [
                    HrPillSegment(value: 'detail', label: 'Detail report'),
                    HrPillSegment(value: 'summary', label: 'Summary report'),
                  ],
                  selected: _reportDetail ? 'detail' : 'summary',
                  onChanged: (v) =>
                      setState(() => _reportDetail = v == 'detail'),
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    _filterDropdown('rep_month', 'May 2026', const ['Apr 2026', 'May 2026']),
                    _filterDropdown('rep_dept', 'All departments', const ['All departments', 'HR']),
                    _filterDropdown('rep_emp', 'All employees', const ['All employees', 'Direct reports']),
                    FilledButton.tonal(onPressed: () => _toast('Export report'), child: const Text('Export')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: HrFullWidthDataTable(
              headingRowColor: AppColors.bg,
              columnSpecs: const [
                ('Employee', 2.2),
                ('Date', 1.0),
                ('Shift', 1.1),
                ('Clock in', 1.0),
                ('Clock out', 1.0),
                ('Work hrs', 1.0),
                ('Late', 0.85),
                ('OT hrs', 0.85),
                ('Status', 1.1),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(_avatarName('SL', 'Sarah L')),
                    const DataCell(Text('5 May')),
                    const DataCell(Text('Standard')),
                    const DataCell(Text('08:58')),
                    const DataCell(Text('18:05')),
                    const DataCell(Text('9h 7m')),
                    const DataCell(Text('—')),
                    DataCell(Text('1h 5m', style: GoogleFonts.dmSans(color: AppColors.primary, fontWeight: FontWeight.w600))),
                    DataCell(_statusPill('Complete', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(_avatarName('AL', 'Ahmad L')),
                    const DataCell(Text('5 May')),
                    const DataCell(Text('Standard')),
                    const DataCell(Text('09:28')),
                    const DataCell(Text('18:30')),
                    const DataCell(Text('9h 2m')),
                    DataCell(Text('28m', style: GoogleFonts.dmSans(color: AppColors.danger, fontWeight: FontWeight.w600))),
                    const DataCell(Text('—')),
                    DataCell(_statusPill('Late', const Color(0xFFEDE9FE), const Color(0xFF5B21B6))),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(_avatarName('ZN', 'Zara N')),
                    const DataCell(Text('5 May')),
                    const DataCell(Text('Standard')),
                    const DataCell(Text('—')),
                    const DataCell(Text('—')),
                    const DataCell(Text('—')),
                    const DataCell(Text('—')),
                    const DataCell(Text('—')),
                    DataCell(_statusPill('Absent', AppColors.errorSurface, AppColors.danger)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarName(String i, String n) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: Text(i, style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w800)),
        ),
        const SizedBox(width: 8),
        Text(n, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _statusPill(String t, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(t, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

  Widget _filterDropdown(String id, String initial, List<String> items) {
    String resolved() {
      final s = _attendanceFilterDd[id];
      if (s != null && items.contains(s)) return s;
      return items.contains(initial) ? initial : items.first;
    }

    final safe = items.contains(resolved()) ? resolved() : items.first;
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.bg,
        ),
        child: DropdownButton<String>(
          value: safe,
          icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (nv) {
            if (nv != null) setState(() => _attendanceFilterDd[id] = nv);
          },
        ),
      ),
    );
  }

  Widget _summaryPill(String label, String value, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: GoogleFonts.dmSans(fontSize: 12, color: fg.withValues(alpha: 0.85))),
          Text(value, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w800, color: fg)),
        ],
      ),
    );
  }

  Widget _legendRow() {
    Widget item(String label, Color swatch, {Color? border}) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: swatch,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: border ?? AppColors.border, width: 1),
            ),
          ),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted)),
        ],
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        item('Completed', const Color(0xFFD1FAE5)),
        item('Clock in', const Color(0xFFDBEAFE)),
        item('Planned', AppColors.bg, border: AppColors.border),
        item('Off', const Color(0xFFE2E8F0)),
        item('On leave', const Color(0xFFFEF3C7)),
        item('Overtime', const Color(0xFFFCE7F3)),
        item('Night shift', const Color(0xFFEDE9FE)),
        item('Absent', const Color(0xFFFEE2E2)),
      ],
    );
  }
}

/// Manual punch: form + today's list (mock).
class _ManualPunchTab extends StatefulWidget {
  const _ManualPunchTab();

  @override
  State<_ManualPunchTab> createState() => _ManualPunchTabState();
}

class _ManualPunchTabState extends State<_ManualPunchTab> {
  String _employee = '-- Select employee --';
  String _punchType = 'Clock In';
  String _reason = 'Fingerprint device offline';

  void _toast(String m) {
    final ctx = context;
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, c) {
          final form = _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Manual punch entry', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                _labeledField(
                  'Employee *',
                  InputDecorator(
                    decoration: _inputDec(),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _employee,
                        icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
                        items: const [
                          DropdownMenuItem(value: '-- Select employee --', child: Text('-- Select employee --')),
                          DropdownMenuItem(value: 'Sarah Lim', child: Text('Sarah Lim · EMP-0021')),
                          DropdownMenuItem(value: 'Raj Kumar', child: Text('Raj Kumar · EMP-0048')),
                        ],
                        onChanged: (v) => setState(() => _employee = v ?? _employee),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _labeledField(
                  'Date *',
                  TextFormField(
                    initialValue: '06/05/2026',
                    decoration: _inputDec().copyWith(suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18)),
                  ),
                ),
                const SizedBox(height: 12),
                _labeledField(
                  'Punch type *',
                  InputDecorator(
                    decoration: _inputDec(),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _punchType,
                        icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
                        items: const [
                          DropdownMenuItem(value: 'Clock In', child: Text('Clock In')),
                          DropdownMenuItem(value: 'Clock Out', child: Text('Clock Out')),
                        ],
                        onChanged: (v) => setState(() => _punchType = v ?? _punchType),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _labeledField(
                  'Time (server time)',
                  TextFormField(
                    initialValue: '09:00 AM',
                    enabled: false,
                    decoration: _inputDec().copyWith(fillColor: const Color(0xFFF5F0E8), filled: true),
                  ),
                ),
                const SizedBox(height: 12),
                _labeledField(
                  'Reason',
                  InputDecorator(
                    decoration: _inputDec(),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _reason,
                        icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
                        items: const [
                          DropdownMenuItem(value: 'Fingerprint device offline', child: Text('Fingerprint device offline')),
                          DropdownMenuItem(value: 'Forgot to swipe', child: Text('Forgot to swipe')),
                          DropdownMenuItem(value: 'Remote work', child: Text('Remote work')),
                        ],
                        onChanged: (v) => setState(() => _reason = v ?? _reason),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _labeledField(
                  'Remark',
                  TextFormField(
                    decoration: _inputDec().copyWith(hintText: 'Optional note for HR record'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    OutlinedButton(onPressed: () => _toast('Clock In recorded'), child: const Text('Clock In')),
                    const SizedBox(width: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFBCFE8), foregroundColor: const Color(0xFF9D174D)),
                      onPressed: () => _toast('Clock Out recorded'),
                      child: const Text('Clock Out'),
                    ),
                  ],
                ),
              ],
            ),
          );

          final list = _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: Text("Today's manual punches", style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(20)),
                      child: Text('4 records', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textMuted)),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _punchListItem('08:55', 'Sarah Lim · EMP-0021 · Clock In · Device offline', 'In', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                _punchListItem('09:10', 'Ahmad Luqman · EMP-0187 · Clock In · Forgot to swipe', 'In', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                _punchListItem('17:30', 'Nadia Chen · EMP-0092 · Clock Out · Remote work', 'Out', const Color(0xFFFBCFE8), const Color(0xFF9D174D)),
                _punchListItem('18:05', 'Raj Kumar · EMP-0048 · Clock Out · Biometric', 'Auto', AppColors.bg, AppColors.textMuted),
              ],
            ),
          );

          if (c.maxWidth < 900) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                form,
                const SizedBox(height: 16),
                list,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: form),
              const SizedBox(width: 16),
              Expanded(child: list),
            ],
          );
        },
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

  InputDecoration _inputDec() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
    );
  }

  Widget _labeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: label.replaceAll(' *', ''), style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
              if (label.endsWith(' *'))
                const TextSpan(text: ' *', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  Widget _punchListItem(String time, String line, String badge, Color bg, Color fg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(time, style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, color: AppColors.navy)),
          ),
          Expanded(child: Text(line, style: GoogleFonts.dmSans(fontSize: 13, height: 1.35))),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
            child: Text(badge, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w800, color: fg)),
          ),
        ],
      ),
    );
  }
}

class _RosterTable extends StatelessWidget {
  const _RosterTable();

  static const Color _weekendColBg = Color(0xFFFFF7ED);

  /// Table column index 1 = Mon … 7 = Sun; weekend Sat/Sun = 6 and 7.
  static Widget _weekendBackdrop(int tableColIndex, Widget child) {
    if (tableColIndex < 6) return child;
    return ColoredBox(color: _weekendColBg, child: child);
  }

  @override
  Widget build(BuildContext context) {
    const days = ['Mon 5', 'Tue 6', 'Wed 7', 'Thu 8', 'Fri 9', 'Sat 10', 'Sun 11'];
    final employees = [
      ('SL', 'Sarah Lim', 'Engineering', [
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Clock in', _RosterPalette.clockIn),
        _cell('09:00–18:00', 'Planned', _RosterPalette.planned),
        _cell('09:00–13:00', 'half · Planned', _RosterPalette.planned),
        _cell('Off', '', _RosterPalette.off),
        _cell('Off', '', _RosterPalette.off),
      ]),
      ('RK', 'Raj Kumar', 'Engineering', [
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–20:00', 'OT active', _RosterPalette.ot),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Planned', _RosterPalette.planned),
        _cell('Off', '', _RosterPalette.off),
        _cell('Off', '', _RosterPalette.off),
      ]),
      ('MT', 'Maya Tan', 'HR', [
        _cell('Annual leave', 'On leave', _RosterPalette.leave),
        _cell('Annual leave', 'On leave', _RosterPalette.leave),
        _cell('Annual leave', 'On leave', _RosterPalette.leave),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Planned', _RosterPalette.planned),
        _cell('Off', '', _RosterPalette.off),
        _cell('Off', '', _RosterPalette.off),
      ]),
      ('AL', 'Ahmad L', 'Operations', [
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Late in', _RosterPalette.clockIn),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('22:00–07:00', 'Night', _RosterPalette.night),
        _cell('22:00–07:00', 'Night', _RosterPalette.night),
        _cell('Off', '', _RosterPalette.off),
        _cell('Off', '', _RosterPalette.off),
      ]),
      ('ZN', 'Zara Nor', 'Operations', [
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('Absent', 'No swipe', _RosterPalette.absent),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Planned', _RosterPalette.planned),
        _cell('Off', '', _RosterPalette.off),
        _cell('Off', '', _RosterPalette.off),
      ]),
    ];

    return Table(
      border: TableBorder.all(color: AppColors.border),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: {
        0: const FixedColumnWidth(220),
        for (int i = 1; i <= 7; i++) i: const FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
          children: [
            _th('Employee'),
            ...List.generate(7, (i) {
              final col = i + 1;
              return _weekendBackdrop(
                col,
                _thDay(days[i], showHalfTag: i == 4),
              );
            }),
          ],
        ),
        ...employees.map((e) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                      child: Text(e.$1, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.$2, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                          Text(e.$3, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(7, (i) {
                final col = i + 1;
                return _weekendBackdrop(
                  col,
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: _RosterCell(data: e.$4[i]),
                  ),
                );
              }),
            ],
          );
        }),
      ],
    );
  }

  Widget _th(String s) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        s,
        style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.navy),
      ),
    );
  }

  Widget _thDay(String s, {bool showHalfTag = false}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(s, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 11, color: AppColors.navy)),
          if (showHalfTag)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('half', style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w700, color: const Color(0xFFEA580C))),
            ),
        ],
      ),
    );
  }
}

class _CellData {
  const _CellData(this.line1, this.line2, this.dec);
  final String line1;
  final String line2;
  final BoxDecoration dec;
}

_CellData _cell(String a, String b, BoxDecoration d) => _CellData(a, b, d);

abstract final class _RosterPalette {
  static final BoxDecoration completed = BoxDecoration(
    color: const Color(0xFFD1FAE5),
    borderRadius: BorderRadius.circular(8),
  );
  /// Clock-in / late-in: light blue fill (matches legend), subtle border.
  static final BoxDecoration clockIn = BoxDecoration(
    color: const Color(0xFFDBEAFE),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
  );
  static final BoxDecoration planned = BoxDecoration(
    color: AppColors.bg,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: AppColors.border),
  );
  static final off = BoxDecoration(
    color: const Color(0xFFE2E8F0),
    borderRadius: BorderRadius.circular(8),
  );
  static final leave = BoxDecoration(
    color: const Color(0xFFFEF3C7),
    borderRadius: BorderRadius.circular(8),
  );
  static final ot = BoxDecoration(
    color: const Color(0xFFFCE7F3),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: const Color(0xFFDB2777)),
  );
  static final night = BoxDecoration(
    color: const Color(0xFFEDE9FE),
    borderRadius: BorderRadius.circular(8),
  );
  static final BoxDecoration absent = BoxDecoration(
    color: const Color(0xFFFEE2E2),
    borderRadius: BorderRadius.circular(8),
  );
}

class _RosterCell extends StatelessWidget {
  const _RosterCell({required this.data});
  final _CellData data;

  @override
  Widget build(BuildContext context) {
    final isClockStyle = data.dec == _RosterPalette.clockIn;
    final accent = isClockStyle ? const Color(0xFF1E40AF) : AppColors.navy;
    final sub = isClockStyle ? const Color(0xFF1E40AF) : AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: data.dec,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.line1,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accent,
            ),
          ),
          if (data.line2.isNotEmpty)
            Text(
              data.line2,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                color: sub,
              ),
            ),
        ],
      ),
    );
  }
}
