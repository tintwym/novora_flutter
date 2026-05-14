import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// Top banner used across Training / Attendance / Employment modules (mock-aligned).
class HrModuleHeader extends StatelessWidget {
  const HrModuleHeader({
    super.key,
    required this.moduleSubtitle,
    this.showDepartmentFilter = true,
    this.showExport = true,
    this.exportLabel = 'Export',
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.extraTrailing = const [],
  });

  final String moduleSubtitle;
  final bool showDepartmentFilter;
  final bool showExport;
  final String exportLabel;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final List<Widget> extraTrailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
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
                    color: AppColors.navy,
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
            FilledButton.tonal(
              onPressed: onPrimaryAction,
              child: Text(primaryActionLabel!),
            ),
          ...extraTrailing,
        ],
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
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.bg,
        ),
        child: DropdownButton<String>(
          value: _v,
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
