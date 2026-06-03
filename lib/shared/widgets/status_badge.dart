import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/theme_colors.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, Color>> styles = {
      'Pending': {
        'bg': const Color(0xFFFEF3C7),
        'text': const Color(0xFF92400E),
      },
      'Approved': {
        'bg': const Color(0xFFD1FAE5),
        'text': const Color(0xFF065F46),
      },
      'Rejected': {
        'bg': const Color(0xFFFEE2E2),
        'text': const Color(0xFF991B1B),
      },
    };
    final style =
        styles[label] ?? {'bg': context.mutedPillBg, 'text': context.mutedPillText};
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: style['bg'],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: style['text'],
        ),
      ),
    );
  }
}
