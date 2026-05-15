/// REST paths (joined with [ApiClient.baseUrl]). Mirrors Spring `novora_backend` routes.
abstract final class AppEndpoints {
  static const authCsrf = '/api/v1/auth/csrf';
  static const authLogin = '/api/v1/auth/login';
  static const authRegister = '/api/v1/auth/register';
  static const authLogout = '/auth/logout';
  static const me = '/api/v1/me';

  static const dashboardSummary = '/api/v1/admin/dashboard/summary';
  static const dashboardGrowth = '/api/v1/admin/dashboard/growth';
  static const dashboardRecentHires = '/api/v1/admin/dashboard/recent-hires';
  static const dashboardLeaveRequests = '/api/v1/admin/dashboard/leave-requests';
  static const dashboardPayrollSummary = '/api/v1/admin/dashboard/payroll-summary';
  static const dashboardDepartments = '/api/v1/admin/dashboard/departments';
  static const dashboardAttendanceOverview = '/api/v1/admin/dashboard/attendance-overview';

  static const employees = '/api/v1/admin/employees';
  static const departments = '/api/v1/admin/departments';
}
