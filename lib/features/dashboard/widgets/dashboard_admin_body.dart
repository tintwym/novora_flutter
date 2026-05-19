import 'package:flutter/material.dart';

import '../../../data/repositories/dashboard_repository.dart';
import 'attendance_donut_chart.dart';
import 'dashboard_time_tracking_card.dart';
import 'growth_chart.dart';
import 'leave_requests_card.dart';
import 'payroll_summary_card.dart';
import 'recent_hires_card.dart';
import 'stat_card.dart';

/// Admin dashboard layout matching the new mockup.
class DashboardAdminBody extends StatelessWidget {
  const DashboardAdminBody({
    super.key,
    required this.repository,
    this.skipTimeTrackingLiveUpdates = false,
  });

  final DashboardRepository repository;
  final bool skipTimeTrackingLiveUpdates;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _statGrid(repository.statItems.map((i) => StatCard(item: i)).toList()),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1000) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 2, child: GrowthChart(repository: repository)),
                    const SizedBox(width: 16),
                    Expanded(child: AttendanceDonutChart(repository: repository)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DashboardTimeTrackingCard(
                        enableLiveClock: !skipTimeTrackingLiveUpdates,
                        enableAttendanceApi: !skipTimeTrackingLiveUpdates,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: [
                GrowthChart(repository: repository),
                const SizedBox(height: 16),
                AttendanceDonutChart(repository: repository),
                const SizedBox(height: 16),
                DashboardTimeTrackingCard(
                  enableLiveClock: !skipTimeTrackingLiveUpdates,
                  enableAttendanceApi: !skipTimeTrackingLiveUpdates,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: RecentHiresCard(hires: repository.recentHires)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LeaveRequestsCard(
                      title: 'Absence Queue',
                      linkLabel: 'ACTION LIST',
                      requests: repository.leaveRequests,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: PayrollSummaryCard(payroll: repository.payroll)),
                ],
              );
            }
            return Column(
              children: [
                RecentHiresCard(hires: repository.recentHires),
                const SizedBox(height: 16),
                LeaveRequestsCard(
                  title: 'Absence Queue',
                  linkLabel: 'ACTION LIST',
                  requests: repository.leaveRequests,
                ),
                const SizedBox(height: 16),
                PayrollSummaryCard(payroll: repository.payroll),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _statGrid(List<Widget> cards) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 1000
            ? 6
            : (constraints.maxWidth > 600 ? 3 : 2);
        return GridView.count(
          crossAxisCount: crossCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.35,
          children: cards,
        );
      },
    );
  }
}
