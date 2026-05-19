import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../shared/widgets/themed_surface_card.dart';

class DashboardTeamBulletinCard extends StatelessWidget {
  const DashboardTeamBulletinCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'TEAM BULLETIN',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: tc.secondaryText,
            ),
          ),
          const SizedBox(height: 16),
          _event(
            context,
            day: 'MAY 22',
            title: 'Sprint Retro & Demo',
            meta: '10:00 AM · GOOGLE MEET',
            highlight: true,
          ),
          const SizedBox(height: 12),
          _event(
            context,
            day: 'MAY 24',
            title: 'Q2 Goal Planning',
            meta: '12:30 PM · SOCIAL HALL',
          ),
        ],
      ),
    );
  }

  Widget _event(
    BuildContext context, {
    required String day,
    required String title,
    required String meta,
    bool highlight = false,
  }) {
    final tc = context;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFEFF6FF) : tc.subtleFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: highlight ? AppColors.brandBlueSoft.withValues(alpha: 0.5) : tc.borderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: tc.surfaceCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: tc.borderColor),
            ),
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: tc.primaryText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: tc.primaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: GoogleFonts.dmSans(fontSize: 11, color: tc.secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
