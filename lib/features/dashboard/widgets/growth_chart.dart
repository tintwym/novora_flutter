import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../data/repositories/dashboard_repository.dart';
import '../../../shared/widgets/themed_surface_card.dart';

/// Employee headcount trend — uses repository mock spots until API wiring.
class GrowthChart extends StatelessWidget {
  const GrowthChart({super.key, required this.repository});

  final DashboardRepository repository;

  /// Axis range aligned to 200-step grid (labels match design: 611 … 1316).
  static const double _axisMinY = 600;
  static const double _axisMaxY = 1400;
  static const double _yInterval = 200;

  static String? _leftAxisLabel(double value) {
    final v = value.round();
    if (v <= _axisMinY) return '611';
    if (v == 800) return '800';
    if (v == 1000) return '1000';
    if (v == 1200) return '1200';
    if (v >= _axisMaxY) return '1316';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final months = repository.monthLabels;
    final spots = repository.growthSpots;
    final maxX = spots.isEmpty ? 11.0 : (spots.length - 1).toDouble();

    final tc = context;
    return ThemedSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'WORKFORCE TRENDS',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: tc.secondaryText,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tc.filterChipBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Last 12 months ▾',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: tc.filterChipText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: maxX,
                minY: _axisMinY,
                maxY: _axisMaxY,
                clipData: const FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _yInterval,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: tc.borderColor, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      interval: _yInterval,
                      getTitlesWidget: (value, meta) {
                        final label = _leftAxisLabel(value);
                        if (label == null) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            label,
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              color: AppColors.muted,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final idx = value.round();
                        if (idx < 0 || idx >= months.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            months[idx],
                            style: GoogleFonts.dmSans(
                              fontSize: 10,
                              color: AppColors.muted,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.22,
                    color: AppColors.brandBlueDeep,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.brandBlue.withValues(alpha: 0.35),
                          AppColors.brandBlueSoft.withValues(alpha: 0.12),
                          tc.chartAreaFade,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) => touchedSpots.map((spot) {
                      final xi = spot.x.toInt();
                      final idx = months.isEmpty
                          ? 0
                          : xi.clamp(0, months.length - 1);
                      final label = months.isEmpty ? '—' : months[idx];
                      return LineTooltipItem(
                        '$label: ${spot.y.toInt()} employees',
                        GoogleFonts.dmSans(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

