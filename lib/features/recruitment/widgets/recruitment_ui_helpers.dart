import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';

class RecruitPill extends StatelessWidget {
  const RecruitPill(this.label, {super.key, this.tone = RecruitPillTone.neutral});

  final String label;
  final RecruitPillTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      RecruitPillTone.success => (const Color(0xFFD1FAE5), const Color(0xFF065F46)),
      RecruitPillTone.info => (const Color(0xFFDBEAFE), AppColors.primary),
      RecruitPillTone.warning => (const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
      RecruitPillTone.danger => (const Color(0xFFFEE2E2), const Color(0xFF991B1B)),
      RecruitPillTone.purple => (const Color(0xFFEDE9FE), const Color(0xFF5B21B6)),
      RecruitPillTone.pink => (const Color(0xFFFCE7F3), const Color(0xFF9D174D)),
      RecruitPillTone.neutral => (context.mutedPillBg, context.mutedPillText),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

enum RecruitPillTone { success, info, warning, danger, purple, pink, neutral }

class RecruitAvatar extends StatelessWidget {
  const RecruitAvatar(this.initials, {super.key, this.bg});

  final String initials;
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: bg ?? context.subtleFill,
      child: Text(
        initials,
        style: GoogleFonts.dmSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: context.primaryText,
        ),
      ),
    );
  }
}

class RecruitKpi extends StatelessWidget {
  const RecruitKpi({
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
    final tc = context;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: tc.primaryText,
              ),
            ),
            Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: tc.secondaryText)),
            if (sub != null)
              Text(
                sub!,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: subColor ?? tc.secondaryText,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class RecruitHBar extends StatelessWidget {
  const RecruitHBar({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    this.trailing = '',
  });

  final String label;
  final double value;
  final double max;
  final Color color;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    final frac = max > 0 ? (value / max).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: tc.primaryText)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: frac,
                minHeight: 10,
                backgroundColor: tc.subtleFill,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            child: Text(
              trailing,
              textAlign: TextAlign.right,
              style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: tc.secondaryText),
            ),
          ),
        ],
      ),
    );
  }
}
