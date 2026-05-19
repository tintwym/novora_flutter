import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors.dart';
import '../models/sidebar_subnav.dart';

/// OVERVIEW / BY MODULE rows used in the main sidebar dropdown and module secondary nav.
class SidebarSubnavTiles extends StatelessWidget {
  const SidebarSubnavTiles({
    super.key,
    required this.sections,
    required this.selectedId,
    required this.onSelect,
  });

  final Iterable<SidebarSubnavSection> sections;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final section in sections) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 12, 4),
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
          for (final entry in section.entries)
            _SubnavTile(
              entry: entry,
              selected: entry.id == selectedId,
              onTap: () => onSelect(entry.id),
            ),
        ],
      ],
    );
  }
}

class _SubnavTile extends StatelessWidget {
  const _SubnavTile({
    required this.entry,
    required this.selected,
    required this.onTap,
  });

  final SidebarSubnavEntry entry;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              children: [
                Icon(
                  entry.icon,
                  size: 18,
                  color: selected ? tc.filterChipText : tc.secondaryText,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    entry.label,
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
