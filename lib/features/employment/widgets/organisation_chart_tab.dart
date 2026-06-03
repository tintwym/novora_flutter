import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../shared/widgets/hr_pill_segmented_control.dart';
import '../screens/open_position_profile_screen.dart';

/// Organisation chart + list view (mock data — replace with API later).
class OrganisationChartTab extends StatefulWidget {
  const OrganisationChartTab({super.key});

  @override
  State<OrganisationChartTab> createState() => _OrganisationChartTabState();
}

class _OrganisationChartTabState extends State<OrganisationChartTab> {
  final _search = TextEditingController();
  bool _orgView = true;
  String _deptFilter = 'All';
  OrgChartNodeData? _selected;

  static const _company = 'Novora HRMS PTE Ltd';
  static const _totalEmployees = 1284;
  static const _deptCount = 5;

  static const _deptFilters = ['All', 'Engineering', 'Finance', 'HR', 'Marketing', 'Operations'];

  static final _summary = <String, int>{
    'Engineering': 342,
    'Finance': 180,
    'HR': 88,
    'Marketing': 142,
    'Operations': 261,
  };

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _matchesFilter(OrgChartNodeData n) {
    if (_deptFilter == 'All') return true;
    return n.deptLabel == _deptFilter;
  }

  List<OrgChartNodeData> get _visibleHeads {
    final heads = _mockRoot.children;
    if (_deptFilter == 'All') return heads;
    return heads.where((h) => h.deptLabel == _deptFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.subtleFill,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(),
                  const SizedBox(height: 16),
                  _filterBar(),
                  const SizedBox(height: 20),
                  if (_orgView) _orgChartBody() else _listViewBody(),
                  const SizedBox(height: 20),
                  _summaryBar(),
                  const SizedBox(height: 8),
                  Text(
                    'Click any node to view details · Solid lines = hierarchy · Dashed border = open position',
                    style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  _legendRow(),
                ],
              ),
            ),
          ),
          if (_selected != null) _detailCard(),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final narrow = c.maxWidth < 720;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Organisation chart',
                          style: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w700, color: context.primaryText),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$_company  ›  All departments',
                          style: GoogleFonts.dmSans(fontSize: 13, color: context.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  if (!narrow) ...[
                    _viewToggle(),
                    const SizedBox(width: 12),
                    OutlinedButton(onPressed: () => _toast('Export (mock)'), child: const Text('Export')),
                  ],
                ],
              ),
              if (narrow) ...[
                const SizedBox(height: 12),
                Row(children: [Expanded(child: _viewToggle()), const SizedBox(width: 8), OutlinedButton(onPressed: () => _toast('Export (mock)'), child: const Text('Export'))]),
              ],
              const SizedBox(height: 14),
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Find person...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                  filled: true,
                  fillColor: context.subtleFill,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: context.borderColor)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _viewToggle() {
    return HrPillSegmentedControl(
      width: 248,
      segments: const [
        HrPillSegment(value: 'org', label: 'Org view'),
        HrPillSegment(value: 'list', label: 'List view'),
      ],
      selected: _orgView ? 'org' : 'list',
      onChanged: (v) => setState(() => _orgView = v == 'org'),
    );
  }

  Widget _filterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              Text('Department:', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: context.primaryText)),
              ..._deptFilters.map((d) {
                final on = _deptFilter == d;
                return FilterChip(
                  label: Text(d),
                  selected: on,
                  onSelected: (_) => setState(() => _deptFilter = d),
                  showCheckmark: false,
                  selectedColor: const Color(0xFFDBEAFE),
                  labelStyle: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 12),
                );
              }),
              const SizedBox(width: 8),
              Text(
                '$_totalEmployees employees  ·  $_deptCount departments',
                style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _orgChartBody() {
    final root = _mockRoot;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        children: [
          Center(child: _nodeCard(root, isCeo: true)),
          const SizedBox(height: 8),
          Container(width: 2, height: 16, color: context.borderColor),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, c) {
              final heads = _visibleHeads;
              if (heads.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('No departments match this filter.', style: GoogleFonts.dmSans(color: AppColors.muted)),
                );
              }
              if (c.maxWidth < 900) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: heads.map((h) => _deptColumn(h, width: 200)).toList(),
                  ),
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: heads.map((h) => Expanded(child: _deptColumn(h))).toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          Center(child: _openPositionNode()),
        ],
      ),
    );
  }

  Widget _deptColumn(OrgChartNodeData head, {double? width}) {
    final col = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: _nodeCard(head)),
        if (head.children.isNotEmpty) ...[
          const SizedBox(height: 8),
          Center(child: Container(width: 2, height: 12, color: context.borderColor)),
          const SizedBox(height: 8),
          ...head.children.where(_nodeMatchesSearch).map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _nodeCard(c),
                  if (c.children.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    ...c.children.take(2).map((g) => Padding(padding: const EdgeInsets.only(left: 8, bottom: 6), child: _nodeCard(g, compact: true))),
                    if (c.moreCount > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: TextButton(onPressed: () => _toast('${c.moreCount} more (mock)'), child: Text('+${c.moreCount} more members')),
                      ),
                  ],
                ],
              ),
            );
          }),
        ],
      ],
    );
    if (width != null) {
      return SizedBox(width: width, child: col);
    }
    return col;
  }

  bool _nodeMatchesSearch(OrgChartNodeData n) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return true;
    return n.name.toLowerCase().contains(q) || n.role.toLowerCase().contains(q);
  }

  Widget _nodeCard(OrgChartNodeData n, {bool isCeo = false, bool compact = false}) {
    final style = _DeptPalette.forKey(n.deptKey);
    final selected = _selected?.id == n.id;
    final pad = compact ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8) : const EdgeInsets.symmetric(horizontal: 14, vertical: 12);
    return InkWell(
      onTap: () => setState(() => _selected = n),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: compact ? double.infinity : (isCeo ? 260 : 200),
        padding: pad,
        decoration: BoxDecoration(
          color: isCeo ? const Color(0xFF1E3A5F) : style.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: n.isOpenPosition
                ? AppColors.primary
                : selected
                    ? AppColors.primary
                    : style.border,
            width: n.isOpenPosition || selected ? 2 : 1,
          ),
        ),
        child: n.isOpenPosition
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.primary, size: compact ? 18 : 22),
                  const SizedBox(width: 6),
                  Text(
                    'Open position',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: compact ? 12 : 13),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: compact ? 14 : 18,
                        backgroundColor: isCeo ? Colors.white24 : style.avatarBg,
                        child: Text(
                          n.initials,
                          style: GoogleFonts.dmSans(
                            fontWeight: FontWeight.w800,
                            fontSize: compact ? 10 : 12,
                            color: isCeo ? Colors.white : style.avatarFg,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              n.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w700,
                                fontSize: compact ? 12 : 13,
                                color: isCeo ? Colors.white : style.text,
                              ),
                            ),
                            Text(
                              n.role,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.dmSans(
                                fontSize: compact ? 10 : 11,
                                color: isCeo ? Colors.white70 : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!compact && n.memberCount != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      '${n.memberCount} members',
                      style: GoogleFonts.dmSans(fontSize: 11, color: isCeo ? Colors.white70 : AppColors.muted),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _openPositionNode() {
    final open = OrgChartNodeData.openPosition();
    return _nodeCard(open);
  }

  Widget _listViewBody() {
    final rows = _flattenMock().where((n) => !n.isOpenPosition && _matchesFilter(n)).where(_nodeMatchesSearch).toList();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(context.tableHeaderBg),
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Reports to')),
          ],
          rows: rows
              .map(
                (n) => DataRow(
                  onSelectChanged: (_) => setState(() => _selected = n),
                  cells: [
                    DataCell(Text(n.name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600))),
                    DataCell(Text(n.role)),
                    DataCell(Text(n.deptLabel)),
                    DataCell(Text(n.reportsToName ?? '—')),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  List<OrgChartNodeData> _flattenMock() {
    final out = <OrgChartNodeData>[];
    void visit(OrgChartNodeData n, String? reportsTo) {
      if (!n.isOpenPosition) {
        out.add(
          OrgChartNodeData(
            id: n.id,
            name: n.name,
            role: n.role,
            initials: n.initials,
            deptKey: n.deptKey,
            deptLabel: n.deptLabel,
            memberCount: n.memberCount,
            isOpenPosition: n.isOpenPosition,
            moreCount: n.moreCount,
            reportsToName: reportsTo,
            grade: n.grade,
            since: n.since,
            team: n.team,
            children: const [],
          ),
        );
      }
      for (final c in n.children) {
        visit(c, n.name);
      }
    }

    visit(_mockRoot, null);
    return out;
  }

  Widget _summaryBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: context.subtleFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ..._summary.entries.map((e) {
              final st = _DeptPalette.forLabel(e.key);
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: st.accent, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 6),
                    Text('${e.key}: ', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
                    Text('${e.value}', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
              );
            }),
            Container(width: 1, height: 20, color: context.borderColor),
            const SizedBox(width: 12),
            Text('Total:', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
            const SizedBox(width: 4),
            Text('$_totalEmployees', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  Widget _legendRow() {
    final keys = ['Engineering', 'Finance', 'HR', 'Marketing', 'Operations'];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 14,
      runSpacing: 8,
      children: [
        ...keys.map((k) {
          final st = _DeptPalette.forLabel(k);
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: st.cardBg, border: Border.all(color: st.border), borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 6),
              Text(k, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted)),
            ],
          );
        }),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
            ),
            const SizedBox(width: 6),
            Text('Open position', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ],
    );
  }

  Widget _detailCard() {
    final n = _selected!;
    return Material(
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.borderColor)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: n.isOpenPosition ? context.subtleFill : _DeptPalette.forKey(n.deptKey).avatarBg,
                child: n.isOpenPosition ? Icon(Icons.add, color: AppColors.primary) : Text(n.initials, style: GoogleFonts.dmSans(fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            n.isOpenPosition ? 'Open Position' : n.name,
                            style: GoogleFonts.sora(fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(20)),
                          child: Text('Active', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF065F46))),
                        ),
                        IconButton(onPressed: () => setState(() => _selected = null), icon: const Icon(Icons.close)),
                      ],
                    ),
                    Text(n.role, style: GoogleFonts.dmSans(color: AppColors.textMuted)),
                    const SizedBox(height: 8),
                    Text(
                      'Dept: ${n.deptLabel}   ·   Grade: ${n.grade ?? '—'}   ·   Since: ${n.since ?? '—'}   ·   Team: ${n.team ?? '—'}',
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {
                        if (n.isOpenPosition) {
                          Navigator.of(context, rootNavigator: true).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => const OpenPositionProfileScreen(),
                            ),
                          );
                        } else {
                          _toast('Profile (mock)');
                        }
                      },
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: const Text('View full profile'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toast(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }
}

