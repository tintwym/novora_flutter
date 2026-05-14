import 'package:flutter/material.dart';

import '../../data/repositories/dashboard_repository.dart';
import '../../data/services/dashboard_service.dart';
import '../../shared/widgets/app_sidebar.dart';

class DashboardController extends ChangeNotifier {
  DashboardController({DashboardRepository? repository})
      : _repository = repository ?? DashboardRepository();

  final DashboardRepository _repository;

  DashboardRepository get repository => _repository;

  String activeNavLabel = 'Dashboard';

  static final List<NavMenuItem> navItems = [
    const NavMenuItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
    const NavMenuItem(icon: Icons.groups_outlined, label: 'Employees'),
    const NavMenuItem(icon: Icons.assignment_outlined, label: 'Recruitment'),
    const NavMenuItem(icon: Icons.access_time_outlined, label: 'Attendance'),
    const NavMenuItem(icon: Icons.beach_access_outlined, label: 'Leave Management'),
    const NavMenuItem(icon: Icons.payments_outlined, label: 'Payroll'),
    const NavMenuItem(icon: Icons.trending_up_rounded, label: 'Performance'),
    const NavMenuItem(icon: Icons.school_outlined, label: 'Training'),
    const NavMenuItem(icon: Icons.inventory_2_outlined, label: 'Assets'),
    const NavMenuItem(icon: Icons.description_outlined, label: 'Documents'),
    const NavMenuItem(icon: Icons.bar_chart_outlined, label: 'Reports'),
    const NavMenuItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  void setActiveNav(String label) {
    if (activeNavLabel == label) return;
    activeNavLabel = label;
    notifyListeners();
  }

  /// Loads live KPIs from Spring when a session cookie is present; keeps mocks on failure.
  Future<void> refreshFromApi() async {
    await DashboardService.refreshFromApi();
    notifyListeners();
  }
}
