import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_endpoints.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart';
import '../models/user_model.dart';
import '../models/attendance_model.dart';
import '../models/department_slice_model.dart';
import '../models/employee_model.dart';
import '../models/leave_model.dart';
import '../models/payroll_model.dart';

/// Dashboard KPI tile fed into [StatCard] / grid.
class DashboardStatItem {
  const DashboardStatItem({
    required this.label,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;
}

class _Live {
  _Live({
    required this.statItems,
    required this.recentHires,
    required this.leaveRequests,
    required this.payroll,
    required this.attendanceSlices,
    required this.attendanceRatePercent,
    required this.growthSpots,
    required this.monthLabels,
    required this.departments,
    this.employeeView = false,
  });

  final bool employeeView;
  final List<DashboardStatItem> statItems;
  final List<RecentHireModel> recentHires;
  final List<LeaveRequestModel> leaveRequests;
  final PayrollTotalsModel payroll;
  final List<AttendanceSliceModel> attendanceSlices;

  /// Matches Spring `attendanceRate` (present / all rows in range).
  final double attendanceRatePercent;
  final List<FlSpot> growthSpots;
  final List<String> monthLabels;
  final List<DepartmentSliceModel> departments;
}

/// Loads admin dashboard payloads from Spring when authenticated; otherwise uses mocks.
class DashboardService {
  DashboardService();

  static _Live? _live;

  static void clearCache() {
    _live = null;
  }

  static UserModel? _storedUser() {
    final raw = LocalStorage.instance.userJson;
    if (raw == null || raw.isEmpty) return null;
    try {
      return UserModel.fromAuthJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> refreshFromApi() async {
    try {
      final dio = ApiClient.dio;
      final user = _storedUser();
      if (user?.isEmployee == true) {
        await _refreshEmployeeDashboard(dio);
      } else {
        await _refreshAdminDashboard(dio);
      }
    } catch (_) {
      _live = null;
    }
  }

  static Future<void> _refreshAdminDashboard(Dio dio) async {
    final summary = await _getJson(dio, AppEndpoints.dashboardSummary);
    final growth = await _getJson(dio, AppEndpoints.dashboardGrowth);
    final hires = await _getJson(dio, AppEndpoints.dashboardRecentHires);
    final leaves = await _getJson(dio, AppEndpoints.dashboardLeaveRequests);
    final payroll = await _getJson(dio, AppEndpoints.dashboardPayrollSummary);
    final depts = await _getJson(dio, AppEndpoints.dashboardDepartments);
    final att = await _getJson(dio, AppEndpoints.dashboardAttendanceOverview);
    final attParsed = _parseAttendanceSlicesAndRate(att);
    final attSlices = attParsed?.slices ?? _mockAttendance();
    final attRate = attParsed?.rate ?? _mockAttendanceCenterRate();

    _live = _Live(
      statItems: _parseKpis(summary) ?? _mockStatItems(),
      recentHires: _parseHires(hires) ?? _mockHires(),
      leaveRequests: _parseLeaves(leaves) ?? _mockLeaves(),
      payroll: _parsePayroll(payroll) ?? _mockPayroll(),
      attendanceSlices: attSlices,
      attendanceRatePercent: attRate,
      growthSpots: _parseGrowth(growth) ?? _defaultGrowthSpots,
      monthLabels: _parseGrowthLabels(growth) ?? _defaultGrowthLabels,
      departments: () {
        final d = _parseDepartments(depts);
        return d.isEmpty ? _mockDepartments() : d;
      }(),
    );
  }

  /// EMPLOYEE role cannot call `/api/v1/admin/dashboard/*` (403). Use bundled my-dashboard.
  static Future<void> _refreshEmployeeDashboard(Dio dio) async {
    final data = await _getJson(dio, AppEndpoints.myDashboard);
    if (data is! Map<String, dynamic>) {
      _live = _employeeFallbackLive();
      return;
    }

    final att = data['attendanceOverview'];
    final attParsed = _parseAttendanceSlicesAndRate(att);
    final attSlices = attParsed?.slices ?? _mockAttendance();
    final attRate = attParsed?.rate ?? _mockAttendanceCenterRate();

    _live = _Live(
      employeeView: true,
      statItems: _parseKpis({'kpis': data['kpis']}) ?? _mockEmployeeStatItems(),
      recentHires: const [],
      leaveRequests: _parseLeaves(data['leaveRequests']) ?? const [],
      payroll: _parsePayroll(data['payrollSummary']) ?? _mockEmployeePayroll(),
      attendanceSlices: attSlices,
      attendanceRatePercent: attRate,
      growthSpots: _parseGrowth(data['growth']) ?? _defaultGrowthSpots,
      monthLabels: _parseGrowthLabels(data['growth']) ?? _defaultGrowthLabels,
      departments: () {
        final d = _parseDepartments(data['departments']);
        return d.isEmpty ? _mockDepartments() : d;
      }(),
    );
  }

  static _Live _employeeFallbackLive() => _Live(
        employeeView: true,
        statItems: _mockEmployeeStatItems(),
        recentHires: const [],
        leaveRequests: const [],
        payroll: _mockEmployeePayroll(),
        attendanceSlices: _mockAttendance(),
        attendanceRatePercent: _mockAttendanceCenterRate(),
        growthSpots: _defaultGrowthSpots,
        monthLabels: _defaultGrowthLabels,
        departments: _mockDepartments(),
      );

  static Future<dynamic> _getJson(Dio dio, String path) async {
    try {
      final res = await dio.get<dynamic>(path);
      if (res.statusCode == 200) return res.data;
    } catch (_) {}
    return null;
  }

  bool get isEmployeeView => _live?.employeeView ?? _storedUser()?.isEmployee ?? false;

  List<DashboardStatItem> fetchStatItems() {
    if (_live != null) return _live!.statItems;
    return isEmployeeView ? _mockEmployeeStatItems() : _mockStatItems();
  }

  List<RecentHireModel> fetchRecentHires() {
    if (_live != null) return _live!.recentHires;
    return isEmployeeView ? const [] : _mockHires();
  }

  List<LeaveRequestModel> fetchLeaveRequests() {
    if (_live != null) return _live!.leaveRequests;
    return isEmployeeView ? const [] : _mockLeaves();
  }

  PayrollTotalsModel fetchPayrollSummary() {
    if (_live != null) return _live!.payroll;
    return isEmployeeView ? _mockEmployeePayroll() : _mockPayroll();
  }

  List<AttendanceSliceModel> fetchAttendanceSlices() =>
      _live?.attendanceSlices ?? _mockAttendance();

  /// Center label on attendance donut; aligned with API `attendanceRate` when live.
  double fetchAttendanceOverviewRate() =>
      _live?.attendanceRatePercent ?? _mockAttendanceCenterRate();

  List<FlSpot> get growthSpots => _live?.growthSpots ?? _defaultGrowthSpots;

  List<String> get monthLabels => _live?.monthLabels ?? _defaultGrowthLabels;

  List<DepartmentSliceModel> fetchDepartmentSlices() =>
      _live?.departments.isNotEmpty == true
      ? _live!.departments
      : _mockDepartments();

  static List<DashboardStatItem>? _parseKpis(dynamic summary) {
    if (summary is! Map<String, dynamic>) return null;
    final raw = summary['kpis'];
    if (raw is! List) return null;
    final out = <DashboardStatItem>[];
    for (final e in raw) {
      if (e is! Map<String, dynamic>) continue;
      final label = e['label'] as String? ?? '';
      final value = e['value'] as String? ?? '';
      final delta = e['delta'] as String? ?? '';
      final iconName = e['icon'] as String? ?? '';
      final accent = e['accent'] as String? ?? '#1565C0';
      out.add(
        DashboardStatItem(
          label: label,
          value: value,
          change: delta,
          isPositive: !delta.trim().startsWith('-'),
          icon: _iconFromHint(iconName, label),
          color: _parseHexColor(accent) ?? AppColors.primary,
        ),
      );
    }
    return out.isEmpty ? null : out;
  }

  static List<RecentHireModel>? _parseHires(dynamic data) {
    if (data is! List) return null;
    final palette = [
      AppColors.primary,
      AppColors.purple,
      AppColors.success,
      AppColors.warning,
      AppColors.danger,
    ];
    final out = <RecentHireModel>[];
    var i = 0;
    for (final e in data) {
      if (e is! Map<String, dynamic>) continue;
      final name = e['name'] as String? ?? '';
      final role = e['role'] as String? ?? '';
      final date = e['date'] as String? ?? '';
      out.add(
        RecentHireModel(
          name: name,
          role: role,
          date: date,
          initials: _initials(name),
          color: palette[i % palette.length],
        ),
      );
      i++;
    }
    return out.isEmpty ? null : out;
  }

  static List<LeaveRequestModel>? _parseLeaves(dynamic data) {
    if (data is! List) return null;
    final palette = [
      AppColors.primary,
      AppColors.purple,
      AppColors.success,
      AppColors.warning,
      AppColors.danger,
    ];
    final out = <LeaveRequestModel>[];
    var i = 0;
    for (final e in data) {
      if (e is! Map<String, dynamic>) continue;
      out.add(
        LeaveRequestModel(
          name: e['name'] as String? ?? '',
          type: e['leaveType'] as String? ?? '',
          dates: e['dateRange'] as String? ?? '',
          status: e['status'] as String? ?? '',
          initials: _initials(e['name'] as String? ?? ''),
          color: palette[i % palette.length],
        ),
      );
      i++;
    }
    return out.isEmpty ? null : out;
  }

  static PayrollTotalsModel? _parsePayroll(dynamic data) {
    if (data is! List) return null;
    final rows = <Map<String, dynamic>>[];
    for (final e in data) {
      if (e is Map<String, dynamic>) rows.add(e);
    }
    if (rows.isEmpty) return null;
    var total = 0;
    var deductions = 0;
    for (final e in rows) {
      final n = (e['name'] as String? ?? '').toLowerCase();
      final v = (e['value'] as num?)?.toInt() ?? 0;
      total += v;
      if (n.contains('deduct')) deductions += v;
    }
    final fmt = NumberFormat.currency(
      locale: 'en_US',
      symbol: r'$',
      decimalDigits: 0,
    );
    final net = (total - deductions).clamp(0, 1 << 60);
    return PayrollTotalsModel(
      totalPayroll: fmt.format(total),
      netPay: fmt.format(net),
      deductions: fmt.format(deductions),
      taxes: fmt.format((total * 0.12).round()),
      periodLabel: 'Live data ▾',
    );
  }

  /// Returns slices and Spring `attendanceRate` for the donut center label.
  static ({List<AttendanceSliceModel> slices, double rate})?
  _parseAttendanceSlicesAndRate(dynamic data) {
    if (data is! Map<String, dynamic>) return null;
    final rate = (data['attendanceRate'] as num?)?.toDouble() ?? 0;
    final buckets = data['buckets'];
    if (buckets is! List) return null;
    final out = <AttendanceSliceModel>[];
    var totalCounts = 0;
    for (final b in buckets) {
      if (b is Map<String, dynamic>) {
        totalCounts += (b['count'] as num?)?.toInt() ?? 0;
      }
    }
    for (final b in buckets) {
      if (b is! Map<String, dynamic>) continue;
      final label = b['label'] as String? ?? '';
      final count = (b['count'] as num?)?.toInt() ?? 0;
      final share = totalCounts > 0 ? (100 * count / totalCounts) : 0.0;
      final pct = '${share.toStringAsFixed(1)}%';
      out.add(
        AttendanceSliceModel(
          label: label,
          value: count.toDouble(),
          displayPercent: pct,
          color: _bucketColor(label),
        ),
      );
    }
    if (out.isEmpty) {
      return (
        slices: [
          AttendanceSliceModel(
            label: 'Attendance',
            value: rate,
            displayPercent: '${rate.toStringAsFixed(1)}%',
            color: AppColors.primary,
          ),
        ],
        rate: rate,
      );
    }
    return (slices: out, rate: rate);
  }

  static List<FlSpot>? _parseGrowth(dynamic data) {
    if (data is! List) return null;
    final spots = <FlSpot>[];
    var i = 0.0;
    for (final e in data) {
      if (e is Map<String, dynamic>) {
        final y = (e['employees'] as num?)?.toDouble() ?? 0;
        spots.add(FlSpot(i, y));
        i += 1;
      }
    }
    return spots.isEmpty ? null : spots;
  }

  static List<String>? _parseGrowthLabels(dynamic data) {
    if (data is! List) return null;
    final labels = <String>[];
    for (final e in data) {
      if (e is Map<String, dynamic>) {
        labels.add(e['month'] as String? ?? '');
      }
    }
    return labels.isEmpty ? null : labels;
  }

  static List<DepartmentSliceModel> _parseDepartments(dynamic data) {
    if (data is! List) return const [];
    final palette = [
      AppColors.primary,
      AppColors.purple,
      AppColors.purple2,
      AppColors.purple3,
      AppColors.purple4,
      AppColors.success,
    ];
    final out = <DepartmentSliceModel>[];
    var i = 0;
    for (final e in data) {
      if (e is! Map<String, dynamic>) continue;
      final name = e['name'] as String? ?? '';
      final count = (e['count'] as num?)?.toInt() ?? 0;
      final pct = (e['percent'] as num?)?.toDouble() ?? 0;
      out.add(
        DepartmentSliceModel(
          name: name,
          value: pct,
          count: count,
          color: palette[i % palette.length],
        ),
      );
      i++;
    }
    return out;
  }

  static Color _bucketColor(String label) {
    final l = label.toLowerCase();
    if (l.contains('present')) return AppColors.primary;
    if (l.contains('absent')) return AppColors.border;
    if (l.contains('late')) return AppColors.warning;
    if (l.contains('leave')) return AppColors.purple4;
    if (l.contains('other')) return AppColors.muted;
    return AppColors.accent;
  }

  static Color? _parseHexColor(String raw) {
    var s = raw.trim();
    if (s.isEmpty) return null;
    if (s.startsWith('#')) s = s.substring(1);
    if (s.length == 6) {
      final v = int.tryParse(s, radix: 16);
      if (v == null) return null;
      return Color(0xFF000000 | v);
    }
    return null;
  }

  static IconData _iconFromHint(String icon, String label) {
    final combined = ('$icon $label').toLowerCase();
    if (combined.contains('hire') || combined.contains('person')) {
      return Icons.person_add_outlined;
    }
    if (combined.contains('leave') || combined.contains('beach')) {
      return Icons.beach_access_outlined;
    }
    if (combined.contains('attend') || combined.contains('check')) {
      return Icons.check_circle_outlined;
    }
    if (combined.contains('position') || combined.contains('work')) {
      return Icons.work_outline_rounded;
    }
    if (combined.contains('turn') || combined.contains('sync')) {
      return Icons.sync_alt_rounded;
    }
    if (combined.contains('group') || combined.contains('employee')) {
      return Icons.groups_outlined;
    }
    return Icons.insights_outlined;
  }

  static String _initials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final s = parts.first;
      return s.length >= 2 ? s.substring(0, 2).toUpperCase() : s.toUpperCase();
    }
    return ('${parts.first[0]}${parts.last[0]}').toUpperCase();
  }

  static List<DashboardStatItem> _mockEmployeeStatItems() => const [
    DashboardStatItem(
      label: 'Attendance Rate',
      value: '—',
      change: 'This month',
      isPositive: true,
      icon: Icons.check_circle_outlined,
      color: AppColors.success,
    ),
    DashboardStatItem(
      label: 'Leave Requests',
      value: '0',
      change: '0 pending',
      isPositive: true,
      icon: Icons.beach_access_outlined,
      color: AppColors.accent,
    ),
    DashboardStatItem(
      label: 'Onboarding Tasks',
      value: '0',
      change: 'remaining',
      isPositive: true,
      icon: Icons.assignment_outlined,
      color: AppColors.primary,
    ),
  ];

  static PayrollTotalsModel _mockEmployeePayroll() => const PayrollTotalsModel(
        totalPayroll: '—',
        netPay: '—',
        deductions: '—',
        taxes: '—',
        periodLabel: 'Not available',
      );

  static List<DashboardStatItem> _mockStatItems() => const [
    DashboardStatItem(
      label: 'Total Employees',
      value: '1,248',
      change: '+8.5%',
      isPositive: true,
      icon: Icons.groups_outlined,
      color: AppColors.primary,
    ),
    DashboardStatItem(
      label: 'New Hires',
      value: '42',
      change: '+16.7%',
      isPositive: true,
      icon: Icons.person_add_outlined,
      color: AppColors.purple,
    ),
    DashboardStatItem(
      label: 'On Leave',
      value: '87',
      change: '-3.2%',
      isPositive: false,
      icon: Icons.beach_access_outlined,
      color: AppColors.accent,
    ),
        DashboardStatItem(
          label: 'Attendance Rate',
          value: '96.8%',
          change: '+2.4%',
      isPositive: true,
      icon: Icons.check_circle_outlined,
      color: AppColors.success,
    ),
    DashboardStatItem(
      label: 'Open Positions',
      value: '23',
      change: '-8.0%',
      isPositive: false,
      icon: Icons.work_outline_rounded,
      color: AppColors.warning,
    ),
    DashboardStatItem(
      label: 'Turnover Rate',
      value: '6.2%',
      change: '+1.1%',
      isPositive: true,
      icon: Icons.sync_alt_rounded,
      color: AppColors.purple,
    ),
  ];

  static List<RecentHireModel> _mockHires() => const [
    RecentHireModel(
      name: 'Sarah Johnson',
      role: 'UI/UX Designer',
      date: 'May 28, 2025',
      initials: 'SJ',
      color: AppColors.primary,
    ),
    RecentHireModel(
      name: 'Michael Chen',
      role: 'Backend Developer',
      date: 'May 27, 2025',
      initials: 'MC',
      color: AppColors.purple,
    ),
    RecentHireModel(
      name: 'Priya Sharma',
      role: 'HR Executive',
      date: 'May 26, 2025',
      initials: 'PS',
      color: AppColors.success,
    ),
    RecentHireModel(
      name: 'David Wilson',
      role: 'Sales Manager',
      date: 'May 24, 2025',
      initials: 'DW',
      color: AppColors.warning,
    ),
    RecentHireModel(
      name: 'Emma Brown',
      role: 'Marketing Specialist',
      date: 'May 23, 2025',
      initials: 'EB',
      color: AppColors.danger,
    ),
  ];

  static List<LeaveRequestModel> _mockLeaves() => const [
    LeaveRequestModel(
      name: 'John Doe',
      type: 'Annual Leave',
      dates: 'May 30 – Jun 03',
      status: 'Pending',
      initials: 'JD',
      color: AppColors.primary,
    ),
    LeaveRequestModel(
      name: 'Emily Davis',
      type: 'Sick Leave',
      dates: 'May 29 – May 30',
      status: 'Approved',
      initials: 'ED',
      color: AppColors.purple,
    ),
    LeaveRequestModel(
      name: 'Robert Smith',
      type: 'Personal Leave',
      dates: 'May 31 – Jun 02',
      status: 'Pending',
      initials: 'RS',
      color: AppColors.success,
    ),
    LeaveRequestModel(
      name: 'Lisa Wilson',
      type: 'Annual Leave',
      dates: 'Jun 02 – Jun 06',
      status: 'Approved',
      initials: 'LW',
      color: AppColors.warning,
    ),
    LeaveRequestModel(
      name: 'James Taylor',
      type: 'Sick Leave',
      dates: 'May 30 – May 31',
      status: 'Rejected',
      initials: 'JT',
      color: AppColors.danger,
    ),
  ];

  static PayrollTotalsModel _mockPayroll() => const PayrollTotalsModel(
    totalPayroll: '\$1,248,320',
    netPay: '\$896,450',
    deductions: '\$195,870',
    taxes: '\$156,000',
    periodLabel: 'May 2025 ▾',
  );

  /// Mock counts match the original dashboard demo; legend % and donut are derived so they sum to 100%.
  static List<AttendanceSliceModel> _mockAttendance() {
    const p = 968, a = 25, l = 11, ol = 79;
    const t = p + a + l + ol;
    String pct(int c) => '${(100 * c / t).toStringAsFixed(1)}%';
    return [
      AttendanceSliceModel(
        label: 'Present',
        value: p.toDouble(),
        displayPercent: pct(p),
        color: AppColors.primary,
      ),
      AttendanceSliceModel(
        label: 'Absent',
        value: a.toDouble(),
        displayPercent: pct(a),
        color: AppColors.border,
      ),
      AttendanceSliceModel(
        label: 'Late',
        value: l.toDouble(),
        displayPercent: pct(l),
        color: AppColors.warning,
      ),
      AttendanceSliceModel(
        label: 'On Leave',
        value: ol.toDouble(),
        displayPercent: pct(ol),
        color: AppColors.purple4,
      ),
    ];
  }

  static double _mockAttendanceCenterRate() {
    const p = 968, a = 25, l = 11, ol = 79;
    const t = p + a + l + ol;
    return (100 * p / t);
  }

  static const List<FlSpot> _defaultGrowthSpots = [
    FlSpot(0, 680),
    FlSpot(1, 720),
    FlSpot(2, 760),
    FlSpot(3, 810),
    FlSpot(4, 870),
    FlSpot(5, 910),
    FlSpot(6, 950),
    FlSpot(7, 1010),
    FlSpot(8, 1080),
    FlSpot(9, 1140),
    FlSpot(10, 1190),
    FlSpot(11, 1248),
  ];

  static const List<String> _defaultGrowthLabels = [
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
  ];

  static List<DepartmentSliceModel> _mockDepartments() => const [
    DepartmentSliceModel(
      name: 'Engineering',
      value: 35,
      count: 437,
      color: AppColors.primary,
    ),
    DepartmentSliceModel(
      name: 'Sales',
      value: 20,
      count: 250,
      color: AppColors.purple,
    ),
    DepartmentSliceModel(
      name: 'Marketing',
      value: 15,
      count: 187,
      color: AppColors.purple2,
    ),
    DepartmentSliceModel(
      name: 'HR',
      value: 10,
      count: 125,
      color: AppColors.purple3,
    ),
    DepartmentSliceModel(
      name: 'Operations',
      value: 12,
      count: 150,
      color: AppColors.purple4,
    ),
    DepartmentSliceModel(
      name: 'Finance',
      value: 8,
      count: 99,
      color: AppColors.success,
    ),
  ];
}
