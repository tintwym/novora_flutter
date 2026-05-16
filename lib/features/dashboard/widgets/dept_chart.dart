import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/repositories/dashboard_repository.dart';

/// Attendance breakdown donut fed by [DashboardRepository] (API or mock).
class AttendanceOverviewChart extends StatelessWidget {
  const AttendanceOverviewChart({super.key, required this.repository});

  final DashboardRepository repository;

  static const _sliceColors = {
    'present': AppColors.brandBlueDeep,
    'absent': Color(0xFFCBD5E1),
    'late': Color(0xFFF59E0B),
    'on leave': Color(0xFFA5B4FC),
  };

  static Color _colorForLabel(String label, Color fallback) {
    final key = label.toLowerCase();
    for (final entry in _sliceColors.entries) {
      if (key.contains(entry.key)) return entry.value;
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final attData = repository.attendanceSlices;
    final positive = attData.where((d) => d.value > 0).toList();
    final pieSections = positive
        .map(
          (d) => PieChartSectionData(
            value: d.value,
            color: _colorForLabel(d.label, d.color),
            radius: 52,
            showTitle: false,
          ),
        )
        .toList();
    final chartSections = pieSections.isEmpty
        ? [
            PieChartSectionData(
              value: 1,
              color: AppColors.border.withValues(alpha: 0.4),
              radius: 52,
              showTitle: false,
            ),
          ]
        : pieSections;

    final centerRate = repository.attendanceOverviewRate;

    return _DashboardSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Attendance Overview',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'This Month',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 148,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: chartSections,
                    centerSpaceRadius: 46,
                    sectionsSpace: 1.5,
                    startDegreeOffset: -90,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${centerRate.toStringAsFixed(1)}%',
                          maxLines: 1,
                          style: GoogleFonts.sora(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy,
                            height: 1.05,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Attendance rate',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...attData.map(_sliceRow),
        ],
      ),
    );
  }

  Widget _sliceRow(AttendanceSliceModel d) {
    final dotColor = _colorForLabel(d.label, d.color);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              d.label,
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Text(
            d.displayPercent,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSectionCard extends StatelessWidget {
  const _DashboardSectionCard({required this.child});

  final Widget child;

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
      child: child,
    );
  }
}
