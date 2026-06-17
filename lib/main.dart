import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/constants/app_routes.dart';
import 'firebase_options.dart';
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
  // Prefer a local `.env` (gitignored); fall back to the committed `.env.example` asset.
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    try {
      await dotenv.load(fileName: '.env.example');
    } catch (_) {
      // ApiClient / Firebase fall back to dart-define or defaults.
    }
  }
  if (DefaultFirebaseOptions.isConfigured) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    DefaultFirebaseOptions.logIfDisabled();
  }
  await LocalStorage.init();
  await ThemeNotifier.instance.load();
  await ApiClient.initPersistence();
  // Kick the Render free-tier backend awake before the user clicks anything.
  ApiClient.warmUp();

  // ── Session restore on boot ────────────────────────────────────────────────
  // Two competing goals:
  //   1. Refresh should NEVER feel like a logout.
  //   2. A genuinely invalid cookie / soft-deleted account should still bounce
  //      the user back to /login.
  //
  // The previous implementation awaited `/me` with a 6s timeout. Render's free
  // tier routinely takes 30–90s to wake — long enough to blow past the timeout
  // even with the cold-start retry interceptor — so every refresh during the
  // first idle window of the day landed on /login despite a perfectly valid
  // JSESSIONID cookie.
  //
  // Strategy now:
  //   * If we have a cached user, trust it and land on /dashboard immediately.
  //   * Fire `/me` in the background. It will either confirm the session
  //     (silent refresh of the cached profile) or definitively reject it
  //     (cleared cache + notifier → next navigation bounces to /login). Network
  //     errors are swallowed, so a cold-start no longer signs the user out.
  //   * No cache → wait briefly on `/me` in case the cookie alone is enough
  //     (e.g. fresh device, cleared localStorage). Default to /login on
  //     timeout; the user can sign in normally.
  final cachedUser = SessionNotifier.instance.user;
  var initialRoute =
      cachedUser != null ? AppRoutes.dashboard : AppRoutes.login;

  final mePending = AuthRepository().tryRestoreSession().catchError((_) {
    // Transport/timeout — keep the optimistic cached session in place.
    return SessionNotifier.instance.user;
  });

  if (cachedUser == null) {
    try {
      final user = await mePending.timeout(const Duration(seconds: 2));
      if (user != null) initialRoute = AppRoutes.dashboard;
    } on TimeoutException {
      // Cold backend on a fresh device — fall through to /login. The pending
      // `/me` keeps running; if it eventually returns a user the notifier will
      // be updated and the next manual navigation will pick it up.
    }
  } else {
    // Don't await — the user is already heading to /dashboard. Just make sure
    // the future doesn't become an unhandled error.
    unawaited(mePending);
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
