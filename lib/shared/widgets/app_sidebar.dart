import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_colors.dart';
import '../models/sidebar_subnav.dart';
import 'novora_logo.dart';
import 'sidebar_subnav_tiles.dart';

class NavMenuItem {
  const NavMenuItem({
    required this.icon,
    required this.label,
    this.subnavSections,
  });

  final IconData icon;
  final String label;

  /// When set, this item expands in the sidebar (Reports, Settings, …).
  final List<SidebarSubnavSection>? subnavSections;

  bool get hasSubnav => subnavSections != null && subnavSections!.isNotEmpty;
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.items,
    required this.activeLabel,
    required this.onSelect,
    this.expandedLabels = const {},
    this.onToggleExpand,
    this.activeSubnavId,
    this.onSelectSubnav,
  });

  final List<NavMenuItem> items;
  final String activeLabel;
  final ValueChanged<String> onSelect;

  /// Parent labels with dropdown open (e.g. Reports).
  final Set<String> expandedLabels;
  final ValueChanged<String>? onToggleExpand;

  /// Selected sub-item id for the active module.
  final String? activeSubnavId;
  final void Function(String parentLabel, String subId)? onSelectSubnav;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return Container(
      width: 242,
      color: tc.surfaceCard,
      child: Column(
        children: [
          // Logo header — Novora wordmark above the nav items. The shipped PNG has a baked-in
          // white background, so in dark mode we wrap it in a small white chip; otherwise the
          // logo would render as a glaring white rectangle on the dark sidebar surface.
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
            child: tc.isDarkMode
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SizedBox(
                        height: 24,
                        child: NovoraLogo(
                          height: 24,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 36,
                    child: NovoraLogo(
                      height: 36,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
          ),
          Divider(height: 1, thickness: 1, color: tc.borderColor),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              children: [
                for (final item in items) ...[
                  _ParentTile(
                    item: item,
                    isActive: activeLabel == item.label,
                    isExpanded: expandedLabels.contains(item.label),
                    onTap: () {
                      if (item.hasSubnav) {
                        onToggleExpand?.call(item.label);
                      }
                      onSelect(item.label);
                    },
                  ),
                  if (item.hasSubnav && expandedLabels.contains(item.label))
                    SidebarSubnavTiles(
                      sections: item.subnavSections!,
                      selectedId: activeLabel == item.label
                          ? (activeSubnavId ?? item.subnavSections!.first.entries.first.id)
                          : '',
                      onSelect: (id) => onSelectSubnav?.call(item.label, id),
                    ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: tc.isDarkMode
                    ? null
                    : const LinearGradient(
                        colors: [
                          Color(0xFFE3F2FD),
                          Color(0xFFFFF3E0),
                          Color(0xFFE8F5E9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                color: tc.isDarkMode ? tc.subtleFill : null,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: tc.isDarkMode ? tc.borderColor : const Color(0xFFBBDEFB),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline_rounded,
                    color: tc.filterChipText,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need Help?',
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: tc.primaryText,
                        ),
                      ),
                      Text(
                        'Visit our support center',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: tc.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParentTile extends StatelessWidget {
  const _ParentTile({
    required this.item,
    required this.isActive,
    required this.isExpanded,
    required this.onTap,
  });

  final NavMenuItem item;
  final bool isActive;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            decoration: BoxDecoration(
              gradient: isActive ? AppColors.primaryGrad : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isActive ? Colors.white : tc.secondaryText,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? Colors.white : tc.secondaryText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.hasSubnav)
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    size: 20,
                    color: isActive
                        ? Colors.white.withValues(alpha: 0.9)
                        : AppColors.muted,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