// ——— Mock tree (swap for API models later) ———

class OrgChartNodeData {
  const OrgChartNodeData({
    required this.id,
    required this.name,
    required this.role,
    required this.initials,
    required this.deptKey,
    required this.deptLabel,
    this.memberCount,
    this.isOpenPosition = false,
    this.moreCount = 0,
    this.reportsToName,
    this.children = const [],
    this.grade,
    this.since,
    this.team,
  });

  final String id;
  final String name;
  final String role;
  final String initials;
  final String deptKey;
  final String deptLabel;
  final int? memberCount;
  final bool isOpenPosition;
  final int moreCount;
  final String? reportsToName;
  final List<OrgChartNodeData> children;
  final String? grade;
  final String? since;
  final String? team;

  factory OrgChartNodeData.openPosition() {
    return const OrgChartNodeData(
      id: 'open-hr-bp',
      name: 'Open Position',
      role: 'HR Business Partner',
      initials: '+',
      deptKey: 'open',
      deptLabel: 'HR',
      isOpenPosition: true,
      grade: 'G-6',
      since: 'Recruiting',
      team: '—',
    );
  }
}

class _DeptPalette {
  const _DeptPalette({
    required this.cardBg,
    required this.border,
    required this.text,
    required this.avatarBg,
    required this.avatarFg,
    required this.accent,
  });

