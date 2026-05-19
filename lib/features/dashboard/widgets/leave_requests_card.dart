import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../data/models/leave_model.dart';
import '../../../shared/widgets/status_badge.dart';
import '../../../shared/widgets/themed_surface_card.dart';

class LeaveRequestsCard extends StatelessWidget {
  const LeaveRequestsCard({
    super.key,
    required this.requests,
    this.title = 'Leave Requests',
    this.linkLabel = 'View All',
    this.emptyMessage = 'No leave requests yet.',
  });

  final List<LeaveRequestModel> requests;
  final String title;
  final String linkLabel;
  final String emptyMessage;

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
                title.toUpperCase(),
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: tc.secondaryText,
                ),
              ),
              const Spacer(),
              Text(
                linkLabel,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: AppColors.brandBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (requests.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                emptyMessage,
                style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted),
              ),
            )
          else
          ...requests.asMap().entries.map((e) {
            final r = e.value;
            final isLast = e.key == requests.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: r.color.withValues(alpha: 0.15),
                        child: Text(
                          r.initials,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: r.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.name,
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: tc.primaryText,
                              ),
                            ),
                            Text(
                              '${r.type} · ${r.dates}',
                              style: GoogleFonts.dmSans(
                                fontSize: 10,
                                color: tc.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge(label: r.status),
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
