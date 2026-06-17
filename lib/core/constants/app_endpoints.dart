/// REST paths (joined with [ApiClient.baseUrl]). Mirrors Spring `novora_backend` routes.
abstract final class AppEndpoints {
  /// Production API (Render). Mobile apps call this directly — no Vercel proxy.
  static const productionApiBase = 'https://novora-api-wf1w.onrender.com';

  static const authCsrf = '/api/v1/auth/csrf';
  static const authLogin = '/api/v1/auth/login';
  static const authRegister = '/api/v1/auth/register';
  static const authFirebaseRegister = '/api/v1/auth/firebase/register';
  static const authLogout = '/auth/logout';
  static const me = '/api/v1/me';

  /// Personal dashboard for any signed-in user (including EMPLOYEE).
  static const myDashboard = '/api/v1/my/dashboard';

  static const dashboardSummary = '/api/v1/admin/dashboard/summary';
  static const dashboardGrowth = '/api/v1/admin/dashboard/growth';
  static const dashboardRecentHires = '/api/v1/admin/dashboard/recent-hires';
  static const dashboardLeaveRequests = '/api/v1/admin/dashboard/leave-requests';
  static const dashboardPayrollSummary = '/api/v1/admin/dashboard/payroll-summary';
  static const dashboardDepartments = '/api/v1/admin/dashboard/departments';
  static const dashboardAttendanceOverview = '/api/v1/admin/dashboard/attendance-overview';

  static const myAttendance = '/api/v1/my/attendance';
  static const myAttendanceCheckIn = '/api/v1/my/attendance/check-in';
  static const myAttendanceCheckOut = '/api/v1/my/attendance/check-out';

  static const employees = '/api/v1/admin/employees';
  static const departments = '/api/v1/admin/departments';
}