  final Color cardBg;
  final Color border;
  final Color text;
  final Color avatarBg;
  final Color avatarFg;
  final Color accent;

  static _DeptPalette forKey(String key) {
    switch (key) {
      case 'engineering':
        return const _DeptPalette(
          cardBg: Color(0xFFEFF6FF),
          border: Color(0xFFBFDBFE),
          text: Color(0xFF1E40AF),
          avatarBg: Color(0xFFDBEAFE),
          avatarFg: Color(0xFF1E3A8A),
          accent: Color(0xFF2563EB),
        );
      case 'finance':
        return const _DeptPalette(
          cardBg: Color(0xFFECFDF5),
          border: Color(0xFFA7F3D0),
          text: Color(0xFF065F46),
          avatarBg: Color(0xFFD1FAE5),
          avatarFg: Color(0xFF064E3B),
          accent: Color(0xFF059669),
        );
      case 'hr':
        return const _DeptPalette(
          cardBg: Color(0xFFF3E8FF),
          border: Color(0xFFE9D5FF),
          text: Color(0xFF6B21A8),
          avatarBg: Color(0xFFE9D5FF),
          avatarFg: Color(0xFF581C87),
          accent: Color(0xFF9333EA),
        );
      case 'marketing':
        return const _DeptPalette(
          cardBg: Color(0xFFFCE7F3),
          border: Color(0xFFFBCFE8),
          text: Color(0xFF9D174D),
          avatarBg: Color(0xFFFBCFE8),
          avatarFg: Color(0xFF831843),
          accent: Color(0xFFDB2777),
        );
      case 'operations':
        return const _DeptPalette(
          cardBg: Color(0xFFFFFBEB),
          border: Color(0xFFFDE68A),
          text: Color(0xFF92400E),
          avatarBg: Color(0xFFFEF3C7),
          avatarFg: Color(0xFF78350F),
          accent: Color(0xFFD97706),
        );
      default:
        return const _DeptPalette(
          cardBg: Color(0xFFF1F5F9),
          border: Color(0xFFE2E8F0),
          text: Color(0xFF0F172A),
          avatarBg: Color(0xFFE2E8F0),
          avatarFg: Color(0xFF0F172A),
          accent: Color(0xFF64748B),
        );
    }
  }

