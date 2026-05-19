import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/session/session_notifier.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../attendance/screens/attendance_screen.dart';
import '../../disciplinary/screens/disciplinary_management_screen.dart';
import '../../employees/screens/employee_profile_screen.dart';
import '../../employment/employment_management_screen.dart';
import '../../leave/screens/leave_list_screen.dart';
import '../../payroll/screens/payroll_list_screen.dart';
import '../../claim_management/screens/claim_management_screen.dart';
import '../../performance/screens/performance_screen.dart';
import '../../recruitment/screens/recruitment_management_screen.dart';
import '../../reports/screens/reports_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../asset_management/screens/asset_management_screen.dart';
import '../../training/training_management_screen.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/layouts/responsive_layout.dart';
import '../../../shared/widgets/app_sidebar.dart';
import '../../../shared/widgets/app_topbar.dart';
import '../dashboard_controller.dart';
import '../widgets/dashboard_admin_body.dart';
import '../widgets/dashboard_employee_body.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    this.skipInitialSessionRefresh = false,
    this.skipTimeTrackingLiveUpdates = false,
  });

  /// When true, skips `/me` + dashboard API refresh on first frame (widget tests / offline).
  final bool skipInitialSessionRefresh;

  /// Disables live clock timer and attendance API in the time-tracking card (widget tests).
  final bool skipTimeTrackingLiveUpdates;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardController _controller = DashboardController();
  final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// Pushes inside the dashboard content stack so [MainLayout] sidebar + top bar stay visible.
  void _popShellToRoot() {
    _shellNavigatorKey.currentState?.popUntil((r) => r.isFirst);
  }

  void _onSidebarTap(BuildContext context, String label) {
    switch (label) {
      case 'Dashboard':
        _popShellToRoot();
        Navigator.of(context).popUntil((route) => route.isFirst);
        _controller.setActiveNav('Dashboard');
        return;
      case 'Employees':
      case 'Recruitment':
      case 'Attendance':
      case 'Leave Management':
      case 'Disciplinary Management':
      case 'Payroll':
      case 'Claims':
      case 'Performance':
      case 'Training':
      case 'Assets':
      case 'Reports':
      case 'Settings':
        _popShellToRoot();
        Navigator.of(context).popUntil((route) => route.isFirst);
        _controller.setActiveNav(label);
        return;
      default:
        break;
    }
  }

  void _onSidebarSubnav(String parent, String subId) {
    _popShellToRoot();
    _controller.selectSubnav(parent, subId);
  }

  Widget _buildSidebar(BuildContext context, {bool popDrawer = false}) {
    void maybePop() {
      if (popDrawer) Navigator.pop(context);
    }

    return AppSidebar(
      items: _navItems(),
      activeLabel: _controller.activeNavLabel,
      expandedLabels: _controller.expandedNavLabels,
      activeSubnavId: _controller.activeSubnavId,
      onSelect: (l) {
        maybePop();
        _onSidebarTap(context, l);
      },
      onToggleExpand: _controller.toggleNavExpanded,
      onSelectSubnav: (parent, subId) {
        maybePop();
        _onSidebarSubnav(parent, subId);
      },
    );
  }

  /// Module area only — nested routes (e.g. employee profile) keep shell chrome.
  Widget _shellNavigatorHost() {
    return Navigator(
      key: _shellNavigatorKey,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == AppRoutes.employeeProfile) {
          final id = settings.arguments as String?;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => EmployeeProfileScreen(employeeId: id, embeddedInShell: true),
          );
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ListenableBuilder(
            listenable: _controller,
            builder: (context, _) => _shellBody(),
          ),
        );
      },
    );
  }

  String _shellTitle() {
    switch (_controller.activeNavLabel) {
      case 'Dashboard':
        return 'Dashboard';
      case 'Employees':
        return 'Employment';
      default:
        return _controller.activeNavLabel;
    }
  }

  String? _shellSubtitle() {
    if (_controller.activeNavLabel == 'Dashboard') {
      return _dashboardWelcomeLine();
    }
    return null;
  }

  Widget _shellBody() {
    switch (_controller.activeNavLabel) {
      case 'Dashboard':
        return _buildScrollBody();
      case 'Employees':
        return const EmploymentManagementScreen(embeddedInShell: true);
      case 'Recruitment':
        return const RecruitmentManagementScreen(embeddedInShell: true);
      case 'Attendance':
        return const AttendanceScreen(embeddedInShell: true);
      case 'Leave Management':
        return LeaveListScreen(
          key: ValueKey('leave-${_currentUser()?.primaryRole}'),
          embeddedInShell: true,
        );
      case 'Disciplinary Management':
        return const DisciplinaryManagementScreen(embeddedInShell: true);
      case 'Payroll':
        return const PayrollListScreen(embeddedInShell: true);
      case 'Claims':
        return ClaimManagementScreen(
          key: ValueKey('claims-${_currentUser()?.primaryRole}'),
          embeddedInShell: true,
          employeeView: !(_currentUser()?.canAccessHrAdmin ?? true),
        );
      case 'Performance':
        return const PerformanceScreen(embeddedInShell: true);
      case 'Training':
        return const TrainingManagementScreen(embeddedInShell: true);
      case 'Assets':
        return const AssetManagementScreen(embeddedInShell: true);
      case 'Reports':
        return ReportsScreen(
          embeddedInShell: true,
          showSecondaryNav: false,
          selectedId: _controller.reportsSectionId,
          onSelectedIdChanged: (id) => _controller.selectSubnav('Reports', id),
        );
      case 'Settings':
        return SettingsScreen(
          embeddedInShell: true,
          showSecondaryNav: false,
          selectedId: _controller.settingsSectionId,
          onSelectedIdChanged: (id) => _controller.selectSubnav('Settings', id),
        );
      default:
        return _buildScrollBody();
    }
  }

  @override
  void dispose() {
    SessionNotifier.instance.removeListener(_onSessionChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SessionNotifier.instance.addListener(_onSessionChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.skipInitialSessionRefresh) return;
      unawaited(_refreshSessionAndDashboard());
    });
  }

  void _onSessionChanged() {
    _syncNavWithRole();
    if (!mounted) return;
    unawaited(_controller.refreshFromApi());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListenableBuilder(
        listenable: Listenable.merge([_controller, SessionNotifier.instance]),
        builder: (context, _) {
          return LayoutBuilder(
            builder: (context, constraints) {
              if (ResponsiveLayout.isWide(context)) {
                return MainLayout(
                  sidebar: _buildSidebar(context),
                  topBar: AppTopBar(
                    title: _shellTitle(),
                    subtitle: _shellSubtitle(),
                    trailingDateLabel: _controller.activeNavLabel == 'Dashboard'
                        ? DateFormat.yMMMd().format(DateTime.now())
                        : null,
                  ),
                  body: _shellNavigatorHost(),
                );
              }
              return Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                drawer: Drawer(
                  child: _buildSidebar(context, popDrawer: true),
                ),
                appBar: AppBar(
                  backgroundColor: context.surfaceCard,
                  elevation: 0,
                  title: Text(
                    _shellTitle(),
                    style: GoogleFonts.sora(
                      fontWeight: FontWeight.w700,
                      color: context.primaryText,
                      fontSize: 18,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.notifications_outlined,
                        color: context.primaryText,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                body: _shellNavigatorHost(),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _refreshSessionAndDashboard() async {
    await AuthRepository().refreshProfile();
    if (!mounted) return;
    _syncNavWithRole();
    await _controller.refreshFromApi();
    if (mounted) setState(() {});
  }

  void _syncNavWithRole() {
    final labels = _navItems().map((i) => i.label).toSet();
    if (!labels.contains(_controller.activeNavLabel)) {
      _controller.setActiveNav('Dashboard', forceNotify: true);
      _popShellToRoot();
    }
  }

  UserModel? _currentUser() => SessionNotifier.instance.user;

  List<NavMenuItem> _navItems() => DashboardController.navItemsFor(_currentUser());

  String _dashboardWelcomeLine() {
    final u = _currentUser();
    if (u == null) {
      return "Here's what's happening in your organization.";
    }
    if (u.isEmployee) {
      return "Welcome back, ${u.displayName}! Here's your leave and attendance overview.";
    }
    return "Welcome back, ${u.displayName}! Here's what's happening in your organization.";
  }

  Widget _buildScrollBody() {
    final repo = _controller.repository;
    final isEmployee = _currentUser()?.isEmployee ?? repo.isEmployeeView;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isEmployee)
            DashboardEmployeeBody(
              repository: repo,
              skipTimeTrackingLiveUpdates: widget.skipTimeTrackingLiveUpdates,
            )
          else
            DashboardAdminBody(
              repository: repo,
              skipTimeTrackingLiveUpdates: widget.skipTimeTrackingLiveUpdates,
            ),
          const SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            AppStrings.copyrightFooter,
            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
          ),
        ),
        Text(
          'Version 2.1.0',
          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
        ),
      ],
    );
  }
}
