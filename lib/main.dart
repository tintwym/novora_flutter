import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/constants/app_routes.dart';
import 'core/constants/app_strings.dart';
import 'core/network/api_client.dart';
import 'core/storage/local_storage.dart';
import 'core/theme/app_theme.dart';
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
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // `.env` may be absent locally; ApiClient falls back to localhost.
  }
  await LocalStorage.init();
  await ApiClient.initPersistence();
  var initialRoute = AppRoutes.login;
  try {
    final user = await AuthRepository().tryRestoreSession();
    if (user != null) initialRoute = AppRoutes.dashboard;
  } catch (_) {
    // Stay on login if `/me` fails (no session, server down, etc.).
  }
  runApp(NovoraApp(initialRoute: initialRoute));
}

class NovoraApp extends StatelessWidget {
  const NovoraApp({super.key, this.initialRoute = AppRoutes.login});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
      initialRoute: initialRoute,
      routes: {
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
      },
    );
  }
}
