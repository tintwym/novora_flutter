import 'package:flutter/material.dart';

import '../../../data/repositories/dashboard_repository.dart';
import 'dashboard_attendance_timeline_card.dart';
import 'dashboard_employee_leave_card.dart';
import 'dashboard_quarterly_review_card.dart';
import 'dashboard_team_bulletin_card.dart';
import 'dashboard_time_tracking_card.dart';
import 'stat_card.dart';

/// Employee self-service dashboard layout matching the new mockup.
class DashboardEmployeeBody extends StatelessWidget {
  const DashboardEmployeeBody({
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
            if (constraints.maxWidth > 900) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(flex: 2, child: DashboardAttendanceTimelineCard()),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DashboardTimeTrackingCard(
                        showLiveBadge: false,
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
                const DashboardAttendanceTimelineCard(),
                const SizedBox(height: 16),
                DashboardTimeTrackingCard(
                  showLiveBadge: false,
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
              return const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: DashboardTeamBulletinCard()),
                  SizedBox(width: 16),
                  Expanded(child: DashboardQuarterlyReviewCard()),
                  SizedBox(width: 16),
                  Expanded(child: DashboardEmployeeLeaveCard()),
                ],
              );
            }
            return const Column(
              children: [
                DashboardTeamBulletinCard(),
                SizedBox(height: 16),
                DashboardQuarterlyReviewCard(),
                SizedBox(height: 16),
                DashboardEmployeeLeaveCard(),
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
        final crossCount = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 500 ? 2 : 1);
        return GridView.count(
          crossAxisCount: crossCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          children: cards,
        );
      },
    );
  }
}
