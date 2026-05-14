/// Aggregated dashboard counters (extend when API is wired).
class DashboardStatsModel {
  const DashboardStatsModel({
    required this.headcount,
    required this.openRoles,
    required this.pendingLeave,
  });

  final int headcount;
  final int openRoles;
  final int pendingLeave;
}
