/// Route paths shared across features (avoid circular imports).
abstract final class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';

  static const String employees = '/employees';
  static const String employeeWizard = '/employees/wizard';
  static const String payroll = '/payroll';
  static const String leave = '/leave';
  static const String attendance = '/attendance';
  static const String recruitment = '/recruitment';
  static const String performance = '/performance';
  static const String training = '/training';
  static const String reports = '/reports';
  static const String settings = '/settings';
}
