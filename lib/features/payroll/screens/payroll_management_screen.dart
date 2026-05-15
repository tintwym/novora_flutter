import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/hr_full_width_data_table.dart';
import '../../../shared/widgets/hr_module_header.dart';

/// Payroll Management — mock-aligned primary tabs + pill sub-navigation.
class PayrollManagementScreen extends StatefulWidget {
  const PayrollManagementScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<PayrollManagementScreen> createState() => _PayrollManagementScreenState();
}

class _PayrollManagementScreenState extends State<PayrollManagementScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _primary = TabController(length: 7, vsync: this);

  @override
  void dispose() {
    _primary.dispose();
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
          moduleSubtitle: 'PAYROLL MANAGEMENT',
          showPeriodFilter: true,
          navyPrimaryButton: true,
          primaryActionLabel: 'Run payroll',
          onPrimaryAction: () => _toast('Run payroll'),
        ),
        Material(
          color: Colors.white,
          child: TabBar(
            controller: _primary,
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Allowance'),
              Tab(text: 'Bonus'),
              Tab(text: 'Overtime'),
              Tab(text: 'Deposit'),
              Tab(text: 'Deduction'),
              Tab(text: 'Tax'),
              Tab(text: 'Pay management'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _primary,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _AllowanceBody(),
              _BonusBody(),
              _OvertimeBody(),
              _DepositBody(),
              _DeductionBody(),
              _TaxBody(),
              _PayManagementBody(),
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
        title: Text('Payroll Management', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: body,
    );
  }
}

// ——— Shared ———

Widget _pill(String t, Color bg, Color fg) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Text(t, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
  );
}

Widget _whiteCard({required Widget child}) {
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

Widget _subPills({
  required List<String> labels,
  required int selected,
  required ValueChanged<int> onSelect,
  int? badgeIndex,
  int badgeCount = 0,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
    child: Row(
      children: List.generate(labels.length, (i) {
        final sel = selected == i;
        final showBadge = badgeIndex == i && badgeCount > 0;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: sel
              ? FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onPressed: () => onSelect(i),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(labels[i]),
                      if (showBadge) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$badgeCount',
                            style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFC2410C)),
                          ),
                        ),
                      ],
                    ],
                  ),
                )
              : TextButton(
                  onPressed: () => onSelect(i),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(labels[i], style: GoogleFonts.dmSans(color: AppColors.navy)),
                      if (showBadge) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$badgeCount',
                            style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFC2410C)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        );
      }),
    ),
  );
}

void _payToast(BuildContext context, String m) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
}

/// Mock toolbar filter with working selection state.
class _MemoFilterDd extends StatefulWidget {
  const _MemoFilterDd({required this.initial, required this.items});

  final String initial;
  final List<String> items;

  @override
  State<_MemoFilterDd> createState() => _MemoFilterDdState();
}

class _MemoFilterDdState extends State<_MemoFilterDd> {
  late String _v;

  @override
  void initState() {
    super.initState();
    _v = widget.items.contains(widget.initial) ? widget.initial : widget.items.first;
  }

  @override
  void didUpdateWidget(covariant _MemoFilterDd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial || oldWidget.items.length != widget.items.length) {
      _v = widget.items.contains(widget.initial) ? widget.initial : widget.items.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final safe = widget.items.contains(_v) ? _v : widget.items.first;
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
          items: widget.items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (nv) => setState(() => _v = nv ?? _v),
        ),
      ),
    );
  }
}

Widget _placeholder(String title) {
  return Center(
    child: Text(title, style: GoogleFonts.dmSans(color: AppColors.muted)),
  );
}

// ——— Allowance ———

class _AllowanceBody extends StatefulWidget {
  const _AllowanceBody();

  @override
  State<_AllowanceBody> createState() => _AllowanceBodyState();
}

