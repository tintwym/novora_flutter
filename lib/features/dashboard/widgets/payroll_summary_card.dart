import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/payroll_model.dart';

class PayrollSummaryCard extends StatelessWidget {
  const PayrollSummaryCard({super.key, required this.payroll});

  final PayrollTotalsModel payroll;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                  color: AppColors.navy,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  payroll.periodLabel,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: AppColors.primary,
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
              color: AppColors.navy,
            ),
          ),
          Text(
            'Total Payroll',
            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
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
            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
        Text(
          '$value ',
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.navy,
          ),
        ),
        Text(
          '($pct)',
          style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted),
        ),
      ],
    );
  }
}
