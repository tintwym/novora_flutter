import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/constants/app_routes.dart';
import 'core/constants/app_strings.dart';
import 'core/network/api_client.dart';
import 'core/session/session_notifier.dart';
import 'core/storage/local_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'data/repositories/auth_repository.dart';
import 'features/attendance/attendance_management_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/disciplinary/screens/disciplinary_management_screen.dart';
import 'features/employees/screens/add_employee_screen.dart';
import 'features/employees/screens/employee_list_screen.dart';
import 'features/leave/leave_screen.dart';
import 'features/payroll/payroll_screen.dart';
import 'features/performance/performance_screen.dart';
import 'features/recruitment/recruitment_screen.dart';
import 'features/reports/reports_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/training/screens/training_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env.example');
  } catch (_) {
    // Asset missing in some builds; ApiClient falls back to localhost / dart-define.
  }
  await LocalStorage.init();
  await ThemeNotifier.instance.load();
  await ApiClient.initPersistence();
  // Kick the Render free-tier backend awake before the user clicks anything.
  ApiClient.warmUp();
  // Always try to re-hydrate the session from the server cookie. The previous
  // implementation only attempted this when "Remember me" was on, which kicked the
  // user back to /login on every refresh — even when the JSESSIONID cookie (which
  // survives refresh and lives until the browser closes) was still valid. Now the
  // cookie alone is enough to keep the user signed in; "Remember me" only governs
  // whether the cached user JSON is kept across full browser restarts.
  //
  // Cap the boot wait at a few seconds so a Render cold-start doesn't stall the
  // splash. If `/me` is still in-flight when the timeout fires we fall through to
  // /login; the cold-start retry interceptor keeps the request alive in the
  // background so a subsequent action still benefits from the warmed backend.
  var initialRoute = AppRoutes.login;
  try {
    final user = await AuthRepository()
        .tryRestoreSession()
        .timeout(const Duration(seconds: 6));
    if (user != null) initialRoute = AppRoutes.dashboard;
  } catch (_) {
    // Stay on login on timeout or any network/server failure.
  }
  if (!LocalStorage.instance.rememberMe && initialRoute == AppRoutes.login) {
    // No active session and the user never opted in to persistence — drop any
    // stale cache so the next visit doesn't flash the previous user.
    LocalStorage.instance.userJson = null;
    LocalStorage.instance.authToken = null;
  }
  runApp(NovoraApp(initialRoute: initialRoute));
}

class NovoraApp extends StatelessWidget {
  const NovoraApp({super.key, this.initialRoute = AppRoutes.login});

  final String initialRoute;

  /// Routes that don't require an authenticated session.
  static const Set<String> _publicRoutes = {
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.forgotPassword,
  };

  /// Each entry maps a route name to its builder. Going via `onGenerateRoute` (instead of the
  /// `routes` map) lets us reject deep-links to protected screens for signed-out users — without
  /// the guard, `https://novora-hrms.vercel.app/#/employees` would render the employee list
  /// straight from mock data with no session check.
  static final Map<String, WidgetBuilder> _routeBuilders = {
    AppRoutes.login: (_) => const LoginScreen(),
    AppRoutes.register: (_) => const RegisterScreen(),
    AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
    AppRoutes.dashboard: (_) => const DashboardScreen(),
    AppRoutes.employees: (_) => const EmployeeListScreen(),
    AppRoutes.employeeWizard: (_) => const AddEmployeeScreen(),
    AppRoutes.payroll: (_) => const PayrollScreen(),
    AppRoutes.leave: (_) => const LeaveScreen(),
    AppRoutes.disciplinary: (_) => const DisciplinaryManagementScreen(),
    AppRoutes.attendance: (_) => const AttendanceManagementScreen(),
    AppRoutes.recruitment: (_) => const RecruitmentScreen(),
    AppRoutes.performance: (_) => const PerformanceScreen(),
    AppRoutes.training: (_) => const TrainingListScreen(),
    AppRoutes.reports: (_) => const ReportsScreen(),
    AppRoutes.settings: (_) => const SettingsScreen(),
  };

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    final name = settings.name ?? AppRoutes.login;
    final builder = _routeBuilders[name];
    if (builder == null) return null;
    final isPublic = _publicRoutes.contains(name);
    if (!isPublic && SessionNotifier.instance.user == null) {
      return MaterialPageRoute<void>(
        settings: const RouteSettings(name: AppRoutes.login),
        builder: (ctx) => const LoginScreen(),
      );
    }
    return MaterialPageRoute<void>(settings: settings, builder: builder);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeNotifier.instance,
      builder: (context, _) {
        return MaterialApp(
          title: AppStrings.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeNotifier.instance.mode,
          initialRoute: initialRoute,
          onGenerateRoute: _onGenerateRoute,
        );
      },
    );
  }
}
