import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/widgets/hr_data_table_card.dart';
import '../../shared/widgets/hr_module_header.dart';

/// Training Management module — tabs mirror provided UI mockups.
class TrainingManagementScreen extends StatefulWidget {
  const TrainingManagementScreen({super.key});

  @override
  State<TrainingManagementScreen> createState() =>
      _TrainingManagementScreenState();
}

class _TrainingManagementScreenState extends State<TrainingManagementScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 10, vsync: this);

  static const _tabLabels = [
    'Training type',
    'Category',
    'Course',
    'Subject',
    'Schedule',
    'Training request',
    'Request on behalf',
    'Approval',
    'Attendance',
    'Training History',
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
        title: Text('Training', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HrModuleHeader(
            moduleSubtitle: 'TRAINING MANAGEMENT',
            primaryActionLabel: '+ New request',
            onPrimaryAction: () => _toast('New training request'),
            extraTrailing: [
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {},
              ),
            ],
          ),
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tab,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.primary,
              tabs: _tabLabels.map((t) => Tab(text: t)).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _trainingTypeTab(),
                _simpleCatalogTab(
                  title: 'Category',
                  searchHint: 'Search category...',
                  actionLabel: '+ New category',
                  rows: _categories,
                ),
                _simpleCatalogTab(
                  title: 'Course',
                  searchHint: 'Search course...',
                  actionLabel: '+ New course',
                  rows: _courses,
                ),
                _simpleCatalogTab(
                  title: 'Subject',
                  searchHint: 'Search subject...',
                  actionLabel: '+ New subject',
                  rows: _subjects,
                ),
                _scheduleTab(),
                _requestsTab(isBehalf: false),
                _requestsTab(isBehalf: true),
                _approvalTab(),
                _trainingAttendanceTab(),
                _historyTab(),
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

  Widget _trainingTypeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search type...',
        actionLabel: '+ New training type',
        onAction: () => _toast('Create training type'),
        columns: const [
          DataColumn(label: Text('No.')),
          DataColumn(label: Text('Training type name')),
          DataColumn(label: Text('Description')),
          DataColumn(label: Text('Courses')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: List.generate(_trainingTypes.length, (i) {
          final r = _trainingTypes[i];
          return DataRow(
            cells: [
              DataCell(Text('${i + 1}')),
              DataCell(Text(r.$1, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
              DataCell(Text(r.$2, maxLines: 1, overflow: TextOverflow.ellipsis)),
              DataCell(Text(r.$3)),
              DataCell(_statusChip(r.$4)),
              DataCell(TextButton(onPressed: () => _toast('Edit ${r.$1}'), child: const Text('Edit'))),
            ],
          );
        }),
      ),
    );
  }

  Widget _simpleCatalogTab({
    required String title,
    required String searchHint,
    required String actionLabel,
    required List<(String, String, String, String)> rows,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: searchHint,
        actionLabel: actionLabel,
        onAction: () => _toast('Create $title'),
        columns: const [
          DataColumn(label: Text('No.')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Description')),
          DataColumn(label: Text('Linked')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: List.generate(rows.length, (i) {
          final r = rows[i];
          return DataRow(
            cells: [
              DataCell(Text('${i + 1}')),
              DataCell(Text(r.$1, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
              DataCell(Text(r.$2, maxLines: 1, overflow: TextOverflow.ellipsis)),
              DataCell(Text(r.$3)),
              DataCell(_statusChip(r.$4)),
              DataCell(TextButton(onPressed: () => _toast('Edit ${r.$1}'), child: const Text('Edit'))),
            ],
          );
        }),
      ),
    );
  }

  Widget _scheduleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search schedule...',
        actionLabel: '+ New schedule',
        onAction: () => _toast('Create schedule'),
        columns: const [
          DataColumn(label: Text('No.')),
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('Trainer')),
          DataColumn(label: Text('Start')),
          DataColumn(label: Text('End')),
          DataColumn(label: Text('Venue')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('1')),
              const DataCell(Text('Kubernetes Basics')),
              const DataCell(Text('M. Kumar')),
              const DataCell(Text('12 Jun 2026')),
              const DataCell(Text('14 Jun 2026')),
              const DataCell(Text('KL Training Room A')),
              DataCell(_statusChip('Scheduled')),
              DataCell(TextButton(onPressed: () {}, child: const Text('Edit'))),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text('2')),
              const DataCell(Text('Leadership 101')),
              const DataCell(Text('S. Lim')),
              const DataCell(Text('20 Jun 2026')),
              const DataCell(Text('21 Jun 2026')),
              const DataCell(Text('Zoom')),
              DataCell(_statusChip('Draft')),
              DataCell(TextButton(onPressed: () {}, child: const Text('Edit'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _requestsTab({required bool isBehalf}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: isBehalf ? 'Search employee...' : 'Search request...',
        actionLabel: isBehalf ? '+ Request on behalf' : '+ New training request',
        onAction: () => _toast(isBehalf ? 'Request on behalf' : 'New request'),
        columns: const [
          DataColumn(label: Text('Ref')),
          DataColumn(label: Text('Employee')),
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('Reason')),
          DataColumn(label: Text('Submitted')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('TR-24012')),
              DataCell(Text(isBehalf ? 'Ali Rahman (by HR)' : 'Sarah Lim')),
              const DataCell(Text('AWS Fundamentals')),
              const DataCell(Text('Upskilling')),
              const DataCell(Text('02 Jun 2026')),
              DataCell(_statusChip('Pending')),
              DataCell(TextButton(onPressed: () {}, child: const Text('Open'))),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text('TR-24013')),
              DataCell(Text(isBehalf ? 'Chen Wei (by HR)' : 'James Ng')),
              const DataCell(Text('Excel Advanced')),
              const DataCell(Text('Role requirement')),
              const DataCell(Text('03 Jun 2026')),
              DataCell(_statusChip('Approved')),
              DataCell(TextButton(onPressed: () {}, child: const Text('Open'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _approvalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search approval...',
        actionLabel: '+ Bulk approve',
        onAction: () => _toast('Bulk approve'),
        columns: const [
          DataColumn(label: Text('Ref')),
          DataColumn(label: Text('Employee')),
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('Manager')),
          DataColumn(label: Text('SLA')),
          DataColumn(label: Text('Decision')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('TR-24012')),
              const DataCell(Text('Sarah Lim')),
              const DataCell(Text('AWS Fundamentals')),
              const DataCell(Text('Lee Kuan')),
              const DataCell(Text('2d left')),
              DataCell(_statusChip('Pending')),
              DataCell(Row(
                children: [
                  TextButton(onPressed: () => _toast('Approved'), child: const Text('Approve')),
                  TextButton(onPressed: () => _toast('Rejected'), child: const Text('Reject')),
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trainingAttendanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search attendance...',
        actionLabel: '+ Record attendance',
        onAction: () => _toast('Record attendance'),
        columns: const [
          DataColumn(label: Text('Session')),
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Registered')),
          DataColumn(label: Text('Present')),
          DataColumn(label: Text('Absent')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('SES-883')),
              const DataCell(Text('Kubernetes Basics')),
              const DataCell(Text('13 Jun 2026')),
              const DataCell(Text('18')),
              const DataCell(Text('17')),
              const DataCell(Text('1')),
              DataCell(TextButton(onPressed: () {}, child: const Text('Details'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search history...',
        actionLabel: '+ Export history',
        onAction: () => _toast('Export'),
        columns: const [
          DataColumn(label: Text('Employee')),
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('Completed')),
          DataColumn(label: Text('Score')),
          DataColumn(label: Text('Certificate')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('Sarah Lim')),
              const DataCell(Text('Leadership 101')),
              const DataCell(Text('21 May 2026')),
              const DataCell(Text('92')),
              DataCell(_statusChip('Issued')),
              DataCell(TextButton(onPressed: () {}, child: const Text('Download'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(String label) {
    final green = label == 'Active' || label == 'Approved' || label == 'Scheduled' || label == 'Issued';
    final orange = label == 'Draft' || label == 'Pending';
    final color = green
        ? const Color(0xFFD1FAE5)
        : orange
            ? const Color(0xFFFEF3C7)
            : AppColors.bg;
    final fg = green
        ? const Color(0xFF065F46)
        : orange
            ? const Color(0xFF92400E)
            : AppColors.textMuted;
    return Chip(
      label: Text(label, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
    );
  }
}

// (name, description, linkedCount/status bucket, status label)
final _trainingTypes = [
  ('Management', 'Leadership, strategy & people management', '8', 'Active'),
  ('Technical', 'IT, engineering & systems training', '12', 'Active'),
  ('Compliance', 'Policies, safety & regulatory training', '5', 'Active'),
  ('Soft skills', 'Communication, teamwork & productivity', '6', 'Draft'),
  ('Onboarding', 'New hire orientation & culture', '3', 'Active'),
];

final _categories = [
  ('Leadership', 'Senior leaders & managers', '24 courses', 'Active'),
  ('Cloud', 'AWS/Azure/GCP curriculum', '18 courses', 'Active'),
  ('Compliance', 'Annual mandatory modules', '9 courses', 'Active'),
];

final _courses = [
  ('AWS Fundamentals', 'Compute, storage & IAM essentials', 'Cloud', 'Active'),
  ('Excel Advanced', 'Pivot, macros & dashboards', 'Productivity', 'Draft'),
  ('Safety induction', 'Warehouse safety basics', 'Compliance', 'Active'),
];

final _subjects = [
  ('IAM & Security', 'Identity and least-privilege patterns', 'AWS Fundamentals', 'Active'),
  ('Pivot tables', 'Reporting with Excel', 'Excel Advanced', 'Active'),
];
