import 'package:flutter/material.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/services/dashboard_service.dart';
import '../../shared/widgets/app_sidebar.dart';

class DashboardController extends ChangeNotifier {
  DashboardController({DashboardRepository? repository})
      : _repository = repository ?? DashboardRepository();

  final DashboardRepository _repository;

  DashboardRepository get repository => _repository;

  String activeNavLabel = 'Dashboard';

  static const _allNavItems = [
    NavMenuItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    NavMenuItem(icon: Icons.groups_outlined, label: 'Employees'),
    NavMenuItem(icon: Icons.assignment_outlined, label: 'Recruitment'),
    NavMenuItem(icon: Icons.access_time_outlined, label: 'Attendance'),
    NavMenuItem(icon: Icons.beach_access_outlined, label: 'Leave Management'),
    NavMenuItem(icon: Icons.gavel_outlined, label: 'Disciplinary Management'),
    NavMenuItem(icon: Icons.payments_outlined, label: 'Payroll'),
    NavMenuItem(icon: Icons.receipt_long_outlined, label: 'Claims'),
    NavMenuItem(icon: Icons.trending_up_rounded, label: 'Performance'),
    NavMenuItem(icon: Icons.school_outlined, label: 'Training'),
    NavMenuItem(icon: Icons.inventory_2_outlined, label: 'Assets'),
    NavMenuItem(icon: Icons.bar_chart_outlined, label: 'Reports'),
    NavMenuItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  static const _employeeNavItems = [
    NavMenuItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    NavMenuItem(icon: Icons.access_time_outlined, label: 'Attendance'),
    NavMenuItem(icon: Icons.beach_access_outlined, label: 'Leave Management'),
    NavMenuItem(icon: Icons.receipt_long_outlined, label: 'Claims'),
    NavMenuItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  /// Full HR menu for admins/managers; trimmed menu for [EMPLOYEE].
  static List<NavMenuItem> navItemsFor(UserModel? user) =>
      user != null && user.canAccessHrAdmin ? _allNavItems : _employeeNavItems;

  @Deprecated('Use navItemsFor(user)')
  static List<NavMenuItem> get navItems => _allNavItems;

  void setActiveNav(String label, {bool forceNotify = false}) {
    if (!forceNotify && activeNavLabel == label) return;
    activeNavLabel = label;
    notifyListeners();
  }

  /// Loads live KPIs from Spring when a session cookie is present; keeps mocks on failure.
  Future<void> refreshFromApi() async {
    await DashboardService.refreshFromApi();
    notifyListeners();
  }
}