class _AllowanceBodyState extends State<_AllowanceBody> {
  int _sub = 0;
  static const _labels = ['Allowance type', 'Travel allowance', 'Allowance attachment', 'Allowance payment'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subPills(labels: _labels, selected: _sub, onSelect: (i) => setState(() => _sub = i)),
        Expanded(
          child: switch (_sub) {
            0 => _allowanceType(context),
            _ => _placeholder('${_labels[_sub]} — mock view'),
          },
        ),
      ],
    );
  }

  Widget _allowanceType(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                    const _MemoFilterDd(initial: 'All policy types', items: ['All policy types', 'Transport', 'Meal']),
                    SizedBox(
                      width: 220,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search allowance...',
                          prefixIcon: const Icon(Icons.search, color: AppColors.muted, size: 20),
                          filled: true,
                          fillColor: AppColors.bg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                        ),
                      ),
                    ),
                  ],
                ),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                  onPressed: () => _payToast(context, 'New allowance type'),
                  child: const Text('+ New allowance type'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: HrFullWidthDataTable(
              cellHorizontalPadding: 8,
              columnSpecs: const [
                ('Allowance name', 2.0),
                ('Policy type', 1.0),
                ('Amount (MYR)', 1.0),
                ('Deduction amt', 1.0),
                ('Taxable', 0.75),
                ('On payslip', 0.85),
                ('Attach emp.', 0.85),
                ('Status', 0.75),
                ('Action', 0.7),
              ],
              rows: [
                _allowRow(context, 'Transport allowance', 'Transport', const Color(0xFFDBEAFE), const Color(0xFF1E40AF), '300.00', '—', false, true, false),
                _allowRow(context, 'Meal allowance', 'Meal', const Color(0xFFFFEDD5), const Color(0xFFC2410C), '200.00', '10.00/day', false, true, false),
                _allowRow(context, 'Phone allowance', 'Normal', const Color(0xFFEDE9FE), const Color(0xFF5B21B6), '150.00', '—', true, true, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _allowRow(
    BuildContext context,
    String name,
    String pol,
    Color polBg,
    Color polFg,
    String amt,
    String ded,
    bool taxable,
    bool payslip,
    bool attach,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
        DataCell(_pill(pol, polBg, polFg)),
        DataCell(Text(amt)),
        DataCell(Text(ded)),
        DataCell(_pill(taxable ? 'Yes' : 'No', taxable ? const Color(0xFFD1FAE5) : AppColors.bg, taxable ? const Color(0xFF065F46) : AppColors.textMuted)),
        DataCell(_pill('Yes', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
        DataCell(_pill(attach ? 'Yes' : 'No', attach ? const Color(0xFFD1FAE5) : AppColors.bg, attach ? const Color(0xFF065F46) : AppColors.textMuted)),
        DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
        DataCell(TextButton(onPressed: () => _payToast(context, 'Edit $name'), child: const Text('Edit'))),
      ],
    );
  }
}

// ——— Bonus ———

class _BonusBody extends StatefulWidget {
  const _BonusBody();

  @override
  State<_BonusBody> createState() => _BonusBodyState();
}

class _BonusBodyState extends State<_BonusBody> {
  int _sub = 0;
  static const _labels = ['Bonus type', 'Bonus attachment', 'Bonus payment'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subPills(labels: _labels, selected: _sub, onSelect: (i) => setState(() => _sub = i)),
        Expanded(
          child: switch (_sub) {
            0 => _bonusType(context),
            _ => _placeholder('${_labels[_sub]} — mock view'),
          },
        ),
      ],
    );
  }

  Widget _bonusType(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _whiteCard(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                const _MemoFilterDd(initial: 'All policy types', items: ['All policy types', 'Normal', 'LTIP']),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                  onPressed: () => _payToast(context, 'New bonus type'),
                  child: const Text('+ New bonus type'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: HrFullWidthDataTable(
              columnSpecs: const [
                ('Bonus name', 2.2),
                ('Policy type', 1.2),
                ('Pay month', 1.1),
                ('Based on', 1.2),
                ('On payslip', 0.9),
                ('Status', 0.8),
                ('Actions', 0.7),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Annual performance bonus', overflow: TextOverflow.ellipsis)),
                  DataCell(_pill('Normal', const Color(0xFFDBEAFE), AppColors.primary)),
                  const DataCell(Text('December')),
                  const DataCell(Text('Fixed amount')),
                  DataCell(_pill('Yes', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(TextButton(onPressed: () => _payToast(context, 'Edit'), child: const Text('Edit'))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Service bonus (3 yrs)', overflow: TextOverflow.ellipsis)),
                  DataCell(_pill('Working service', const Color(0xFFEDE9FE), const Color(0xFF5B21B6))),
                  const DataCell(Text('On anniversary')),
                  const DataCell(Text('Salary x factor')),
                  DataCell(_pill('Yes', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(TextButton(onPressed: () => _payToast(context, 'Edit'), child: const Text('Edit'))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('LTIP — Grade G7+', overflow: TextOverflow.ellipsis)),
                  DataCell(_pill('LTIP', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
                  const DataCell(Text('March (FY end)')),
                  const DataCell(Text('Performance eval')),
                  DataCell(_pill('Yes', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(TextButton(onPressed: () => _payToast(context, 'Edit'), child: const Text('Edit'))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Overtime ———

class _OvertimeBody extends StatefulWidget {
  const _OvertimeBody();

  @override
  State<_OvertimeBody> createState() => _OvertimeBodyState();
}

class _OvertimeBodyState extends State<_OvertimeBody> {
  int _sub = 0;
  static const _labels = [
    'OT policy attachment',
    'Manual OT setup',
    'Specific OT setup',
    'OT request',
    'Request for others',
    'OT approval',
    'OT history',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subPills(
          labels: _labels,
          selected: _sub,
          onSelect: (i) => setState(() => _sub = i),
          badgeIndex: 5,
          badgeCount: 4,
        ),
        Expanded(
          child: switch (_sub) {
            0 => _otPolicy(context),
            _ => _placeholder('${_labels[_sub]} — mock view'),
          },
        ),
      ],
    );
  }

  Widget _otPolicy(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _whiteCard(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                const _MemoFilterDd(initial: 'All departments', items: ['All departments', 'Engineering']),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                  onPressed: () => _payToast(context, 'Attach OT policy'),
                  child: const Text('+ Attach OT policy'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final left = _whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('OT policy settings', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700))),
                        TextButton(onPressed: () => _payToast(context, 'Edit policy'), child: const Text('Edit policy')),
                      ],
                    ),
                    const Divider(height: 20),
                    _kv('Weekday OT rate', 'Based on salary (per hour)'),
                    _kv('Weekend OT rate', '1.5x per hour'),
                    _kv('Public holiday OT', '2.0x per hour'),
                    _kv('Calculate by', 'Per minute rate'),
                    _kv('Rounding block', '30 minutes'),
                    _kv('Min OT threshold', '30 minutes'),
                    _kv('Max OT per day', '4 hours'),
                  ],
                ),
              );
              final right = _whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Attached employees', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700))),
                        _pill('430 employees', const Color(0xFFDBEAFE), AppColors.primary),
                      ],
                    ),
                    const Divider(height: 16),
                    DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.bg),
                      columns: const [
                        DataColumn(label: Text('Employee')),
                        DataColumn(label: Text('Department')),
                        DataColumn(label: Text('Policy type')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(_empAv('SL', 'Sarah Lim')),
                          const DataCell(Text('Engineering')),
                          DataCell(_pill('Salary-based', const Color(0xFFDBEAFE), AppColors.primary)),
                          DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                        ]),
                        DataRow(cells: [
                          DataCell(_empAv('RK', 'Raj Kumar')),
                          const DataCell(Text('Engineering')),
                          DataCell(_pill('Salary-based', const Color(0xFFDBEAFE), AppColors.primary)),
                          DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                        ]),
                        DataRow(cells: [
                          DataCell(_empAv('AL', 'Ahmad L')),
                          const DataCell(Text('Operations')),
                          DataCell(_pill('Fixed amt', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
                          DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                        ]),
                      ],
                    ),
                  ],
                ),
              );
              if (c.maxWidth < 900) {
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [left, const SizedBox(height: 16), right]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: left),
                  const SizedBox(width: 16),
                  Expanded(flex: 3, child: right),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: Text(k, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted))),
          Expanded(flex: 3, child: Text(v, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _empAv(String i, String n) {
    return Row(
      children: [
        CircleAvatar(radius: 14, backgroundColor: AppColors.primary.withValues(alpha: 0.12), child: Text(i, style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w800))),
        const SizedBox(width: 8),
        Text(n, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ——— Deposit ———

class _DepositBody extends StatefulWidget {
  const _DepositBody();

  @override
  State<_DepositBody> createState() => _DepositBodyState();
}

class _DepositBodyState extends State<_DepositBody> {
  int _sub = 0;
  static const _labels = ['Deposit type', 'Deposit attachment'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subPills(labels: _labels, selected: _sub, onSelect: (i) => setState(() => _sub = i)),
        Expanded(
          child: switch (_sub) {
            0 => _depositType(context),
            _ => _placeholder('Deposit attachment — mock view'),
          },
        ),
      ],
    );
  }

  Widget _depositType(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
              onPressed: () => _payToast(context, 'New deposit type'),
              child: const Text('+ New deposit type'),
            ),
          ),
          const SizedBox(height: 12),
          _whiteCard(
            child: HrFullWidthDataTable(
              cellHorizontalPadding: 8,
              columnSpecs: const [
                ('Deposit type', 1.6),
                ('Code', 0.6),
                ('Employment status', 1.2),
                ('Frequency', 0.9),
                ('Amount basis', 1.1),
                ('Reimburse month', 1.0),
                ('Status', 0.8),
                ('Actions', 0.7),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Uniform deposit')),
                  const DataCell(Text('UNI')),
                  DataCell(_pill('All staff', const Color(0xFFDBEAFE), AppColors.primary)),
                  const DataCell(Text('One-time')),
                  const DataCell(Text('Fixed MYR 100')),
                  const DataCell(Text('On resign')),
                  DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(TextButton(onPressed: () => _payToast(context, 'Edit'), child: const Text('Edit'))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Saving deposit')),
                  const DataCell(Text('SAV')),
                  DataCell(_pill('Permanent', const Color(0xFFDBEAFE), AppColors.primary)),
                  const DataCell(Text('Monthly')),
                  const DataCell(Text('2% of basic')),
                  const DataCell(Text('On resign')),
                  DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(TextButton(onPressed: () => _payToast(context, 'Edit'), child: const Text('Edit'))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Laptop deposit')),
                  const DataCell(Text('LAP')),
                  DataCell(_pill('Engineering', const Color(0xFFEDE9FE), const Color(0xFF5B21B6))),
                  const DataCell(Text('One-time')),
                  const DataCell(Text('Fixed MYR 500')),
                  const DataCell(Text('On resign')),
                  DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(TextButton(onPressed: () => _payToast(context, 'Edit'), child: const Text('Edit'))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Deduction ———

class _DeductionBody extends StatefulWidget {
  const _DeductionBody();

  @override
  State<_DeductionBody> createState() => _DeductionBodyState();
}

class _DeductionBodyState extends State<_DeductionBody> {
  int _sub = 0;
  static const _labels = ['Deduction type', 'Deduction attachment', 'Manual deduction'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subPills(labels: _labels, selected: _sub, onSelect: (i) => setState(() => _sub = i)),
        Expanded(
          child: switch (_sub) {
            0 => _deductionType(context),
            _ => _placeholder('${_labels[_sub]} — mock view'),
          },
        ),
      ],
    );
  }

  Widget _deductionType(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _whiteCard(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                const _MemoFilterDd(initial: 'All types', items: ['All types', 'Statutory', 'Tax']),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                  onPressed: () => _payToast(context, 'New deduction type'),
                  child: const Text('+ New deduction type'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: HrFullWidthDataTable(
              columnSpecs: const [
                ('Deduction name', 1.8),
                ('Type', 1.0),
                ('Deduction rule', 1.4),
                ('Amount / Rate', 1.1),
                ('On payslip', 0.9),
                ('Status', 0.8),
                ('Action', 0.7),
              ],
              rows: [
                _dedRow('EPF (employee)', 'Statutory', const Color(0xFFDBEAFE), AppColors.primary, 'Based on salary', '11%'),
                _dedRow('SOCSO', 'Statutory', const Color(0xFFDBEAFE), AppColors.primary, 'Statutory table', '0.5%'),
                _dedRow('Income tax (PCB)', 'Tax', const Color(0xFFEDE9FE), const Color(0xFF5B21B6), 'PCB schedule', 'Varied'),
                _dedRow('Late deduction', 'Rota rule', const Color(0xFFFFEDD5), const Color(0xFFC2410C), 'Per minute late', 'MYR 0.50/min'),
                _dedRow('Missing swipe', 'Attendance', const Color(0xFFFCE7F3), const Color(0xFF9D174D), 'Per occurrence', 'MYR 20.00'),
                _dedRow('Unpaid leave', 'Leave', AppColors.bg, AppColors.textMuted, 'Normal rate/day', 'Salary ÷ work days'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _dedRow(String name, String type, Color tBg, Color tFg, String rule, String rate) {
    return DataRow(
      cells: [
        DataCell(Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600))),
        DataCell(_pill(type, tBg, tFg)),
        DataCell(Text(rule)),
        DataCell(Text(rate)),
        DataCell(_pill('Yes', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
        DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
        DataCell(TextButton(onPressed: () => _payToast(context, 'Edit $name'), child: const Text('Edit'))),
      ],
    );
  }
}

// ——— Tax ———

class _TaxBody extends StatefulWidget {
  const _TaxBody();

  @override
  State<_TaxBody> createState() => _TaxBodyState();
}

class _TaxBodyState extends State<_TaxBody> {
  int _sub = 0;
  static const _labels = ['Tax category', 'Tax attachment', 'Income tax policy', 'Taxable pays'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subPills(labels: _labels, selected: _sub, onSelect: (i) => setState(() => _sub = i)),
        Expanded(
          child: switch (_sub) {
            0 => _taxCategory(context),
            _ => _placeholder('${_labels[_sub]} — mock view'),
          },
        ),
      ],
    );
  }

  Widget _taxCategory(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
              onPressed: () => _payToast(context, 'New tax category'),
              child: const Text('+ New tax category'),
            ),
          ),
          const SizedBox(height: 12),
          _whiteCard(
            child: HrFullWidthDataTable(
              columnSpecs: const [
                ('Tax name', 2.0),
                ('Code', 0.7),
                ('Calculate on', 1.4),
                ('Calc. overall income', 1.2),
                ('Status', 0.8),
                ('Edit', 0.7),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Personal income tax')),
                  const DataCell(Text('PCB')),
                  const DataCell(Text('Monthly salary')),
                  DataCell(_pill('Yes', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(TextButton(onPressed: () => _payToast(context, 'Edit PCB'), child: const Text('Edit'))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Social security (SOCSO)', overflow: TextOverflow.ellipsis)),
                  const DataCell(Text('SSB')),
                  const DataCell(Text('Basic salary')),
                  DataCell(_pill('No', AppColors.bg, AppColors.textMuted)),
                  DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                  DataCell(TextButton(onPressed: () => _payToast(context, 'Edit SSB'), child: const Text('Edit'))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Pay management ———

class _PayManagementBody extends StatefulWidget {
  const _PayManagementBody();

  @override
  State<_PayManagementBody> createState() => _PayManagementBodyState();
}

class _PayManagementBodyState extends State<_PayManagementBody> {
  int _sub = 0;
  static const _labels = ['Payment duration', 'Payroll preparation', 'Payroll run', 'Payroll history'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _subPills(labels: _labels, selected: _sub, onSelect: (i) => setState(() => _sub = i)),
        Expanded(
          child: switch (_sub) {
            0 => _paymentDuration(context),
            _ => _placeholder('${_labels[_sub]} — mock view'),
          },
        ),
      ],
    );
  }

  Widget _paymentDuration(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _whiteCard(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Define the monthly payroll calculation period', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.navy, foregroundColor: Colors.white),
                  onPressed: () => _payToast(context, 'New duration'),
                  child: const Text('+ New duration'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final left = _whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Payment duration setup', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700))),
                        TextButton(onPressed: () => _payToast(context, 'Edit'), child: const Text('Edit')),
                      ],
                    ),
                    const Divider(height: 20),
                    _pdKv('Duration name', 'Monthly (May 2026)'),
                    _pdKv('Period start', '1 May 2026'),
                    _pdKv('Period end', '31 May 2026'),
                    _pdKv('Pay date', '31 May 2026'),
                    _pdKv('1-day basic salary based on', '26 working days / month'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('Status', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted)),
                        const SizedBox(width: 12),
                        _pill('Current period', const Color(0xFFDBEAFE), AppColors.primary),
                      ],
                    ),
                  ],
                ),
              );
              final right = _whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Past payment durations', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.bg),
                      columns: const [
                        DataColumn(label: Text('Duration name')),
                        DataColumn(label: Text('Start')),
                        DataColumn(label: Text('End')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: [
                        DataRow(cells: [
                          const DataCell(Text('May 2026')),
                          const DataCell(Text('1 May')),
                          const DataCell(Text('31 May')),
                          DataCell(_pill('Current', const Color(0xFFDBEAFE), AppColors.primary)),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Apr 2026')),
                          const DataCell(Text('1 Apr')),
                          const DataCell(Text('30 Apr')),
                          DataCell(_pill('Confirmed', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Mar 2026')),
                          const DataCell(Text('1 Mar')),
                          const DataCell(Text('31 Mar')),
                          DataCell(_pill('Confirmed', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                        ]),
                      ],
                    ),
                  ],
                ),
              );
              if (c.maxWidth < 900) {
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [left, const SizedBox(height: 16), right]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: left),
                  const SizedBox(width: 16),
                  Expanded(child: right),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _pdKv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 200, child: Text(k, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted))),
          Expanded(child: Text(v, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
