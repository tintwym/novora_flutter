import 'package:flutter/material.dart';
import '../../../shared/widgets/module_shell_background.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/hr_full_width_data_table.dart';
import '../../../shared/widgets/hr_module_header.dart';

/// Performance Management — mock-aligned with reference UI (levels, grades, KPI, evaluation flow).
class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen>
    with SingleTickerProviderStateMixin {
  static const _evalBadge = 3;

  late final TabController _tab = TabController(length: 12, vsync: this);
  final Map<String, String> _dd = {};

  bool _evaluationFormOpen = false;

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _toast(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  String _d(String id, String initial, List<String> items) {
    final s = _dd[id];
    if (s != null && items.contains(s)) return s;
    return items.contains(initial) ? initial : items.first;
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HrModuleHeader(
          moduleSubtitle: 'PERFORMANCE MANAGEMENT',
          showYearFilter: true,
          navyPrimaryButton: true,
          primaryActionLabel: '+ New evaluation',
          onPrimaryAction: () {
            setState(() {
              _evaluationFormOpen = true;
              _tab.index = 7;
            });
            _toast('New evaluation');
          },
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
            onTap: (i) {
              if (i != 7) {
                setState(() => _evaluationFormOpen = false);
              }
            },
            tabs: [
              _perfTab('Perf. level'),
              _perfTab('Perf. grade'),
              _perfTab('KPI setting'),
              _perfTab('Eval. type'),
              _perfTab('Eval. category'),
              _perfTab('Eval. setup'),
              _perfTab('Grant permissions'),
              _perfTab('Evaluation', badge: _evalBadge),
              _perfTab('Perf. result'),
              _perfTab('Competency list'),
              _perfTab('Review report'),
              _perfTab('Employee profile'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _perfLevelTab(),
              _perfGradeTab(),
              _kpiSettingTab(),
              _evalTypeTab(),
              _evalCategoryTab(),
              _evalSetupTab(),
              _grantPermissionsTab(),
              _evaluationTab(),
              _perfResultTab(),
              _competencyTab(),
              _reviewReportTab(),
              _employeeProfileTab(),
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
        title: Text('Performance', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: body,
    );
  }

  Widget _perfTab(String label, {int badge = 0}) {
    return Tab(
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1),
          ),
          if (badge > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$badge',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.warning,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _scrollBody(List<Widget> children) {
    return ColoredBox(
      color: AppColors.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }

  Widget _toolbarRow(List<Widget> leading, List<Widget> trailing) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Wrap(spacing: 8, runSpacing: 8, children: leading),
        Wrap(spacing: 8, runSpacing: 8, children: trailing),
      ],
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

  Widget _searchField(String hint, {double maxW = 280}) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxW),
      child: TextField(
        style: GoogleFonts.dmSans(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          filled: true,
          fillColor: AppColors.bg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }

  Widget _filterDd(String id, String initial, List<String> items) {
    final v = _d(id, initial, items);
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.bg,
        ),
        child: DropdownButton<String>(
          value: v,
          icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (nv) {
            if (nv != null) setState(() => _dd[id] = nv);
          },
        ),
      ),
    );
  }

  Widget _primaryBtn(String label, VoidCallback onTap) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }

  Widget _linkBtn(String label, VoidCallback onTap) {
    return TextButton(onPressed: onTap, child: Text(label));
  }

  Widget _yesNoPill(bool yes) {
    return _statusPill(
      yes ? 'Yes' : 'No',
      yes ? const Color(0xFFD1FAE5) : AppColors.bg,
      yes ? const Color(0xFF065F46) : AppColors.textMuted,
    );
  }

  Widget _statusPill(String t, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(t, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }

  Widget _avatarName(String initials, String name, Color bg) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: bg,
          child: Text(
            initials,
            style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.navy),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _gradeLetterBox(String letter, Color bg) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(letter, style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, fontSize: 13)),
    );
  }

  Widget _kpiSectionTitle(String title, String badgeLabel, Color badgeBg, Color badgeFg) {
    return Row(
      children: [
        Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(width: 8),
        _statusPill(badgeLabel, badgeBg, badgeFg),
      ],
    );
  }

  Widget _kpiScoreCircle(String score, Color fg, Color bg) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bg),
      child: Text(score, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w800, color: fg)),
    );
  }

  // --- Tabs ---

  Widget _perfLevelTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [_searchField('Search level...')],
          [_primaryBtn('+ New level', () => _toast('New level'))],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: HrFullWidthDataTable(
          headingRowColor: AppColors.bg,
          columnSpecs: const [
            ('No.', 0.45),
            ('Level name', 1.2),
            ('Description', 2.4),
            ('Employees', 0.85),
            ('Status', 0.7),
            ('', 0.55),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('1')),
              const DataCell(Text('Basic')),
              const DataCell(Text('Entry-level performance expectation')),
              DataCell(_linkBtn('148', () => _toast('Employees'))),
              DataCell(_statusPill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('Edit', () => _toast('Edit'))),
            ]),
            DataRow(cells: [
              const DataCell(Text('2')),
              const DataCell(Text('Intermediate')),
              const DataCell(Text('Mid-level, meets most expectations')),
              DataCell(_linkBtn('612', () => _toast('Employees'))),
              DataCell(_statusPill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('Edit', () => _toast('Edit'))),
            ]),
            DataRow(cells: [
              const DataCell(Text('3')),
              const DataCell(Text('Advanced')),
              const DataCell(Text('Senior-level, consistently exceeds targets')),
              DataCell(_linkBtn('394', () => _toast('Employees'))),
              DataCell(_statusPill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('Edit', () => _toast('Edit'))),
            ]),
            DataRow(cells: [
              const DataCell(Text('4')),
              const DataCell(Text('Expert')),
              const DataCell(Text('Top-tier, role model for department')),
              DataCell(_linkBtn('130', () => _toast('Employees'))),
              DataCell(_statusPill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('Edit', () => _toast('Edit'))),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _perfGradeTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [_searchField('Search grade...')],
          [_primaryBtn('+ New grade', () => _toast('New grade'))],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: HrFullWidthDataTable(
          headingRowColor: AppColors.bg,
          columnSpecs: const [
            ('Grade', 0.55),
            ('Grade name', 1.2),
            ('Mark from', 0.65),
            ('Mark to', 0.65),
            ('Apply for performance', 1.1),
            ('Employees', 0.85),
            ('', 0.45),
          ],
          rows: [
            DataRow(cells: [
              DataCell(_gradeLetterBox('A', const Color(0xFFDBEAFE))),
              const DataCell(Text('Excellent')),
              const DataCell(Text('80')),
              const DataCell(Text('100')),
              DataCell(_yesNoPill(true)),
              DataCell(_linkBtn('186', () {})),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              DataCell(_gradeLetterBox('B', const Color(0xFFD1FAE5))),
              const DataCell(Text('Good')),
              const DataCell(Text('65')),
              const DataCell(Text('79')),
              DataCell(_yesNoPill(true)),
              DataCell(_linkBtn('542', () {})),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              DataCell(_gradeLetterBox('C', const Color(0xFFFFEDD5))),
              const DataCell(Text('Satisfactory')),
              const DataCell(Text('50')),
              const DataCell(Text('64')),
              DataCell(_yesNoPill(true)),
              DataCell(_linkBtn('398', () {})),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              DataCell(_gradeLetterBox('D', AppColors.errorSurface)),
              const DataCell(Text('Needs improvement')),
              const DataCell(Text('30')),
              const DataCell(Text('49')),
              DataCell(_yesNoPill(true)),
              DataCell(_linkBtn('158', () {})),
              DataCell(_linkBtn('Edit', () {})),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _kpiMiniTable(String title, String badge, Color bBg, Color bFg, List<DataRow> rows) {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _kpiSectionTitle(title, badge, bBg, bFg),
          const SizedBox(height: 12),
          HrFullWidthDataTable(
            headingRowColor: AppColors.bg,
            columnSpecs: const [
              ('From %', 0.7),
              ('To %', 0.7),
              ('Target %', 1.0),
              ('KPI score', 0.85),
              ('', 0.45),
            ],
            rows: rows,
          ),
        ],
      ),
    );
  }

  Widget _kpiSettingTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [_filterDd('kpi_types', 'All KPI types', const ['All KPI types', 'Attendance', 'Achievement'])],
          [_primaryBtn('+ New KPI setting', () => _toast('New KPI setting'))],
        ),
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          if (c.maxWidth > 900) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _kpiMiniTable(
                    'Attendance KPI',
                    'Attendance',
                    const Color(0xFFDBEAFE),
                    AppColors.brandBlueDeep,
                    [
                      DataRow(cells: [
                        const DataCell(Text('95')),
                        const DataCell(Text('100')),
                        DataCell(Text('100%', style: GoogleFonts.dmSans(color: AppColors.success, fontWeight: FontWeight.w700))),
                        DataCell(_kpiScoreCircle('100', AppColors.success, const Color(0xFFD1FAE5))),
                        DataCell(_linkBtn('Edit', () {})),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('85')),
                        const DataCell(Text('94')),
                        DataCell(Text('85%', style: GoogleFonts.dmSans(color: AppColors.primary, fontWeight: FontWeight.w700))),
                        DataCell(_kpiScoreCircle('85', AppColors.primary, const Color(0xFFDBEAFE))),
                        DataCell(_linkBtn('Edit', () {})),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('70')),
                        const DataCell(Text('84')),
                        DataCell(Text('70%', style: GoogleFonts.dmSans(color: AppColors.warning, fontWeight: FontWeight.w700))),
                        DataCell(_kpiScoreCircle('70', AppColors.warning, const Color(0xFFFEF3C7))),
                        DataCell(_linkBtn('Edit', () {})),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('0')),
                        const DataCell(Text('69')),
                        DataCell(Text('Below target', style: GoogleFonts.dmSans(color: AppColors.danger, fontWeight: FontWeight.w700))),
                        DataCell(_kpiScoreCircle('0', AppColors.danger, AppColors.errorSurface)),
                        DataCell(_linkBtn('Edit', () {})),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _kpiMiniTable(
                    'Achievement KPI',
                    'Achievement',
                    const Color(0xFFEDE9FE),
                    const Color(0xFF5B21B6),
                    [
                      DataRow(cells: [
                        const DataCell(Text('90')),
                        const DataCell(Text('100')),
                        DataCell(Text('100%', style: GoogleFonts.dmSans(color: AppColors.success, fontWeight: FontWeight.w700))),
                        DataCell(_kpiScoreCircle('100', AppColors.success, const Color(0xFFD1FAE5))),
                        DataCell(_linkBtn('Edit', () {})),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('75')),
                        const DataCell(Text('89')),
                        DataCell(Text('80%', style: GoogleFonts.dmSans(color: AppColors.primary, fontWeight: FontWeight.w700))),
                        DataCell(_kpiScoreCircle('80', AppColors.primary, const Color(0xFFDBEAFE))),
                        DataCell(_linkBtn('Edit', () {})),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('60')),
                        const DataCell(Text('74')),
                        DataCell(Text('65%', style: GoogleFonts.dmSans(color: AppColors.warning, fontWeight: FontWeight.w700))),
                        DataCell(_kpiScoreCircle('65', AppColors.warning, const Color(0xFFFEF3C7))),
                        DataCell(_linkBtn('Edit', () {})),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('0')),
                        const DataCell(Text('59')),
                        DataCell(Text('Below target', style: GoogleFonts.dmSans(color: AppColors.danger, fontWeight: FontWeight.w700))),
                        DataCell(_kpiScoreCircle('0', AppColors.danger, AppColors.errorSurface)),
                        DataCell(_linkBtn('Edit', () {})),
                      ]),
                    ],
                  ),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _kpiMiniTable(
                'Attendance KPI',
                'Attendance',
                const Color(0xFFDBEAFE),
                AppColors.brandBlueDeep,
                [
                  DataRow(cells: [
                    const DataCell(Text('95')),
                    const DataCell(Text('100')),
                    DataCell(Text('100%', style: GoogleFonts.dmSans(color: AppColors.success, fontWeight: FontWeight.w700))),
                    DataCell(_kpiScoreCircle('100', AppColors.success, const Color(0xFFD1FAE5))),
                    DataCell(_linkBtn('Edit', () {})),
                  ]),
                ],
              ),
              const SizedBox(height: 16),
              _kpiMiniTable(
                'Achievement KPI',
                'Achievement',
                const Color(0xFFEDE9FE),
                const Color(0xFF5B21B6),
                [
                  DataRow(cells: [
                    const DataCell(Text('90')),
                    const DataCell(Text('100')),
                    DataCell(Text('100%', style: GoogleFonts.dmSans(color: AppColors.success, fontWeight: FontWeight.w700))),
                    DataCell(_kpiScoreCircle('100', AppColors.success, const Color(0xFFD1FAE5))),
                    DataCell(_linkBtn('Edit', () {})),
                  ]),
                ],
              ),
            ],
          );
        },
      ),
    ]);
  }

  Widget _evalTypeTab() {
    return _scrollBody([
      _whiteCard(
        child: Align(
          alignment: Alignment.centerRight,
          child: _primaryBtn('+ New evaluation type', () => _toast('New type')),
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: HrFullWidthDataTable(
          headingRowColor: AppColors.bg,
          columnSpecs: const [
            ('Type name', 1.4),
            ('Every month', 0.85),
            ('Achieve KPI', 0.75),
            ('Notify before', 0.75),
            ('Trainee eval.', 0.75),
            ('Appraiser', 1.0),
            ('Status', 0.65),
            ('', 0.45),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('Mid-year appraisal')),
              const DataCell(Text('6 months')),
              DataCell(_yesNoPill(true)),
              const DataCell(Text('14 days')),
              DataCell(_yesNoPill(true)),
              const DataCell(Text('Direct manager')),
              DataCell(_statusPill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              const DataCell(Text('Year-end appraisal')),
              const DataCell(Text('12 months')),
              DataCell(_yesNoPill(true)),
              const DataCell(Text('30 days')),
              DataCell(_yesNoPill(false)),
              const DataCell(Text('Direct manager')),
              DataCell(_statusPill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              const DataCell(Text('Probation review')),
              const DataCell(Text('3 months')),
              DataCell(_yesNoPill(false)),
              const DataCell(Text('7 days')),
              DataCell(_yesNoPill(true)),
              const DataCell(Text('HOD → HR')),
              DataCell(_statusPill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              const DataCell(Text('Quarterly KPI review')),
              const DataCell(Text('3 months')),
              DataCell(_yesNoPill(true)),
              const DataCell(Text('7 days')),
              DataCell(_yesNoPill(false)),
              const DataCell(Text('Direct manager')),
              DataCell(_statusPill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('Edit', () {})),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _evalCategoryTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [_filterDd('eval_cat_kpi', 'All KPI types', const ['All KPI types', 'Attribute', 'KPI category'])],
          [_primaryBtn('+ New category', () => _toast('New category'))],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: HrFullWidthDataTable(
          headingRowColor: AppColors.bg,
          columnSpecs: const [
            ('Category name', 1.1),
            ('KPI type', 0.95),
            ('Weightage %', 0.65),
            ('Scoring scheme', 1.0),
            ('Measurement', 1.0),
            ('Definition levels', 0.85),
            ('', 0.45),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('Technical skills')),
              DataCell(_statusPill('Attribute', const Color(0xFFDBEAFE), AppColors.brandBlueDeep)),
              const DataCell(Text('25%')),
              const DataCell(Text('1–5 rating scale')),
              const DataCell(Text('Measurement index')),
              DataCell(_statusPill('4 levels', AppColors.bg, AppColors.textMuted)),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              const DataCell(Text('Communication')),
              DataCell(_statusPill('Attribute', const Color(0xFFDBEAFE), AppColors.brandBlueDeep)),
              const DataCell(Text('15%')),
              const DataCell(Text('1–5 rating scale')),
              const DataCell(Text('Measurement index')),
              DataCell(_statusPill('4 levels', AppColors.bg, AppColors.textMuted)),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              const DataCell(Text('Leadership')),
              DataCell(_statusPill('Competency', const Color(0xFFEDE9FE), const Color(0xFF5B21B6))),
              const DataCell(Text('20%')),
              const DataCell(Text('1–5 rating scale')),
              const DataCell(Text('Measurement index')),
              DataCell(_statusPill('4 levels', AppColors.bg, AppColors.textMuted)),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              const DataCell(Text('Project delivery')),
              DataCell(_statusPill('KPI category', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              const DataCell(Text('30%')),
              const DataCell(Text('% achievement')),
              const DataCell(Text('Target %')),
              DataCell(_statusPill('Auto-calc', AppColors.bg, AppColors.textMuted)),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              const DataCell(Text('Attendance')),
              DataCell(_statusPill('Attendance KPI', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              const DataCell(Text('10%')),
              const DataCell(Text('% attendance')),
              const DataCell(Text('Attendance %')),
              DataCell(_statusPill('Auto-calc', AppColors.bg, AppColors.textMuted)),
              DataCell(_linkBtn('Edit', () {})),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _setupCard({
    required String title,
    required List<(bool checked, String line)> categories,
    required List<(String k, String v)> settings,
  }) {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
              _statusPill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Linked evaluation categories',
            style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          ...categories.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(e.$1 ? Icons.check_box : Icons.check_box_outline_blank, size: 18, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(child: Text(e.$2, style: GoogleFonts.dmSans(fontSize: 13))),
                ],
              ),
            ),
          ),
          const Divider(height: 24),
          ...settings.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text(e.$1, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted))),
                  Text(e.$2, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.success)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _evalSetupTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [
            _filterDd(
              'eval_setup_type',
              'All evaluation types',
              const ['All evaluation types', 'Year-end', 'Probation'],
            ),
          ],
          [_primaryBtn('+ New setup', () => _toast('New setup'))],
        ),
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth > 960;
          final yearEnd = _setupCard(
            title: 'Year end appraisal — setup',
            categories: const [
              (true, 'Technical skills (Attribute — 25%)'),
              (true, 'Communication (Attribute — 15%)'),
              (true, 'Leadership (Competency — 20%)'),
              (true, 'Project delivery (KPI — 30%)'),
              (true, 'Attendance (Attendance KPI — 10%)'),
            ],
            settings: const [
              ('Total weightage', '100%'),
              ('Enable next period objectives', 'Yes'),
              ('Enable training required', 'Yes'),
              ('Enable CEP / career planning', 'Yes'),
              ('Enable appraiser note', 'Yes'),
            ],
          );
          final probation = _setupCard(
            title: 'Probation review — setup',
            categories: const [
              (true, 'Technical skills (Attribute — 40%)'),
              (true, 'Communication (Attribute — 30%)'),
              (false, 'Leadership (Competency — 0%)'),
              (false, 'Project delivery (KPI — 0%)'),
              (true, 'Attendance (Attendance KPI — 30%)'),
            ],
            settings: const [
              ('Total weightage', '100%'),
              ('Enable next period objectives', 'No'),
              ('Enable training required', 'Yes'),
              ('Enable CEP / career planning', 'No'),
              ('Enable appraiser note', 'Yes'),
            ],
          );
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: yearEnd),
                const SizedBox(width: 16),
                Expanded(child: probation),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              yearEnd,
              const SizedBox(height: 16),
              probation,
            ],
          );
        },
      ),
    ]);
  }

  Widget _grantPermissionsTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [
            _filterDd('gp_eval', 'All evaluation types', const ['All evaluation types', 'Year-end appraisal', 'Mid-year']),
            _filterDd('gp_status', 'All status', const ['All status', 'Active', 'Expired']),
          ],
          [_primaryBtn('+ Grant permission', () => _toast('Grant'))],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: HrFullWidthDataTable(
          headingRowColor: AppColors.bg,
          columnSpecs: const [
            ('Evaluator', 1.35),
            ('Evaluation type', 1.1),
            ('Review period from', 0.95),
            ('Review period to', 0.95),
            ('Pending', 0.85),
            ('Status', 0.7),
            ('', 1.2),
          ],
          rows: [
            DataRow(cells: [
              DataCell(_avatarName('DN', 'David Ng', const Color(0xFFDBEAFE))),
              const DataCell(Text('Year-end appraisal')),
              const DataCell(Text('1 Jan 2026')),
              const DataCell(Text('31 Jan 2026')),
              DataCell(_linkBtn('8 employees', () {})),
              DataCell(_statusPill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(
                Wrap(
                  spacing: 8,
                  children: [
                    _linkBtn('View list', () {}),
                    OutlinedButton(
                      onPressed: () => _toast('Hold'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger)),
                      child: const Text('Hold'),
                    ),
                  ],
                ),
              ),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('NR', 'Nina Rozzi', const Color(0xFFD1FAE5))),
              const DataCell(Text('Year-end appraisal')),
              const DataCell(Text('1 Jan 2026')),
              const DataCell(Text('31 Jan 2026')),
              DataCell(_linkBtn('5 employees', () {})),
              DataCell(_statusPill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(
                Wrap(
                  spacing: 8,
                  children: [
                    _linkBtn('View list', () {}),
                    OutlinedButton(
                      onPressed: () => _toast('Hold'),
                      style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger)),
                      child: const Text('Hold'),
                    ),
                  ],
                ),
              ),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('KL', 'Kevin Lim', const Color(0xFFFFE4E6))),
              const DataCell(Text('Mid-year appraisal')),
              const DataCell(Text('1 Jun 2025')),
              const DataCell(Text('30 Jun 2025')),
              DataCell(Text('0 pending', style: GoogleFonts.dmSans(color: AppColors.textMuted))),
              DataCell(_statusPill('Expired', AppColors.bg, AppColors.textMuted)),
              DataCell(
                Wrap(
                  spacing: 8,
                  children: [
                    _linkBtn('View list', () {}),
                    _primaryBtn('Re-grant', () => _toast('Re-grant')),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _evaluationTab() {
    if (_evaluationFormOpen) {
      return _evaluationEntryForm();
    }
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [
            _filterDd('ev_rt', 'All review types', const ['All review types', 'Year-end', 'Mid-year', 'Probation']),
            _filterDd('ev_st', 'All status', const ['All status', 'Pending', 'Completed']),
            _filterDd('ev_dp', 'All departments', const ['All departments', 'Engineering', 'HR']),
            _searchField('Search employee...', maxW: 220),
          ],
          [_primaryBtn('+ New evaluation', () => setState(() => _evaluationFormOpen = true))],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: HrFullWidthDataTable(
          headingRowColor: AppColors.bg,
          columnSpecs: const [
            ('Employee', 1.35),
            ('Review type', 1.0),
            ('Review date', 0.85),
            ('Review period', 1.0),
            ('Status', 0.75),
            ('', 0.55),
          ],
          rows: [
            DataRow(cells: [
              DataCell(_avatarName('SL', 'Sarah Lim', const Color(0xFFDBEAFE))),
              const DataCell(Text('Year-end appraisal')),
              const DataCell(Text('15 Jan 2026')),
              const DataCell(Text('Jan–Dec 2025')),
              DataCell(_statusPill('Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              DataCell(_linkBtn('Open', () => setState(() => _evaluationFormOpen = true))),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('RK', 'Raj Kumar', const Color(0xFFD1FAE5))),
              const DataCell(Text('Probation review')),
              const DataCell(Text('20 Jan 2026')),
              const DataCell(Text('Jan 2026')),
              DataCell(_statusPill('Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              DataCell(_linkBtn('Open', () => setState(() => _evaluationFormOpen = true))),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('AL', 'Ahmad L.', const Color(0xFFEDE9FE))),
              const DataCell(Text('Mid-year appraisal')),
              const DataCell(Text('10 Jul 2025')),
              const DataCell(Text('Jan–Jun 2025')),
              DataCell(_statusPill('Completed', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('Download', () => _toast('Download'))),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('NC', 'Nadia Chen', const Color(0xFFFFE4E6))),
              const DataCell(Text('Year-end appraisal')),
              const DataCell(Text('12 Jan 2025')),
              const DataCell(Text('Jan–Dec 2024')),
              DataCell(_statusPill('Completed', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('Download', () => _toast('Download'))),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _evaluationEntryForm() {
    return ColoredBox(
      color: AppColors.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                TextButton.icon(
                  key: const Key('perf_eval_back'),
                  onPressed: () => setState(() => _evaluationFormOpen = false),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to list'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _whiteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Evaluation entry',
                        style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 10),
                      _statusPill('Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, c) {
                      final row = c.maxWidth > 720;
                      final fields = [
                        _formFieldRO('Employee', 'Sarah Lim (EMP-0021)'),
                        _formFieldRO('Review type', 'Year-end appraisal'),
                        _formFieldRO('Review date', '15/01/2026'),
                        _formFieldRO('Review period', '1 Jan 2025 – 31 Dec 2025'),
                        _formFieldRO('Status', 'Pending (grade calculation)'),
                      ];
                      if (row) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: Column(children: fields.sublist(0, 3))),
                            const SizedBox(width: 24),
                            Expanded(child: Column(children: fields.sublist(3))),
                          ],
                        );
                      }
                      return Column(children: fields);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, c) {
                final wide = c.maxWidth > 1000;
                final scoring = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: () => _toast('Category list loaded'),
                      child: const Text('Load category list'),
                    ),
                    const SizedBox(height: 16),
                    _attributeRatingBlock(),
                    const SizedBox(height: 16),
                    _kpiDeliveryBlock(),
                    const SizedBox(height: 16),
                    _attendanceKpiBlock(),
                  ],
                );
                final sidebar = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Objectives for next period', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _outlineField('Category / objective'),
                    const SizedBox(height: 8),
                    _outlineField('Target'),
                    const SizedBox(height: 8),
                    Text('Training required', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _outlineField('Training course'),
                    const SizedBox(height: 8),
                    Text('CDP / career planning', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _outlineField('Possible position'),
                    const SizedBox(height: 8),
                    Text('Appraiser note', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Notes and remarks…',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                );
                if (wide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: scoring),
                      const SizedBox(width: 20),
                      Expanded(flex: 2, child: sidebar),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    scoring,
                    const SizedBox(height: 20),
                    sidebar,
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => _toast('Draft saved'), child: const Text('Save draft')),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    setState(() => _evaluationFormOpen = false);
                    _toast('Evaluation submitted');
                  },
                  child: const Text('Submit evaluation'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _formFieldRO(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _outlineField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _attributeRatingBlock() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attribute — technical skills (25%)',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          _ratingRow('Code quality & standards', 4),
          _ratingRow('Problem-solving ability', 5),
          _ratingRow('System design', 4),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Category score: 86.7 / 100',
              style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.navy),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingRow(String label, int selected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: GoogleFonts.dmSans(fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: Wrap(
              spacing: 6,
              children: List.generate(5, (i) {
                final v = i + 1;
                final on = v == selected;
                return CircleAvatar(
                  radius: 16,
                  backgroundColor: on ? AppColors.primary : AppColors.bg,
                  child: Text(
                    '$v',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: on ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                );
              }),
            ),
          ),
          Text('$selected/5', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _kpiDeliveryBlock() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KPI — project delivery (30%)',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          _kvNumberRow('Sprints completed on time', '92', '92%'),
          _kvNumberRow('Bugs resolved within SLA', '88', '88%'),
          const SizedBox(height: 8),
          Text(
            'Final score: auto-calculated',
            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _kvNumberRow(String k, String val, String pct) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(k)),
          Container(
            width: 64,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(val, textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          Text(pct, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _attendanceKpiBlock() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance KPI (10%)',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          Text('Attendance rate (auto): 97%', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 15)),
          Text('Based on review period attendance data', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _perfResultTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [
            _filterDd('pr_dept', 'All departments', const ['All departments', 'Engineering']),
            _filterDd('pr_grade', 'All grades', const ['All grades', 'A', 'B', 'C']),
            _filterDd('pr_period', 'Year-end 2023', const ['Year-end 2023', 'Year-end 2024', 'Year-end 2025']),
          ],
          [
            _linkBtn('Calculate grade', () => _toast('Calculate')),
            _primaryBtn('Export results', () => _toast('Export')),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: HrFullWidthDataTable(
          headingRowColor: AppColors.bg,
          columnSpecs: const [
            ('Employee', 1.4),
            ('Attr. score', 0.75),
            ('KPI score', 0.75),
            ('Comp. score', 0.75),
            ('Attend. score', 0.8),
            ('Total score', 0.85),
            ('Grade', 0.5),
            ('', 0.45),
          ],
          rows: [
            DataRow(cells: [
              DataCell(_avatarName('SL', 'Sarah Lim', const Color(0xFFDBEAFE))),
              const DataCell(Text('86.7')),
              const DataCell(Text('90.0')),
              const DataCell(Text('82.0')),
              const DataCell(Text('97.0')),
              DataCell(Text('91.7', style: GoogleFonts.dmSans(color: AppColors.primary, fontWeight: FontWeight.w800))),
              DataCell(_gradeLetterBox('A', const Color(0xFFDBEAFE))),
              DataCell(_linkBtn('Detail', () {})),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('RK', 'Raj Kumar', const Color(0xFFD1FAE5))),
              const DataCell(Text('80.0')),
              const DataCell(Text('88.0')),
              const DataCell(Text('79.0')),
              const DataCell(Text('95.0')),
              DataCell(Text('86.2', style: GoogleFonts.dmSans(color: AppColors.primary, fontWeight: FontWeight.w800))),
              DataCell(_gradeLetterBox('B', const Color(0xFFFFEDD5))),
              DataCell(_linkBtn('Detail', () {})),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('AL', 'Ahmad L', const Color(0xFFEDE9FE))),
              const DataCell(Text('52.0')),
              const DataCell(Text('55.0')),
              const DataCell(Text('50.0')),
              const DataCell(Text('80.0')),
              DataCell(Text('56.5', style: GoogleFonts.dmSans(color: AppColors.warning, fontWeight: FontWeight.w800))),
              DataCell(_gradeLetterBox('C', const Color(0xFFFFEDD5))),
              DataCell(_linkBtn('Detail', () {})),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _competencyTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [
            _filterDd('comp_type', 'All types', const ['All types', 'Competency', 'Sub-comp.']),
            _searchField('Search competency...'),
          ],
          [_primaryBtn('+ New competency', () => _toast('New competency'))],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: HrFullWidthDataTable(
          headingRowColor: AppColors.bg,
          columnSpecs: const [
            ('Competency name', 1.5),
            ('Type', 0.85),
            ('Parent competency', 1.0),
            ('Definition', 2.2),
            ('', 0.45),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('Leadership')),
              DataCell(_statusPill('Competency', const Color(0xFFEDE9FE), const Color(0xFF5B21B6))),
              const DataCell(Text('—')),
              const DataCell(Text('Ability to guide, inspire and influence a team')),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              DataCell(Text('↳ Team motivation', style: GoogleFonts.dmSans())),
              DataCell(_statusPill('Sub-comp.', const Color(0xFFDBEAFE), AppColors.brandBlueDeep)),
              const DataCell(Text('Leadership')),
              const DataCell(Text('Keeping team morale and engagement high')),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              DataCell(Text('↳ Conflict resolution', style: GoogleFonts.dmSans())),
              DataCell(_statusPill('Sub-comp.', const Color(0xFFDBEAFE), AppColors.brandBlueDeep)),
              const DataCell(Text('Leadership')),
              const DataCell(Text('Handling disagreements constructively')),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              const DataCell(Text('Problem solving')),
              DataCell(_statusPill('Competency', const Color(0xFFEDE9FE), const Color(0xFF5B21B6))),
              const DataCell(Text('—')),
              const DataCell(Text('Analytical thinking and solution design')),
              DataCell(_linkBtn('Edit', () {})),
            ]),
            DataRow(cells: [
              DataCell(Text('↳ Root cause analysis', style: GoogleFonts.dmSans())),
              DataCell(_statusPill('Sub-comp.', const Color(0xFFDBEAFE), AppColors.brandBlueDeep)),
              const DataCell(Text('Problem solving')),
              const DataCell(Text('Identifying underlying causes of issues')),
              DataCell(_linkBtn('Edit', () {})),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _reviewReportTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [
            _filterDd('rr_period', 'Year-end 2025', const ['Year-end 2025', 'Mid-year 2025', 'Year-end 2024']),
            _filterDd('rr_dept', 'All departments', const ['All departments', 'Engineering', 'HR']),
            _searchField('Search employee...', maxW: 200),
          ],
          [
            _linkBtn('Generate PDF', () => _toast('PDF')),
            _primaryBtn('Export all', () => _toast('Export all')),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: HrFullWidthDataTable(
          headingRowColor: AppColors.bg,
          columnSpecs: const [
            ('Employee', 1.35),
            ('Review type', 1.0),
            ('Review period', 1.0),
            ('Total score', 0.75),
            ('Grade', 0.55),
            ('Appraiser', 0.95),
            ('Status', 0.7),
            ('', 0.75),
          ],
          rows: [
            DataRow(cells: [
              DataCell(_avatarName('SL', 'Sarah Lim', const Color(0xFFDBEAFE))),
              const DataCell(Text('Year-end appraisal')),
              const DataCell(Text('Jan–Dec 2025')),
              DataCell(Text('91.7', style: GoogleFonts.dmSans(color: AppColors.primary, fontWeight: FontWeight.w700))),
              DataCell(_gradeLetterBox('A', const Color(0xFFDBEAFE))),
              const DataCell(Text('David Ng')),
              DataCell(_statusPill('Completed', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(Row(children: [_linkBtn('View', () {}), _linkBtn('PDF', () {})])),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('RK', 'Raj Kumar', const Color(0xFFD1FAE5))),
              const DataCell(Text('Mid-year appraisal')),
              const DataCell(Text('Jan–Jun 2025')),
              DataCell(Text('86.2', style: GoogleFonts.dmSans(color: AppColors.primary, fontWeight: FontWeight.w700))),
              DataCell(_gradeLetterBox('B', const Color(0xFFFFEDD5))),
              const DataCell(Text('Kevin Lim')),
              DataCell(_statusPill('Completed', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(Row(children: [_linkBtn('View', () {}), _linkBtn('PDF', () {})])),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _employeeProfileTab() {
    return _scrollBody([
      _whiteCard(
        child: _filterDd(
          'emp_pick',
          'Sarah Lim (EMP-0021)',
          const ['Sarah Lim (EMP-0021)', 'Raj Kumar (EMP-0044)', 'Ahmad L. (EMP-0088)'],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFDBEAFE),
              child: Text('SL', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sarah Lim Wei Ling', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(
                    'EMP-0021 · Engineering · Senior Developer',
                    style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth > 900;
          final left = _whiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kvBadge('Performance level', 'Advanced', const Color(0xFFDBEAFE), AppColors.brandBlueDeep),
                _kvBadge('Current grade (latest)', '', const Color(0xFFDBEAFE), AppColors.navy, trailing: _gradeLetterBox('A', const Color(0xFFDBEAFE))),
                _kvLine('Latest score', Text('91.7 / 100', style: GoogleFonts.dmSans(color: AppColors.primary, fontWeight: FontWeight.w800))),
                _kvLine('Last review', Text('Year-end appraisal — Jan 2026')),
                _kvBadge('CEP rating', 'High potential', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                _kvLine('Possible next position', Text('Tech Lead')),
                _kvLine('Time frame', Text('12 months')),
                const Divider(height: 28),
                Text('Score breakdown', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                _barRow('Technical skills (attr.)', 0.87, AppColors.navy),
                _barRow('Project delivery (KPI)', 0.9, AppColors.secondaryAccent),
                _barRow('Leadership (comp.)', 0.82, const Color(0xFF7C3AED)),
                _barRow('Communication (attr.)', 0.88, AppColors.warning),
                _barRow('Attendance KPI', 0.97, AppColors.success),
                const SizedBox(height: 12),
                Text(
                  'Overall score 91.7 / 100',
                  style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ],
            ),
          );
          final right = _whiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Review history', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                HrFullWidthDataTable(
                  headingRowColor: AppColors.bg,
                  columnSpecs: const [
                    ('Review type', 1.2),
                    ('Period', 0.75),
                    ('Score', 0.65),
                    ('Grade', 0.55),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('Year-end appraisal')),
                      const DataCell(Text('2025')),
                      const DataCell(Text('91.7')),
                      DataCell(_gradeLetterBox('A', const Color(0xFFDBEAFE))),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Mid-year appraisal')),
                      const DataCell(Text('H1 2025')),
                      const DataCell(Text('87.3')),
                      DataCell(_gradeLetterBox('A', const Color(0xFFDBEAFE))),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Year-end appraisal')),
                      const DataCell(Text('2023')),
                      const DataCell(Text('75.2')),
                      DataCell(_gradeLetterBox('B', const Color(0xFFFFEDD5))),
                    ]),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Training recommended', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                _trainingRecRow('Leadership essentials', true),
                _trainingRecRow('Agile & Scrum', false),
                const SizedBox(height: 16),
                Text('Appraiser note (latest)', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(
                  'Strong technical contributor with consistent improvement. '
                  'Nominated for tech lead role in Q3 2026. Recommended for leadership training before promotion cycle.',
                  style: GoogleFonts.dmSans(fontSize: 13, height: 1.45),
                ),
                const SizedBox(height: 8),
                Text(
                  '— David Ng · 15 Jan 2026',
                  style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          );
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 16),
                Expanded(child: right),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              left,
              const SizedBox(height: 16),
              right,
            ],
          );
        },
      ),
    ]);
  }

  Widget _kvBadge(String k, String v, Color bg, Color fg, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(k, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
          ),
          if (trailing != null)
            trailing
          else
            _statusPill(v.isEmpty ? '—' : v, bg, fg),
        ],
      ),
    );
  }

  Widget _kvLine(String k, Widget value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(k, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
          ),
          Expanded(child: value),
        ],
      ),
    );
  }

  Widget _barRow(String label, double frac, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: GoogleFonts.dmSans(fontSize: 12))),
              Text(
                (frac * 100).toStringAsFixed(1),
                style: GoogleFonts.dmSans(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRoundedRect(
            radius: 4,
            child: LinearProgressIndicator(
              value: frac,
              minHeight: 8,
              backgroundColor: AppColors.border,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _trainingRecRow(String title, bool mandatory) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          _statusPill(
            mandatory ? 'Mandatory' : 'Optional',
            mandatory ? AppColors.errorSurface : AppColors.bg,
            mandatory ? AppColors.danger : AppColors.textMuted,
          ),
        ],
      ),
    );
  }
}

/// Clip rounded corners for [LinearProgressIndicator].
class ClipRoundedRect extends StatelessWidget {
  const ClipRoundedRect({super.key, required this.radius, required this.child});

  final double radius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: child,
    );
  }
}
