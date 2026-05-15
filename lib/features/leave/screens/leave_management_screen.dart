import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/hr_full_width_data_table.dart';
import '../../../shared/widgets/hr_module_header.dart';

/// Leave Management — mock-aligned tabs (Leave type … Employee leave profile).
class LeaveManagementScreen extends StatefulWidget {
  const LeaveManagementScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<LeaveManagementScreen> createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends State<LeaveManagementScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 8, vsync: this);
  final Set<int> _attachmentSelected = {1, 3};
  /// Toolbar / filter dropdown selections (mock filters).
  final Map<String, String> _leaveFilterDd = {};

  static const _approvalPendingCount = 6;
  static const _attachmentRowCount = 5;

  bool? get _attachSelectAll {
    if (_attachmentSelected.isEmpty) return false;
    if (_attachmentSelected.length == _attachmentRowCount) return true;
    return null;
  }

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
          moduleSubtitle: 'LEAVE MANAGEMENT',
          showYearFilter: true,
          navyPrimaryButton: true,
          showMoreMenu: true,
          primaryActionLabel: '+ New leave request',
          onPrimaryAction: () => _toast('New leave request'),
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
              _tabIcon(Icons.grid_view_outlined, 'Leave type'),
              _tabIcon(Icons.article_outlined, 'Leave policy'),
              _tabIcon(Icons.attachment_outlined, 'Leave attachment'),
              _tabIcon(Icons.edit_calendar_outlined, 'Leave request'),
              _tabIcon(Icons.people_outline, 'Request for others'),
              _tabApproval(),
              _tabIcon(Icons.history, 'Leave history'),
              _tabIcon(Icons.person_outline, 'Employee leave profile'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _leaveTypeTab(),
              _leavePolicyTab(),
              _leaveAttachmentTab(),
              const _LeaveRequestTab(),
              const _RequestForOthersTab(),
              _leaveApprovalTab(),
              _leaveHistoryTab(),
              _employeeLeaveProfileTab(),
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
        title: Text('Leave Management', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: body,
    );
  }

  Widget _tabIcon(IconData icon, String label) {
    return Tab(
      height: 52,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _tabApproval() {
    return Tab(
      height: 52,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 18),
          const SizedBox(width: 6),
          const Text('Leave approval'),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$_approvalPendingCount',
              style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: const Color(0xFFC2410C)),
            ),
          ),
        ],
      ),
    );
  }

  // ——— Leave type ———

  Widget _leaveTypeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
                SizedBox(
                  width: 260,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search leave type...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                      filled: true,
                      fillColor: AppColors.bg,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                    ),
                  ),
                ),
                _filterDropdown('leaveType_kind', 'All types', const ['All types', 'Paid', 'Unpaid']),
                OutlinedButton.icon(
                  onPressed: () => _toast('New leave type'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New leave type'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: HrFullWidthDataTable(
              columnSpecs: const [
                ('Leave type name', 2.4),
                ('Paid?', 0.8),
                ('Deduction rate', 1.2),
                ('Hour based', 0.9),
                ('Attachment req.', 1.1),
                ('Status', 0.9),
                ('Actions', 1.3),
              ],
              rows: [
                _typeRow('Annual leave', const Color(0xFF2563EB), true, 'No deduct...', false, false),
                _typeRow('Medical leave', const Color(0xFF059669), true, 'No deduct...', false, true),
                _typeRow('Emergency leave', const Color(0xFFEA580C), true, 'No deduct...', false, false),
                _typeRow('Unpaid leave', const Color(0xFFEF4444), false, 'Normal rate', false, false),
                _typeRow('Replacement leave', const Color(0xFF7C3AED), true, 'No deduct...', false, false),
                _typeRow('Maternity leave', const Color(0xFFEC4899), true, 'No deduct...', false, true),
                _typeRow('Hour leave', const Color(0xFF0D9488), true, 'No deduct...', true, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _typeRow(String name, Color dot, bool paid, String deduct, bool hourBased, bool attachReq) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Container(width: 10, height: 10, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
              const SizedBox(width: 10),
              Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        DataCell(_pill(paid ? 'Yes' : 'No', paid ? const Color(0xFFD1FAE5) : AppColors.errorSurface, paid ? const Color(0xFF065F46) : AppColors.danger)),
        DataCell(Text(deduct, style: GoogleFonts.dmSans(fontSize: 13))),
        DataCell(_pill(hourBased ? 'Yes' : 'No', hourBased ? const Color(0xFFDBEAFE) : AppColors.bg, hourBased ? AppColors.primary : AppColors.textMuted)),
        DataCell(_pill(attachReq ? 'Yes' : 'No', attachReq ? const Color(0xFFFEF3C7) : AppColors.bg, attachReq ? const Color(0xFF92400E) : AppColors.textMuted)),
        DataCell(_pill('Active', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(onPressed: () => _toast('Edit $name'), child: const Text('Edit')),
              IconButton(onPressed: () => _toast('More $name'), icon: const Icon(Icons.more_vert, size: 20)),
            ],
          ),
        ),
      ],
    );
  }

  // ——— Leave policy ———

  Widget _leavePolicyTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
                    _filterDropdown('policy_leaveTypes', 'All leave types', const ['All leave types', 'Annual', 'Medical']),
                    _filterDropdown('policy_dept', 'All departments', const ['All departments', 'HR']),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () => _toast('New policy'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New policy'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 1000;
              final annual = _policyCardAnnual();
              final medical = _policyCardMedical();
              final emergency = _policyCardEmergency();
              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    annual,
                    const SizedBox(height: 16),
                    medical,
                    const SizedBox(height: 16),
                    emergency,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: annual),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        medical,
                        const SizedBox(height: 16),
                        emergency,
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _leaveAttachmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
                    _filterDropdown('attach_leaveTypes', 'All leave types', const ['All leave types', 'Annual']),
                    _filterDropdown('attach_dept', 'All departments', const ['All departments', 'HR']),
                    _filterDropdown('attach_status', 'All status', const ['All status', 'Attached']),
                  ],
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton(onPressed: () {
                      setState(() {
                        if (_attachmentSelected.length == _attachmentRowCount) {
                          _attachmentSelected.clear();
                        } else {
                          _attachmentSelected.clear();
                          for (var i = 0; i < _attachmentRowCount; i++) {
                            _attachmentSelected.add(i);
                          }
                        }
                      });
                    }, child: const Text('Select all')),
                    FilledButton.tonal(onPressed: () => _toast('Manual attach'), child: const Text('Manual attach')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: HrFullWidthDataTable(
              headingRowColor: const Color(0xFFF5F0E8),
              dataRowMinHeight: 52,
              dataRowMaxHeight: 72,
              columnSpecs: const [
                ('', 0.35),
                ('Employee', 1.6),
                ('Department', 1.1),
                ('Leave type', 1.5),
                ('Entitlement', 0.9),
                ('Attached?', 0.8),
                ('Activation', 0.9),
                ('', 0.8),
              ],
              headerCells: [
                Checkbox(
                  value: _attachSelectAll,
                  tristate: true,
                  onChanged: (v) {
                    setState(() {
                      _attachmentSelected.clear();
                      if (v == true) {
                        for (var i = 0; i < _attachmentRowCount; i++) {
                          _attachmentSelected.add(i);
                        }
                      }
                    });
                  },
                ),
                null,
                null,
                null,
                null,
                null,
                null,
                null,
              ],
              rows: [
                _attachRow(0, 'SL', 'Sarah Lim', 'Engineering', 'Maternity leave', const Color(0xFFEC4899), '60 days', false, true),
                _attachRow(1, 'RK', 'Raj Kumar', 'Engineering', 'Annual leave', const Color(0xFF2563EB), '16 days', true, false),
                _attachRow(2, 'MT', 'Maya Tan', 'HR', 'Replacement leave', const Color(0xFF7C3AED), '2 days', false, true),
                _attachRow(3, 'AL', 'Ahmad L', 'Operations', 'Medical leave', const Color(0xFF0D9488), '14 days', true, false),
                _attachRow(4, 'NC', 'Nadia Chen', 'Marketing', 'Maternity leave', const Color(0xFFEC4899), '60 days', false, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _attachRow(
    int id,
    String initials,
    String name,
    String dept,
    String leaveName,
    Color dot,
    String entitlement,
    bool attached,
    bool manual,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Checkbox(
            value: _attachmentSelected.contains(id),
            onChanged: (v) {
              setState(() {
                if (v == true) {
                  _attachmentSelected.add(id);
                } else {
                  _attachmentSelected.remove(id);
                }
              });
            },
          ),
        ),
        DataCell(
          Row(
            children: [
              CircleAvatar(radius: 14, backgroundColor: AppColors.primary.withValues(alpha: 0.12), child: Text(initials, style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w800))),
              const SizedBox(width: 8),
              Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        DataCell(Text(dept)),
        DataCell(
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Flexible(child: Text(leaveName, style: GoogleFonts.dmSans(fontSize: 13))),
            ],
          ),
        ),
        DataCell(Text(entitlement)),
        DataCell(Text(attached ? 'Yes' : 'No', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: attached ? AppColors.success : AppColors.muted))),
        DataCell(
          _pill(
            manual ? 'Manual' : 'Auto',
            manual ? const Color(0xFFFFEDD5) : const Color(0xFFD1FAE5),
            manual ? const Color(0xFFC2410C) : const Color(0xFF065F46),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () => _toast(attached ? 'View' : 'Attach'),
                child: Text(attached ? 'View' : 'Attach'),
              ),
              IconButton(onPressed: () => _toast('Row menu'), icon: const Icon(Icons.more_vert, size: 20)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _leaveApprovalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
                    _filterDropdown('approval_status', 'All status', const ['All status', 'Pending']),
                    _filterDropdown('approval_leaveTypes', 'All leave types', const ['All leave types', 'Annual']),
                    _filterDropdown('approval_date', '06/05/2026', const ['06/05/2026', '01/05/2026']),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(20)),
                      child: Text('$_approvalPendingCount pending', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: const Color(0xFFC2410C), fontSize: 12)),
                    ),
                  ],
                ),
                TextButton(onPressed: () => _toast('Reset filters'), child: const Text('Reset')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: HrFullWidthDataTable(
              columnSpecs: const [
                ('Employee', 1.5),
                ('Leave type', 0.9),
                ('From / To', 1.1),
                ('Days', 0.5),
                ('Reason', 1.2),
                ('Approved by', 1.0),
                ('Status', 0.9),
                ('Actions', 1.2),
              ],
              rows: [
                _approvalRow(
                  'SL',
                  'Sarah Lim',
                  'Annual',
                  const Color(0xFFDBEAFE),
                  '12 May',
                  '14 May',
                  '3',
                  'Family trip',
                  pending: true,
                  statusLabel: 'Pending',
                  statusBg: const Color(0xFFFFEDD5),
                  statusFg: const Color(0xFFC2410C),
                ),
                _approvalRow(
                  'RK',
                  'Raj Kumar',
                  'Medical',
                  const Color(0xFFD1FAE5),
                  '2 May',
                  '2 May',
                  '1',
                  'Fever',
                  accepted: true,
                  statusLabel: 'Accepted',
                  statusBg: const Color(0xFFD1FAE5),
                  statusFg: const Color(0xFF065F46),
                ),
                _approvalRow(
                  'NC',
                  'Nadia Chen',
                  'Annual',
                  const Color(0xFFDBEAFE),
                  '5 May',
                  '6 May',
                  '2',
                  'Personal',
                  denied: true,
                  statusLabel: 'Denied',
                  statusBg: AppColors.errorSurface,
                  statusFg: AppColors.danger,
                  actionNote: 'Peak period',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _approvalRow(
    String initials,
    String name,
    String typeLabel,
    Color typeBg,
    String from,
    String to,
    String days,
    String reason, {
    bool pending = false,
    bool accepted = false,
    bool denied = false,
    required String statusLabel,
    required Color statusBg,
    required Color statusFg,
    String? actionNote,
  }) {
    Widget actions;
    if (pending) {
      actions = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12)),
            onPressed: () => _toast('Approved $name'),
            child: const Text('Approve'),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: AppColors.danger)),
            onPressed: () => _toast('Denied $name'),
            child: const Text('Deny'),
          ),
        ],
      );
    } else if (actionNote != null) {
      actions = Text(actionNote, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.danger, fontWeight: FontWeight.w600));
    } else {
      actions = Text(statusLabel, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: statusFg));
    }

    return DataRow(
      cells: [
        DataCell(_empCell(initials, name)),
        DataCell(_leaveTypePill(typeLabel, typeBg)),
        DataCell(Text('$from → $to')),
        DataCell(Text(days)),
        DataCell(SizedBox(width: 120, child: Text(reason, maxLines: 2, overflow: TextOverflow.ellipsis))),
        DataCell(
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: pending ? AppColors.danger : (accepted ? AppColors.success : AppColors.muted)),
              const SizedBox(width: 4),
              Text('David Ng', style: GoogleFonts.dmSans(fontSize: 12)),
              if (accepted) const Icon(Icons.check, size: 14, color: AppColors.success),
              if (denied) const Icon(Icons.close, size: 14, color: AppColors.navy),
            ],
          ),
        ),
        DataCell(_pill(statusLabel, statusBg, statusFg)),
        DataCell(actions),
      ],
    );
  }

  Widget _leaveHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
                    _filterDropdown('history_status', 'All status', const ['All status', 'Pending']),
                    _filterDropdown('history_leaveTypes', 'All leave types', const ['All leave types']),
                    _filterDropdown('history_dept', 'All departments', const ['All departments']),
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
                    OutlinedButton(onPressed: () => _toast('Leave card'), child: const Text('Leave card')),
                    OutlinedButton(onPressed: () => _toast('Generate PDF'), child: const Text('Generate PDF')),
                    FilledButton(onPressed: () => _toast('Export'), child: const Text('Export')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _whiteCard(
            child: HrFullWidthDataTable(
              cellHorizontalPadding: 8,
              columnSpecs: const [
                ('Employee', 1.5),
                ('Leave type', 0.9),
                ('From / To', 1.0),
                ('Days', 0.5),
                ('Requested by', 1.0),
                ('Approved by', 1.0),
                ('Status', 0.9),
                ('Action', 0.7),
              ],
              rows: [
                _historyRow('SL', 'Sarah Lim', 'Annual', const Color(0xFFDBEAFE), '12 May', '14 May', '3', 'Self', 'David Ng', false, false, 'Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
                _historyRow('RK', 'Raj Kumar', 'Medical', const Color(0xFFD1FAE5), '2 May', '2 May', '1', 'Self', 'David Ng', true, false, 'Accepted', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                _historyRow('MT', 'Maya Tan', 'Medical', const Color(0xFFD1FAE5), '1 May', '1 May', '1', 'HR (behalf)', 'Nina Reza', false, false, 'Waiting file', const Color(0xFFDBEAFE), AppColors.primary),
                _historyRow('NC', 'Nadia Chen', 'Annual', const Color(0xFFDBEAFE), '5 May', '6 May', '2', 'Self', 'Kevin Lim', false, true, 'Denied', AppColors.errorSurface, AppColors.danger),
                _historyRow('AL', 'Ahmad L.', 'Unpaid', AppColors.bg, '9 May', '9 May', '1', 'Self', 'Malik Said', false, false, 'Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
                _historyRow('ZN', 'Zara Nor', 'Annual', const Color(0xFFDBEAFE), '21 Apr', '22 Apr', '2', 'Self', 'Malik Said', true, false, 'Cancelled', AppColors.bg, AppColors.textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DataRow _historyRow(
    String i,
    String name,
    String type,
    Color typeBg,
    String a,
    String b,
    String days,
    String by,
    String approver,
    bool check,
    bool cross,
    String status,
    Color stBg,
    Color stFg,
  ) {
    return DataRow(
      cells: [
        DataCell(_empCell(i, name)),
        DataCell(_leaveTypePill(type, typeBg)),
        DataCell(Text('$a → $b')),
        DataCell(Text(days)),
        DataCell(Text(by)),
        DataCell(
          Row(
            children: [
              Text(approver),
              if (check) const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.check_circle, color: AppColors.success, size: 16)),
              if (cross) const Padding(padding: EdgeInsets.only(left: 4), child: Icon(Icons.cancel, color: AppColors.danger, size: 16)),
            ],
          ),
        ),
        DataCell(_pill(status, stBg, stFg)),
        DataCell(TextButton(onPressed: () => _toast('View $name'), child: const Text('View'))),
      ],
    );
  }

  Widget _employeeLeaveProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _whiteCard(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _filterDropdown('empProfile_employee', 'Sarah Lim (EMP-0021)', const ['Sarah Lim (EMP-0021)', 'Raj Kumar (EMP-0048)']),
                TextButton(onPressed: () => _toast('Leave & time off policy'), child: const Text('Leave & time off policy')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final left = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _whiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(radius: 28, backgroundColor: AppColors.primary.withValues(alpha: 0.2), child: Text('SL', style: GoogleFonts.dmSans(fontWeight: FontWeight.w800))),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Sarah Lim Wei Ling', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700)),
                                  Text('EMP-0021 · Engineering · Senior Developer', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _kvLine('Employment type', 'Permanent'),
                        _kvLine('Join date', '12 Jan 2021'),
                        _kvLine('Service period', '4 years 3 months'),
                        _kvLine('Leave year', 'Jan – Dec 2026'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _whiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Leave entitlement & balance', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        HrFullWidthDataTable(
                          headingRowColor: const Color(0xFFF5F0E8),
                          columnSpecs: const [
                            ('Leave type', 2.0),
                            ('Entitled', 1.0),
                            ('Used', 1.0),
                            ('Balance', 1.0),
                            ('Carried forward', 1.2),
                          ],
                          rows: [
                            _entRow('Annual', const Color(0xFF2563EB), '18', '6', '12', '2'),
                            _entRow('Medical', const Color(0xFF059669), '14', '4', '10', '0'),
                            _entRow('Emergency', const Color(0xFFEA580C), '3', '1', '2', '0'),
                            _entRow('Replacement', const Color(0xFF7C3AED), '1', '0', '1', '0'),
                            _entRow('Hour leave', const Color(0xFF0D9488), '16h', '4h', '12h', '0'),
                          ],
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Applied policies', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        _policyLine('Annual leave policy', 'Applied', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                        Text('Service leave bonus: +2 days (3–5 yrs)', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        _policyLine('Medical leave policy', 'Applied', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                        _policyLine('Emergency leave policy', 'Applied', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                        _policyLine('Maternity leave', 'Not attached', AppColors.bg, AppColors.textMuted),
                        _policyLine('Replacement leave', 'Manual attached', const Color(0xFFD1FAE5), const Color(0xFF166534)),
                        _policyLine('Unpaid leave', 'Applied', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _whiteCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Recent leave activity', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        DataTable(
                          headingRowColor: WidgetStateProperty.all(AppColors.bg),
                          columns: const [
                            DataColumn(label: Text('Leave type')),
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('Days')),
                            DataColumn(label: Text('Status')),
                          ],
                          rows: [
                            DataRow(cells: [
                              const DataCell(Text('Annual')),
                              const DataCell(Text('12–14 May')),
                              const DataCell(Text('3')),
                              DataCell(_pill('Pending', const Color(0xFFFFEDD5), const Color(0xFFC2410C))),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('Annual')),
                              const DataCell(Text('21–22 Apr')),
                              const DataCell(Text('2')),
                              DataCell(_pill('Accepted', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('Medical')),
                              const DataCell(Text('3 Mar')),
                              const DataCell(Text('2')),
                              DataCell(_pill('Accepted', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('Emergency')),
                              const DataCell(Text('10 Feb')),
                              const DataCell(Text('1')),
                              DataCell(_pill('Accepted', const Color(0xFFD1FAE5), const Color(0xFF065F46))),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );

              if (c.maxWidth < 960) {
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [left, const SizedBox(height: 16), right]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: left),
                  const SizedBox(width: 16),
                  Expanded(flex: 4, child: right),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  DataRow _entRow(String label, Color dot, String e, String u, String b, String c) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
        ),
        DataCell(Text(e)),
        DataCell(Text(u)),
        DataCell(Text(b)),
        DataCell(Text(c)),
      ],
    );
  }

  Widget _policyLine(String k, String tag, Color bg, Color fg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(k, style: GoogleFonts.dmSans(fontSize: 13))),
          _pill(tag, bg, fg),
        ],
      ),
    );
  }

  Widget _kvLine(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(width: 160, child: Text(k, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted))),
          Expanded(child: Text(v, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _empCell(String initials, String name) {
    return Row(
      children: [
        CircleAvatar(radius: 14, backgroundColor: AppColors.brandBlueSoft, child: Text(initials, style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w800))),
        const SizedBox(width: 8),
        Text(name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _leaveTypePill(String t, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(t, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

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

  Widget _filterDropdown(String id, String initial, List<String> items) {
    String resolved() {
      final s = _leaveFilterDd[id];
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
            if (nv != null) setState(() => _leaveFilterDd[id] = nv);
          },
        ),
      ),
    );
  }
}

// ——— Policy cards (clean model; avoids invalid record typing) ———
extension on _LeaveManagementScreenState {
  Widget _policyCardAnnual() => _buildPolicyCard(
        title: 'Annual leave policy',
        tag: 'Yearly',
        tagColor: const Color(0xFF059669),
        blocks: [
          _PolicyBlock(
            title: 'Entitlement',
            rows: const [
              ('Allow days', '16 days / year', null),
              ('Accrual method', 'Monthly prorate', null),
              ('Carry forward days', '8 days max', null),
              ('Applicable to', 'All confirmed employees', null),
              ('Auto attach (service)', '12 months', null),
              ('Minimum working days', '15 days', null),
            ],
          ),
          _PolicyBlock(
            title: 'Service leave (additional)',
            rows: const [
              ('3–5 years service', '+2 days', null),
              ('5–10 years service', '+4 days', null),
              ('10+ years service', '+6 days', null),
            ],
          ),
          _PolicyBlock(
            title: 'Holiday rules',
            rows: const [
              ('Count off / holidays', 'Excluded', null),
              ('Leave before public holiday', 'Counted', null),
              ('Leave after public holiday', 'Counted', null),
              ('Not allow combination with', 'Unpaid leave', null),
            ],
          ),
        ],
      );

  Widget _policyCardMedical() => _buildPolicyCard(
        title: 'Medical leave policy',
        tag: 'Yearly',
        tagColor: const Color(0xFF059669),
        blocks: [
          _PolicyBlock(
            title: null,
            rows: const [
              ('Allow days', '14 days / year', null),
              ('Accrual method', 'Full upfront', null),
              ('Carry forward', 'Not allowed', null),
              ('Attachment required', 'MC / Hospital cert.', AppColors.danger),
              ('Auto attach', 'On join date', null),
              ('Compensation allowance', 'Based on salary', null),
            ],
          ),
        ],
      );

  Widget _policyCardEmergency() => _buildPolicyCard(
        title: 'Emergency & unpaid policy',
        tag: null,
        tagColor: AppColors.muted,
        blocks: [
          _PolicyBlock(
            title: null,
            rows: const [
              ('Emergency — allow days', '3 days / year', null),
              ('Emergency — accrual', 'Full upfront', null),
              ('Unpaid — deduction rate', 'Normal rate', null),
              ('Probation employees', 'Medical only', null),
              ('Contract employees', 'Annual + Medical', null),
            ],
          ),
        ],
      );

  Widget _buildPolicyCard({
    required String title,
    required String? tag,
    required Color tagColor,
    required List<_PolicyBlock> blocks,
  }) {
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
          Row(
            children: [
              Expanded(child: Text(title, style: GoogleFonts.sora(fontSize: 17, fontWeight: FontWeight.w700))),
              if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: tagColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                  child: Text(tag, style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w800, color: tagColor)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          for (var bi = 0; bi < blocks.length; bi++) ...[
            if (blocks[bi].title != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(6)),
                child: Text(blocks[bi].title!, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ),
            ],
            for (final row in blocks[bi].rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(row.$1, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        row.$2,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: row.$3 ?? AppColors.navy,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (bi < blocks.length - 1) const Divider(height: 20),
          ],
        ],
      ),
    );
  }
}

class _PolicyBlock {
  const _PolicyBlock({this.title, required this.rows});
  final String? title;
  final List<(String, String, Color?)> rows;
}

class _LeaveRequestTab extends StatefulWidget {
  const _LeaveRequestTab();

  @override
  State<_LeaveRequestTab> createState() => _LeaveRequestTabState();
}

class _LeaveRequestTabState extends State<_LeaveRequestTab> {
  bool _byDay = true;
  String _formLeaveType = 'Annual leave (12 days remaining)';
  String _firstDaySession = 'Full day';
  String _lastDaySession = 'Full day';
  bool _notifyApprover = true;

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LeaveChrome.whiteCard(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    _LeaveChrome.summaryPill('Pending', '1', const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
                    _LeaveChrome.summaryPill('Accepted', '4', const Color(0xFFD1FAE5), const Color(0xFF065F46)),
                    _LeaveChrome.summaryPill('Denied', '1', AppColors.errorSurface, AppColors.danger),
                    _LeaveChrome.summaryPill('Waiting for file', '1', const Color(0xFFDBEAFE), AppColors.primary),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () => _toast('New request'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New request'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final form = _LeaveChrome.whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text('Leave request form', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700))),
                        SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(value: true, label: Text('By day')),
                            ButtonSegment(value: false, label: Text('By hour')),
                          ],
                          selected: {_byDay},
                          onSelectionChanged: (s) => setState(() => _byDay = s.first),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel('Leave type *'),
                    _dropdown(
                      _formLeaveType,
                      const ['Annual leave (12 days remaining)', 'Medical leave'],
                      (v) => setState(() => _formLeaveType = v ?? _formLeaveType),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [_fieldLabel('From date *'), _dateField('12/05/2026')])),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [_fieldLabel('To date *'), _dateField('14/05/2026')])),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [_fieldLabel('Total days'), _readOnly('3 days')])),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [_fieldLabel('First day'), _dropdown(_firstDaySession, const ['Full day', 'AM', 'PM'], (v) => setState(() => _firstDaySession = v ?? _firstDaySession))])),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [_fieldLabel('Last day'), _dropdown(_lastDaySession, const ['Full day', 'AM', 'PM'], (v) => setState(() => _lastDaySession = v ?? _lastDaySession))])),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _fieldLabel('Reason'),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Reason for leave request...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Send email notification to approver', style: GoogleFonts.dmSans(fontSize: 13)),
                      value: _notifyApprover,
                      onChanged: (v) => setState(() => _notifyApprover = v ?? true),
                    ),
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

              final overview = _LeaveChrome.whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Leave balance overview', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    _balanceBar('Annual leave', 12 / 16, '12 / 16 days', AppColors.primary),
                    _balanceBar('Medical leave', 10 / 14, '10 / 14 days', AppColors.success),
                    _balanceBar('Emergency leave', 2 / 3, '2 / 3 days', const Color(0xFFEA580C)),
                    _balanceBar('Replacement leave', 1, '1 / 1 day', const Color(0xFF7C3AED)),
                  ],
                ),
              );

              final history = _LeaveChrome.whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('My time offs', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    HrFullWidthDataTable(
                      columnSpecs: const [
                        ('Leave type', 1.5),
                        ('Date', 2.0),
                        ('Days', 0.8),
                        ('Status', 1.2),
                      ],
                      rows: [
                        DataRow(cells: [
                          const DataCell(Text('Annual')),
                          const DataCell(Text('12–14 May')),
                          const DataCell(Text('3')),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(8)),
                            child: Text('Pending', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFC2410C))),
                          )),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Medical')),
                            const DataCell(Text('2 May')),
                            const DataCell(Text('1')),
                            DataCell(Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(8)),
                              child: Text('Waiting...', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            )),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text('Annual')),
                            const DataCell(Text('21–22 Apr')),
                            const DataCell(Text('2')),
                            DataCell(Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(8)),
                              child: Text('Accept...', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFF065F46))),
                            )),
                          ]),
                          DataRow(cells: [
                            const DataCell(Text('Emergency')),
                            const DataCell(Text('5 Apr')),
                            const DataCell(Text('1')),
                            DataCell(Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.errorSurface, borderRadius: BorderRadius.circular(8)),
                              child: Text('Denied', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.danger)),
                            )),
                          ]),
                      ],
                    ),
                  ],
                ),
              );

              final rightCol = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  overview,
                  const SizedBox(height: 16),
                  history,
                ],
              );

              if (c.maxWidth < 1000) {
                return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [form, const SizedBox(height: 16), rightCol]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: form),
                  const SizedBox(width: 16),
                  Expanded(flex: 2, child: rightCol),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _fieldLabel(String s) {
    final req = s.endsWith(' *');
    final base = req ? s.substring(0, s.length - 2) : s;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600),
          children: [
            TextSpan(text: base),
            if (req) const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    final safe = items.contains(value) ? value : items.first;
    return InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: safe,
          icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _dateField(String v) {
    return TextFormField(
      initialValue: v,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
      ),
    );
  }

  Widget _readOnly(String v) {
    return TextFormField(
      initialValue: v,
      readOnly: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.bg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _balanceBar(String label, double ratio, String caption, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
              Text(caption, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: ratio.clamp(0.0, 1.0), minHeight: 8, backgroundColor: AppColors.bg, color: color),
          ),
        ],
      ),
    );
  }
}

