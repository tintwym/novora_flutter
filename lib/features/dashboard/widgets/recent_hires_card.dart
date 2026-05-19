import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../data/models/employee_model.dart';
import '../../../shared/widgets/themed_surface_card.dart';

class RecentHiresCard extends StatelessWidget {
  const RecentHiresCard({super.key, required this.hires});

  final List<RecentHireModel> hires;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'NEW TALENT',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: tc.secondaryText,
                ),
              ),
              const Spacer(),
              Text(
                'EXPLORER',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.brandBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...hires.asMap().entries.map((e) {
            final h = e.value;
            final isLast = e.key == hires.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: h.color.withValues(alpha: 0.15),
                        child: Text(
                          h.initials,
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: h.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h.name,
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: tc.primaryText,
                              ),
                            ),
                            Text(
                              h.role,
                              style: GoogleFonts.dmSans(
                                fontSize: 11,
                                color: tc.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        h.date,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: tc.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast) Divider(color: tc.borderColor, height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }
}
