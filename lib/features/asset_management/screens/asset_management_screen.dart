import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../shared/widgets/hr_module_header.dart';
import '../../../shared/widgets/module_shell_background.dart';
import '../../../shared/widgets/themed_surface_card.dart';
import '../models/asset_registry_entry.dart';
import '../widgets/asset_register_sheet.dart';
import '../widgets/asset_ui_helpers.dart';

/// Asset Management — registry, categories, assignment, maintenance, disposal, reports.
class AssetManagementScreen extends StatefulWidget {
  const AssetManagementScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<AssetManagementScreen> createState() => _AssetManagementScreenState();
}

class _AssetManagementScreenState extends State<AssetManagementScreen>
    with SingleTickerProviderStateMixin {
  static const _assignmentBadge = 3;

  late final TabController _tab = TabController(length: 6, vsync: this);
  final Map<String, String> _dd = {};
  final TextEditingController _registrySearchCtrl = TextEditingController();
  List<AssetRegistryEntry> _registry = AssetRegistryEntry.seed();
  bool _ack = true;
  bool _emailNotify = false;
  bool _unavailable = true;
  bool _notifyOwner = false;

  @override
  void initState() {
    super.initState();
    _registrySearchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    _registrySearchCtrl.dispose();
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
          moduleSubtitle: 'ASSET MANAGEMENT',
          showPeriodFilter: false,
          showDepartmentFilter: true,
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
              const Tab(height: 48, child: Text('Asset registry')),
              const Tab(height: 48, child: Text('Category & type')),
              _tabWithBadge('Assignment', _assignmentBadge),
              const Tab(height: 48, child: Text('Maintenance')),
              const Tab(height: 48, child: Text('Disposal')),
              const Tab(height: 48, child: Text('Reports')),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _registryTab(),
              _categoryTab(),
              _assignmentTab(),
              _maintenanceTab(),
              _disposalTab(),
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
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Assets', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: body,
    );
  }

  Widget _tabWithBadge(String label, int badge) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _card({required Widget child, EdgeInsets? padding}) {
    return ThemedSurfaceCard(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
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

  Widget _primaryBtn(String label, VoidCallback onTap, {Color? bg}) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: bg ?? AppColors.primary,
        foregroundColor: Colors.white,
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }

  Widget _labeledField(String label, {String? hint, String? value, bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          required ? '$label *' : label,
          style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500, color: context.secondaryText),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: value != null ? TextEditingController(text: value) : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: context.subtleFill,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _labeledDropdown(String label, String id, String initial, List<String> items, {bool required = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          required ? '$label *' : label,
          style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textMuted),
        ),
        const SizedBox(height: 6),
        _filterDd(id, initial, items),
      ],
    );
  }

  // --- Asset registry ---

  List<AssetRegistryEntry> get _filteredRegistry {
    final q = _registrySearchCtrl.text.trim().toLowerCase();
    final cat = _d('reg_cat', 'All categories', const [
      'All categories',
      'IT equipment',
      'Vehicle',
      'Furniture',
      'Office equipment',
    ]);
    final status = _d('reg_status', 'All status', const [
      'All status',
      'Active',
      'Maintenance',
      'Unassigned',
      'Disposed',
    ]);
    return _registry.where((a) {
      if (cat != 'All categories' && a.category != cat) return false;
      if (status != 'All status' && a.status != status) return false;
      if (q.isEmpty) return true;
      return a.name.toLowerCase().contains(q) || a.tag.toLowerCase().contains(q);
    }).toList();
  }

  int get _registryActiveCount =>
      _registry.where((a) => a.status == 'Active').length;

  int get _registryUnassignedCount =>
      _registry.where((a) => a.status == 'Unassigned').length;

  int get _registryMaintenanceCount =>
      _registry.where((a) => a.status == 'Maintenance').length;

  int get _registryDisposedCount =>
      _registry.where((a) => a.status == 'Disposed').length;

  Future<void> _openRegisterAsset() async {
    final created = await showModalBottomSheet<AssetRegistryEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AssetRegisterSheet(
        existingTags: _registry.map((e) => e.tag).toList(),
      ),
    );
    if (created == null || !mounted) return;
    setState(() => _registry = [created, ..._registry]);
    _toast('${created.name} added to registry (${created.tag})');
  }

  void _showRegistryDetail(AssetRegistryEntry entry) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(entry.name, style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tag: ${entry.tag}', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('Category: ${entry.category}'),
            Text('Assigned: ${entry.assigneeLabel}'),
            Text('Purchase: ${entry.purchaseDate}'),
            Text('Cost: MYR ${entry.cost} · Book: ${entry.bookValue}'),
            const SizedBox(height: 8),
            AssetPill(entry.status, tone: entry.statusTone),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _registryTab() {
    final filtered = _filteredRegistry;
    return _scroll([
      _card(
        child: Row(
          children: [
            AssetKpiTile(
              value: '${_registry.length}',
              label: 'Total assets',
              subLabel: '$_registryActiveCount active',
              subColor: AppColors.success,
            ),
            const AssetKpiTile(
              value: 'MYR 4.2M',
              label: 'Total asset value',
              subLabel: 'Acquisition cost',
            ),
            AssetKpiTile(
              value: '$_registryMaintenanceCount',
              label: 'Under maintenance',
              subLabel: '12 overdue service',
              subColor: AppColors.warning,
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      _card(
        child: Row(
          children: [
            AssetKpiTile(
              value: '$_registryUnassignedCount',
              label: 'Unassigned',
              subLabel: 'Available in store',
            ),
            AssetKpiTile(
              value: '$_registryDisposedCount',
              label: 'Disposed / written off',
              subLabel: 'This year',
              subColor: AppColors.danger,
            ),
            const AssetKpiTile(
              value: 'MYR 2.8M',
              label: 'Current book value',
              subLabel: 'After depreciation',
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      _toolbar([
        SizedBox(
          width: 280,
          child: TextField(
            controller: _registrySearchCtrl,
            decoration: InputDecoration(
              hintText: 'Search asset name or tag...',
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
              filled: true,
              fillColor: context.subtleFill,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: context.borderColor),
              ),
            ),
          ),
        ),
        _filterDd('reg_cat', 'All categories', const [
          'All categories',
          'IT equipment',
          'Vehicle',
          'Furniture',
          'Office equipment',
        ]),
        _filterDd('reg_status', 'All status', const [
          'All status',
          'Active',
          'Maintenance',
          'Unassigned',
          'Disposed',
        ]),
      ], trailing: _primaryBtn('+ Register asset', _openRegisterAsset)),
      const SizedBox(height: 8),
      Text(
        '${filtered.length} asset${filtered.length == 1 ? '' : 's'} shown',
        style: GoogleFonts.dmSans(fontSize: 12, color: context.secondaryText),
      ),
      const SizedBox(height: 8),
      _card(
        padding: EdgeInsets.zero,
        child: _registryTable(filtered),
      ),
    ]);
  }

  Widget _toolbar(List<Widget> leading, {Widget? trailing}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...leading,
        ?trailing,
      ],
    );
  }

  Widget _registryTable(List<AssetRegistryEntry> rows) {
    if (rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'No assets match your search or filters.',
            style: GoogleFonts.dmSans(color: context.secondaryText),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(context.subtleFill),
        columns: [
          _col(''),
          _col('Asset name'),
          _col('Asset tag'),
          _col('Category'),
          _col('Assigned to'),
          _col('Purchase date'),
          _col('Cost (MYR)'),
          _col('Book value'),
          _col('Status'),
          _col(''),
        ],
        rows: rows.map((r) {
          return DataRow(cells: [
            DataCell(Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: context.subtleFill,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.inventory_2_outlined, size: 18, color: context.secondaryText),
            )),
            DataCell(Text(r.name, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: context.primaryText))),
            DataCell(Text(r.tag, style: GoogleFonts.dmSans(color: AppColors.primary, fontWeight: FontWeight.w600))),
            DataCell(AssetPill(r.category, tone: categoryTone(r.category))),
            DataCell(r.assigneeInitials == null
                ? Text(r.assigneeLabel)
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AssetAvatar(r.assigneeInitials!),
                      const SizedBox(width: 6),
                      Text(r.assigneeLabel),
                    ],
                  )),
            DataCell(Text(r.purchaseDate)),
            DataCell(Text(r.cost)),
            DataCell(Text(
              r.bookValue,
              style: GoogleFonts.dmSans(
                color: r.bookValue == 'Written off' ? AppColors.danger : context.primaryText,
                fontWeight: FontWeight.w600,
              ),
            )),
            DataCell(AssetPill(r.status, tone: r.statusTone)),
            DataCell(TextButton(
              onPressed: () => _showRegistryDetail(r),
              child: const Text('View'),
            )),
          ]);
        }).toList(),
      ),
    );
  }

  DataColumn _col(String label) => DataColumn(
        label: Text(
          label,
          style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w700, color: context.secondaryText),
        ),
      );

  // --- Category & type ---

  Widget _categoryTab() {
    return _scroll([
      Align(
        alignment: Alignment.centerRight,
        child: OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 18),
          label: const Text('New category'),
        ),
      ),
      const SizedBox(height: 12),
      LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth > 900;
          final list = _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search category...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.muted),
                    filled: true,
                    fillColor: AppColors.bg,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _categoryListTable(),
              ],
            ),
          );
          final form = _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'New asset category',
                  style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy),
                ),
                const SizedBox(height: 16),
                _labeledField('Category name', hint: 'e.g. Laboratory equipment', required: true),
                const SizedBox(height: 12),
                _labeledField('Asset prefix code', hint: 'e.g. LAB', required: true),
                const SizedBox(height: 12),
                _labeledDropdown('Depreciation method', 'dep_method', 'Straight line', const ['Straight line', 'Declining balance']),
                const SizedBox(height: 12),
                _labeledField('Depreciation rate (%)', hint: 'e.g. 20'),
                const SizedBox(height: 12),
                _labeledField('Useful life (years)', hint: 'e.g. 5'),
                const SizedBox(height: 12),
                _labeledDropdown('Maintenance schedule', 'maint_sched', 'Every 6 months', const ['Every 6 months', 'Annually', 'None']),
                const SizedBox(height: 12),
                _labeledField('Description', hint: 'Optional notes about this category...'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: _primaryBtn('Save category', () => _toast('Category saved')),
                ),
              ],
            ),
          );
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: list),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: form),
              ],
            );
          }
          return Column(children: [list, const SizedBox(height: 16), form]);
        },
      ),
    ]);
  }

  Widget _categoryListTable() {
    final data = [
      ('IT equipment', 642, '20% / year', const Color(0xFFE0F2FE)),
      ('Furniture', 418, '10% / year', const Color(0xFFD1FAE5)),
      ('Vehicle', 28, '20% / year', const Color(0xFFFFEDD5)),
      ('Office equipment', 312, '20% / year', const Color(0xFFEDE9FE)),
      ('Property', 12, '5% / year', const Color(0xFFFCE7F3)),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppColors.bg),
        columns: [_col('Category name'), _col('Assets'), _col('Depreciation'), _col('Status'), _col('')],
        rows: data.map((d) {
          return DataRow(cells: [
            DataCell(Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: d.$4, borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(width: 8),
                Text(d.$1, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
              ],
            )),
            DataCell(Text('${d.$2}')),
            DataCell(Text(d.$3)),
            const DataCell(AssetPill('Active', tone: AssetPillTone.success)),
            DataCell(TextButton(onPressed: () {}, child: const Text('Edit'))),
          ]);
        }).toList(),
      ),
    );
  }

  // --- Assignment ---

  Widget _assignmentTab() {
    return _scroll([
      _toolbar([
        _filterDd('asgn_status', 'All status', const ['All status', 'Pending', 'Active']),
        _filterDd('asgn_dept', 'All departments', const ['All departments', 'Engineering', 'HR']),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '3 pending handover',
            style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.warning),
          ),
        ),
      ], trailing: _primaryBtn('+ Assign asset', () => _toast('Assign asset'))),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth > 960;
          final form = _assignmentForm();
          final tables = Column(
            children: [
              _pendingHandoversCard(),
              const SizedBox(height: 16),
              _activeAssignmentsCard(),
            ],
          );
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: form),
                const SizedBox(width: 16),
                Expanded(flex: 3, child: tables),
              ],
            );
          }
          return Column(children: [form, const SizedBox(height: 16), tables]);
        },
      ),
    ]);
  }

  Widget _assignmentForm() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AssetSectionLabel('Asset details'),
          _labeledDropdown('Asset', 'asgn_asset', '-- Select asset --', const ['-- Select asset --', 'Lenovo ThinkPad', 'MacBook Pro']),
          const SizedBox(height: 16),
          const AssetSectionLabel('Assign to'),
          _labeledDropdown('Employee', 'asgn_emp', '-- Select employee --', const ['-- Select employee --', 'Ahmad L.', 'Sarah L.']),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _labeledField('Assignment date', value: '06/05/2026', required: true)),
              const SizedBox(width: 12),
              Expanded(child: _labeledField('Expected return date', hint: 'dd/mm/yyyy')),
            ],
          ),
          const SizedBox(height: 12),
          _labeledDropdown('Location / department', 'asgn_loc', 'KL HQ - Engineering floor', const ['KL HQ - Engineering floor', 'Penang Branch']),
          const SizedBox(height: 12),
          _labeledDropdown('Condition on handover', 'asgn_cond', 'New', const ['New', 'Good', 'Fair']),
          const SizedBox(height: 12),
          _labeledField('Handover notes', hint: 'Any notes on accessories included, condition, etc...'),
          const SizedBox(height: 8),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _ack,
            onChanged: (v) => setState(() => _ack = v ?? false),
            title: const Text('Require employee acknowledgement'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _emailNotify,
            onChanged: (v) => setState(() => _emailNotify = v ?? false),
            title: const Text('Send email notification to employee'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text('Cancel')),
              const Spacer(),
              Expanded(child: _primaryBtn('Assign asset', () => _toast('Asset assigned'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pendingHandoversCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Pending handovers', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('3 pending', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.warning)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _simpleTable(
            ['Asset', 'Assigned to', 'Date', 'Status', ''],
            [
              ['Lenovo ThinkPad', _person('AL', 'Ahmad L.'), '5 May', const AssetPill('Awaiting ack.', tone: AssetPillTone.warning), _link('Remind')],
              ['Standing desk', _person('ZN', 'Zara N.'), '4 May', const AssetPill('Awaiting ack.', tone: AssetPillTone.warning), _link('Remind')],
              ['Ergonomic chair', _person('MT', 'Maya T.'), '3 May', const AssetPill('Awaiting ack.', tone: AssetPillTone.warning), _link('Remind')],
            ],
          ),
        ],
      ),
    );
  }

  Widget _activeAssignmentsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Active assignments', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _simpleTable(
            ['Asset', 'Employee', 'Since', 'Return by', ''],
            [
              ['MacBook Pro', _person('SL', 'Sarah L.'), 'Jan 2021', '—', _link('Return')],
              ['Dell Monitor', _person('RK', 'Raj K.'), 'Mar 2022', '—', _link('Return')],
              ['Toyota Hilux', _person('AL', 'Ahmad L.'), 'Jun 2020', '—', _link('Return')],
            ],
          ),
        ],
      ),
    );
  }

  Widget _person(String initials, String name) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AssetAvatar(initials),
        const SizedBox(width: 6),
        Text(name),
      ],
    );
  }

  Widget _link(String label) => TextButton(onPressed: () {}, child: Text(label));

  Widget _simpleTable(List<String> headers, List<List<Object>> rows) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(context.subtleFill),
        columns: headers.map((h) => _col(h)).toList(),
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

  // --- Maintenance ---

  Widget _maintenanceTab() {
    return _scroll([
      _toolbar([
        _filterDd('mnt_cat', 'All categories', const ['All categories', 'IT equipment', 'Vehicle']),
        _filterDd('mnt_status', 'All status', const ['All status', 'Scheduled', 'In progress', 'Overdue']),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.bg,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('dd/mm/yyyy', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted)),
              const SizedBox(width: 8),
              Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textMuted),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.danger.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('12 overdue', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.danger)),
        ),
      ], trailing: _primaryBtn('+ Schedule maintenance', () => _toast('Scheduled'))),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth > 960;
          final form = _maintenanceForm();
          final right = Column(
            children: [
              _maintenanceScheduleCard(),
              const SizedBox(height: 16),
              _maintenanceHistoryCard(),
            ],
          );
          if (wide) {
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

  Widget _maintenanceForm() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('New maintenance record', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _labeledDropdown('Asset', 'mnt_asset', '-- Select asset --', const ['-- Select asset --', 'Toyota Hilux', 'HP LaserJet']),
          const SizedBox(height: 12),
          _labeledDropdown('Maintenance type', 'mnt_type', 'Scheduled service', const ['Scheduled service', 'Corrective', 'Preventive', 'Inspection']),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _labeledField('Schedule date', value: '10/05/2026', required: true)),
              const SizedBox(width: 12),
              Expanded(child: _labeledField('Est. completion', value: '12/05/2026')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _labeledField('Vendor / service provider', hint: 'e.g. AutoServ Workshop')),
              const SizedBox(width: 12),
              Expanded(child: _labeledField('Est. cost (MYR)', value: '0.00')),
            ],
          ),
          const SizedBox(height: 12),
          _labeledField('Maintenance description', hint: 'Details of the maintenance work required...'),
          const SizedBox(height: 8),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _unavailable,
            onChanged: (v) => setState(() => _unavailable = v ?? false),
            title: const Text('Mark asset as unavailable during maintenance'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _notifyOwner,
            onChanged: (v) => setState(() => _notifyOwner = v ?? false),
            title: const Text('Notify asset owner'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text('Save draft')),
              const Spacer(),
              Expanded(child: _primaryBtn('Schedule', () => _toast('Maintenance scheduled'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _maintenanceScheduleCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Maintenance schedule', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _simpleTable(
            ['Asset', 'Type', 'Date', 'Cost', 'Status', ''],
            [
              ['Toyota Hilux', 'Scheduled', '10 May', 'MYR 800', const AssetPill('Scheduled', tone: AssetPillTone.info), _link('Edit')],
              ['HP LaserJet', 'Corrective', '6 May', 'MYR 250', const AssetPill('In progress', tone: AssetPillTone.warning), _link('Edit')],
              ['Server rack', 'Preventive', '1 Apr', 'MYR 1,200', const AssetPill('Overdue', tone: AssetPillTone.danger), _link('Edit')],
              ['Air cond. unit', 'Inspection', '28 Apr', 'MYR 180', const AssetPill('Completed', tone: AssetPillTone.success), _link('View')],
            ],
          ),
        ],
      ),
    );
  }

  Widget _maintenanceHistoryCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Maintenance history log', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('View all')),
            ],
          ),
          const SizedBox(height: 8),
          _historyLine('28 Apr', 'Air conditioner — inspection completed', 'CoolTech Sdn Bhd · MYR 180', AppColors.success),
          _historyLine('15 Apr', 'Toyota Hilux — oil change & service', 'AutoServ Workshop · MYR 650', AppColors.success),
          _historyLine('2 Apr', 'HP LaserJet — drum unit replaced', 'In-house IT team · MYR 320', AppColors.success),
        ],
      ),
    );
  }

  Widget _historyLine(String date, String title, String sub, Color dot) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(date, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
          ),
          Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 4), decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600)),
                Text(sub, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Disposal ---

  Widget _disposalTab() {
    return _scroll([
      _toolbar([
        _filterDd('disp_method', 'All methods', const ['All methods', 'Written off', 'Sold', 'Donated', 'Scrapped']),
        _filterDd('disp_cat', 'All categories', const ['All categories', 'IT equipment', 'Vehicle']),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Text('23 disposed YTD', style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ], trailing: _primaryBtn('+ Record disposal', () => _toast('Record disposal'))),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth > 960;
          final form = _disposalForm();
          final history = _disposalHistoryCard();
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: form),
                const SizedBox(width: 16),
                Expanded(flex: 3, child: history),
              ],
            );
          }
          return Column(children: [form, const SizedBox(height: 16), history]);
        },
      ),
    ]);
  }

  Widget _disposalForm() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Disposal entry form', style: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _labeledDropdown('Asset', 'disp_asset', '-- Select asset --', const ['-- Select asset --', 'iPhone 14 Pro']),
          const SizedBox(height: 12),
          _labeledField('Disposal date', value: '06/05/2026', required: true),
          const SizedBox(height: 12),
          _labeledDropdown('Disposal method', 'disp_m', 'Written off', const ['Written off', 'Sold', 'Donated', 'Scrapped', 'Transferred']),
          const SizedBox(height: 12),
          _labeledField('Book value at disposal (MYR)', value: 'Auto-calculated'),
          const SizedBox(height: 12),
          _labeledField('Disposal value (MYR)', value: '0.00'),
          const SizedBox(height: 12),
          _labeledDropdown('Disposal reason', 'disp_reason', 'End of useful life', const ['End of useful life', 'Damaged', 'Obsolete']),
          const SizedBox(height: 12),
          _labeledDropdown('Approved by', 'disp_approver', 'Ahmad Wahid (CEO)', const ['Ahmad Wahid (CEO)', 'HR Admin']),
          const SizedBox(height: 12),
          _labeledField('Disposal notes', hint: 'Additional notes, recipient details if donated...'),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(onPressed: () {}, child: const Text('Cancel')),
              const Spacer(),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _toast('Disposal recorded'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Record disposal'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _disposalHistoryCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Disposal history — 2026', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('Export')),
            ],
          ),
          const SizedBox(height: 12),
          _simpleTable(
            ['Asset', 'Method', 'Date', 'Book val.', 'Disposal val.', 'G/L'],
            [
              ['iPhone 14 Pro', const AssetPill('Written off', tone: AssetPillTone.danger), '5 May', '4,800', '0', Text('-4,800', style: GoogleFonts.dmSans(color: AppColors.danger, fontWeight: FontWeight.w600))],
              ['Old office sofa', const AssetPill('Donated', tone: AssetPillTone.success), '20 Apr', '480', '0', Text('-480', style: GoogleFonts.dmSans(color: AppColors.danger))],
              ['Honda City', const AssetPill('Sold', tone: AssetPillTone.warning), '15 Mar', '18,000', Text('22,500', style: GoogleFonts.dmSans(color: AppColors.success)), Text('+4,500', style: GoogleFonts.dmSans(color: AppColors.success, fontWeight: FontWeight.w600))],
              ['HP ProBook x3', const AssetPill('Scrapped', tone: AssetPillTone.warning), '5 Feb', '1,200', '150', Text('-1,050', style: GoogleFonts.dmSans(color: AppColors.danger))],
              ['Dell server', const AssetPill('Transferred', tone: AssetPillTone.purple), '10 Jan', '12,000', '12,000', const Text('0')],
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Net gain / (loss) on disposal — 2026',
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '-MYR 1,830',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w800,
                    color: AppColors.danger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Reports ---

  Widget _reportsTab() {
    return _scroll([
      _toolbar([
        _filterDd('rpt_month', 'May 2026', const ['Apr 2026', 'May 2026', 'Jun 2026']),
        _filterDd('rpt_cat', 'All categories', const ['All categories', 'IT equipment']),
        _filterDd('rpt_dept', 'All departments', const ['All departments', 'Engineering']),
      ], trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(onPressed: () {}, child: const Text('Generate PDF')),
          const SizedBox(width: 8),
          _primaryBtn('Export', () => _toast('Export queued')),
        ],
      )),
      const SizedBox(height: 16),
      _card(
        child: const Row(
          children: [
            AssetKpiTile(value: 'MYR 4.2M', label: 'Total acquisition cost', subLabel: '1,847 assets'),
            AssetKpiTile(value: 'MYR 2.8M', label: 'Current book value', subLabel: 'After depreciation', subColor: AppColors.warning),
            AssetKpiTile(value: 'MYR 38,400', label: 'Maintenance cost YTD', subLabel: '48 service records'),
          ],
        ),
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth > 960;
          final left = Column(
            children: [
              _reportsValueByCategory(),
              const SizedBox(height: 16),
              _reportsStatusBreakdown(),
            ],
          );
          final right = Column(
            children: [
              _reportsDepreciationTable(),
              const SizedBox(height: 16),
              _reportsByDepartment(),
            ],
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
          return Column(children: [left, const SizedBox(height: 16), right]);
        },
      ),
    ]);
  }

  Widget _reportsValueByCategory() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Asset value by category', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          const AssetHBar(label: 'IT equipment', value: 1840000, max: 1840000, color: AppColors.primary, trailing: 'MYR 1,840,000'),
          const AssetHBar(label: 'Vehicle', value: 980000, max: 1840000, color: AppColors.warning, trailing: 'MYR 980,000'),
          const AssetHBar(label: 'Furniture', value: 620000, max: 1840000, color: AppColors.success, trailing: 'MYR 620,000'),
          const AssetHBar(label: 'Office equipment', value: 480000, max: 1840000, color: Color(0xFF818CF8), trailing: 'MYR 480,000'),
          const AssetHBar(label: 'Property', value: 280000, max: 1840000, color: Color(0xFFF472B6), trailing: 'MYR 280,000'),
        ],
      ),
    );
  }

  Widget _reportsStatusBreakdown() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Asset status breakdown', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _statusRow('Active & assigned', '1,612', '87.3%', AppColors.success),
          _statusRow('Unassigned / in store', '187', '10.1%', AppColors.primary),
          _statusRow('Under maintenance', '48', '2.6%', AppColors.warning),
          _statusRow('Disposed YTD', '23', '', AppColors.danger, showPct: false),
          _statusRow('Written off YTD', '8', '', AppColors.danger, showPct: false),
        ],
      ),
    );
  }

  Widget _statusRow(String label, String count, String pct, Color color, {bool showPct = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label, style: GoogleFonts.dmSans(fontSize: 13))),
          Text(count, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          if (showPct) ...[
            const SizedBox(width: 12),
            Text(pct, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ],
      ),
    );
  }

  Widget _reportsDepreciationTable() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Depreciation schedule — 2026', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _simpleTable(
            ['Asset', 'Acq. cost', 'Depn. rate', 'Depn. YTD', 'Book value'],
            [
              ['MacBook Pro 14"', '8,500', '20%', Text('-850', style: GoogleFonts.dmSans(color: AppColors.danger)), '4,250'],
              ['Toyota Hilux', '95,000', '20%', Text('-9,500', style: GoogleFonts.dmSans(color: AppColors.danger)), '47,500'],
            ],
          ),
        ],
      ),
    );
  }

  Widget _reportsByDepartment() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Assets by department', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          const AssetHBar(label: 'Engineering', value: 624, max: 624, color: AppColors.primary, trailing: '624'),
          const AssetHBar(label: 'Operations', value: 418, max: 624, color: AppColors.success, trailing: '418'),
          const AssetHBar(label: 'Finance', value: 312, max: 624, color: Color(0xFF818CF8), trailing: '312'),
          const AssetHBar(label: 'Marketing', value: 218, max: 624, color: AppColors.warning, trailing: '218'),
          const AssetHBar(label: 'HR', value: 88, max: 624, color: Color(0xFFF472B6), trailing: '88'),
        ],
      ),
    );
  }
}
