import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/hr_data_table_card.dart';
import '../../../shared/widgets/hr_module_header.dart';

/// Time & Attendance module — tabs mirror attendance mockups (Duty roster … Report).
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 8, vsync: this);

  String _rosterGranularity = 'week';

  static const _tabs = [
    'Duty roster',
    'Timesheet',
    'Shift pattern',
    'Roll call',
    'Manual punch',
    'Unknown swipes',
    'Overtime',
    'Report',
  ];

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Attendance', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HrModuleHeader(
            moduleSubtitle: 'TIME & ATTENDANCE',
            primaryActionLabel: '+ Manual punch',
            onPrimaryAction: () => _toast('Manual punch'),
          ),
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tab,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.primary,
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _dutyRosterTab(),
                _timesheetTab(),
                _shiftPatternTab(),
                _rollCallTab(),
                _manualPunchTab(),
                _unknownSwipesTab(),
                _overtimeTab(),
                _reportTab(),
              ],
            ),
          ),
        ],
      ),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
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
                      OutlinedButton(onPressed: () {}, child: const Text('Prev')),
                      OutlinedButton(onPressed: () {}, child: const Text('Next')),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'week', label: Text('Week')),
                          ButtonSegment(value: 'day', label: Text('Day')),
                          ButtonSegment(value: 'month', label: Text('Month')),
                        ],
                        selected: {_rosterGranularity},
                        onSelectionChanged: (s) =>
                            setState(() => _rosterGranularity = s.first),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _toast('Import'),
                  icon: const Icon(Icons.upload_file_outlined, size: 18),
                  label: const Text('Import data'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _RosterTable(),
          ),
          const SizedBox(height: 16),
          _legendRow(),
        ],
      ),
    );
  }

  Widget _timesheetTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search employee...',
        actionLabel: '+ Adjust timesheet',
        onAction: () => _toast('Adjust'),
        columns: const [
          DataColumn(label: Text('Employee')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Clock in')),
          DataColumn(label: Text('Clock out')),
          DataColumn(label: Text('Hours')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('Sarah Lim')),
              const DataCell(Text('09 May 2026')),
              const DataCell(Text('09:02')),
              const DataCell(Text('18:04')),
              const DataCell(Text('8.0')),
              DataCell(_tinyChip('Balanced', AppColors.success)),
              DataCell(TextButton(onPressed: () {}, child: const Text('Edit'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shiftPatternTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search pattern...',
        actionLabel: '+ New pattern',
        onAction: () => _toast('New pattern'),
        columns: const [
          DataColumn(label: Text('Pattern')),
          DataColumn(label: Text('Applies to')),
          DataColumn(label: Text('Cycle')),
          DataColumn(label: Text('Effective')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('Office standard')),
              const DataCell(Text('HQ · Engineering')),
              const DataCell(Text('5D · Mon–Fri')),
              const DataCell(Text('01 Jan 2026')),
              DataCell(_tinyChip('Active', AppColors.success)),
              DataCell(TextButton(onPressed: () {}, child: const Text('Edit'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rollCallTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search session...',
        actionLabel: '+ Start roll call',
        onAction: () => _toast('Roll call'),
        columns: const [
          DataColumn(label: Text('Session')),
          DataColumn(label: Text('Location')),
          DataColumn(label: Text('Supervisor')),
          DataColumn(label: Text('Expected')),
          DataColumn(label: Text('Checked-in')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('Morning briefing')),
              const DataCell(Text('KL HQ · Hall A')),
              const DataCell(Text('R. Kumar')),
              const DataCell(Text('42')),
              const DataCell(Text('39')),
              DataCell(TextButton(onPressed: () {}, child: const Text('Open'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _manualPunchTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search punch...',
        actionLabel: '+ Add punch',
        onAction: () => _toast('Add punch'),
        columns: const [
          DataColumn(label: Text('Employee')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Reason')),
          DataColumn(label: Text('Approver')),
          DataColumn(label: Text('Status')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('James Ng')),
              const DataCell(Text('08 May 2026')),
              const DataCell(Text('IN')),
              const DataCell(Text('08:55')),
              const DataCell(Text('Forgot card')),
              const DataCell(Text('HR')),
              DataCell(_tinyChip('Approved', AppColors.success)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _unknownSwipesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search device...',
        actionLabel: '+ Resolve',
        onAction: () => _toast('Resolve swipe'),
        columns: const [
          DataColumn(label: Text('Device')),
          DataColumn(label: Text('Time')),
          DataColumn(label: Text('Card')),
          DataColumn(label: Text('Match')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('Turnstile W1')),
              const DataCell(Text('07:58')),
              const DataCell(Text('890021')),
              DataCell(_tinyChip('Unmatched', AppColors.warning)),
              DataCell(TextButton(onPressed: () {}, child: const Text('Assign'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overtimeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search OT...',
        actionLabel: '+ OT request',
        onAction: () => _toast('OT request'),
        columns: const [
          DataColumn(label: Text('Ref')),
          DataColumn(label: Text('Employee')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Hours')),
          DataColumn(label: Text('Reason')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('OT-9921')),
              const DataCell(Text('Priya Sharma')),
              const DataCell(Text('08 May 2026')),
              const DataCell(Text('2.5')),
              const DataCell(Text('Release prep')),
              DataCell(_tinyChip('Pending', AppColors.warning)),
              DataCell(TextButton(onPressed: () {}, child: const Text('Approve'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search report...',
        actionLabel: '+ Schedule report',
        onAction: () => _toast('Schedule'),
        columns: const [
          DataColumn(label: Text('Report')),
          DataColumn(label: Text('Frequency')),
          DataColumn(label: Text('Last run')),
          DataColumn(label: Text('Owner')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('Daily attendance summary')),
              const DataCell(Text('Daily · 08:00')),
              const DataCell(Text('12 May 2026')),
              const DataCell(Text('HR Ops')),
              DataCell(TextButton(onPressed: () {}, child: const Text('Run now'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tinyChip(String label, Color c) {
    final fg = c.computeLuminance() > 0.5 ? AppColors.navy : Colors.white;
    return Chip(
      label: Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: fg)),
      backgroundColor: c,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _legendRow() {
    Widget chip(String t, Color bg, Color fg) {
      return Chip(
        label: Text(t, style: GoogleFonts.dmSans(fontSize: 10, color: fg)),
        backgroundColor: bg,
        side: BorderSide.none,
        visualDensity: VisualDensity.compact,
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        chip('Completed', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
        chip('Clock in', const Color(0xFFDBEAFE), const Color(0xFF1E40AF)),
        chip('Planned / off', AppColors.bg, AppColors.textMuted),
        chip('On leave', const Color(0xFFFEF3C7), const Color(0xFF92400E)),
        chip('OT active', const Color(0xFFFCE7F3), const Color(0xFF9D174D)),
        chip('Night shift', const Color(0xFFEDE9FE), const Color(0xFF5B21B6)),
        chip('Absent', const Color(0xFFFEE2E2), const Color(0xFF991B1B)),
      ],
    );
  }
}

class _RosterTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const days = ['Mon 5', 'Tue 6', 'Wed 7', 'Thu 8', 'Fri 9', 'Sat 10', 'Sun 11'];
    final employees = [
      ('SL', 'Sarah Lim', 'Engineering', [
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Clock in', _RosterPalette.clockIn),
        _cell('half', 'Planned', _RosterPalette.planned),
        _cell('Off', '', _RosterPalette.off),
        _cell('Off', '', _RosterPalette.off),
      ]),
      ('RK', 'Raj Kumar', 'Operations', [
        _cell('22:00–07:00', 'Night', _RosterPalette.night),
        _cell('22:00–07:00', 'Night', _RosterPalette.night),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('OT active', 'OT', _RosterPalette.ot),
        _cell('Off', '', _RosterPalette.off),
      ]),
      ('PN', 'Priya Nair', 'HR', [
        _cell('Annual leave', 'Leave', _RosterPalette.leave),
        _cell('Annual leave', 'Leave', _RosterPalette.leave),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–13:00', 'Half', _RosterPalette.planned),
        _cell('Off', '', _RosterPalette.off),
      ]),
      ('JW', 'James Wong', 'Marketing', [
        _cell('Absent', 'No swipe', _RosterPalette.absent),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('09:00–18:00', 'Completed', _RosterPalette.completed),
        _cell('Off', '', _RosterPalette.off),
        _cell('Off', '', _RosterPalette.off),
      ]),
    ];

    return Table(
      border: TableBorder.all(color: AppColors.border),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFF8FAFC)),
          children: [
            _th('Employee'),
            ...days.map(_th),
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
              ...e.$4.map((c) => Padding(
                    padding: const EdgeInsets.all(6),
                    child: _RosterCell(data: c),
                  )),
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
  static final clockIn = BoxDecoration(
    color: const Color(0xFFDBEAFE),
    borderRadius: BorderRadius.circular(8),
  );
  static final planned = BoxDecoration(
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: data.dec,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.line1,
            style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          if (data.line2.isNotEmpty)
            Text(
              data.line2,
              style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.textMuted),
            ),
        ],
      ),
    );
  }
}
