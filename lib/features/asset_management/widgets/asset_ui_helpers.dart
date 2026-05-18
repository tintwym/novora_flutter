import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';

class AssetPill extends StatelessWidget {
  const AssetPill(this.label, {super.key, this.tone = AssetPillTone.neutral});

  final String label;
  final AssetPillTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      AssetPillTone.success => (const Color(0xFFD1FAE5), const Color(0xFF065F46)),
      AssetPillTone.info => (const Color(0xFFDBEAFE), AppColors.primary),
      AssetPillTone.warning => (const Color(0xFFFFEDD5), const Color(0xFFC2410C)),
      AssetPillTone.danger => (const Color(0xFFFEE2E2), const Color(0xFF991B1B)),
      AssetPillTone.purple => (const Color(0xFFEDE9FE), const Color(0xFF5B21B6)),
      AssetPillTone.it => (const Color(0xFFE0F2FE), const Color(0xFF0369A1)),
      AssetPillTone.vehicle => (const Color(0xFFFFEDD5), const Color(0xFF9A3412)),
      AssetPillTone.furniture => (const Color(0xFFD1FAE5), const Color(0xFF065F46)),
      AssetPillTone.office => (const Color(0xFFEDE9FE), const Color(0xFF5B21B6)),
      AssetPillTone.neutral => (const Color(0xFFF1F5F9), AppColors.textMuted),
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

enum AssetPillTone {
  success,
  info,
  warning,
  danger,
  purple,
  it,
  vehicle,
  furniture,
  office,
  neutral,
}

AssetPillTone categoryTone(String category) {
  return switch (category) {
    'IT equipment' => AssetPillTone.it,
    'Vehicle' => AssetPillTone.vehicle,
    'Furniture' => AssetPillTone.furniture,
    'Office equipment' => AssetPillTone.office,
    _ => AssetPillTone.neutral,
  };
}

class AssetAvatar extends StatelessWidget {
  const AssetAvatar(this.initials, {super.key, this.color});

  final String initials;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? context.subtleFill;
    return CircleAvatar(
      radius: 14,
      backgroundColor: bg,
      child: Text(
        initials,
        style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700, color: context.primaryText),
      ),
    );
  }
}

class AssetKpiTile extends StatelessWidget {
  const AssetKpiTile({
    super.key,
    required this.value,
    required this.label,
    this.subLabel,
    this.subColor,
  });

  final String value;
  final String label;
  final String? subLabel;
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
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.dmSans(fontSize: 12, color: tc.secondaryText),
            ),
            if (subLabel != null) ...[
              const SizedBox(height: 2),
              Text(
                subLabel!,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: subColor ?? AppColors.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AssetSectionLabel extends StatelessWidget {
  const AssetSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class AssetHBar extends StatelessWidget {
  const AssetHBar({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    this.trailing,
  });

  final String label;
  final double value;
  final double max;
  final Color color;
  final String? trailing;

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
            width: 88,
            child: Text(
              trailing ?? value.toStringAsFixed(0),
              textAlign: TextAlign.right,
              style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: tc.secondaryText),
            ),
          ),
        ],
      ),
    );
  }
}
