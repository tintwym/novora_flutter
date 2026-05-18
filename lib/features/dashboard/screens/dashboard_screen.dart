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
import '../../recruitment/screens/job_list_screen.dart';
import '../../reports/screens/reports_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../asset_management/screens/asset_management_screen.dart';
import '../../training/training_management_screen.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../shared/layouts/responsive_layout.dart';
import '../../../shared/widgets/app_sidebar.dart';
import '../../../shared/widgets/app_topbar.dart';
import '../dashboard_controller.dart';
import '../widgets/attendance_donut_chart.dart';
import '../widgets/growth_chart.dart';
import '../widgets/leave_requests_card.dart';
import '../widgets/payroll_summary_card.dart';
import '../widgets/recent_hires_card.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.skipInitialSessionRefresh = false});

  /// When true, skips `/me` + dashboard API refresh on first frame (widget tests / offline).
  final bool skipInitialSessionRefresh;

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
        return const JobListScreen(embeddedInShell: true);
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
        return const ReportsScreen(embeddedInShell: true);
      case 'Settings':
        return const SettingsScreen(embeddedInShell: true);
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
                  sidebar: AppSidebar(
                    items: _navItems(),
                    activeLabel: _controller.activeNavLabel,
                    onSelect: (l) => _onSidebarTap(context, l),
                  ),
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
                  child: AppSidebar(
                    items: _navItems(),
                    activeLabel: _controller.activeNavLabel,
                    onSelect: (l) {
                      Navigator.pop(context);
                      _onSidebarTap(context, l);
                    },
                  ),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatGrid(
            repo.statItems.map((i) => StatCard(item: i)).toList(),
          ),
          const SizedBox(height: 20),
          _buildChartsRow(),
          const SizedBox(height: 16),
          _buildBottomRow(),
          const SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildStatGrid(List<Widget> cards) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 1000
            ? 6
            : (constraints.maxWidth > 600 ? 3 : 2);
        return GridView.count(
          crossAxisCount: crossCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.3,
          children: cards,
        );
      },
    );
  }

  Widget _buildChartsRow() {
    final repo = _controller.repository;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 12, child: GrowthChart(repository: repo)),
                const SizedBox(width: 16),
                Expanded(
                  flex: 10,
                  child: AttendanceDonutChart(repository: repo),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            GrowthChart(repository: repo),
            const SizedBox(height: 16),
            AttendanceDonutChart(repository: repo),
          ],
        );
      },
    );
  }

  Widget _buildBottomRow() {
    final repo = _controller.repository;
    final isEmployee = _currentUser()?.isEmployee ?? repo.isEmployeeView;

    if (isEmployee) {
      return LeaveRequestsCard(
        title: 'My leave requests',
        emptyMessage: 'You have not submitted any leave requests yet.',
        requests: repo.leaveRequests,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: RecentHiresCard(hires: repo.recentHires)),
              const SizedBox(width: 16),
              Expanded(child: LeaveRequestsCard(requests: repo.leaveRequests)),
              const SizedBox(width: 16),
              Expanded(child: PayrollSummaryCard(payroll: repo.payroll)),
            ],
          );
        }
        return Column(
          children: [
            RecentHiresCard(hires: repo.recentHires),
            const SizedBox(height: 16),
            LeaveRequestsCard(requests: repo.leaveRequests),
            const SizedBox(height: 16),
            PayrollSummaryCard(payroll: repo.payroll),
          ],
        );
      },
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
