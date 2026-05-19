import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/ui/app_snackbar.dart';

/// Dark highlight card on the employee dashboard.
class DashboardQuarterlyReviewCard extends StatelessWidget {
  const DashboardQuarterlyReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'QUARTERLY REVIEW',
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Exceeds Exp.',
            style: GoogleFonts.sora(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.show_chart_rounded, color: AppColors.brandBlueSoft, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'CONSISTENT GROWTH SCORE',
                  style: GoogleFonts.dmSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => AppSnackBar.showError(context, 'Performance feedback opens soon.'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brandBlue,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('VIEW FEEDBACK'),
          ),
        ],
      ),
    );
  }
}
