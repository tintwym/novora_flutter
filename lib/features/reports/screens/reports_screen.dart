import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../shared/widgets/module_shell_background.dart';
import '../models/reports_nav.dart';
import '../panels/reports_panels.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedId = 'report_centre';
  String _search = '';

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

  void _navigate(String id) => setState(() => _selectedId = id);

  @override
  Widget build(BuildContext context) {
    final body = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ReportsSidebar(
          search: _search,
          onSearchChanged: (v) => setState(() => _search = v),
          selectedId: _selectedId,
          onSelect: _navigate,
          sections: _filteredSections,
        ),
        Expanded(
          child: ColoredBox(
            color: context.pageBackground,
            child: buildReportsPanel(
              _selectedId,
              context,
              onNavigate: _navigate,
            ),
          ),
        ),
      ],
    );

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
    return Container(
      width: 260,
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
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              children: [
                for (final section in sections) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                    child: Text(
                      section.title,
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  for (final item in section.items)
                    _NavTile(
                      item: item,
                      selected: item.id == selectedId,
                      onTap: () => onSelect(item.id),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final ReportsNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: selected
            ? (tc.isDarkMode
                  ? AppColors.brandBlue.withValues(alpha: 0.25)
                  : const Color(0xFFEFF6FF))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 18,
                  color: selected ? tc.filterChipText : tc.secondaryText,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected ? tc.filterChipText : tc.primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
