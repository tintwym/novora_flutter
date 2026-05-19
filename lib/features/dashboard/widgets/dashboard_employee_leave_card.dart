import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/ui/app_snackbar.dart';
import '../../../shared/widgets/themed_surface_card.dart';

class DashboardEmployeeLeaveCard extends StatelessWidget {
  const DashboardEmployeeLeaveCard({super.key});

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'MY LEAVE STATUS',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: tc.secondaryText,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => AppSnackBar.showError(context, 'Leave application opens from Leave module.'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'APPLY',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brandBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _row(context, title: 'May Short Break', dates: 'MAY 28 – MAY 30', status: 'APPROVED', approved: true),
          const SizedBox(height: 12),
          _row(context, title: 'Personal Health', dates: 'JUN 12', status: 'PENDING', approved: false),
        ],
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required String title,
    required String dates,
    required String status,
    required bool approved,
  }) {
    final tc = context;
    final bg = approved ? const Color(0xFFDCFCE7) : tc.subtleFill;
    final fg = approved ? const Color(0xFF065F46) : tc.secondaryText;
    return Row(
      children: [
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
                dates,
                style: GoogleFonts.dmSans(fontSize: 11, color: tc.secondaryText),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            status,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
        ),
      ],
    );
  }
}
