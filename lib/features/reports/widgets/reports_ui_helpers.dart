import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../models/reports_nav.dart';

class ReportModulePill extends StatelessWidget {
  const ReportModulePill(this.module, {super.key});

  final ReportModule module;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (module) {
      ReportModule.payroll => (
        const Color(0xFFD1FAE5),
        const Color(0xFF065F46),
        'Payroll',
      ),
      ReportModule.attendance => (
        const Color(0xFFDBEAFE),
        AppColors.primary,
        'Attendance',
      ),
      ReportModule.leave => (
        const Color(0xFFFFEDD5),
        const Color(0xFFC2410C),
        'Leave',
      ),
      ReportModule.performance => (
        const Color(0xFFEDE9FE),
        const Color(0xFF5B21B6),
        'Performance',
      ),
      ReportModule.employee => (AppColors.bg, AppColors.textMuted, 'Employee'),
      ReportModule.claims => (
        const Color(0xFFFCE7F3),
        const Color(0xFF9D174D),
        'Claims',
      ),
      ReportModule.training => (
        const Color(0xFFE0F2FE),
        const Color(0xFF0369A1),
        'Training',
      ),
      ReportModule.recruitment => (
        const Color(0xFFFEF3C7),
        const Color(0xFFB45309),
        'Recruitment',
      ),
      ReportModule.asset => (
        const Color(0xFFE2E8F0),
        const Color(0xFF475569),
        'Asset',
      ),
      ReportModule.disciplinary => (
        const Color(0xFFFEE2E2),
        const Color(0xFF991B1B),
        'Disciplinary',
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class ReportStatusPill extends StatelessWidget {
  const ReportStatusPill(this.label, {super.key, this.active = true});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final bg = active ? const Color(0xFFD1FAE5) : AppColors.bg;
    final fg = active ? const Color(0xFF065F46) : AppColors.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class ReportFormatPill extends StatelessWidget {
  const ReportFormatPill(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.subtleFill,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.borderColor),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.muted,
        ),
      ),
    );
  }
}

class ReportKpiTile extends StatelessWidget {
  const ReportKpiTile({
    super.key,
    required this.value,
    required this.label,
    this.sub,
    this.subColor,
  });

  final String value;
  final String label;
  final String? sub;
  final Color? subColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: context.primaryText,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.primaryText,
              ),
            ),
            if (sub != null) ...[
              const SizedBox(height: 2),
              Text(
                sub!,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: subColor ?? AppColors.muted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ReportSnapshotRow extends StatelessWidget {
  const ReportSnapshotRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: context.secondaryText,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? context.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportDeptBar extends StatelessWidget {
  const ReportDeptBar({
    super.key,
    required this.label,
    required this.pct,
    required this.color,
  });

  final String label;
  final int pct;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: context.secondaryText,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct / 100,
                minHeight: 8,
                backgroundColor: context.subtleFill,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$pct%',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportGradeBar extends StatelessWidget {
  const ReportGradeBar({
    super.key,
    required this.label,
    required this.count,
    required this.color,
    required this.max,
  });

  final String label;
  final int count;
  final Color color;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: context.secondaryText,
                  ),
                ),
              ),
              Text(
                '$count',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: count / max,
              minHeight: 10,
              backgroundColor: context.subtleFill,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportListTile extends StatelessWidget {
  const ReportListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onRun,
    this.onPdf,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onRun;
  final VoidCallback? onPdf;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: context.secondaryText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
          if (onRun != null || onPdf != null) ...[
            const SizedBox(width: 12),
            if (onRun != null)
              TextButton(
                onPressed: onRun,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('Run'),
              ),
            if (onPdf != null)
              TextButton(
                onPressed: onPdf,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text('PDF'),
              ),
          ],
        ],
      ),
    );
  }
}

class ReportSectionTitle extends StatelessWidget {
  const ReportSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: context.primaryText,
        ),
      ),
    );
  }
}

void showReportSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
