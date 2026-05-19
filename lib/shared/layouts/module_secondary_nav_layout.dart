import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/theme_colors.dart';
import 'responsive_layout.dart';

bool _usePinnedSecondarySidebar(double contentWidth) =>
    contentWidth >= ResponsiveLayout.moduleSecondarySidebarMinWidth;

/// Module shell with a secondary nav column (Reports, Settings).
///
/// Wide content area (≥1200px): pinned secondary sidebar + content.
/// Narrow: full-width content and a [Sections] control that opens an end drawer.
///
/// Uses [LayoutBuilder] so embedded modules (beside the main app sidebar) measure
/// their actual column width, not the full window.
class ModuleSecondaryNavLayout extends StatelessWidget {
  const ModuleSecondaryNavLayout({
    super.key,
    required this.secondaryNav,
    required this.content,
    required this.currentSectionLabel,
    this.sidebarWidth = 260,
  });

  final Widget secondaryNav;
  final Widget content;
  final String currentSectionLabel;
  final double sidebarWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth;
        if (_usePinnedSecondarySidebar(contentWidth)) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(width: sidebarWidth, child: secondaryNav),
              Expanded(child: content),
            ],
          );
        }

        final drawerWidth = math.min(300.0, contentWidth * 0.92);

        return Scaffold(
          backgroundColor: context.pageBackground,
          endDrawer: Drawer(
            width: drawerWidth,
            child: SafeArea(child: secondaryNav),
          ),
          body: Builder(
            builder: (innerContext) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ModuleSectionsToolbar(
                    currentSectionLabel: currentSectionLabel,
                    onSectionsTap: () =>
                        Scaffold.of(innerContext).openEndDrawer(),
                  ),
                  Expanded(child: content),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

/// Compact bar shown when the module secondary sidebar is collapsed.
class ModuleSectionsToolbar extends StatelessWidget {
  const ModuleSectionsToolbar({
    super.key,
    required this.currentSectionLabel,
    required this.onSectionsTap,
  });

  final String currentSectionLabel;
  final VoidCallback onSectionsTap;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return Material(
      color: tc.surfaceCard,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: tc.borderColor)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: onSectionsTap,
                icon: const Icon(Icons.menu_rounded, size: 18),
                label: const Text('Sections'),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  currentSectionLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: tc.primaryText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Closes the sections drawer after a nav item is chosen (narrow layout only).
void closeModuleSectionsDrawerIfOpen(BuildContext context) {
  final nav = Navigator.of(context);
  if (nav.canPop()) {
    nav.pop();
  }
}
