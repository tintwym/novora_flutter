import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../shared/widgets/themed_surface_card.dart';

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
            radius: 54,
            showTitle: false,
          ),
        )
        .toList();
    final chartSections = pieSections.isEmpty
        ? [
            PieChartSectionData(
              value: 1,
              color: AppColors.border.withValues(alpha: 0.4),
              radius: 54,
              showTitle: false,
            ),
          ]
        : pieSections;

    final centerRate = repository.attendanceOverviewRate;

    final tc = context;
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ATTENDANCE',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: tc.secondaryText,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ],
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
                    centerSpaceRadius: 50,
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
                            color: tc.primaryText,
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
                          color: tc.secondaryText,
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
          ...attData.map((d) => _sliceRow(context, d)),
        ],
      ),
    );
  }

  Widget _sliceRow(BuildContext context, AttendanceSliceModel d) {
    final tc = context;
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
                color: tc.secondaryText,
              ),
            ),
          ),
          Text(
            d.displayPercent,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: tc.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
