import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../shared/widgets/hr_module_header.dart';
import '../../../shared/widgets/module_shell_background.dart';
import '../../../shared/widgets/themed_surface_card.dart';
import '../widgets/recruitment_ui_helpers.dart';

/// Recruitment Management — requisitions, pipeline, interviews, offers (mock UI).
class RecruitmentManagementScreen extends StatefulWidget {
  const RecruitmentManagementScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<RecruitmentManagementScreen> createState() =>
      _RecruitmentManagementScreenState();
}

class _RecruitmentManagementScreenState extends State<RecruitmentManagementScreen>
    with SingleTickerProviderStateMixin {
  static const _interviewBadge = 5;

  late final TabController _tab = TabController(length: 7, vsync: this);
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
          moduleSubtitle: 'RECRUITMENT MANAGEMENT',
          showPeriodFilter: false,
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
              const Tab(height: 48, child: Text('Job requisition')),
              const Tab(height: 48, child: Text('Job posting')),
              const Tab(height: 48, child: Text('Candidate pipeline')),
              _tabBadge('Interviews', _interviewBadge),
              const Tab(height: 48, child: Text('Offer management')),
              const Tab(height: 48, child: Text('Pre-onboarding')),
              const Tab(height: 48, child: Text('Reports')),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _requisitionTab(),
              _postingTab(),
              _pipelineTab(),
              _interviewsTab(),
              _offerTab(),
              _preOnboardingTab(),
              _reportsTab(),
            ],
          ),
        ),
      ],
    );

    if (widget.embeddedInShell) {
      return ModuleShellBackground(child: body);
    }

    return Scaffold(
      backgroundColor: context.pageBackground,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Recruitment', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: context.primaryText,
        backgroundColor: context.surfaceCard,
        elevation: 0,
      ),
      body: body,
    );
  }

  Widget _tabBadge(String label, int badge) {
    return Tab(
      height: 48,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
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

  Widget _scroll(List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
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

  Widget _toolbar(List<Widget> leading, {Widget? trailing}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [...leading, ?trailing],
    );
  }

  // --- Job requisition ---

  Widget _requisitionTab() {
    return _scroll([
      ThemedSurfaceCard(
        child: const Row(
          children: [
            RecruitKpi(value: '12', label: 'Open requisitions', sub: '3 urgent', subColor: AppColors.warning),
            RecruitKpi(value: '147', label: 'Total applicants', sub: 'This month'),
            RecruitKpi(value: '28d', label: 'Avg. time to hire', sub: '↓ 4 days vs last qtr', subColor: AppColors.success),
          ],
        ),
      ),
      const SizedBox(height: 12),
      ThemedSurfaceCard(
        child: const Row(
          children: [
            RecruitKpi(value: '5', label: 'Offers extended', sub: '3 accepted'),
            RecruitKpi(value: 'MYR 8,400', label: 'Recruitment cost YTD', sub: 'Job ads + agency'),
            RecruitKpi(value: '82%', label: 'Offer acceptance rate', sub: '↑ from 74%', subColor: AppColors.success),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _toolbar([
        SizedBox(
          width: 220,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search position...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
              filled: true,
              fillColor: AppColors.bg,
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        _filterDd('req_status', 'All status', const ['All status', 'Open', 'In review', 'Filled']),
        _filterDd('req_dept', 'All departments', const ['All departments', 'HR', 'Engineering']),
      ], trailing: _primaryBtn('+ New requisition', () => _toast('New requisition'))),
      const SizedBox(height: 12),
      ThemedSurfaceCard(
        padding: EdgeInsets.zero,
        child: _simpleTable(
          const ['Position title', 'Department', 'Type', 'Requested by', 'Open date', 'Target fill', 'Applicants', 'Status', ''],
          [
            ['HR Business Partner', const RecruitPill('HR', tone: RecruitPillTone.purple), 'Permanent', 'Nina Reza', '8 Apr', '13 May', Text('14', style: TextStyle(color: AppColors.primary)), const RecruitPill('Open', tone: RecruitPillTone.warning), _link('View')],
            ['Sr. Frontend Developer', const RecruitPill('Engineering', tone: RecruitPillTone.info), 'Permanent', 'David Ng', '1 Apr', '30 Apr', Text('28', style: TextStyle(color: AppColors.primary)), const RecruitPill('In review', tone: RecruitPillTone.info), _link('View')],
            ['Finance Analyst', const RecruitPill('Finance', tone: RecruitPillTone.success), 'Contract', 'Rachel Tan', '15 Apr', '15 Jan', Text('8', style: TextStyle(color: AppColors.primary)), const RecruitPill('Filled', tone: RecruitPillTone.success), _link('View')],
            ['Operations Lead', const RecruitPill('Operations', tone: RecruitPillTone.warning), 'Permanent', 'Malik Said', '20 Mar', '20 May', Text('11', style: TextStyle(color: AppColors.primary)), const RecruitPill('Open', tone: RecruitPillTone.warning), _link('View')],
            ['Digital Marketing Lead', const RecruitPill('Marketing', tone: RecruitPillTone.pink), 'Permanent', 'Kevin Lim', '25 Apr', '25 Jan', Text('4', style: TextStyle(color: AppColors.primary)), const RecruitPill('On hold', tone: RecruitPillTone.neutral), _link('View')],
          ],
        ),
      ),
    ]);
  }

  // --- Job posting ---

  Widget _postingTab() {
    return _scroll([
      _toolbar([
        _filterDd('post_req', 'All requisitions', const ['All requisitions', 'REQ-2025-047']),
        _filterDd('post_ch', 'All channels', const ['All channels', 'JobStreet', 'LinkedIn']),
      ], trailing: _primaryBtn('+ Create posting', () => _toast('Create posting'))),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final form = _postingForm();
          final right = Column(
            children: [
              _activePostingsCard(),
              const SizedBox(height: 16),
              _sourceBreakdownCard(),
            ],
          );
          if (c.maxWidth > 960) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: form),
                const SizedBox(width: 16),
                Expanded(flex: 3, child: right),
              ],
            );
          }
          return Column(children: [form, const SizedBox(height: 16), right]);
        },
      ),
    ]);
  }

  Widget _postingForm() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Linked requisition', style: GoogleFonts.dmSans(fontSize: 12, color: context.secondaryText)),
          const SizedBox(height: 6),
          _filterDd('linked', 'REQ-2025-047 — HR Business Partner', const ['REQ-2025-047 — HR Business Partner']),
          const SizedBox(height: 12),
          _field('Job title (public facing)', 'HR Business Partner'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _field('Employment type', 'Full-time')),
              const SizedBox(width: 12),
              Expanded(child: _field('Work arrangement', 'On-site')),
            ],
          ),
          const SizedBox(height: 12),
          _field('Salary range (MYR)', 'e.g. 5,500 - 7,000', hint: true),
          const SizedBox(height: 12),
          _field('Job description', 'Key responsibilities, requirements, perks...', multiline: true),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text('Save draft')),
              const Spacer(),
              Expanded(child: _primaryBtn('Publish posting', () => _toast('Published'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activePostingsCard() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Active postings', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700, color: context.primaryText)),
          const SizedBox(height: 12),
          _simpleTable(
            const ['Position', 'Channel', 'Views', 'Applicants', 'Status'],
            [
              ['HR Business Partner', 'JobStreet', '420', Text('14', style: TextStyle(color: AppColors.primary)), const RecruitPill('Live', tone: RecruitPillTone.success)],
              ['Sr. Frontend Dev', 'LinkedIn', '310', Text('28', style: TextStyle(color: AppColors.primary)), const RecruitPill('Live', tone: RecruitPillTone.success)],
              ['Finance Analyst', 'Internal', '88', '—', const RecruitPill('On hold', tone: RecruitPillTone.neutral)],
            ],
          ),
        ],
      ),
    );
  }

  Widget _sourceBreakdownCard() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Text('Applicant source breakdown'),
          SizedBox(height: 12),
          RecruitHBar(label: 'JobStreet', value: 62, max: 62, color: AppColors.primary, trailing: '62'),
          RecruitHBar(label: 'LinkedIn', value: 33, max: 62, color: Color(0xFF818CF8), trailing: '33'),
          RecruitHBar(label: 'Referral', value: 26, max: 62, color: AppColors.success, trailing: '26'),
          RecruitHBar(label: 'Internal', value: 14, max: 62, color: AppColors.warning, trailing: '14'),
          RecruitHBar(label: 'Agency', value: 12, max: 62, color: Color(0xFFF472B6), trailing: '12'),
        ],
      ),
    );
  }

  // --- Candidate pipeline ---

  Widget _pipelineTab() {
    return _scroll([
      _toolbar([
        _filterDd('pipe_role', 'HR Business Partner', const ['HR Business Partner', 'All roles']),
        _filterDd('pipe_src', 'All sources', const ['All sources', 'JobStreet', 'LinkedIn']),
        SizedBox(
          width: 200,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search candidate...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
              filled: true,
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ], trailing: _primaryBtn('+ Add candidate', () => _toast('Add candidate'))),
      const SizedBox(height: 16),
      SizedBox(
        height: 420,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _kanbanCol('Applied', 6, [
              _candCard('AR', 'Aisha Rahman', '3 yrs · BSc HR', 'JobStreet · 6 May'),
              _candCard('BL', 'Ben Loh', '5 yrs · MBA', 'LinkedIn · 5 May'),
              _candCard('CW', 'Cindy Wong', '2 yrs · Dip HR', 'Referral · 4 May'),
            ]),
            _kanbanCol('Screening', 4, [
              _candCard('LW', 'Lena Wong', '6 yrs · BSc Psych', 'JobStreet · 3 May', match: '92%'),
              _candCard('FA', 'Faris Azman', '4 yrs · BBA', 'LinkedIn · 2 May', match: '85%'),
            ]),
            _kanbanCol('Phone interview', 3, [
              _candCard('LW', 'Lena Wong', 'Scheduled 11 May', '', tag: const RecruitPill('Confirmed', tone: RecruitPillTone.info)),
              _candCard('FA', 'Faris Azman', 'Scheduled 11 May', '', tag: const RecruitPill('Pending confirm', tone: RecruitPillTone.warning)),
            ]),
            _kanbanCol('Panel interview', 2, [
              _candCard('LW', 'Lena Wong', 'Panel 14 May', '2 interviewers', tag: const RecruitPill('2 interviewers', tone: RecruitPillTone.purple)),
            ]),
            _kanbanCol('Offer', 1, [
              _candCard('LW', 'Lena Wong', 'Offer extended', '', tag: const RecruitPill('Awaiting accept', tone: RecruitPillTone.info)),
            ]),
            _kanbanCol('Hired', 0, [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text('No hired candidates yet for this role.', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
              ),
            ]),
          ],
        ),
      ),
    ]);
  }

  Widget _kanbanCol(String title, int count, List<Widget> cards) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: context.subtleFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 13))),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: Text('$count', style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ),
              ],
            ),
          ),
          Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 8), children: cards)),
        ],
      ),
    );
  }

  Widget _candCard(String initials, String name, String line1, String line2, {String? match, Widget? tag}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RecruitAvatar(initials),
              const SizedBox(width: 8),
              Expanded(child: Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 13))),
              if (match != null) Text(match, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          Text(line1, style: GoogleFonts.dmSans(fontSize: 11, color: context.secondaryText)),
          if (line2.isNotEmpty) Text(line2, style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.muted)),
          if (tag != null) ...[const SizedBox(height: 6), tag],
        ],
      ),
    );
  }

  // --- Interviews ---

  Widget _interviewsTab() {
    return _scroll([
      _toolbar([
        _filterDd('int_req', 'All requisitions', const ['All requisitions']),
        _filterDd('int_st', 'All status', const ['All status', 'Confirmed', 'Pending']),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('5 upcoming today', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.warning)),
        ),
      ], trailing: _primaryBtn('+ Schedule interview', () => _toast('Scheduled'))),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final left = _scheduleInterviewForm();
          final right = Column(
            children: [
              _upcomingInterviewsCard(),
              const SizedBox(height: 16),
              _scorecardCard(),
            ],
          );
          if (c.maxWidth > 960) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: left),
                const SizedBox(width: 16),
                Expanded(flex: 3, child: right),
              ],
            );
          }
          return Column(children: [left, const SizedBox(height: 16), right]);
        },
      ),
    ]);
  }

  Widget _scheduleInterviewForm() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Schedule interview', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _field('Candidate', 'Lena Wong — HR Business Partner'),
          const SizedBox(height: 12),
          _field('Interview stage', 'Phone screening'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _field('Date', '14/05/2026')),
              const SizedBox(width: 12),
              Expanded(child: _field('Time', '09:00 AM')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _field('Duration', '30 minutes')),
              const SizedBox(width: 12),
              Expanded(child: _field('Format', 'In person')),
            ],
          ),
          const SizedBox(height: 12),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: true, onChanged: (_) {}, title: const Text('Send calendar invite to candidate')),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: true, onChanged: (_) {}, title: const Text('Send reminder 24 hrs before')),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text('Cancel')),
              const Spacer(),
              Expanded(child: _primaryBtn('Schedule', () => _toast('Interview scheduled'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _upcomingInterviewsCard() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Upcoming interviews', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _simpleTable(
            const ['Candidate', 'Stage', 'Date', 'Time', 'Format', 'Status'],
            [
              ['Lena Wong', 'Panel', '14 May', '10:00 AM', 'In person', const RecruitPill('Confirmed', tone: RecruitPillTone.success)],
              ['Faris Azman', 'Phone', '11 May', '09:00 AM', 'Phone', const RecruitPill('Pending', tone: RecruitPillTone.warning)],
              ['Priya Kumar', 'Panel', '15 May', '02:00 PM', 'Video', const RecruitPill('Confirmed', tone: RecruitPillTone.success)],
              ['Rajan Singh', 'Phone', '12 May', '11:00 AM', 'Phone', const RecruitPill('No show', tone: RecruitPillTone.danger)],
            ],
          ),
        ],
      ),
    );
  }

  Widget _scorecardCard() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Interview scorecard — Lena Wong', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
              const Spacer(),
              const RecruitPill('Panel interview', tone: RecruitPillTone.purple),
            ],
          ),
          const SizedBox(height: 12),
          _scoreBar('Communication', 0.9, AppColors.primary),
          _scoreBar('HR knowledge', 0.95, AppColors.success),
          _scoreBar('Problem solving', 0.88, AppColors.primary),
          _scoreBar('Culture fit', 0.92, const Color(0xFF818CF8)),
          _scoreBar('Leadership', 0.8, AppColors.warning),
          const SizedBox(height: 12),
          const RecruitPill('Proceed to offer', tone: RecruitPillTone.success),
        ],
      ),
    );
  }

  Widget _scoreBar(String label, double v, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 110, child: Text(label, style: GoogleFonts.dmSans(fontSize: 12))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: v, minHeight: 8, backgroundColor: context.subtleFill, color: color),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(v * 100).round()}%', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // --- Offer management ---

  Widget _offerTab() {
    return _scroll([
      _toolbar([
        _filterDd('off_st', 'All status', const ['All status', 'Sent', 'Accepted']),
        _filterDd('off_pos', 'All positions', const ['All positions']),
      ], trailing: _primaryBtn('+ Create offer', () => _toast('Create offer'))),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final form = _offerForm();
          final right = Column(
            children: [
              _offerTrackerCard(),
              const SizedBox(height: 16),
              _stageProgressCard(),
            ],
          );
          if (c.maxWidth > 960) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: form),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: right),
              ],
            );
          }
          return Column(children: [form, const SizedBox(height: 16), right]);
        },
      ),
    ]);
  }

  Widget _offerForm() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Offer letter — Lena Wong', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700)),
              const Spacer(),
              const RecruitPill('Awaiting acceptance', tone: RecruitPillTone.warning),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const RecruitAvatar('LW', bg: Color(0xFFE0F2FE)),
              const SizedBox(width: 8),
              Text('HR Business Partner — REQ-2025-047', style: GoogleFonts.dmSans(fontSize: 12, color: context.secondaryText)),
            ],
          ),
          const SizedBox(height: 16),
          _field('Position title', 'HR Business Partner'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _field('Basic salary (MYR)', '6500')),
              const SizedBox(width: 12),
              Expanded(child: _field('Allowances (MYR)', '650')),
            ],
          ),
          const SizedBox(height: 12),
          _field('Proposed start date', '02/06/2026'),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text('Preview PDF')),
              const Spacer(),
              Expanded(child: _primaryBtn('Send offer', () => _toast('Offer sent'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _offerTrackerCard() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Offer tracker', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _simpleTable(
            const ['Candidate', 'Position', 'Salary', 'Sent', 'Expiry', 'Status'],
            [
              ['Lena Wong', 'HR BP', 'MYR 6,500', '6 May', Text('20 May', style: TextStyle(color: AppColors.danger)), const RecruitPill('Sent', tone: RecruitPillTone.warning)],
              ['Ahmad B', 'Ops Lead', 'MYR 9,200', '1 May', '1 Jun', const RecruitPill('Accepted', tone: RecruitPillTone.success)],
              ['Sara K', 'Marketing', 'MYR 5,800', '20 Apr', '—', const RecruitPill('Declined', tone: RecruitPillTone.danger)],
            ],
          ),
        ],
      ),
    );
  }

  Widget _stageProgressCard() {
    final stages = ['Applied', 'Screened', 'Phone', 'Panel', 'Offer sent', 'Accepted', 'Hired'];
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Stage progress — Lena Wong', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            children: [
              for (var i = 0; i < stages.length; i++)
                RecruitPill(
                  stages[i],
                  tone: i < 5 ? RecruitPillTone.success : RecruitPillTone.neutral,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Total cost to company: MYR 7,150/mth', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.primary)),
        ],
      ),
    );
  }

  // --- Pre-onboarding ---

  Widget _preOnboardingTab() {
    return _scroll([
      _toolbar([
        _filterDd('pre_st', 'All status', const ['All status', 'Docs pending', 'Ready']),
      ], trailing: _primaryBtn('+ Start pre-onboarding', () => _toast('Pre-onboarding started'))),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final left = _preOnboardingChecklist();
          final right = Column(
            children: [
              _preQueueCard(),
              const SizedBox(height: 16),
              _preActivityCard(),
            ],
          );
          if (c.maxWidth > 960) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: left),
                const SizedBox(width: 16),
                Expanded(flex: 3, child: right),
              ],
            );
          }
          return Column(children: [left, const SizedBox(height: 16), right]);
        },
      ),
    ]);
  }

  Widget _preOnboardingChecklist() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const RecruitAvatar('AB', bg: Color(0xFFD1FAE5)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ahmad Bakri', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 15)),
                    Text('Operations Lead · Start: 2 Jun 2026', style: GoogleFonts.dmSans(fontSize: 12, color: context.secondaryText)),
                  ],
                ),
              ),
              const RecruitPill('Docs pending', tone: RecruitPillTone.warning),
            ],
          ),
          const SizedBox(height: 16),
          ...[
            ('Signed offer letter', RecruitPillTone.success),
            ('NRIC / passport copy', RecruitPillTone.success),
            ('Bank account details', RecruitPillTone.success),
            ('EPF member number', RecruitPillTone.warning),
            ('Emergency contact form', RecruitPillTone.warning),
          ].map((e) => _docRow(e.$1, e.$2)),
          const Divider(),
          Text('System provisioning', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 13)),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: true, onChanged: (_) {}, title: const Text('Create HRMS employee account')),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: true, onChanged: (_) {}, title: const Text('Set up email account')),
          CheckboxListTile(contentPadding: EdgeInsets.zero, value: false, onChanged: (_) {}, title: const Text('Register biometric (TA terminal)')),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text('Send reminder')),
              const Spacer(),
              Expanded(child: _primaryBtn('Mark ready to onboard', () => _toast('Marked ready'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _docRow(String label, RecruitPillTone tone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: GoogleFonts.dmSans(fontSize: 13))),
          RecruitPill(tone == RecruitPillTone.success ? 'Received' : 'Pending', tone: tone),
        ],
      ),
    );
  }

  Widget _preQueueCard() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Pre-onboarding queue', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _simpleTable(
            const ['Candidate', 'Position', 'Start date', 'Docs', 'Ready?'],
            [
              [const RecruitAvatar('AB'), 'Operations Lead', '2 Jun', const RecruitPill('4/7 received', tone: RecruitPillTone.warning), const RecruitPill('Not ready', tone: RecruitPillTone.pink)],
              [const RecruitAvatar('LW'), 'HR BP', 'TBD', const RecruitPill('Offer pending', tone: RecruitPillTone.neutral), const Text('—')],
            ],
          ),
        ],
      ),
    );
  }

  Widget _preActivityCard() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Onboarding activity log', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _logLine('6 May', 'Offer accepted — Ahmad Bakri', AppColors.primary),
          _logLine('5 May', 'Document request email sent — Ahmad Bakri', AppColors.primary),
          _logLine('25 Apr', 'All documents received — Zara Nor', AppColors.success),
        ],
      ),
    );
  }

  Widget _logLine(String date, String text, Color dot) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 48, child: Text(date, style: GoogleFonts.dmSans(fontSize: 12, color: context.secondaryText))),
          Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 4), decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.dmSans(fontSize: 13))),
        ],
      ),
    );
  }

  // --- Reports ---

  Widget _reportsTab() {
    return _scroll([
      _toolbar([
        _filterDd('rpt_q', 'Q2 2024', const ['Q1 2024', 'Q2 2024']),
        _filterDd('rpt_d', 'All departments', const ['All departments']),
      ], trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(onPressed: () {}, child: const Text('Generate PDF')),
          const SizedBox(width: 8),
          _primaryBtn('Export', () => _toast('Export queued')),
        ],
      )),
      const SizedBox(height: 16),
      ThemedSurfaceCard(
        child: const Row(
          children: [
            RecruitKpi(value: '28 days', label: 'Avg. time to hire', sub: '↓ 4d vs Q1', subColor: AppColors.success),
            RecruitKpi(value: '82%', label: 'Offer acceptance rate', sub: '↑ from 74%', subColor: AppColors.success),
            RecruitKpi(value: 'MYR 8,400', label: 'Total recruitment cost YTD'),
          ],
        ),
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final left = Column(
            children: [
              _conversionCard(),
              const SizedBox(height: 16),
              _costBySourceCard(),
            ],
          );
          final right = Column(
            children: [
              _reqSummaryCard(),
              const SizedBox(height: 16),
              _tthByDeptCard(),
            ],
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
          return Column(children: [left, const SizedBox(height: 16), right]);
        },
      ),
    ]);
  }

  Widget _conversionCard() {
    return const ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Pipeline conversion rate'),
          SizedBox(height: 12),
          RecruitHBar(label: 'Applied → Screen', value: 68, max: 68, color: AppColors.primary, trailing: '68%'),
          RecruitHBar(label: 'Screen → Phone', value: 55, max: 68, color: Color(0xFF818CF8), trailing: '55%'),
          RecruitHBar(label: 'Phone → Panel', value: 40, max: 68, color: AppColors.secondaryAccent, trailing: '40%'),
          RecruitHBar(label: 'Panel → Offer', value: 35, max: 68, color: AppColors.warning, trailing: '35%'),
          RecruitHBar(label: 'Offer → Hired', value: 28, max: 68, color: AppColors.success, trailing: '28%'),
        ],
      ),
    );
  }

  Widget _costBySourceCard() {
    return const ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Recruitment cost by source'),
          SizedBox(height: 12),
          RecruitHBar(label: 'JobStreet ads', value: 4620, max: 4620, color: AppColors.primary, trailing: '4,620'),
          RecruitHBar(label: 'LinkedIn ads', value: 2520, max: 4620, color: Color(0xFF818CF8), trailing: '2,520'),
          RecruitHBar(label: 'Agency fees', value: 1260, max: 4620, color: AppColors.warning, trailing: '1,260'),
        ],
      ),
    );
  }

  Widget _reqSummaryCard() {
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Requisition status summary', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...[
            ('Open positions', '12'),
            ('Filled this quarter', '5'),
            ('Total applicants', '147'),
            ('Offers accepted', '4'),
          ].map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(child: Text(e.$1)),
                    Text(e.$2, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _tthByDeptCard() {
    return const ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Time to hire by department (days)'),
          SizedBox(height: 12),
          RecruitHBar(label: 'Engineering', value: 36, max: 36, color: AppColors.primary, trailing: '36d'),
          RecruitHBar(label: 'Finance', value: 28, max: 36, color: AppColors.secondaryAccent, trailing: '28d'),
          RecruitHBar(label: 'HR', value: 25, max: 36, color: Color(0xFF818CF8), trailing: '25d'),
          RecruitHBar(label: 'Operations', value: 22, max: 36, color: AppColors.warning, trailing: '22d'),
          RecruitHBar(label: 'Marketing', value: 19, max: 36, color: Color(0xFFF472B6), trailing: '19d'),
        ],
      ),
    );
  }

  // --- Helpers ---

  Widget _field(String label, String value, {bool hint = false, bool multiline = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: context.secondaryText)),
        const SizedBox(height: 6),
        // TextFormField.initialValue avoids the per-rebuild TextEditingController allocation that
        // the previous implementation did. The old code leaked a controller every time setState
        // fired and also wiped user input on every parent rebuild.
        TextFormField(
          initialValue: hint ? '' : value,
          maxLines: multiline ? 4 : 1,
          decoration: InputDecoration(
            hintText: hint ? value : null,
            filled: true,
            fillColor: context.subtleFill,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _link(String label) => TextButton(onPressed: () {}, child: Text(label));

  Widget _simpleTable(List<String> headers, List<List<Object>> rows) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(context.subtleFill),
        columns: headers.map((h) => DataColumn(label: Text(h, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w700)))).toList(),
        rows: rows
            .map(
              (cells) => DataRow(
                cells: cells
                    .map((c) => DataCell(c is Widget ? c : Text('$c')))
                    .toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