  static _DeptPalette forLabel(String label) {
    switch (label) {
      case 'Engineering':
        return forKey('engineering');
      case 'Finance':
        return forKey('finance');
      case 'HR':
        return forKey('hr');
      case 'Marketing':
        return forKey('marketing');
      case 'Operations':
        return forKey('operations');
      default:
        return forKey('ceo');
    }
  }
}

final OrgChartNodeData _mockRoot = OrgChartNodeData(
  id: 'ceo',
  name: 'Ahmad Wahid',
  role: 'Chief Executive Officer · CEO',
  initials: 'AW',
  deptKey: 'ceo',
  deptLabel: 'Executive',
  children: [
    OrgChartNodeData(
      id: 'eng-head',
      name: 'David Ng',
      role: 'Head of Eng.',
      initials: 'DN',
      deptKey: 'engineering',
      deptLabel: 'Engineering',
      memberCount: 342,
      children: [
        OrgChartNodeData(
          id: 'sarah',
          name: 'Sarah Lim',
          role: 'Sr. Developer',
          initials: 'SL',
          deptKey: 'engineering',
          deptLabel: 'Engineering',
          moreCount: 8,
          children: [
            const OrgChartNodeData(id: 'hana', name: 'Hana', role: 'Dev', initials: 'H', deptKey: 'engineering', deptLabel: 'Engineering'),
            const OrgChartNodeData(id: 'zul', name: 'Zul M', role: 'Dev', initials: 'ZM', deptKey: 'engineering', deptLabel: 'Engineering'),
          ],
        ),
        const OrgChartNodeData(id: 'raj', name: 'Raj', role: 'Tech Lead', initials: 'R', deptKey: 'engineering', deptLabel: 'Engineering'),
      ],
    ),
    const OrgChartNodeData(
      id: 'cfo',
      name: 'Rachel Tan',
      role: 'CFO',
      initials: 'RT',
      deptKey: 'finance',
      deptLabel: 'Finance',
      memberCount: 180,
      children: [
        OrgChartNodeData(id: 'fa1', name: 'Wei Chen', role: 'Financial Analyst', initials: 'WC', deptKey: 'finance', deptLabel: 'Finance'),
        OrgChartNodeData(id: 'fa2', name: 'Priya Nair', role: 'Controller', initials: 'PN', deptKey: 'finance', deptLabel: 'Finance'),
      ],
    ),
    const OrgChartNodeData(
      id: 'hr-head',
      name: 'Nina Reza',
      role: 'Head of HR',
      initials: 'NR',
      deptKey: 'hr',
      deptLabel: 'HR',
      memberCount: 88,
      children: [
        OrgChartNodeData(id: 'bp1', name: 'Alex Wong', role: 'HR Partner', initials: 'AW', deptKey: 'hr', deptLabel: 'HR'),
      ],
    ),
    const OrgChartNodeData(
      id: 'cmo',
      name: 'Kevin Lim',
      role: 'CMO',
      initials: 'KL',
      deptKey: 'marketing',
      deptLabel: 'Marketing',
      memberCount: 142,
      children: [
        OrgChartNodeData(id: 'm1', name: 'Siti Aminah', role: 'Brand Lead', initials: 'SA', deptKey: 'marketing', deptLabel: 'Marketing'),
      ],
    ),
    const OrgChartNodeData(
      id: 'coo',
      name: 'Malik Said',
      role: 'COO',
      initials: 'MS',
      deptKey: 'operations',
      deptLabel: 'Operations',
      memberCount: 261,
      children: [
        OrgChartNodeData(id: 'op1', name: 'Jonas Lee', role: 'Ops Manager', initials: 'JL', deptKey: 'operations', deptLabel: 'Operations'),
      ],
    ),
  ],
);
