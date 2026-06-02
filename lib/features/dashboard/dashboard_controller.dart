import 'package:flutter/material.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/services/dashboard_service.dart';
import '../../features/reports/models/reports_nav.dart';
import '../../features/settings/models/settings_nav_item.dart';
import '../../shared/widgets/app_sidebar.dart';

class DashboardController extends ChangeNotifier {
  DashboardController({DashboardRepository? repository})
      : _repository = repository ?? DashboardRepository();

  final DashboardRepository _repository;
  // Guard: `refreshFromApi` and `setActiveNav` are reachable from `SessionNotifier` listeners that
  // can fire mid-logout, after the screen (and this controller) have been disposed. Calling
  // `notifyListeners()` on a disposed `ChangeNotifier` fires a Flutter assertion in debug builds.
  bool _isDisposed = false;

  DashboardRepository get repository => _repository;

  bool get isDisposed => _isDisposed;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _notify() {
    if (_isDisposed) return;
    notifyListeners();
  }

  String activeNavLabel = 'Dashboard';
  String reportsSectionId = 'report_centre';
  String settingsSectionId = 'company_profile';
  final Set<String> expandedNavLabels = {};

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
  static List<NavMenuItem> navItemsFor(UserModel? user) {
    final base = user != null && user.canAccessHrAdmin ? _allNavItems : _employeeNavItems;
    return base
        .map(
          (item) => NavMenuItem(
            icon: item.icon,
            label: item.label,
            subnavSections: switch (item.label) {
              'Reports' => ReportsNav.sidebarSections,
              'Settings' => SettingsNav.sidebarSections,
              _ => null,
            },
          ),
        )
        .toList();
  }

  String? get activeSubnavId => switch (activeNavLabel) {
        'Reports' => reportsSectionId,
        'Settings' => settingsSectionId,
        _ => null,
      };

  @Deprecated('Use navItemsFor(user)')
  static List<NavMenuItem> get navItems => _allNavItems;

  void setActiveNav(String label, {bool forceNotify = false}) {
    if (!forceNotify && activeNavLabel == label) return;
    activeNavLabel = label;
    if (_hasSubnav(label)) {
      expandedNavLabels.add(label);
    }
    _notify();
  }

  void toggleNavExpanded(String label) {
    if (expandedNavLabels.contains(label)) {
      expandedNavLabels.remove(label);
    } else {
      expandedNavLabels.add(label);
    }
    _notify();
  }

  void selectSubnav(String parentLabel, String subId) {
    activeNavLabel = parentLabel;
    expandedNavLabels.add(parentLabel);
    if (parentLabel == 'Reports') {
      reportsSectionId = subId;
    } else if (parentLabel == 'Settings') {
      settingsSectionId = subId;
    }
    _notify();
  }

  static bool _hasSubnav(String label) =>
      label == 'Reports' || label == 'Settings';

  Future<void>? _inFlightRefresh;

  /// Loads live KPIs from Spring when a session cookie is present; keeps mocks on failure.
  ///
  /// Guarded against concurrent calls: if a refresh is already running (e.g. one triggered by the
  /// dashboard's own startup flow and a second by a `SessionNotifier` listener firing after `/me`
  /// returns), the second caller awaits the first instead of issuing a parallel batch of HTTP
  /// requests and racing for the cache.
  Future<void> refreshFromApi() {
    final existing = _inFlightRefresh;
    if (existing != null) return existing;
    final future = _doRefresh();
    _inFlightRefresh = future;
    return future.whenComplete(() {
      if (identical(_inFlightRefresh, future)) {
        _inFlightRefresh = null;
      }
    });
  }

  Future<void> _doRefresh() async {
    await DashboardService.refreshFromApi();
    _notify();
  }
}
