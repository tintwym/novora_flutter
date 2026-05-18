import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/theme_colors.dart';

/// Top banner used across Training / Attendance / Employment modules (mock-aligned).
class HrModuleHeader extends StatelessWidget {
  const HrModuleHeader({
    super.key,
    required this.moduleSubtitle,
    this.showDepartmentFilter = true,
    this.showPeriodFilter = false,
    this.showYearFilter = false,
    this.showExport = true,
    this.exportLabel = 'Export',
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.navyPrimaryButton = false,
    this.showMoreMenu = false,
    this.extraTrailing = const [],
  });

  final String moduleSubtitle;
  final bool showDepartmentFilter;
  /// Month / period dropdown (e.g. Time & Attendance).
  final bool showPeriodFilter;
  /// Calendar year dropdown (e.g. Leave Management).
  final bool showYearFilter;
  final bool showExport;
  final String exportLabel;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  /// When true, primary action uses solid navy (attendance mock).
  final bool navyPrimaryButton;
  final bool showMoreMenu;
  final List<Widget> extraTrailing;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: tc.surfaceCard,
        border: Border(bottom: BorderSide(color: tc.borderColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.brandName,
                  style: GoogleFonts.sora(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: tc.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  moduleSubtitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          if (showPeriodFilter)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: _PeriodDropdown(),
            ),
          if (showYearFilter)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: _YearDropdown(),
            ),
          if (showDepartmentFilter)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _DeptDropdown(),
            ),
          if (showExport)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export queued')),
                  );
                },
                child: Text(exportLabel),
              ),
            ),
          if (primaryActionLabel != null)
            navyPrimaryButton
                ? FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: onPrimaryAction,
                    child: Text(primaryActionLabel!),
                  )
                : FilledButton.tonal(
                    onPressed: onPrimaryAction,
                    child: Text(primaryActionLabel!),
                  ),
          if (showMoreMenu)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, color: AppColors.navy),
              onSelected: (v) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$v (mock)')));
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'settings', child: Text('Module settings')),
                PopupMenuItem(value: 'help', child: Text('Help')),
              ],
            ),
          ...extraTrailing,
        ],
      ),
    );
  }
}

class _PeriodDropdown extends StatefulWidget {
  const _PeriodDropdown();

  @override
  State<_PeriodDropdown> createState() => _PeriodDropdownState();
}

class _PeriodDropdownState extends State<_PeriodDropdown> {
  String _v = 'May 2026';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: context.borderColor),
          borderRadius: BorderRadius.circular(8),
          color: context.subtleFill,
        ),
        child: DropdownButton<String>(
          value: _v,
          icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
          items: const [
            DropdownMenuItem(value: 'Apr 2026', child: Text('Apr 2026')),
            DropdownMenuItem(value: 'May 2026', child: Text('May 2026')),
            DropdownMenuItem(value: 'Jun 2026', child: Text('Jun 2026')),
          ],
          onChanged: (v) => setState(() => _v = v ?? _v),
        ),
      ),
    );
  }
}

class _YearDropdown extends StatefulWidget {
  const _YearDropdown();

  @override
  State<_YearDropdown> createState() => _YearDropdownState();
}

class _YearDropdownState extends State<_YearDropdown> {
  String _v = '2026';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: context.borderColor),
          borderRadius: BorderRadius.circular(8),
          color: context.subtleFill,
        ),
        child: DropdownButton<String>(
          value: _v,
          icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
          items: const [
            DropdownMenuItem(value: '2025', child: Text('2025')),
            DropdownMenuItem(value: '2026', child: Text('2026')),
            DropdownMenuItem(value: '2027', child: Text('2027')),
          ],
          onChanged: (v) => setState(() => _v = v ?? _v),
        ),
      ),
    );
  }
}

class _DeptDropdown extends StatefulWidget {
  @override
  State<_DeptDropdown> createState() => _DeptDropdownState();
}

class _DeptDropdownState extends State<_DeptDropdown> {
  String _v = 'All departments';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: context.borderColor),
          borderRadius: BorderRadius.circular(8),
          color: context.subtleFill,
        ),
        child: DropdownButton<String>(
          value: _v,
          icon: Icon(Icons.expand_more, size: 20, color: AppColors.textMuted),
          items: const [
            DropdownMenuItem(value: 'All departments', child: Text('All departments')),
            DropdownMenuItem(value: 'Engineering', child: Text('Engineering')),
            DropdownMenuItem(value: 'HR', child: Text('HR')),
            DropdownMenuItem(value: 'Operations', child: Text('Operations')),
            DropdownMenuItem(value: 'Marketing', child: Text('Marketing')),
          ],
          onChanged: (v) => setState(() => _v = v ?? _v),
        ),
      ),
    );
  }
}
