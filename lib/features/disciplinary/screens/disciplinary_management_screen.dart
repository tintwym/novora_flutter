import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/hr_module_header.dart';

/// Disciplinary Management — mock-aligned tabs (Reason, Action, Setup, History).
class DisciplinaryManagementScreen extends StatefulWidget {
  const DisciplinaryManagementScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<DisciplinaryManagementScreen> createState() => _DisciplinaryManagementScreenState();
}

class _DisciplinaryManagementScreenState extends State<DisciplinaryManagementScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 4, vsync: this);

  final Map<String, String> _disciplinaryDd = {};

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
          moduleSubtitle: 'DISCIPLINARY MANAGEMENT',
          navyPrimaryButton: true,
          primaryActionLabel: '+ New disciplinary case',
          onPrimaryAction: () => _toast('New disciplinary case'),
        ),
        Material(
          color: Colors.white,
          child: TabBar(
            controller: _tab,
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            tabs: [
              _tabLbl(Icons.schedule, 'Disciplinary reason'),
              _tabLbl(Icons.gavel_outlined, 'Disciplinary action'),
              _tabLbl(Icons.article_outlined, 'Disciplinary setup'),
              _tabLbl(Icons.history, 'Disciplinary history'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _reasonTab(),
              _actionTab(),
              const _DisciplinarySetupTab(),
              _historyTab(),
            ],
          ),
        ),
      ],
    );

    if (widget.embeddedInShell) {
      return ColoredBox(color: AppColors.bg, child: body);
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Disciplinary Management', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: body,
    );
  }

  Widget _tabLbl(IconData icon, String text) {
    return Tab(
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Flexible(child: Text(text, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _reasonTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _card(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 240,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search reason...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                      filled: true,
                      fillColor: AppColors.bg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                  ),
                ),
                _dd('reason_severity', 'All severity', const ['All severity', 'Minor', 'Major', 'Gross misconduct']),
                OutlinedButton.icon(
                  onPressed: () => _toast('New reason'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New reason'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(AppColors.bg),
                dataRowMinHeight: 52,
                dataRowMaxHeight: 72,
                columns: const [
                  DataColumn(label: SizedBox(width: 28, child: Icon(Icons.drag_indicator, size: 18, color: AppColors.muted))),
                  DataColumn(label: Text('Reason / Offence')),
                  DataColumn(label: Text('Severity level')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: [
                  _reasonRow(
                    'Unauthorised absence',
                    'Minor',
                    const Color(0xFFFEF9C3),
                    const Color(0xFF854D0E),
                    'Repeated failure to follow attendance policy without notice.',
                    'Active',
                    const Color(0xFFD1FAE5),
                    const Color(0xFF065F46),
                  ),
                  _reasonRow(
                    'Insubordination',
                    'Major',
                    const Color(0xFFFCE7F3),
                    const Color(0xFF9D174D),
                    'Refusal to follow reasonable management instructions.',
                    'Active',
                    const Color(0xFFD1FAE5),
                    const Color(0xFF065F46),
                  ),
                  _reasonRow(
                    'Fraud / dishonesty',
                    'Gross misconduct',
                    const Color(0xFFFEE2E2),
                    const Color(0xFF991B1B),
                    'Theft, falsification of records, or breach of trust.',
                    'Active',
                    const Color(0xFFD1FAE5),
                    const Color(0xFF065F46),
                  ),
                  _reasonRow(
                    'Dress code violation',
                    'Minor',
                    AppColors.bg,
                    AppColors.textMuted,
                    'Non-compliance with company dress and presentation standards.',
                    'Inactive',
                    AppColors.bg,
                    AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _reasonRow(
    String reason,
    String severity,
    Color sevBg,
    Color sevFg,
    String desc,
    String status,
    Color stBg,
    Color stFg,
  ) {
    return DataRow(
      cells: [
        const DataCell(Icon(Icons.drag_indicator, size: 18, color: AppColors.muted)),
        DataCell(Text(reason, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600))),
        DataCell(_pill(severity, sevBg, sevFg)),
        DataCell(SizedBox(width: 280, child: Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.dmSans(fontSize: 12)))),
        DataCell(_pill(status, stBg, stFg)),
        DataCell(OutlinedButton(onPressed: () => _toast('Edit $reason'), child: const Text('Edit'))),
      ],
    );
  }

  Widget _actionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _card(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 220,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search action...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                      filled: true,
                      fillColor: AppColors.bg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                  ),
                ),
                _dd('action_levels', 'All levels', const ['All levels', 'L1', 'L2', 'L3', 'L4', 'L5', 'L6']),
                OutlinedButton.icon(
                  onPressed: () => _toast('New action'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New action'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFFF5F0E8)),
                dataRowMinHeight: 52,
                dataRowMaxHeight: 72,
                columns: const [
                  DataColumn(label: Text('Level')),
                  DataColumn(label: Text('Action name')),
                  DataColumn(label: Text('Action type')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Pay impact')),
                  DataColumn(label: Text('')),
                ],
                rows: [
                  _actionRow('L1', 'Verbal warning', 'Verbal', AppColors.bg, 'Informal verbal caution, not recorded on file.', 'No deduction', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                  _actionRow('L2', 'First written warning', 'Written', const Color(0xFFFFEDD5), 'Formal first written warning, filed with HR.', 'No deduction', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                  _actionRow('L3', 'Second written warning', 'Written', const Color(0xFFFFEDD5), 'Final written warning before escalation.', 'Partial deduction', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
                  _actionRow('L4', 'Suspension without pay', 'Suspension', AppColors.errorSurface, 'Temporary suspension pending investigation.', 'Full deduction', AppColors.errorSurface, AppColors.danger),
                  _actionRow('L5', 'Demotion', 'Grade change', const Color(0xFFEDE9FE), 'Reduction in job grade and responsibilities.', 'Pay review', AppColors.errorSurface, AppColors.danger),
                  _actionRow('L6', 'Termination', 'Dismissal', AppColors.errorSurface, 'Employment contract termination.', 'Full deduction', AppColors.errorSurface, AppColors.danger),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _actionRow(
    String level,
    String name,
    String typeLabel,
    Color typeBg,
    String desc,
    String pay,
    Color payBg,
    Color payFg,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(level, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
        DataCell(Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700))),
        DataCell(_pill(typeLabel, typeBg, AppColors.navy)),
        DataCell(SizedBox(width: 220, child: Text(desc, maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.dmSans(fontSize: 12)))),
        DataCell(_pill(pay, payBg, payFg)),
        DataCell(OutlinedButton(onPressed: () => _toast('Edit $name'), child: const Text('Edit'))),
      ],
    );
  }

  Widget _historyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _card(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    _dd('hist_status', 'All status', const ['All status', 'Pending', 'Acknowledged', 'Closed']),
                    _dd('hist_warnLevel', 'All warning levels', const ['All warning levels', 'L1', 'L2']),
                    _dd('hist_dept', 'All departments', const ['All departments', 'Operations']),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search employee...',
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.bg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    TextButton(onPressed: () => _toast('Generate PDF'), child: const Text('Generate PDF')),
                    FilledButton(onPressed: () => _toast('Export'), child: const Text('Export')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(AppColors.bg),
                dataRowMinHeight: 52,
                dataRowMaxHeight: 72,
                columns: const [
                  DataColumn(label: Text('Employee')),
                  DataColumn(label: Text('Reason / offence')),
                  DataColumn(label: Text('Incident date')),
                  DataColumn(label: Text('Action date')),
                  DataColumn(label: Text('Warning level')),
                  DataColumn(label: Text('Action issued by')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('')),
                ],
                rows: [
                  _histRow('AL', Colors.orange, 'Ahmad L', 'Unauthorised absence', '6 May 2026', '7 May 2026', 'L1 - Verbal warning', AppColors.bg, AppColors.textMuted, 'Nina Reza', 'Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
                  _histRow('ZN', Colors.purple, 'Zara Nor', 'Persistent lateness', '25 Apr 2026', '28 Apr 2026', 'L2 - First written warning', const Color(0xFFFFEDD5), const Color(0xFFC2410C), 'Malik Said', 'Acknowledged', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                  _histRow('RK', Colors.blue, 'Raj Kumar', 'Dress code violation', '8 Mar 2026', '10 Mar 2026', 'L1 - Verbal warning', AppColors.bg, AppColors.textMuted, 'David Ng', 'Closed', const Color(0xFFCCFBF1), const Color(0xFF0F766E)),
                  _histRow('ZN', Colors.purple, 'Zara Nor', 'Persistent lateness', '10 Jan 2026', '12 Jan 2026', 'L1 - Verbal warning', AppColors.bg, AppColors.textMuted, 'Malik Said', 'Closed', const Color(0xFFCCFBF1), const Color(0xFF0F766E)),
                  _histRow('NC', Colors.teal, 'Nadia Chen', 'Insubordination', '5 Nov 2025', '7 Nov 2025', 'L2 - First written warning', const Color(0xFFFFEDD5), const Color(0xFFC2410C), 'Kevin Lim', 'Closed', const Color(0xFFCCFBF1), const Color(0xFF0F766E)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _histRow(
    String initials,
    Color avBg,
    String name,
    String offence,
    String inc,
    String act,
    String warn,
    Color warnBg,
    Color warnFg,
    String issuer,
    String status,
    Color stBg,
    Color stFg,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: avBg.withValues(alpha: 0.25), child: Text(initials, style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w800))),
              const SizedBox(width: 8),
              Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        DataCell(SizedBox(width: 160, child: Text(offence, maxLines: 2, overflow: TextOverflow.ellipsis))),
        DataCell(Text(inc)),
        DataCell(Text(act)),
        DataCell(_pill(warn, warnBg, warnFg)),
        DataCell(Text(issuer)),
        DataCell(_pill(status, stBg, stFg)),
        DataCell(TextButton(onPressed: () => _toast('View $name'), child: const Text('View'))),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      final s = _disciplinaryDd[id];
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
            if (nv != null) setState(() => _disciplinaryDd[id] = nv);
          },
        ),
      ),
    );
  }
}

class _DisciplinarySetupTab extends StatefulWidget {
  const _DisciplinarySetupTab();

  @override
  State<_DisciplinarySetupTab> createState() => _DisciplinarySetupTabState();
}

class _DisciplinarySetupTabState extends State<_DisciplinarySetupTab> {
  String _employee = '-- Select employee --';
  String _reason = '-- Select reason --';
  String _witness = '-- Select witness (optional) --';
  String _level = 'Verbal warning';
  String _issuedBy = 'Nina Reza (Head of Operations)';
  String _nextAction = 'First written warning';

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0E8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              children: [
                Text('Create a new disciplinary case for an employee', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
                OutlinedButton.icon(
                  onPressed: () => _toast('New case'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New case'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final form = _setupFormCard();
              final side = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _warningGuideCard(),
                  const SizedBox(height: 16),
                  _recentCasesCard(),
                ],
              );
              if (c.maxWidth < 1000) {
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [form, const SizedBox(height: 16), side]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: form),
                  const SizedBox(width: 16),
                  Expanded(flex: 3, child: side),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _setupFormCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Disciplinary case form', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          _secPill('Employee information'),
          const SizedBox(height: 12),
          _reqLabel('Employee'),
          _dropdownField(_employee, const ['-- Select employee --', 'Ahmad Luqman', 'Zara Nor'], (v) => setState(() => _employee = v ?? _employee)),
          const SizedBox(height: 12),
          Text('Department', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: 'Operations',
            readOnly: true,
            decoration: _outlineDec(fill: AppColors.bg),
          ),
          const SizedBox(height: 20),
          _secPill('Incident details'),
          const SizedBox(height: 12),
          _reqLabel('Disciplinary reason'),
          _dropdownField(_reason, const ['-- Select reason --', 'Unauthorised absence', 'Persistent lateness'], (v) => setState(() => _reason = v ?? _reason)),
          const SizedBox(height: 12),
          _reqLabel('Date of incident'),
          TextFormField(
            initialValue: '06/05/2026',
            decoration: _outlineDec().copyWith(suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18)),
          ),
          const SizedBox(height: 12),
          Text('Location / site', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextFormField(decoration: _outlineDec(hint: 'e.g. HQ, Level 3')),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('From time', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextFormField(
                  initialValue: '09:30 AM',
                  decoration: _outlineDec().copyWith(suffixIcon: const Icon(Icons.access_time, size: 18)),
                ),
              ])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Text('To time', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextFormField(
                  initialValue: '10:00 AM',
                  decoration: _outlineDec().copyWith(suffixIcon: const Icon(Icons.access_time, size: 18)),
                ),
              ])),
            ],
          ),
          const SizedBox(height: 12),
          _reqLabel('Incident description'),
          TextFormField(
            maxLines: 4,
            decoration: _outlineDec(hint: 'Describe the incident in detail...'),
          ),
          const SizedBox(height: 12),
          Text('Witness(es) involved', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _dropdownField(_witness, const ['-- Select witness (optional) --', 'Nina Reza', 'Malik Said'], (v) => setState(() => _witness = v ?? _witness)),
          const SizedBox(height: 20),
          _secPill('Action & warning level'),
          const SizedBox(height: 12),
          _reqLabel('Level of disciplinary'),
          _dropdownField(_level, const ['Verbal warning', 'First written warning', 'Second written warning'], (v) => setState(() => _level = v ?? _level)),
          const SizedBox(height: 12),
          _reqLabel('Action issued by'),
          _dropdownField(_issuedBy, const ['Nina Reza (Head of Operations)', 'Malik Said', 'David Ng'], (v) => setState(() => _issuedBy = v ?? _issuedBy)),
          const SizedBox(height: 12),
          _reqLabel('Action date'),
          TextFormField(
            initialValue: '07/05/2026',
            decoration: _outlineDec().copyWith(suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18)),
          ),
          const SizedBox(height: 12),
          Text('If repeated, next action', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _dropdownField(_nextAction, const ['First written warning', 'Second written warning', 'Suspension'], (v) => setState(() => _nextAction = v ?? _nextAction)),
          const SizedBox(height: 12),
          Text('Statement of future expectation', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextFormField(
            maxLines: 3,
            decoration: _outlineDec(hint: 'Caution note or expectation for the employee going forward...'),
          ),
          const SizedBox(height: 20),
          _secPill('Supporting document'),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _toast('File picker (mock)'),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined, size: 36, color: AppColors.muted),
                  const SizedBox(height: 8),
                  Text('Click to attach file (PDF, DOCX, PNG)', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              OutlinedButton(onPressed: () => _toast('Cancelled'), child: const Text('Cancel')),
              const SizedBox(width: 12),
              FilledButton(onPressed: () => _toast('Disciplinary case saved'), child: const Text('Save disciplinary case')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _secPill(String t) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(20)),
        child: Text(t, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
      ),
    );
  }

  Widget _reqLabel(String base) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600),
          children: [
            TextSpan(text: base),
            const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  InputDecoration _outlineDec({String? hint, Color? fill}) {
    return InputDecoration(
      hintText: hint,
      filled: fill != null,
      fillColor: fill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
    );
  }

  Widget _dropdownField(String value, List<String> items, ValueChanged<String?> onChanged) {
    return InputDecorator(
      decoration: _outlineDec(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _warningGuideCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Warning level guide', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _guideRow('L1', AppColors.bg, 'Verbal warning', 'Informal, not on file — minor first offence.'),
          _guideRow('L2', const Color(0xFFFFEDD5), 'First written warning', 'Formal, recorded — repeated minor or first major.'),
          _guideRow('L3', const Color(0xFFFEF3C7), 'Second written warning', 'Final warning — partial pay deduction may apply.'),
          _guideRow('L4', const Color(0xFFFCE7F3), 'Suspension without pay', 'Pending investigation — full salary deduction.'),
          _guideRow('L5', const Color(0xFFEDE9FE), 'Demotion', 'Grade and pay reduction — serious misconduct.'),
          _guideRow('L6', AppColors.errorSurface, 'Termination', 'Dismissal — gross misconduct only.'),
        ],
      ),
    );
  }

  Widget _guideRow(String level, Color chipBg, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: chipBg, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.border)),
            child: Text(level, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 13)),
                Text(sub, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentCasesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('Recent cases', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(20)),
                child: Text('3 open', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w800, color: const Color(0xFFC2410C))),
              ),
            ],
          ),
          const Divider(height: 20),
          _recentItem('6 May 2026', AppColors.danger, 'Ahmad Luqman', 'Unauthorised absence · Verbal warning', 'Pending acknowledgement', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
          _recentItem('28 Apr 2026', AppColors.success, 'Zara Nor', 'Persistent lateness · First written warning', 'Acknowledged', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
          _recentItem('10 Mar 2026', AppColors.success, 'Raj Kumar', 'Dress code · Verbal warning', 'Closed', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
        ],
      ),
    );
  }

  Widget _recentItem(String date, Color dotColor, String name, String line, String status, Color stBg, Color stFg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(date, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.muted)),
              const SizedBox(width: 8),
              Icon(Icons.circle, size: 8, color: dotColor),
              const SizedBox(width: 6),
              Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          Text(line, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: stBg, borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: stFg)),
          ),
        ],
      ),
    );
  }
}
