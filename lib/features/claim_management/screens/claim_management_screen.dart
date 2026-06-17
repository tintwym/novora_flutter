import 'package:flutter/material.dart';
import '../../../shared/widgets/module_shell_background.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../shared/widgets/hr_full_width_data_table.dart';
import '../../../shared/widgets/hr_module_header.dart';

/// Claim Management — expense / reimbursement mock UI (reference: Novora CLAIM MANAGEMENT).
class ClaimManagementScreen extends StatefulWidget {
  const ClaimManagementScreen({
    super.key,
    this.embeddedInShell = false,
    this.employeeView = false,
  });

  final bool embeddedInShell;

  /// When true, only [Submit claim] and [Claim history] tabs (for [EMPLOYEE]).
  final bool employeeView;

  @override
  State<ClaimManagementScreen> createState() => _ClaimManagementScreenState();
}

class _ClaimManagementScreenState extends State<ClaimManagementScreen>
    with SingleTickerProviderStateMixin {
  static const _pendingBadge = 7;

  late final TabController _tab = TabController(
    length: widget.employeeView ? 2 : 6,
    vsync: this,
  );
  final Map<String, String> _dd = {};

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
        const HrModuleHeader(
          showPeriodFilter: true,
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
            tabs: widget.employeeView
                ? const [
                    Tab(height: 48, child: Text('Submit claim')),
                    Tab(height: 48, child: Text('Claim history')),
                  ]
                : [
                    const Tab(height: 48, child: Text('Submit claim')),
                    _claimTab('Approval', badge: _pendingBadge),
                    const Tab(height: 48, child: Text('Policy & compliance')),
                    const Tab(height: 48, child: Text('Payroll integration')),
                    const Tab(height: 48, child: Text('Analytics & reports')),
                    const Tab(height: 48, child: Text('Claim history')),
                  ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.employeeView
                ? [
                    _submitClaimTab(),
                    _claimHistoryTab(),
                  ]
                : [
                    _submitClaimTab(),
                    _approvalTab(),
                    _policyTab(),
                    _payrollTab(),
                    _analyticsTab(),
                    _claimHistoryTab(),
                  ],
          ),
        ),
      ],
    );

    if (widget.embeddedInShell) {
      return ModuleShellBackground(child: body);
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Claims', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        elevation: 0,
      ),
      body: body,
    );
  }

  Widget _claimTab(String label, {int badge = 0}) {
    return Tab(
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
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
      color: context.subtleFill,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: child,
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

  Widget _filterDd(String id, String initial, List<String> items) {
    final v = _d(id, initial, items);
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: context.borderColor),
          borderRadius: BorderRadius.circular(8),
          color: context.subtleFill,
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

  /// Compact approve/reject for narrow table cells (avoids overflow).
  Widget _approveActions() {
    return Wrap(
      spacing: 4,
      runSpacing: 2,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.success,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => _toast('Approved'),
          child: const Text('Approve'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.danger,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => _toast('Rejected'),
          child: const Text('Reject'),
        ),
      ],
    );
  }

  Widget _pill(String t, Color bg, Color fg) {
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

  Widget _catPill(String label, Color bg, Color fg) => _pill(label, bg, fg);

  // --- Submit claim ---
  Widget _submitClaimTab() {
    final summary = Row(
      children: [
        _pill('Pending: 2', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
        const SizedBox(width: 8),
        _pill('Approved: 4', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
        const SizedBox(width: 8),
        _pill('Rejected: 1', AppColors.errorSurface, AppColors.danger),
      ],
    );

    final leftCol = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Receipt capture & OCR', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            OutlinedButton(onPressed: () => _toast('Mobile upload'), child: const Text('Mobile upload')),
            OutlinedButton(onPressed: () => _toast('OCR scan'), child: const Text('OCR scan')),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.subtleFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.borderColor),
          ),
          child: Column(
            children: [
              Text(
                'Snap or upload receipt. JPG, PNG, PDF — max 10MB',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: () => _toast('Scan receipt'), child: const Text('Scan receipt')),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('My recent claims', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        HrFullWidthDataTable(
          headingRowColor: context.tableHeaderBg,
          columnSpecs: const [
            ('Date', 0.7),
            ('Category', 1.0),
            ('Amount', 0.8),
            ('Status', 0.8),
            ('', 0.4),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('5 May')),
              DataCell(_catPill('Meal', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              const DataCell(Text('MYR 38.50')),
              DataCell(_pill('Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              DataCell(_linkBtn('View', () {})),
            ]),
            DataRow(cells: [
              const DataCell(Text('20 Apr')),
              DataCell(_catPill('Meal', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              const DataCell(Text('MYR 55.00')),
              DataCell(_pill('Rejected', AppColors.errorSurface, AppColors.danger)),
              DataCell(_linkBtn('View', () {})),
            ]),
            DataRow(cells: [
              const DataCell(Text('15 Apr')),
              DataCell(_catPill('Mileage', const Color(0xFFFFEDD5), AppColors.warning)),
              const DataCell(Text('MYR 78.40')),
              DataCell(_pill('Approved', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('View', () {})),
            ]),
          ],
        ),
      ],
    );

    final form = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Claim details', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, fontSize: 15)),
        const SizedBox(height: 12),
        Text('Claim category *', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        _filterDd('claim_cat', '-- Select category --', const [
          '-- Select category --',
          'Meal',
          'Transport',
          'Hotel',
          'Air ticket',
        ]),
        const SizedBox(height: 12),
        Text('Claim date *', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        TextField(
          decoration: InputDecoration(
            hintText: 'dd/mm/yyyy',
            filled: true,
            fillColor: context.subtleFill,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        Text('Vendor / merchant', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        TextField(
          decoration: InputDecoration(
            hintText: 'e.g. Subway Sdn Bhd',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Currency', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  _filterDd('claim_ccy', 'MYR', const ['MYR', 'USD', 'SGD']),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount *', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
                  const SizedBox(height: 4),
                  TextField(
                    decoration: InputDecoration(
                      hintText: '0.00',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('MYR equiv.: Auto-converted', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.primary)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Live rate: 1 USD = 4.68 MYR · updated 1 min ago',
            style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        Text('Project / cost centre', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        _filterDd('claim_proj', '— Optional —', const ['— Optional —', 'PRJ-001', 'PRJ-014']),
        const SizedBox(height: 12),
        Text('Claim description *', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Business purpose…',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Upload receipt (required for claims > MYR 50)',
          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
          ),
          child: Text(
            'Policy alert: Meal allowance daily limit is MYR 30.00. Your claim of MYR 42.00 exceeds '
            'the limit by MYR 12.00. Additional approval required.',
            style: GoogleFonts.dmSans(fontSize: 12, height: 1.35),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Checkbox(value: true, onChanged: (_) {}),
            Expanded(
              child: Text(
                'Send email notification to approver',
                style: GoogleFonts.dmSans(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () => _toast('Draft saved'), child: const Text('Save draft')),
            _primaryBtn('Submit claim', () => _toast('Submitted')),
          ],
        ),
      ],
    );

    return _scrollBody([
      _whiteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _filterDd('my_claims', 'My claims – May 2026', const ['My claims – May 2026', 'Apr 2026']),
                const Spacer(),
                summary,
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          if (c.maxWidth > 1000) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: _whiteCard(child: leftCol)),
                const SizedBox(width: 16),
                Expanded(flex: 6, child: _whiteCard(child: form)),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _whiteCard(child: leftCol),
              const SizedBox(height: 16),
              _whiteCard(child: form),
            ],
          );
        },
      ),
    ]);
  }

  // --- Approval ---
  Widget _approvalTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [
            _filterDd('ap_st', 'All status', const ['All status', 'Pending', 'Approved']),
            _filterDd('ap_cat', 'All categories', const ['All categories', 'Meal', 'Hotel']),
            _filterDd('ap_dept', 'All departments', const ['All departments', 'Engineering']),
            SizedBox(
              width: 140,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'dd/mm/yyyy',
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
          [
            _pill('7 pending approval', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
            _linkBtn('Reset', () => _toast('Reset')),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Approval routing rules', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                const Spacer(),
                _linkBtn('Edit rules', () => _toast('Edit rules')),
              ],
            ),
            const SizedBox(height: 12),
            _ruleRow(
              'Claims ≤ MYR 200',
              'Direct manager only — single approval',
              _pill('Sequential', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
            ),
            _ruleRow(
              'Claims MYR 201 – MYR 1,000',
              'Manager → Department Head',
              _pill('Sequential', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
            ),
            _ruleRow(
              'Claims > MYR 1,000',
              'Manager → Dept Head → Finance Director (parallel with Dept Head)',
              _pill('Parallel', const Color(0xFFEDE9FE), const Color(0xFF5B21B6)),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: HrFullWidthDataTable(
          headingRowColor: context.tableHeaderBg,
          columnSpecs: const [
            ('Employee', 1.25),
            ('Category', 0.85),
            ('Date', 0.65),
            ('Amount', 0.7),
            ('Approval chain', 1.5),
            ('Policy flag', 0.95),
            ('Status', 0.75),
            ('', 1.35),
          ],
          rows: [
            DataRow(cells: [
              DataCell(_avatarName('SL', 'Sarah Lim', const Color(0xFFDBEAFE))),
              DataCell(_catPill('Meal', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              const DataCell(Text('5 May')),
              const DataCell(Text('MYR 38.50')),
              const DataCell(Text('David Ng')),
              DataCell(_pill('Clear', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_pill('Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              DataCell(_approveActions()),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('RK', 'Raj Kumar', const Color(0xFFD1FAE5))),
              DataCell(_catPill('Hotel', const Color(0xFFDBEAFE), AppColors.brandBlueDeep)),
              const DataCell(Text('28 Apr')),
              const DataCell(Text('MYR 450.00')),
              const DataCell(Text('David ✓ → Ahmad W.')),
              DataCell(_pill('Clear', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_pill('Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              DataCell(_approveActions()),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('MT', 'Maya Tan', const Color(0xFFEDE9FE))),
              DataCell(_catPill('Air ticket', const Color(0xFFEDE9FE), const Color(0xFF5B21B6))),
              const DataCell(Text('25 Apr')),
              const DataCell(Text('MYR 1,280.00')),
              const DataCell(Text('Nina ✓ → Ahmad W | Finance')),
              DataCell(_pill('Flagged', AppColors.errorSurface, AppColors.danger)),
              DataCell(_pill('Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              DataCell(_approveActions()),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('AL', 'Ahmad L', const Color(0xFFFFE4E6))),
              DataCell(_catPill('Meal', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              const DataCell(Text('6 May')),
              const DataCell(Text('MYR 42.00')),
              const DataCell(Text('Malik Said')),
              DataCell(_pill('Over limit', AppColors.errorSurface, AppColors.danger)),
              DataCell(_pill('Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              DataCell(_approveActions()),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('NC', 'Nadia Chen', const Color(0xFFFFE4E6))),
              DataCell(_catPill('Transport', const Color(0xFFDBEAFE), AppColors.brandBlueDeep)),
              const DataCell(Text('3 May')),
              const DataCell(Text('MYR 120.00')),
              const DataCell(Text('Kevin ✓')),
              DataCell(_pill('Clear', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_pill('Approved', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('View detail', () {})),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _ruleRow(String title, String subtitle, Widget tag) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          tag,
        ],
      ),
    );
  }

  // --- Policy ---
  Widget _policyTab() {
    return _scrollBody([
      LayoutBuilder(
        builder: (context, c) {
          final limits = _whiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _filterDd('pol_cat', 'All categories', const ['All categories', 'Meal', 'Transport']),
                    const Spacer(),
                    _linkBtn('Edit limits', () {}),
                  ],
                ),
                const SizedBox(height: 12),
                HrFullWidthDataTable(
                  headingRowColor: context.tableHeaderBg,
                  columnSpecs: const [
                    ('Category', 1.1),
                    ('Daily limit', 0.9),
                    ('Monthly cap', 0.9),
                    ('Receipt req.', 1.0),
                    ('', 0.45),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('Meal allowance')),
                      const DataCell(Text('MYR 30 daily')),
                      const DataCell(Text('MYR 600')),
                      DataCell(_pill('> MYR 15', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
                      DataCell(_linkBtn('Edit', () {})),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Transport')),
                      const DataCell(Text('MYR 200 daily')),
                      const DataCell(Text('MYR 2,000')),
                      DataCell(_pill('> MYR 50', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
                      DataCell(_linkBtn('Edit', () {})),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('Hotel / stay')),
                      const DataCell(Text('MYR 350/night')),
                      const DataCell(Text('—')),
                      DataCell(_pill('Always', const Color(0xFFFFE4E6), AppColors.danger)),
                      DataCell(_linkBtn('Edit', () {})),
                    ]),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Auto-validation rules', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                    const Spacer(),
                    _linkBtn('Edit rules', () {}),
                  ],
                ),
                const SizedBox(height: 8),
                _checkRule('Flag claims exceeding daily / monthly category limits', true),
                _checkRule('Detect duplicate submissions (same vendor + date + amount)', true),
                _checkRule('Block claims submitted more than 30 days after receipt date', true),
                _checkRule('Require receipt attachment for claims above threshold', true),
                _checkRule('Auto-convert foreign currency at live exchange rate', true),
                _checkRule('Hold claims from employees on notice period', false),
                _checkRule('Notify HR on claims exceeding MYR 1,000', true),
              ],
            ),
          );

          final right = _whiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    _primaryBtn('+ New policy rule', () => _toast('New rule')),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Policy flags — this month', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                _flagTile('Meal limit exceeded', 'Ahmad L — MYR 42.00 vs MYR 30 limit', AppColors.errorSurface),
                _flagTile('Duplicate submission', 'Zara N — same vendor + date as 28 Apr', const Color(0xFFFEF3C7)),
                _flagTile('Late submission', 'Raj K — receipt 28 Feb, submitted 5 May', const Color(0xFFFFEDD5)),
                const SizedBox(height: 16),
                Text('Audit trail — recent actions', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                _auditLine(Colors.green, '6 May 10:42 · David Ng approved MYR 120 transport — Nadia Chen'),
                _auditLine(AppColors.danger, '6 May 09:15 · Kevin Lim rejected MYR 55 meal — Sarah Lim'),
                _linkBtn('Full log', () {}),
              ],
            ),
          );

          if (c.maxWidth > 960) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: limits),
                const SizedBox(width: 16),
                Expanded(child: right),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [limits, const SizedBox(height: 16), right],
          );
        },
      ),
    ]);
  }

  Widget _checkRule(String label, bool checked) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(checked ? Icons.check_box : Icons.check_box_outline_blank, size: 20, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: GoogleFonts.dmSans(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _flagTile(String title, String subtitle, Color bg) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
          Text(subtitle, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _auditLine(Color dot, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 4), decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.dmSans(fontSize: 12))),
        ],
      ),
    );
  }

  // --- Payroll ---
  Widget _payrollTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [
            _filterDd('pay_batch', 'May 2026 payroll', const ['May 2026 payroll', 'Apr 2026 payroll']),
            _filterDd('pay_dept', 'All departments', const ['All departments', 'Engineering']),
          ],
          [
            OutlinedButton(onPressed: () => _toast('Preview'), child: const Text('Preview batch')),
            const SizedBox(width: 8),
            _primaryBtn('Push to payroll', () => _toast('Push')),
          ],
        ),
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final left = _whiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payroll push status — May 2026', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                _kv('Total approved claims', 'MYR 14,820.00'),
                _kv('Pushed to payroll', 'MYR 9,340.00', valueColor: AppColors.success),
                _kv('Awaiting push', 'MYR 5,480.00', valueColor: AppColors.warning),
                _kv('Payroll cut-off', '25 May 2026'),
                _kv('Next payroll date', '31 May 2026'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Integration status', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
                    const SizedBox(width: 8),
                    _pill('Connected', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                  ],
                ),
                const Divider(height: 24),
                Text('Currency conversion log', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                HrFullWidthDataTable(
                  headingRowColor: context.tableHeaderBg,
                  columnSpecs: const [
                    ('Employee', 1.2),
                    ('Orig.', 0.5),
                    ('Orig. amt', 0.85),
                    ('Rate', 0.55),
                    ('MYR equiv.', 0.85),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(_avatarName('MT', 'Maya T', const Color(0xFFEDE9FE))),
                      const DataCell(Text('USD')),
                      const DataCell(Text(r'$280.00')),
                      const DataCell(Text('4.68')),
                      const DataCell(Text('MYR 1,310.40')),
                    ]),
                  ],
                ),
              ],
            ),
          );

          final right = _whiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Claims ready for payroll batch', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    _pill('12 claims', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
                  ],
                ),
                const SizedBox(height: 12),
                HrFullWidthDataTable(
                  headingRowColor: context.tableHeaderBg,
                  columnSpecs: const [
                    ('Employee', 1.2),
                    ('Category', 0.85),
                    ('Amount (MYR)', 0.75),
                    ('Approved by', 0.95),
                    ('Push status', 0.85),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(_avatarName('SL', 'Sarah Lim', const Color(0xFFDBEAFE))),
                      const DataCell(Text('Transport')),
                      const DataCell(Text('120.00')),
                      const DataCell(Text('David Ng')),
                      DataCell(_pill('Pushed', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                    ]),
                    DataRow(cells: [
                      DataCell(_avatarName('RK', 'Raj Kumar', const Color(0xFFD1FAE5))),
                      const DataCell(Text('Hotel')),
                      const DataCell(Text('450.00')),
                      const DataCell(Text('Ahmad W.')),
                      DataCell(_pill('Queued', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
                    ]),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total queued for May 2026 payroll', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                      Text('MYR 5,480.00', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
          );

          if (c.maxWidth > 960) {
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
            children: [left, const SizedBox(height: 16), right],
          );
        },
      ),
    ]);
  }

  Widget _kv(String k, String v, {Color? valueColor}) {
    return Builder(
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(child: Text(k, style: GoogleFonts.dmSans(color: AppColors.textMuted))),
            Text(v, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: valueColor ?? ctx.primaryText)),
          ],
        ),
      ),
    );
  }

  // --- Analytics ---
  Widget _analyticsTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [_filterDd('an_m', 'May 2026', const ['May 2026', 'Apr 2026']), _filterDd('an_d', 'All departments', const ['All departments'])],
          [_linkBtn('Export report', () => _toast('Export'))],
        ),
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final kpi = Row(
            children: [
              Expanded(child: _kpiCard('Total claimed – YTD', 'MYR 48,230', '+12% vs last year')),
              const SizedBox(width: 12),
              Expanded(child: _kpiCard('Claimed – May 2026', 'MYR 14,820', '94% of monthly budget')),
              const SizedBox(width: 12),
              Expanded(child: _kpiCard('Policy flags – May', '8', '4 blocked · 4 escalated')),
            ],
          );

          final charts = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _whiteCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Spend by category — May 2026', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      _hBar('Air ticket', 5840, 5840, AppColors.primary),
                      _hBar('Hotel / stay', 4320, 5840, const Color(0xFF7C3AED)),
                      _hBar('Transport', 2240, 5840, AppColors.success),
                      _hBar('Meal', 1820, 5840, AppColors.warning),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _whiteCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Spend by department', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 12),
                      _hBar('Engineering', 6480, 6480, AppColors.primary),
                      _hBar('Operations', 4950, 6480, AppColors.success),
                      _hBar('Finance', 2700, 6480, const Color(0xFF7C3AED)),
                    ],
                  ),
                ),
              ),
            ],
          );

          final budget = _whiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Budget tracking — travel & entertainment', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                _budgetRow('Engineering travel', 6480, 10000, AppColors.primary),
                _budgetRow('Operations travel', 4950, 6000, AppColors.warning),
                _budgetRow('Marketing entertainment', 1800, 2000, AppColors.danger),
              ],
            ),
          );

          final top = _whiteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Top claimants — May 2026', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                HrFullWidthDataTable(
                  headingRowColor: context.tableHeaderBg,
                  columnSpecs: const [
                    ('Employee', 1.4),
                    ('No. claims', 0.65),
                    ('Total (MYR)', 0.85),
                    ('Flags', 0.55),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(_avatarName('MT', 'Maya Tan', const Color(0xFFEDE9FE))),
                      const DataCell(Text('6')),
                      const DataCell(Text('3,820.00')),
                      const DataCell(Text('1')),
                    ]),
                    DataRow(cells: [
                      DataCell(_avatarName('SL', 'Sarah Lim', const Color(0xFFDBEAFE))),
                      const DataCell(Text('4')),
                      const DataCell(Text('1,650.00')),
                      const DataCell(Text('1')),
                    ]),
                  ],
                ),
              ],
            ),
          );

          if (c.maxWidth > 900) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                kpi,
                const SizedBox(height: 16),
                charts,
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: budget),
                    const SizedBox(width: 16),
                    Expanded(child: top),
                  ],
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              kpi,
              const SizedBox(height: 16),
              charts,
              const SizedBox(height: 16),
              budget,
              const SizedBox(height: 16),
              top,
            ],
          );
        },
      ),
    ]);
  }

  Widget _kpiCard(String title, String value, String sub) {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(builder: (ctx) => Text(title, style: GoogleFonts.dmSans(fontSize: 12, color: ctx.secondaryText))),
          const SizedBox(height: 6),
          Builder(builder: (ctx) => Text(value, style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w800, color: ctx.primaryText))),
          Builder(builder: (ctx) => Text(sub, style: GoogleFonts.dmSans(fontSize: 11, color: ctx.secondaryText))),
        ],
      ),
    );
  }

  Widget _hBar(String label, int value, int max, Color color) {
    final frac = max > 0 ? value / max : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.dmSans(fontSize: 12)),
              Text('MYR ${_fmt(value)}', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: frac, minHeight: 8, backgroundColor: AppColors.border, color: color),
          ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    return n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  Widget _budgetRow(String label, int used, int cap, Color color) {
    final frac = cap > 0 ? used / cap : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label · MYR ${_fmt(used)} / MYR ${_fmt(cap)}', style: GoogleFonts.dmSans(fontSize: 12)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: frac.clamp(0.0, 1.0), minHeight: 8, backgroundColor: AppColors.border, color: color),
          ),
        ],
      ),
    );
  }

  // --- Claim history ---
  Widget _claimHistoryTab() {
    return _scrollBody([
      _whiteCard(
        child: _toolbarRow(
          [
            _filterDd('hist_st', 'All status', const ['All status', 'Pushed', 'Queued', 'Rejected']),
            _filterDd('hist_cat', 'All categories', const ['All categories', 'Meal', 'Transport']),
            _filterDd('hist_dept', 'All departments', const ['All departments']),
            SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search employee…',
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
          [
            _linkBtn('Generate PDF', () => _toast('PDF')),
            _primaryBtn('Export', () => _toast('Export')),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _whiteCard(
        child: HrFullWidthDataTable(
          headingRowColor: context.tableHeaderBg,
          columnSpecs: const [
            ('Employee', 1.25),
            ('Category', 0.85),
            ('Claim date', 0.7),
            ('Vendor', 0.95),
            ('Amount (MYR)', 0.8),
            ('Approved by', 1.0),
            ('Payroll month', 0.85),
            ('Status', 0.75),
            ('', 0.45),
          ],
          rows: [
            DataRow(cells: [
              DataCell(_avatarName('NC', 'Nadia Chen', const Color(0xFFFFE4E6))),
              DataCell(_catPill('Transport', const Color(0xFFDBEAFE), AppColors.brandBlueDeep)),
              const DataCell(Text('3 May')),
              const DataCell(Text('Grab')),
              const DataCell(Text('120.00')),
              const DataCell(Text('Kevin Lim ✓')),
              const DataCell(Text('May 2026')),
              DataCell(_pill('Pushed', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
              DataCell(_linkBtn('View', () {})),
            ]),
            DataRow(cells: [
              DataCell(_avatarName('SL', 'Sarah Lim', const Color(0xFFDBEAFE))),
              DataCell(_catPill('Meal', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
              const DataCell(Text('20 Apr')),
              const DataCell(Text("Nando's")),
              const DataCell(Text('55.00')),
              const DataCell(Text('Kevin Lim ✗')),
              const DataCell(Text('—')),
              DataCell(_pill('Rejected', AppColors.errorSurface, AppColors.danger)),
              DataCell(_linkBtn('View', () {})),
            ]),
          ],
        ),
      ),
    ]);
  }
}