class _RequestForOthersTab extends StatefulWidget {
  const _RequestForOthersTab();

  static Widget _roEmp(String i, String n, Color bg) {
    return Row(
      children: [
        CircleAvatar(radius: 14, backgroundColor: bg.withValues(alpha: 0.2), child: Text(i, style: GoogleFonts.dmSans(fontSize: 9, fontWeight: FontWeight.w800))),
        const SizedBox(width: 8),
        Text(n, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
      ],
    );
  }

  static Widget _pillSmall(String t) {
    final c = t == 'Pending'
        ? (const Color(0xFFFFEDD5), const Color(0xFFC2410C))
        : (const Color(0xFFD1FAE5), const Color(0xFF065F46));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: c.$1, borderRadius: BorderRadius.circular(8)),
      child: Text(t, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: c.$2)),
    );
  }

  @override
  State<_RequestForOthersTab> createState() => _RequestForOthersTabState();
}

class _RequestForOthersTabState extends State<_RequestForOthersTab> {
  String _employee = '-- Select employee --';
  String _leaveType = 'Annual leave';
  String _session = 'Full day';

  void _toast(String m) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  Widget _dropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    final safe = items.contains(value) ? value : items.first;
    return InputDecorator(
      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), contentPadding: const EdgeInsets.symmetric(horizontal: 12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: safe,
          icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LeaveChrome.whiteCard(
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text('Submit leave on behalf of another employee', style: GoogleFonts.dmSans(color: AppColors.textMuted)),
                OutlinedButton.icon(
                  onPressed: () => _toast('New request for others'),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New request for others'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, c) {
              final form = _LeaveChrome.whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Leave request for others', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'Employee', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                      const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                    ])),
                    const SizedBox(height: 6),
                    _dropdown(
                      _employee,
                      const ['-- Select employee --', 'Sarah Lim', 'Maya Tan'],
                      (v) => setState(() => _employee = v ?? _employee),
                    ),
                    const SizedBox(height: 12),
                    Text.rich(TextSpan(children: [
                      TextSpan(text: 'Leave type', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                      const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                    ])),
                    const SizedBox(height: 6),
                    _dropdown(
                      _leaveType,
                      const ['Annual leave', 'Medical leave'],
                      (v) => setState(() => _leaveType = v ?? _leaveType),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text.rich(TextSpan(children: [
                                TextSpan(text: 'From date', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                                const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                              ])),
                              const SizedBox(height: 6),
                              TextField(decoration: InputDecoration(hintText: 'dd/mm/yyyy', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text.rich(TextSpan(children: [
                                TextSpan(text: 'To date', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                                const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                              ])),
                              const SizedBox(height: 6),
                              TextField(decoration: InputDecoration(hintText: 'dd/mm/yyyy', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Total days', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextFormField(
                      initialValue: 'Auto-calculated',
                      readOnly: true,
                      decoration: InputDecoration(filled: true, fillColor: AppColors.bg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 12),
                    Text('Session', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    _dropdown(
                      _session,
                      const ['Full day', 'AM', 'PM'],
                      (v) => setState(() => _session = v ?? _session),
                    ),
                    const SizedBox(height: 12),
                    Text('Reason', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Reason for leave on behalf...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Send email notification to approver', style: GoogleFonts.dmSans(fontSize: 13)),
                      value: true,
                      onChanged: (_) {},
                    ),
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

              final table = _LeaveChrome.whiteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Requested time offs (on behalf)', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    HrFullWidthDataTable(
                      columnSpecs: const [
                        ('Employee', 2.0),
                        ('Leave type', 1.2),
                        ('Date', 1.5),
                        ('Days', 0.7),
                        ('Status', 1.0),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(_RequestForOthersTab._roEmp('SL', 'Sarah L', Colors.blue)),
                          const DataCell(Text('Annual')),
                          const DataCell(Text('3–5 May')),
                          const DataCell(Text('3')),
                          DataCell(_RequestForOthersTab._pillSmall('Pending')),
                        ]),
                        DataRow(cells: [
                          DataCell(_RequestForOthersTab._roEmp('MT', 'Maya T', Colors.purple)),
                          const DataCell(Text('Medical')),
                          const DataCell(Text('1 May')),
                          const DataCell(Text('1')),
                          DataCell(_RequestForOthersTab._pillSmall('Accepted')),
                        ]),
                        DataRow(cells: [
                          DataCell(_RequestForOthersTab._roEmp('AL', 'Ahmad L', Colors.orange)),
                          const DataCell(Text('Emergency')),
                          const DataCell(Text('28 Apr')),
                          const DataCell(Text('1')),
                          DataCell(_RequestForOthersTab._pillSmall('Pending')),
                        ]),
                        DataRow(cells: [
                          DataCell(_RequestForOthersTab._roEmp('NC', 'Nadia C', Colors.teal)),
                          const DataCell(Text('Annual')),
                          const DataCell(Text('21–22 Apr')),
                          const DataCell(Text('2')),
                          DataCell(_RequestForOthersTab._pillSmall('Accepted')),
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
}

abstract final class _LeaveChrome {
  static Widget whiteCard({required Widget child}) {
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

  static Widget summaryPill(String k, String v, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$k: ', style: GoogleFonts.dmSans(fontSize: 12, color: fg.withValues(alpha: 0.9))),
          Text(v, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w800, color: fg)),
        ],
      ),
    );
  }
}
