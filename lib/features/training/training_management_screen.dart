import 'package:flutter/material.dart';
import '../../shared/widgets/module_shell_background.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/widgets/hr_full_width_data_table.dart';
import '../../shared/widgets/hr_module_header.dart';

/// Training Management — mock-aligned tabs and tables.
class TrainingManagementScreen extends StatefulWidget {
  const TrainingManagementScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<TrainingManagementScreen> createState() => _TrainingManagementScreenState();
}

class _TrainingManagementScreenState extends State<TrainingManagementScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 10, vsync: this);

  static const _approvalBadge = 5;

  /// Mock toolbar dropdown selections keyed by stable id.
  final Map<String, String> _trainingDd = {};

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _toast(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HrModuleHeader(
          moduleSubtitle: 'TRAINING MANAGEMENT',
          navyPrimaryButton: true,
          showMoreMenu: true,
          primaryActionLabel: '+ New request',
          onPrimaryAction: () => _toast('New request'),
        ),
        Material(
          color: Theme.of(context).colorScheme.surface,
          child: TabBar(
            controller: _tab,
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            tabAlignment: TabAlignment.start,
            tabs: [
              _tTab(Icons.grid_view_outlined, 'Training type'),
              _tTab(Icons.category_outlined, 'Category'),
              _tTab(Icons.menu_book_outlined, 'Course'),
              _tTab(Icons.subject_outlined, 'Subject'),
              _tTab(Icons.calendar_month_outlined, 'Schedule'),
              _tTab(Icons.fact_check_outlined, 'Training request'),
              _tTab(Icons.person_add_alt_1_outlined, 'Request on behalf'),
              _tTab(Icons.check_circle_outline, 'Approval', badge: _approvalBadge),
              _tTab(Icons.how_to_reg_outlined, 'Attendance'),
              _tTab(Icons.history, 'Training history'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _trainingTypeTab(),
              _categoryTab(),
              _courseTab(),
              _subjectTab(),
              _scheduleTab(),
              const _TrainingRequestPane(),
              const _RequestOnBehalfPane(),
              _approvalTab(),
              _attendanceTab(),
              _historyTab(),
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
        title: Text('Training Management', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: body,
    );
  }

  Widget _tTab(IconData icon, String label, {int badge = 0}) {
    return Tab(
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
          if (badge > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEDD5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$badge',
                style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFC2410C)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _trainingTypeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _toolbarCard(
            left: SizedBox(
              width: 260,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search type...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                  filled: true,
                  fillColor: AppColors.bg,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                ),
              ),
            ),
            right: OutlinedButton(
              onPressed: () => _toast('New training type'),
              child: const Text('+ New training type'),
            ),
          ),
          const SizedBox(height: 16),
          _tableCard(
            child: HrFullWidthDataTable(
              headingRowColor: const Color(0xFFF5F0E8),
              columnSpecs: const [
                ('No.', 0.5),
                ('Training type name', 1.5),
                ('Description', 3.0),
                ('Courses', 0.7),
                ('Status', 0.9),
                ('Actions', 0.7),
              ],
              rows: [
                _typeRow(1, 'Management', 'Leadership, strategy & people ma...', '8', 'Active', true),
                _typeRow(2, 'Technical', 'IT, engineering & systems training', '12', 'Active', true),
                _typeRow(3, 'Compliance', 'Regulatory, safety & legal require...', '5', 'Active', true),
                _typeRow(4, 'Soft skills', 'Communication, teamwork & pre...', '6', 'Active', true),
                _typeRow(5, 'Onboarding', 'New employee orientation progra...', '3', 'Draft', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _typeRow(int no, String name, String desc, String courses, String status, bool active) {
    return DataRow(
      cells: [
        DataCell(Text('$no')),
        DataCell(Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
        DataCell(Text(desc, maxLines: 1, overflow: TextOverflow.ellipsis)),
        DataCell(Text(courses)),
        DataCell(_pill(status, active ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7), active ? const Color(0xFF065F46) : const Color(0xFF92400E))),
        DataCell(TextButton(onPressed: () => _toast('Edit $name'), child: const Text('Edit'))),
      ],
    );
  }

  Widget _categoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _toolbarCard(
            left: Wrap(
              spacing: 8,
              children: [
                _dd('category_train_kind', 'All training types', const ['All training types', 'Management', 'Technical']),
                SizedBox(
                  width: 220,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search category...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                      filled: true,
                      fillColor: AppColors.bg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                  ),
                ),
              ],
            ),
            right: OutlinedButton(onPressed: () => _toast('New category'), child: const Text('+ New category')),
          ),
          const SizedBox(height: 16),
          _tableCard(
            child: HrFullWidthDataTable(
              headingRowColor: const Color(0xFFF5F0E8),
              columnSpecs: const [
                ('No.', 0.5),
                ('Category name', 1.4),
                ('Training type', 1.2),
                ('Description', 2.5),
                ('Subjects', 0.7),
                ('Action', 0.7),
              ],
              rows: [
                _catRow(1, 'Leadership', 'Management', const Color(0xFFDBEAFE), const Color(0xFF1E40AF), 'Leading teams & strategy', '4'),
                _catRow(2, 'Computer skills', 'Technical', const Color(0xFFEDE9FE), const Color(0xFF5B21B6), 'Software & hardware', '6'),
                _catRow(3, 'Fire safety', 'Compliance', const Color(0xFFFFEDD5), const Color(0xFFC2410C), 'Emergency & safety drills', '2'),
                _catRow(4, 'Public speaking', 'Soft skills', const Color(0xFFD1FAE5), const Color(0xFF065F46), 'Presentation & communication', '3'),
                _catRow(5, 'Project management', 'Management', const Color(0xFFDBEAFE), const Color(0xFF1E40AF), 'Agile, Scrum & PMO', '5'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _catRow(int no, String name, String type, Color bg, Color fg, String desc, String subs) {
    return DataRow(
      cells: [
        DataCell(Text('$no')),
        DataCell(Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
        DataCell(_pill(type, bg, fg)),
        DataCell(Text(desc, maxLines: 1, overflow: TextOverflow.ellipsis)),
        DataCell(Text(subs)),
        DataCell(TextButton(onPressed: () => _toast('Edit $name'), child: const Text('Edit'))),
      ],
    );
  }

  Widget _courseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _toolbarCard(
            left: Wrap(
              spacing: 8,
              children: [
                _dd('cat_kind', 'All types', const ['All types', 'Management', 'Technical']),
                _dd('cat_delivery', 'All delivery', const ['All delivery', 'Internal', 'External']),
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search course...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                      filled: true,
                      fillColor: AppColors.bg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                  ),
                ),
              ],
            ),
            right: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
              onPressed: () => _toast('New course'),
              child: const Text('+ New course'),
            ),
          ),
          const SizedBox(height: 16),
          _tableCard(
            child: HrFullWidthDataTable(
              headingRowColor: const Color(0xFFF5F0E8),
              columnSpecs: const [
                ('Course title', 1.8),
                ('Type / Category', 1.2),
                ('Delivery', 0.9),
                ('Frequency', 1.0),
                ('Mandatory', 0.9),
                ('Due within', 0.9),
                ('Status', 0.8),
                ('Actions', 0.7),
              ],
              rows: [
                _courseRow('Leadership essentials', 'Management', const Color(0xFFDBEAFE), const Color(0xFF1E40AF), 'Internal', 'One time', true, '7 days'),
                _courseRow('Excel advanced', 'Technical', const Color(0xFFEDE9FE), const Color(0xFF5B21B6), 'Internal', 'Renewing', false, '30 days'),
                _courseRow('ISO 9001 awareness', 'Compliance', const Color(0xFFFFEDD5), const Color(0xFFC2410C), 'External', 'Annual', true, '1 day'),
                _courseRow('Agile & Scrum', 'Management', const Color(0xFFDBEAFE), const Color(0xFF1E40AF), 'Overseas', 'One time', false, '—'),
                _courseRow('Public speaking', 'Soft skills', const Color(0xFFD1FAE5), const Color(0xFF065F46), 'Internal', 'Repeat...', false, '14 days'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _courseRow(
    String title,
    String cat,
    Color catBg,
    Color catFg,
    String delivery,
    String freq,
    bool mandatory,
    String due,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
        DataCell(_pill(cat, catBg, catFg)),
        DataCell(Text(delivery)),
        DataCell(Text(freq)),
        DataCell(_pill(mandatory ? 'Yes' : 'No', mandatory ? const Color(0xFFFEE2E2) : AppColors.bg, mandatory ? AppColors.danger : AppColors.textMuted)),
        DataCell(Text(due)),
        DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
        DataCell(TextButton(onPressed: () => _toast('Edit $title'), child: const Text('Edit'))),
      ],
    );
  }

  Widget _subjectTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _toolbarCard(
            left: Wrap(
              spacing: 8,
              children: [
                _dd('subject_course', 'All courses', const ['All courses', 'Leadership essentials']),
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search subject...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                      filled: true,
                      fillColor: AppColors.bg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                  ),
                ),
              ],
            ),
            right: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
              onPressed: () => _toast('New subject'),
              child: const Text('+ New subject'),
            ),
          ),
          const SizedBox(height: 16),
          _tableCard(
            child: HrFullWidthDataTable(
              headingRowColor: const Color(0xFFF5F0E8),
              columnSpecs: const [
                ('Subject title', 1.6),
                ('Course', 1.4),
                ('Internal trainer', 1.2),
                ('External trainer', 1.2),
                ('Achieve skills', 1.4),
                ('Actions', 0.7),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Team leadership', style: TextStyle(fontWeight: FontWeight.w700))),
                  const DataCell(Text('Leadership esse...', overflow: TextOverflow.ellipsis)),
                  const DataCell(Text('David Ng')),
                  const DataCell(Text('—')),
                  DataCell(_pill('People mgmt', const Color(0xFFDBEAFE), AppColors.primary)),
                  DataCell(TextButton(onPressed: () => _toast('Edit'), child: const Text('Edit'))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Decision making', style: TextStyle(fontWeight: FontWeight.w700))),
                  const DataCell(Text('Leadership esse...', overflow: TextOverflow.ellipsis)),
                  const DataCell(Text('Nina Reza')),
                  const DataCell(Text('—')),
                  DataCell(_pill('Critical thinking', const Color(0xFFEDE9FE), const Color(0xFF5B21B6))),
                  DataCell(TextButton(onPressed: () => _toast('Edit'), child: const Text('Edit'))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Pivot tables', style: TextStyle(fontWeight: FontWeight.w700))),
                  const DataCell(Text('Excel advanced')),
                  const DataCell(Text('—')),
                  const DataCell(Text('Excel Pro Sdn')),
                  DataCell(_pill('Data analysis', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(TextButton(onPressed: () => _toast('Edit'), child: const Text('Edit'))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Scrum ceremonies', style: TextStyle(fontWeight: FontWeight.w700))),
                  const DataCell(Text('Agile & Scrum')),
                  const DataCell(Text('—')),
                  const DataCell(Text('Agile Acad...', overflow: TextOverflow.ellipsis)),
                  DataCell(_pill('Agile delivery', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
                  DataCell(TextButton(onPressed: () => _toast('Edit'), child: const Text('Edit'))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _toolbarCard(
            left: Wrap(
              spacing: 8,
              children: [
                _dd('sched_course', 'All courses', const ['All courses', 'Leadership essentials']),
                _dd('sched_status', 'All status', const ['All status', 'Upcoming', 'Ongoing']),
                _dd('sched_date', '06/05/2026', const ['06/05/2026', '12/05/2026']),
              ],
            ),
            right: Wrap(
              spacing: 8,
              children: [
                OutlinedButton(onPressed: () => _toast('Copy schedule'), child: const Text('Copy schedule')),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                  onPressed: () => _toast('Create new'),
                  child: const Text('+ Create new'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _tableCard(
            child: HrFullWidthDataTable(
              headingRowColor: const Color(0xFFF5F0E8),
              columnSpecs: const [
                ('Course title', 1.8),
                ('Type', 0.8),
                ('Period', 1.0),
                ('Days', 0.6),
                ('Fee (MYR)', 0.9),
                ('Company cont.', 0.9),
                ('Request before', 1.0),
                ('Status', 0.9),
              ],
              rows: [
                _schedRow('Leadership essentials', 'Internal', '12–14 May', '3', '500/pax', '100%', '7 days', 'Upcoming', const Color(0xFFDBEAFE), AppColors.primary),
                _schedRow('Excel advanced', 'Internal', '6–7 May', '2', '200/pax', '50%', '3 days', 'Ongoing', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
                _schedRow('ISO 9001 awareness', 'External', '2 May', '1', '800/pax', '100%', '14 days', 'Completed', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                _schedRow('Agile & Scrum', 'Overseas', '20–24 May', '5', '3,200/pax', '80%', '21 days', 'Upcoming', const Color(0xFFDBEAFE), AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _schedRow(String course, String type, String period, String days, String fee, String co, String req, String st, Color stBg, Color stFg) {
    return DataRow(
      cells: [
        DataCell(Text(course, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
        DataCell(Text(type)),
        DataCell(Text(period)),
        DataCell(Text(days)),
        DataCell(Text(fee)),
        DataCell(Text(co)),
        DataCell(Text(req)),
        DataCell(_pill(st, stBg, stFg)),
      ],
    );
  }

  Widget _approvalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _toolbarCard(
            left: Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _dd('appr_status', 'All status', const ['All status', 'Pending']),
                _dd('appr_dept', 'All departments', const ['All departments', 'Engineering']),
                _dd('appr_date', '06/05/2026', const ['06/05/2026']),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(20)),
                  child: Text('$_approvalBadge pending approval', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: const Color(0xFFC2410C), fontSize: 12)),
                ),
              ],
            ),
            right: OutlinedButton(onPressed: () => _toast('Reset filter'), child: const Text('Reset filter')),
          ),
          const SizedBox(height: 16),
          _tableCard(
            child: HrFullWidthDataTable(
              dataRowMinHeight: 48,
              dataRowMaxHeight: 96,
              columnSpecs: const [
                ('Employee', 1.6),
                ('Course', 1.6),
                ('Date', 0.9),
                ('Location', 1.0),
                ('Approved by', 1.2),
                ('Status', 0.9),
                ('', 1.0),
              ],
              rows: [
                _apprRow1(),
                _apprRow2(),
                _apprRow3(),
                _apprRow4(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _apprRow1() {
    return DataRow(
      cells: [
        DataCell(_empAv('SL', 'Sarah Lim')),
        const DataCell(Text('Leadership esse...')),
        const DataCell(Text('12-14 May')),
        const DataCell(Text('Room A')),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Icon(Icons.circle, size: 8, color: AppColors.danger), const SizedBox(width: 4), Text('David Ng', style: GoogleFonts.dmSans(fontSize: 12))]),
              Row(children: [Icon(Icons.circle, size: 8, color: AppColors.muted), const SizedBox(width: 4), Text('Ahmad Wahid', style: GoogleFonts.dmSans(fontSize: 12))]),
            ],
          ),
        ),
        DataCell(_pill('Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
        DataCell(
          Row(
            children: [
              FilledButton(style: FilledButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10)), onPressed: () => _toast('Approved'), child: const Text('Approve')),
              const SizedBox(width: 6),
              OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger), onPressed: () => _toast('Denied'), child: const Text('Deny')),
            ],
          ),
        ),
      ],
    );
  }

  DataRow _apprRow2() {
    return DataRow(
      cells: [
        DataCell(_empAv('RK', 'Raj Kumar')),
        const DataCell(Text('Agile & Scrum')),
        const DataCell(Text('20-24...')),
        const DataCell(Text('Overseas')),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Icon(Icons.circle, size: 8, color: AppColors.success), const SizedBox(width: 4), const Icon(Icons.check, size: 14, color: AppColors.success), Text(' David Ng', style: GoogleFonts.dmSans(fontSize: 12))]),
              Row(children: [Icon(Icons.circle, size: 8, color: AppColors.danger), const SizedBox(width: 4), Text('Ahmad Wahid', style: GoogleFonts.dmSans(fontSize: 12))]),
            ],
          ),
        ),
        DataCell(_pill('Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
        DataCell(
          Row(
            children: [
              FilledButton(style: FilledButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10)), onPressed: () => _toast('Approved'), child: const Text('Approve')),
              const SizedBox(width: 6),
              OutlinedButton(style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger), onPressed: () => _toast('Denied'), child: const Text('Deny')),
            ],
          ),
        ),
      ],
    );
  }

  DataRow _apprRow3() {
    return DataRow(
      cells: [
        DataCell(_empAv('MT', 'Maya Tan')),
        const DataCell(Text('Excel advanced')),
        const DataCell(Text('6-7 May')),
        const DataCell(Text('Room B')),
        DataCell(Row(children: [Icon(Icons.circle, size: 8, color: AppColors.success), const SizedBox(width: 4), const Icon(Icons.check, size: 14, color: AppColors.success), Text(' Nina Reza', style: GoogleFonts.dmSans(fontSize: 12))])),
        DataCell(_pill('Approved', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
        const DataCell(Text('Completed')),
      ],
    );
  }

  DataRow _apprRow4() {
    return DataRow(
      cells: [
        DataCell(_empAv('NC', 'Nadia Chen')),
        const DataCell(Text('Public speaking')),
        const DataCell(Text('20 May')),
        const DataCell(Text('Room A')),
        DataCell(Row(children: [Icon(Icons.circle, size: 8, color: AppColors.navy), const SizedBox(width: 4), const Icon(Icons.close, size: 14), Text(' Kevin Lim', style: GoogleFonts.dmSans(fontSize: 12))])),
        DataCell(_pill('Denied', AppColors.errorSurface, AppColors.danger)),
        const DataCell(Text('Budget cap')),
      ],
    );
  }

  Widget _attendanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _toolbarCard(
            left: Wrap(
              spacing: 8,
              children: [
                _dd('trainAtt_course', 'All courses', const ['All courses', 'Leadership']),
                _dd('trainAtt_dept', 'All departments', const ['All departments']),
                _dd('trainAtt_date', '06/05/2026', const ['06/05/2026']),
                OutlinedButton(onPressed: () => _toast('Reset'), child: const Text('Reset')),
                OutlinedButton(onPressed: () => _toast('Filter'), child: const Text('Filter')),
              ],
            ),
            right: const SizedBox(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: OutlinedButton.icon(
                onPressed: () => _toast('Create attendance'),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create new attendance'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _tableCard(
            child: HrFullWidthDataTable(
              columnSpecs: const [
                ('Employee', 1.5),
                ('Course / Subject', 1.8),
                ('Schedule date', 1.0),
                ('Actual date', 1.0),
                ('Time in', 0.8),
                ('Time out', 0.8),
                ('Status', 0.9),
                ('Actions', 0.8),
              ],
              rows: [
                _attRow('SL', Colors.blue, 'Sarah Lim', 'Leadership — Tea...', '12 May', '12 May', '09:02', '13:05', 'Present', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                _attRow('RK', Colors.green, 'Raj Kumar', 'Excel — Pivot tables', '6 May', '6 May', '09:05', '17:00', 'Present', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                _attRow('MT', Colors.purple, 'Maya Tan', 'Excel — Pivot tables', '6 May', '6 May', '—', '—', 'Absent', AppColors.errorSurface, AppColors.danger),
                _attRow('AL', Colors.orange, 'Ahmad L', 'Leadership — Dec...', '13 May', '13 May', '09:15', '12:00', 'Late', const Color(0xFFFEF3C7), const Color(0xFF92400E)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _attRow(String i, Color c, String n, String course, String sd, String ad, String tin, String tout, String st, Color stBg, Color stFg) {
    return DataRow(
      cells: [
        DataCell(_empAv(i, n, bg: c)),
        DataCell(Text(course)),
        DataCell(Text(sd)),
        DataCell(Text(ad)),
        DataCell(Text(tin)),
        DataCell(Text(tout)),
        DataCell(_pill(st, stBg, stFg)),
        DataCell(OutlinedButton(onPressed: () => _toast('Edit $n'), child: const Text('Edit'))),
      ],
    );
  }

  Widget _historyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _toolbarCard(
            left: Wrap(
              spacing: 8,
              children: [
                _dd('hist_status', 'All status', const ['All status', 'Pending', 'Completed']),
                _dd('hist_dept', 'All departments', const ['All departments']),
                _dd('hist_course', 'All courses', const ['All courses']),
                SizedBox(
                  width: 180,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search employee...',
                      isDense: true,
                      prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.muted),
                      filled: true,
                      fillColor: AppColors.bg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                TextButton(onPressed: () => _toast('Reset'), child: const Text('Reset')),
              ],
            ),
            right: OutlinedButton(onPressed: () => _toast('Export history'), child: const Text('Export history')),
          ),
          const SizedBox(height: 16),
          _tableCard(
            child: HrFullWidthDataTable(
              headingRowColor: const Color(0xFFF5F0E8),
              columnSpecs: const [
                ('Employee', 1.5),
                ('Course title', 1.6),
                ('Date', 1.0),
                ('Days', 0.6),
                ('Fee', 0.7),
                ('Approved by', 1.4),
                ('Status', 0.9),
                ('Action', 0.7),
              ],
              rows: [
                _histRow('SL', Colors.blue, 'Sarah Lim', 'Leadership essent...', '12-14 May', '3', '500', 'David Ng · pending', true, false, 'Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
                _histRow('RK', Colors.green, 'Raj Kumar', 'Excel advanced', '6-7 May', '2', '200', 'David Ng ✓', false, true, 'Compl...', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                _histRow('MT', Colors.purple, 'Maya Tan', 'Public speaking', '20 May', '1', '0', 'Nina Reza ✓', false, true, 'Allocat...', const Color(0xFFD1FAE5), const Color(0xFF166534)),
                _histRow('NC', Colors.teal, 'Nadia Chen', 'Annual leave work...', '5-6 May', '2', '0', 'Kevin Lim ✘', false, false, 'Denied', AppColors.errorSurface, AppColors.danger),
                _histRow('ZN', Colors.pink, 'Zara Nor', 'Agile & Scrum', '20 Apr', '5', '3200', 'Malik Said ✓', false, true, 'Cancelled', AppColors.bg, AppColors.textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _histRow(
    String i,
    Color av,
    String name,
    String course,
    String date,
    String days,
    String fee,
    String appr,
    bool pendingRed,
    bool greenCheck,
    String status,
    Color stBg,
    Color stFg,
  ) {
    return DataRow(
      cells: [
        DataCell(_empAv(i, name, bg: av)),
        DataCell(Text(course)),
        DataCell(Text(date)),
        DataCell(Text(days)),
        DataCell(Text(fee)),
        DataCell(
          Row(
            children: [
              Expanded(
                child: Text(
                  appr,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: pendingRed ? AppColors.danger : (greenCheck ? AppColors.success : AppColors.navy),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell(_pill(status, stBg, stFg)),
        DataCell(TextButton(onPressed: () => _toast('View $name'), child: const Text('View'))),
      ],
    );
  }

  Widget _empAv(String initials, String name, {Color? bg}) {
    final b = bg ?? AppColors.primary;
    return Row(
      children: [
        CircleAvatar(radius: 14, backgroundColor: b.withValues(alpha: 0.2), child: Text(initials, style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w800))),
        const SizedBox(width: 8),
        Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _toolbarCard({required Widget left, required Widget right}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: [left, right],
      ),
    );
  }

  Widget _tableCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

  Widget _pill(String t, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(t, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }

  Widget _dd(String id, String initial, List<String> items) {
    String resolved() {
      final s = _trainingDd[id];
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
            if (nv != null) setState(() => _trainingDd[id] = nv);
          },
        ),
      ),
    );
  }
}

// ——— Training request (two columns) ———

class _TrainingRequestPane extends StatefulWidget {
  const _TrainingRequestPane();

  @override
  State<_TrainingRequestPane> createState() => _TrainingRequestPaneState();
}

class _TrainingRequestPaneState extends State<_TrainingRequestPane> {
  bool _s1 = true;
  bool _s2 = true;
  bool _s3 = false;
  bool _email = true;
  String _coursePick = '-- Select course --';

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _summaryBar(),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final form = _formCard();
              final tracker = _trackerCard();
              if (c.maxWidth < 1000) {
                return Column(children: [form, const SizedBox(height: 16), tracker]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: form),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: tracker),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _summaryBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        children: [
          Text('My training requests', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
          Wrap(
            spacing: 8,
            children: [
              _sumPill('Pending', '2', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
              _sumPill('Allocated', '3', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
              _sumPill('Denied', '1', AppColors.errorSurface, AppColors.danger),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                onPressed: () => _toast('New request'),
                child: const Text('+ New request'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sumPill(String k, String v, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text('$k: $v', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, color: fg, fontSize: 12)),
    );
  }

  Widget _formCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('New training request', style: GoogleFonts.sora(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Text.rich(TextSpan(text: 'Course title ', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600), children: const [TextSpan(text: '*', style: TextStyle(color: Colors.red))])),
          const SizedBox(height: 6),
          _drop(_coursePick, const ['-- Select course --', 'Leadership essentials'], (nv) => setState(() => _coursePick = nv ?? _coursePick)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text.rich(TextSpan(text: 'Date from ', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600), children: const [TextSpan(text: '*', style: TextStyle(color: Colors.red))])),
                const SizedBox(height: 6),
                TextFormField(initialValue: '12/05/2026', decoration: _dec().copyWith(suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18))),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text.rich(TextSpan(text: 'Date to ', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600), children: const [TextSpan(text: '*', style: TextStyle(color: Colors.red))])),
                const SizedBox(height: 6),
                TextFormField(initialValue: '14/05/2026', decoration: _dec().copyWith(suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18))),
              ])),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('No. of days', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextFormField(initialValue: '3', readOnly: true, decoration: _dec(fill: AppColors.bg)),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('Course fee (MYR)', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextFormField(initialValue: '500.00', readOnly: true, decoration: _dec(fill: AppColors.bg)),
              ])),
            ],
          ),
          const SizedBox(height: 12),
          Text.rich(TextSpan(text: 'Training schedule selection ', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600), children: const [TextSpan(text: '*', style: TextStyle(color: Colors.red))])),
          const SizedBox(height: 8),
          CheckboxListTile(value: _s1, onChanged: (v) => setState(() => _s1 = v ?? false), title: Text('Team leadership — 12 May, 09:00–13:00', style: GoogleFonts.dmSans(fontSize: 13)), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading),
          CheckboxListTile(value: _s2, onChanged: (v) => setState(() => _s2 = v ?? false), title: Text('Decision making — 13 May, 09:00–12:00', style: GoogleFonts.dmSans(fontSize: 13)), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading),
          CheckboxListTile(value: _s3, onChanged: (v) => setState(() => _s3 = v ?? false), title: Text('Conflict resolution — 14 May, 14:00–17:00', style: GoogleFonts.dmSans(fontSize: 13)), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading),
          const SizedBox(height: 8),
          Text.rich(TextSpan(text: 'Location ', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600), children: const [TextSpan(text: '*', style: TextStyle(color: Colors.red))])),
          const SizedBox(height: 6),
          TextFormField(decoration: _dec(hint: 'e.g. Training room A, Level 3')),
          const SizedBox(height: 12),
          Text('Request reason', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextFormField(maxLines: 3, decoration: _dec(hint: 'Reason for this training request...')),
          CheckboxListTile(value: _email, onChanged: (v) => setState(() => _email = v ?? true), title: Text('Send email notification to approver', style: GoogleFonts.dmSans(fontSize: 13)), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton(onPressed: () => _toast('Cancelled'), child: const Text('Cancel')),
              const SizedBox(width: 12),
              OutlinedButton(onPressed: () => _toast('Submitted'), child: const Text('Submit request')),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _dec({String? hint, Color? fill}) {
    return InputDecoration(
      hintText: hint,
      filled: fill != null,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
    );
  }

  Widget _drop(String value, List<String> items, ValueChanged<String?> onChanged) {
    final safe = items.contains(value) ? value : items.first;
    return InputDecorator(
      decoration: _dec(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(isExpanded: true, value: safe, icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged),
      ),
    );
  }

  Widget _trackerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('My training (status tracker)', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          DataTable(
            headingRowColor: WidgetStateProperty.all(AppColors.bg),
            columns: const [
              DataColumn(label: Text('Course')),
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('')),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text('Excel advanced')),
                const DataCell(Text('6-7 May')),
                DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(8)), child: Text('Allocated', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF065F46))))),
                DataCell(TextButton(onPressed: () => _toast('View'), child: const Text('View'))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Leadership')),
                const DataCell(Text('12-14 May')),
                DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(8)), child: Text('Pending', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFC2410C))))),
                DataCell(TextButton(onPressed: () => _toast('View'), child: const Text('View'))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Public speaking')),
                const DataCell(Text('20 May')),
                DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(8)), child: Text('Pending', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFC2410C))))),
                DataCell(TextButton(onPressed: () => _toast('Cancel'), child: const Text('Cancel'))),
              ]),
              DataRow(cells: [
                const DataCell(Text('ISO 9001')),
                const DataCell(Text('2 May')),
                DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFCCFBF1), borderRadius: BorderRadius.circular(8)), child: Text('Completed', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF0F766E))))),
                DataCell(TextButton(onPressed: () => _toast('View'), child: const Text('View'))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Agile & Scrum')),
                const DataCell(Text('20 Apr')),
                DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: AppColors.errorSurface, borderRadius: BorderRadius.circular(8)), child: Text('Denied', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.danger)))),
                DataCell(TextButton(onPressed: () => _toast('View'), child: const Text('View'))),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}

// ——— Request on behalf ———

class _RequestOnBehalfPane extends StatefulWidget {
  const _RequestOnBehalfPane();

  @override
  State<_RequestOnBehalfPane> createState() => _RequestOnBehalfPaneState();
}

class _RequestOnBehalfPaneState extends State<_RequestOnBehalfPane> {
  bool _sl = true;
  bool _rk = true;
  bool _al = false;
  bool _email = true;
  bool _approveNow = false;
  String _submitFor = 'Individual employee';
  String _department = '-- Select --';
  String _behalfCourse = 'Leadership essentials (12-14 May)';

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFFF5F0E8), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text('Submit training request on behalf of employees', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                  onPressed: () => _toast('New on-behalf request'),
                  child: const Text('+ New on-behalf request'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final form = Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Request on behalf', style: GoogleFonts.sora(fontSize: 17, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    _sec('Select employees'),
                    Text('Submit for', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _behalfDrop(_submitFor, const ['Individual employee', 'Department'], (nv) => setState(() => _submitFor = nv ?? _submitFor)),
                    const SizedBox(height: 12),
                    Text('Department', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _behalfDrop(_department, const ['-- Select --', 'Engineering', 'Operations'], (nv) => setState(() => _department = nv ?? _department)),
                    const SizedBox(height: 12),
                    Text('Employees', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    CheckboxListTile(value: _sl, onChanged: (v) => setState(() => _sl = v ?? false), title: const Text('Sarah Lim (EMP-0021) — Engineering'), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading),
                    CheckboxListTile(value: _rk, onChanged: (v) => setState(() => _rk = v ?? false), title: const Text('Raj Kumar (EMP-0048) — Engineering'), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading),
                    CheckboxListTile(value: _al, onChanged: (v) => setState(() => _al = v ?? false), title: const Text('Ahmad Luqman (EMP-0187) — Operations'), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading),
                    const SizedBox(height: 16),
                    _sec('Training details'),
                    Text('Course title', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _behalfDrop(_behalfCourse, const ['Leadership essentials (12-14 May)', 'Excel advanced'], (nv) => setState(() => _behalfCourse = nv ?? _behalfCourse)),
                    const SizedBox(height: 12),
                    Text('Location', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextFormField(initialValue: 'Training room A', decoration: _bd()),
                    const SizedBox(height: 12),
                    Text('Company contribution', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextFormField(initialValue: '100% / Fixed MY', decoration: _bd()),
                    CheckboxListTile(value: _email, onChanged: (v) => setState(() => _email = v ?? true), title: const Text('Send email to approver'), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading),
                    CheckboxListTile(value: _approveNow, onChanged: (v) => setState(() => _approveNow = v ?? false), title: const Text('Approve now (bypass email approval)'), contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        OutlinedButton(onPressed: () => _toast('Cancelled'), child: const Text('Cancel')),
                        const SizedBox(width: 12),
                        FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                          onPressed: () => _toast('Submit on behalf'),
                          child: const Text('Submit on behalf'),
                        ),
                      ],
                    ),
                  ],
                ),
              );

              final table = Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('My submitted requests on behalf', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('Employee')),
                        DataColumn(label: Text('Course')),
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(_miniEmp('SL', 'Sarah L', Colors.blue)),
                          const DataCell(Text('Leadership')),
                          const DataCell(Text('12 May')),
                          DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(8)), child: Text('Approved', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF065F46))))),
                        ]),
                        DataRow(cells: [
                          DataCell(_miniEmp('RK', 'Raj K', Colors.green)),
                          const DataCell(Text('Leadership')),
                          const DataCell(Text('12 May')),
                          DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(8)), child: Text('Pending', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFC2410C))))),
                        ]),
                        DataRow(cells: [
                          DataCell(_miniEmp('AL', 'Ahmad L', Colors.orange)),
                          const DataCell(Text('ISO 9001')),
                          const DataCell(Text('2 May')),
                          DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFCCFBF1), borderRadius: BorderRadius.circular(8)), child: Text('Completed', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF0F766E))))),
                        ]),
                      ],
                    ),
                  ],
                ),
              );

              if (c.maxWidth < 960) {
                return Column(children: [form, const SizedBox(height: 16), table]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: form),
                  const SizedBox(width: 16),
                  Expanded(child: table),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sec(String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(20)),
          child: Text(t, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ),
      ),
    );
  }

  InputDecoration _bd() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
    );
  }

  Widget _behalfDrop(String value, List<String> items, ValueChanged<String?> onChanged) {
    final safe = items.contains(value) ? value : items.first;
    return InputDecorator(
      decoration: _bd(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(isExpanded: true, value: safe, icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted), items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChanged),
      ),
    );
  }

  Widget _miniEmp(String i, String n, Color c) {
    return Row(
      children: [
        CircleAvatar(radius: 12, backgroundColor: c.withValues(alpha: 0.2), child: Text(i, style: GoogleFonts.dmSans(fontSize: 8, fontWeight: FontWeight.w800))),
        const SizedBox(width: 6),
        Text(n, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
