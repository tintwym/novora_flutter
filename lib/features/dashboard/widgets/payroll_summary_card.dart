import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../data/models/payroll_model.dart';
import '../../../shared/widgets/themed_surface_card.dart';

class PayrollSummaryCard extends StatelessWidget {
  const PayrollSummaryCard({super.key, required this.payroll});

  final PayrollTotalsModel payroll;

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
                'Payroll Summary',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: tc.primaryText,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: tc.filterChipBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  payroll.periodLabel,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: tc.filterChipText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            payroll.totalPayroll,
            style: GoogleFonts.sora(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: tc.primaryText,
            ),
          ),
          Text(
            'Total Payroll',
            style: GoogleFonts.dmSans(fontSize: 12, color: tc.secondaryText),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Row(
              children: [
                Expanded(
                  flex: 72,
                  child: Container(
                    height: 8,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 16,
                  child: Container(height: 8, color: AppColors.purple),
                ),
                Expanded(
                  flex: 12,
                  child: Container(height: 8, color: AppColors.purple3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _PayrollRow(
            color: AppColors.primary,
            label: 'Net Pay',
            value: payroll.netPay,
            pct: '71.9%',
          ),
          const SizedBox(height: 8),
          _PayrollRow(
            color: AppColors.purple,
            label: 'Deductions',
            value: payroll.deductions,
            pct: '15.7%',
          ),
          const SizedBox(height: 8),
          _PayrollRow(
            color: AppColors.purple3,
            label: 'Taxes',
            value: payroll.taxes,
            pct: '12.4%',
          ),
        ],
      ),
    );
  }
}

class _PayrollRow extends StatelessWidget {
  const _PayrollRow({
    required this.color,
    required this.label,
    required this.value,
    required this.pct,
  });

  final Color color;
  final String label;
  final String value;
  final String pct;

  @override
  Widget build(BuildContext context) {
    final tc = context;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.dmSans(fontSize: 12, color: tc.secondaryText),
          ),
        ),
        Text(
          '$value ',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: tc.primaryText,
          ),
        ),
        Text(
          '($pct)',
          style: GoogleFonts.dmSans(fontSize: 11, color: tc.secondaryText),
        ),
      ],
    );
  }
}
