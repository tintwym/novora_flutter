import 'package:fl_chart/fl_chart.dart';

import '../models/attendance_model.dart';
import '../models/department_slice_model.dart';
import '../models/employee_model.dart';
import '../models/leave_model.dart';
import '../models/payroll_model.dart';
import '../services/dashboard_service.dart';

class DashboardRepository {
  DashboardRepository({DashboardService? service})
    : _service = service ?? DashboardService();
  final DashboardService _service;

  bool get isEmployeeView => _service.isEmployeeView;

  List<DashboardStatItem> get statItems => _service.fetchStatItems();
  List<RecentHireModel> get recentHires => _service.fetchRecentHires();
  List<LeaveRequestModel> get leaveRequests => _service.fetchLeaveRequests();
  PayrollTotalsModel get payroll => _service.fetchPayrollSummary();
  List<AttendanceSliceModel> get attendanceSlices =>
      _service.fetchAttendanceSlices();

  double get attendanceOverviewRate => _service.fetchAttendanceOverviewRate();

  List<FlSpot> get growthSpots => _service.growthSpots;
  List<String> get monthLabels => _service.monthLabels;

  List<DepartmentSliceModel> get departmentSlices =>
      _service.fetchDepartmentSlices();
}
