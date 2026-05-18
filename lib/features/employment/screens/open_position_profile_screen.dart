import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

/// Full requisition profile for an open role (from org chart → View full profile).
class OpenPositionProfileScreen extends StatefulWidget {
  const OpenPositionProfileScreen({super.key});

  @override
  State<OpenPositionProfileScreen> createState() => _OpenPositionProfileScreenState();
}

class _OpenPositionProfileScreenState extends State<OpenPositionProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 4, vsync: this);
  String _applicantFilter = 'All';

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
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left, color: AppColors.navy),
          label: Text(
            'Organisation chart',
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: AppColors.navy),
          ),
        ),
        leadingWidth: 200,
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          OutlinedButton(onPressed: () => _toast('Close requisition (mock)'), child: const Text('Close requisition')),
          const SizedBox(width: 8),
          OutlinedButton(onPressed: () => _toast('Share posting (mock)'), child: const Text('Share posting')),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: FilledButton(
              onPressed: () => _toast('Fill position (mock)'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
              ),
              child: const Text('Fill position'),
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _headerBlock(),
          Material(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tab,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.primary,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Applicants (14)'),
                Tab(text: 'Job description'),
                Tab(text: 'Activity log'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _overviewTab(),
                _applicantsTab(),
                _jobDescriptionTab(),
                _activityLogTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerBlock() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final narrow = c.maxWidth < 900;
          final titleBlock = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(Icons.person_add_alt_1_outlined, color: AppColors.muted, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        Text(
                          'HR Business Partner',
                          style: GoogleFonts.sora(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy),
                        ),
                        _pill('Open', bg: const Color(0xFFFEF3C7), fg: const Color(0xFF92400E)),
                        _pill('Urgent', bg: const Color(0xFFFEE2E2), fg: AppColors.danger),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'REQ-2025-047 · HR Department · Kuala Lumpur HQ · Grade G-6',
                      style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _tagChip('AperioOccasio Sdn Bhd'),
                        _tagChip('HR'),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFB45309),
                            side: const BorderSide(color: Color(0xFFFBBF24)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text('Open position', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );

          final metrics = _metricsRow();

          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [titleBlock, const SizedBox(height: 16), metrics],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: titleBlock),
              const SizedBox(width: 24),
              metrics,
            ],
          );
        },
      ),
    );
  }

  Widget _metricsRow() {
    Widget cell(String value, String label, {bool danger = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: danger ? AppColors.danger : AppColors.navy,
              ),
            ),
            Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
          ],
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          cell('14', 'Applicants'),
          const VerticalDivider(width: 1),
          cell('3', 'Shortlisted'),
          const VerticalDivider(width: 1),
          cell('28d', 'Open since'),
          const VerticalDivider(width: 1),
          cell('7d', 'Target left', danger: true),
        ],
      ),
    );
  }

  Widget _pill(String t, {required Color bg, required Color fg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(t, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }

  Widget _tagChip(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(6)),
      child: Text(t, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted)),
    );
  }

  // —— Overview ——
  Widget _overviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, c) {
          final twoCol = c.maxWidth >= 1000;
          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _whiteCard(
                title: 'Requisition details',
                child: Column(
                  children: [
                    _kv('Requisition No.', 'REQ-2025-047'),
                    _kv('Position title', 'HR Business Partner'),
                    _kv('Department', 'Human Resources'),
                    _kv('Reports to', 'Nina Reza'),
                    _kv('Job grade', 'G-6 / Sub A'),
                    _kv('Employment type', 'Permanent · Full-time'),
                    _kv('Salary range', 'MYR 5,500 – 7,000'),
                    _kv('Location', 'Kuala Lumpur HQ'),
                    _kv('Requested by', 'Nina Reza'),
                    _kv('Approved by', 'Ahmad Wahid'),
                    _kv('Open date', '8 Apr 2025'),
                    _kv('Target fill date', '13 May 2025', valueColor: AppColors.danger),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _whiteCard(
                title: 'Recruitment stage',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _stageBar(),
                    const SizedBox(height: 10),
                    Text(
                      'Currently at: Interview stage — 3 candidates shortlisted',
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          );
          final right = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _whiteCard(
                title: 'Applicant pipeline',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _kv('Total applied', '14'),
                    _kv('Screened', '10'),
                    _kv('Phone interview', '6'),
                    _kv('Shortlisted', '3'),
                    _kv('Rejected', '7', valueColor: AppColors.danger),
                    _kv('Withdrawn', '4'),
                    const Divider(height: 24),
                    _kv('Source — Job portal', '8'),
                    _kv('Source — Referral', '4'),
                    _kv('Source — LinkedIn', '2'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _whiteCard(
                title: 'Top shortlisted',
                child: Column(
                  children: [
                    _shortlistRow('LW', 'Lena Wong', '5 yrs exp · HRBP certified', 0.92, AppColors.primary),
                    const SizedBox(height: 12),
                    _shortlistRow('FA', 'Faris Azman', '4 yrs · generalist HR', 0.85, AppColors.success),
                    const SizedBox(height: 12),
                    _shortlistRow('PK', 'Priya Kumar', '6 yrs · MNC HRBP', 0.81, AppColors.purple3),
                  ],
                ),
              ),
            ],
          );
          if (twoCol) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: left),
                const SizedBox(width: 16),
                Expanded(flex: 5, child: right),
              ],
            );
          }
          return Column(children: [left, const SizedBox(height: 16), right]);
        },
      ),
    );
  }

  Widget _stageBar() {
    const stages = ['Approved', 'Posted', 'Screening', 'Interview', 'Offer', 'Onboard'];
    const active = 3;
    return Row(
      children: List.generate(stages.length, (i) {
        final done = i < active;
        final cur = i == active;
        return Expanded(
          child: Column(
            children: [
              Text(
                stages[i],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: cur ? FontWeight.w800 : FontWeight.w500,
                  color: cur ? const Color(0xFFB45309) : AppColors.muted,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                height: 6,
                margin: EdgeInsets.only(right: i < stages.length - 1 ? 4 : 0),
                decoration: BoxDecoration(
                  color: done || cur ? (cur ? const Color(0xFFF59E0B) : AppColors.primary) : AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _shortlistRow(String initials, String name, String sub, double pct, Color bar) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: bar.withValues(alpha: 0.2),
          child: Text(initials, style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, fontSize: 11, color: bar)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
              Text(sub, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
            ],
          ),
        ),
        SizedBox(
          width: 56,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${(pct * 100).round()}%', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, fontSize: 12)),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(value: pct, minHeight: 5, backgroundColor: AppColors.border, color: bar),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // —— Applicants ——
  static const _applicants = [
    _Applicant('Lena Wong', 'LW', 'Applied 10 Apr · 5 yrs · BSc HRM · HRBP Certified', 'Shortlisted', false),
    _Applicant('Faris Azman', 'FA', 'Applied 9 Apr · 4 yrs · Psychology · HR generalist', 'Shortlisted', false),
    _Applicant('Priya Kumar', 'PK', 'Applied 8 Apr · 6 yrs · MBA · MNC HRBP', 'Shortlisted', false),
    _Applicant('Jason Lee', 'JL', 'Applied 7 Apr · 3 yrs · Diploma · Retail HR', 'Rejected', true),
    _Applicant('Maya Soo', 'MS', 'Applied 6 Apr · 2 yrs · Fresh grad', 'Rejected', true),
  ];

  Widget _applicantsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _whiteCard(
        title: 'All applicants',
        trailing: Wrap(
          spacing: 8,
          children: [
            FilterChip(
              label: const Text('All (14)'),
              selected: _applicantFilter == 'All',
              onSelected: (_) => setState(() => _applicantFilter = 'All'),
              showCheckmark: false,
            ),
            FilterChip(
              label: const Text('Shortlisted (3)'),
              selected: _applicantFilter == 'Shortlisted',
              onSelected: (_) => setState(() => _applicantFilter = 'Shortlisted'),
              selectedColor: const Color(0xFFD1FAE5),
              showCheckmark: false,
            ),
            FilterChip(
              label: const Text('Rejected (7)'),
              selected: _applicantFilter == 'Rejected',
              onSelected: (_) => setState(() => _applicantFilter = 'Rejected'),
              selectedColor: const Color(0xFFFEE2E2),
              showCheckmark: false,
            ),
          ],
        ),
        child: Column(
          children: [
            ..._applicants.where((a) {
              if (_applicantFilter == 'All') return true;
              return a.status == _applicantFilter;
            }).map((a) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: a.rejected ? const Color(0xFFFEE2E2) : const Color(0xFFDBEAFE),
                          child: Text(a.initials, style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, fontSize: 12)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                              Text(a.meta, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        _pill(
                          a.status,
                          bg: a.rejected ? const Color(0xFFFEE2E2) : const Color(0xFFD1FAE5),
                          fg: a.rejected ? AppColors.danger : const Color(0xFF065F46),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(onPressed: () => _toast('Applicant profile (mock)'), child: const Text('View')),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                ],
              );
            }),
            const SizedBox(height: 8),
            TextButton(onPressed: () => _toast('Load more (mock)'), child: const Text('+ 9 more applicants — filter to narrow the list')),
          ],
        ),
      ),
    );
  }

  // —— Job description ——
  Widget _jobDescriptionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, c) {
          final twoCol = c.maxWidth >= 900;
          final role = _whiteCard(
            title: 'Role summary',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About the role', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  'We are looking for an experienced HR Business Partner to act as a strategic advisor to department heads, '
                  'drive talent initiatives, and ensure a consistent employee experience across Kuala Lumpur HQ.',
                  style: GoogleFonts.dmSans(fontSize: 13, height: 1.5, color: AppColors.navyMid),
                ),
                const SizedBox(height: 16),
                Text('Key responsibilities', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ...[
                  'Partner with department heads on workforce planning and succession.',
                  'Lead end-to-end recruitment for assigned business units.',
                  'Manage employee relations, investigations, and grievance handling.',
                  'Drive performance management and appraisal cycles.',
                  'Support HR policy development, communication, and compliance.',
                ].map((t) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('•  '),
                          Expanded(child: Text(t, style: GoogleFonts.dmSans(fontSize: 13, height: 1.45))),
                        ],
                      ),
                    )),
              ],
            ),
          );
          final req = _whiteCard(
            title: 'Requirements',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Education', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  "Bachelor's degree in HRM, Business, Psychology or related field.",
                  style: GoogleFonts.dmSans(fontSize: 13, height: 1.45),
                ),
                const SizedBox(height: 12),
                Text('Experience', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Minimum 4 years in an HRBP or generalist HR role.', style: GoogleFonts.dmSans(fontSize: 13)),
                const SizedBox(height: 12),
                Text('Required skills', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['Employee relations', 'Recruitment', 'Performance mgmt', 'Labour law (MY)', 'HRMS systems']
                      .map((s) => Chip(label: Text(s, style: GoogleFonts.dmSans(fontSize: 11)), backgroundColor: const Color(0xFFDBEAFE)))
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text('Preferred skills', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['SHRM / CIPD certified', 'OD experience', 'Payroll knowledge']
                      .map((s) => Chip(label: Text(s, style: GoogleFonts.dmSans(fontSize: 11)), backgroundColor: AppColors.bg))
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text('Salary range', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  'MYR 5,500 – 7,000 / month',
                  style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
          );
          if (twoCol) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: role),
                const SizedBox(width: 16),
                Expanded(child: req),
              ],
            );
          }
          return Column(children: [role, const SizedBox(height: 16), req]);
        },
      ),
    );
  }

  // —— Activity log ——
  Widget _activityLogTab() {
    final items = [
      _LogItem('6 May 2025', const Color(0xFFFBBF24), 'Interview scheduled — Lena Wong, Faris Azman, Priya Kumar',
          'By Nina Reza · Panel: Nina Reza, Ahmad Wahid'),
      _LogItem('3 May 2025', AppColors.primary, '3 candidates shortlisted after phone screening', 'By Maya Tan (Recruiter)'),
      _LogItem('25 Apr 2025', AppColors.primary, 'Phone interviews conducted — 6 candidates', 'By Maya Tan · 4 rejected, 2 withdrawn'),
      _LogItem('15 Apr 2025', AppColors.primary, '14 applications received — initial screening started', 'By Maya Tan'),
      _LogItem('8 Apr 2025', AppColors.success, 'Position posted on JobStreet, LinkedIn and internal portal',
          'Requisition REQ-2025-047 approved by CEO Ahmad Wahid'),
      _LogItem('1 Apr 2025', AppColors.success, 'Requisition submitted by Nina Reza', 'Reason: Department headcount expansion · Budget approved'),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _whiteCard(
        title: 'Activity log',
        child: Column(
          children: items.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 88,
                    child: Text(e.date, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
                  ),
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 4, right: 12),
                    decoration: BoxDecoration(color: e.dot, shape: BoxShape.circle),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(e.subtitle, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _whiteCard({required String title, Widget? trailing, required Widget child}) {
    return Container(
      width: double.infinity,
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
              ?trailing,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _kv(String k, String v, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(k, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
          ),
          Expanded(
            child: Text(
              v,
              style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: valueColor ?? AppColors.navy),
            ),
          ),
        ],
      ),
    );
  }
}

class _Applicant {
  const _Applicant(this.name, this.initials, this.meta, this.status, this.rejected);

  final String name;
  final String initials;
  final String meta;
  final String status;
  final bool rejected;
}

class _LogItem {
  const _LogItem(this.date, this.dot, this.title, this.subtitle);

  final String date;
  final Color dot;
  final String title;
  final String subtitle;
}
