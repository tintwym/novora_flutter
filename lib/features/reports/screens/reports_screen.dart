import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../shared/layouts/module_secondary_nav_layout.dart';
import '../../../shared/models/sidebar_subnav.dart';
import '../../../shared/widgets/module_shell_background.dart';
import '../../../shared/widgets/sidebar_subnav_tiles.dart';
import '../models/reports_nav.dart';
import '../panels/reports_panels.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({
    super.key,
    this.embeddedInShell = false,
    this.showSecondaryNav = true,
    this.selectedId,
    this.onSelectedIdChanged,
  });

  final bool embeddedInShell;

  /// When false, sub-nav lives in the main app sidebar dropdown (shell mode).
  final bool showSecondaryNav;
  final String? selectedId;
  final ValueChanged<String>? onSelectedIdChanged;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late String _selectedId = widget.selectedId ?? 'report_centre';
  String _search = '';

  @override
  void didUpdateWidget(ReportsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final external = widget.selectedId;
    if (external != null && external != _selectedId) {
      _selectedId = external;
    }
  }

  Iterable<ReportsNavSection> get _filteredSections {
    if (_search.trim().isEmpty) return ReportsNav.sections;
    final q = _search.toLowerCase();
    return ReportsNav.sections
        .map(
          (s) => ReportsNavSection(
            title: s.title,
            items: s.items
                .where((i) => i.label.toLowerCase().contains(q))
                .toList(),
          ),
        )
        .where((s) => s.items.isNotEmpty);
  }

  void _navigate(String id) {
    setState(() => _selectedId = id);
    widget.onSelectedIdChanged?.call(id);
    closeModuleSectionsDrawerIfOpen(context);
  }

  @override
  Widget build(BuildContext context) {
    final sectionLabel =
        ReportsNav.findById(_selectedId)?.label ?? 'Reports Hub';

    final content = ColoredBox(
      color: context.pageBackground,
      child: buildReportsPanel(
        _selectedId,
        context,
        onNavigate: _navigate,
      ),
    );

    final Widget body;
    if (widget.showSecondaryNav) {
      body = ModuleSecondaryNavLayout(
        currentSectionLabel: sectionLabel,
        secondaryNav: _ReportsSidebar(
          search: _search,
          onSearchChanged: (v) => setState(() => _search = v),
          selectedId: _selectedId,
          onSelect: _navigate,
          sections: _filteredSections,
        ),
        content: content,
      );
    } else {
      body = content;
    }

    if (widget.embeddedInShell) {
      return ModuleShellBackground(child: body);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reports',
          style: GoogleFonts.sora(fontWeight: FontWeight.w700),
        ),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: body,
    );
  }
}

class _ReportsSidebar extends StatelessWidget {
  const _ReportsSidebar({
    required this.search,
    required this.onSearchChanged,
    required this.selectedId,
    required this.onSelect,
    required this.sections,
  });

  final String search;
  final ValueChanged<String> onSearchChanged;
  final String selectedId;
  final ValueChanged<String> onSelect;
  final Iterable<ReportsNavSection> sections;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tc.surfaceCard,
        border: Border(right: BorderSide(color: tc.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.brandName,
                  style: GoogleFonts.sora(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: tc.primaryText,
                  ),
                ),
                Text(
                  'REPORTS',
                  style: GoogleFonts.dmSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search reports...',
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: AppColors.muted,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: AppColors.muted,
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                filled: true,
                fillColor: tc.subtleFill,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: tc.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: tc.borderColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
              children: [
                SidebarSubnavTiles(
                  sections: sections.map(
                    (s) => SidebarSubnavSection(
                      title: s.title,
                      entries: s.items
                          .map(
                            (i) => SidebarSubnavEntry(
                              id: i.id,
                              label: i.label,
                              icon: i.icon,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  selectedId: selectedId,
                  onSelect: onSelect,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
