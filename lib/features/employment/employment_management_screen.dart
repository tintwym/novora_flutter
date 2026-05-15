import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../shared/widgets/hr_data_table_card.dart';
import '../../shared/widgets/hr_module_header.dart';
import 'widgets/organisation_chart_tab.dart';

/// Employment Management: Employee profile, Directory (wizard), Organisation chart.
class EmploymentManagementScreen extends StatefulWidget {
  const EmploymentManagementScreen({super.key, this.embeddedInShell = false});

  /// When true, shown inside [DashboardScreen] — no app bar / back (shell provides chrome).
  final bool embeddedInShell;

  @override
  State<EmploymentManagementScreen> createState() =>
      _EmploymentManagementScreenState();
}

class _EmploymentManagementScreenState extends State<EmploymentManagementScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HrModuleHeader(
          moduleSubtitle: 'EMPLOYMENT MANAGEMENT',
          primaryActionLabel: '+ Add employee',
          onPrimaryAction: () => Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.employeeWizard),
        ),
        Material(
          color: Colors.white,
          child: TabBar(
            controller: _tab,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textMuted,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Employee profile'),
              Tab(text: 'Employee directory'),
              Tab(text: 'Organisation chart'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tab,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _profileOverview(),
              _directoryList(),
              const OrganisationChartTab(),
            ],
          ),
        ),
      ],
    );

    if (widget.embeddedInShell) {
      return ColoredBox(color: AppColors.bg, child: body);
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Employment', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: body,
    );
  }

  Widget _profileOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionCard(
            title: 'Summary',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kv('Employee No.', 'EMP-0285'),
                _kv('Name', 'Sarah Lim'),
                _kv('Department', 'Engineering'),
                _kv('Position', 'Principal Engineer'),
                _kv('Employment status', 'Permanent'),
                _kv('Join date', '12 Mar 2022'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Personal',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kv('NRIC / Passport', '820101-01-5678'),
                _kv('Mobile', '+60 12 345 6789'),
                _kv('Email', 'sarah.lim@novora.com'),
                _kv('Address', 'Kuala Lumpur'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Family',
            child: const Text('Dependents & emergency contacts (mock)'),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Pay rate',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kv('Salary type', 'Monthly'),
                _kv('Basic salary', 'RM 18,500'),
                _kv('Bank', 'Maybank · ****4421'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Career',
            child: const Text('Promotions & transfers timeline (mock)'),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Education',
            child: const Text('Degrees & certifications (mock)'),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Documents',
            child: Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const Text('Offer letter.pdf'),
                  onPressed: () {},
                ),
                ActionChip(
                  avatar: const Icon(Icons.description_outlined, size: 18),
                  label: const Text('Contract.docx'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _sectionCard(
            title: 'Biometric',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kv('Face template', 'Enrolled · v3'),
                _kv('Card ID', '890021'),
                OutlinedButton(onPressed: () {}, child: const Text('Re-enroll')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _directoryList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: HrDataTableCard(
        searchHint: 'Search employee...',
        actionLabel: '+ Add employee',
        onAction: () => Navigator.of(context, rootNavigator: true).pushNamed(AppRoutes.employeeWizard),
        columns: const [
          DataColumn(label: Text('Employee No.')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Department')),
          DataColumn(label: Text('Position')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('EMP-0021')),
              const DataCell(Text('Sarah Lim Wei Ling')),
              const DataCell(Text('Engineering')),
              const DataCell(Text('Senior Developer')),
              DataCell(_statusActive()),
              DataCell(
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.employeeProfile,
                    arguments: 'EMP-0021',
                  ),
                  child: const Text('Open'),
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text('EMP-0199')),
              const DataCell(Text('Raj Kumar')),
              const DataCell(Text('Operations')),
              const DataCell(Text('Team Lead')),
              DataCell(_statusActive()),
              DataCell(
                TextButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.employeeProfile,
                    arguments: 'EMP-0199',
                  ),
                  child: const Text('Open'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.navy),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(k, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted)),
          ),
          Expanded(child: Text(v, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _statusActive() {
    return Chip(
      label: Text('Active', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w600, color: const Color(0xFF065F46))),
      backgroundColor: const Color(0xFFD1FAE5),
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
    );
  }
}
