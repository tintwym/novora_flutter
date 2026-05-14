import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

/// 5-step Employee Directory wizard (Details → … → Review) per employment mockups.
class EmployeeDirectoryWizardScreen extends StatefulWidget {
  const EmployeeDirectoryWizardScreen({super.key});

  @override
  State<EmployeeDirectoryWizardScreen> createState() =>
      _EmployeeDirectoryWizardScreenState();
}

class _EmployeeDirectoryWizardScreenState extends State<EmployeeDirectoryWizardScreen> {
  int _step = 0;

  final _empNo = TextEditingController(text: 'EMP-0285');
  final _company = TextEditingController(text: 'Novora Sdn Bhd');
  final _location = TextEditingController(text: 'Kuala Lumpur HQ');
  final _branch = TextEditingController(text: 'Main Branch');
  final _employerNote = TextEditingController();
  final _remarks = TextEditingController();

  bool _activeEmployee = true;
  bool _autoClock = false;
  bool _ignoreRota = false;
  bool _ignoreSwipe = false;

  String _employmentStatus = 'Permanent';
  String _jobType = 'Full-time';
  String _appointment = 'Confirmed';

  static const _stepTitles = [
    'Details',
    'Personal',
    'Off duty',
    'Biometric',
    'Review',
  ];

  @override
  void dispose() {
    _empNo.dispose();
    _company.dispose();
    _location.dispose();
    _branch.dispose();
    _employerNote.dispose();
    _remarks.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 4) {
      setState(() => _step++);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee submitted')),
      );
      Navigator.pop(context);
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text('Employee Directory', style: GoogleFonts.sora(fontWeight: FontWeight.w700)),
        foregroundColor: AppColors.navy,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(onPressed: () {}, child: const Text('Save as draft')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 960;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: wide ? 3 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: _stepIndicator(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: KeyedSubtree(
                            key: ValueKey<int>(_step),
                            child: [
                              _stepDetails(),
                              _stepPlaceholder('Personal particulars, IDs & contacts'),
                              _stepPlaceholder('Rest days, roster exceptions'),
                              _stepPlaceholder('Face / fingerprint enrollment'),
                              _review(),
                            ][_step],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: AppColors.border)),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Step ${_step + 1}: ${_stepTitles[_step]}',
                            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                          ),
                          const Spacer(),
                          OutlinedButton(onPressed: _back, child: const Text('Back')),
                          const SizedBox(width: 12),
                          FilledButton(
                            onPressed: _next,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_step == 4 ? 'Finish' : 'Next step'),
                                if (_step < 4) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.arrow_forward, size: 18),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (wide)
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(right: 20, top: 20, bottom: 20),
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
                          'Step ${_step + 1} of 5',
                          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (_step + 1) / 5,
                            minHeight: 8,
                            backgroundColor: AppColors.bg,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${((_step + 1) / 5 * 100).round()}% complete',
                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                        ),
                        const SizedBox(height: 16),
                        Text('Tips', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Text(
                          '• Employee No. can be auto-generated via Settings.\n'
                          '• Employment Status, Department and Position must exist in Settings.\n'
                          '• Tick Active to mark the employee as currently working.',
                          style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _stepIndicator() {
    return Row(
      children: List.generate(5, (i) {
        final active = i == _step;
        final done = i < _step;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Text(
                  _stepTitles[i],
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active ? AppColors.primary : AppColors.muted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: done || active ? AppColors.primary : AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _stepDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDec(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile photo & flags', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                      color: AppColors.bg,
                    ),
                    child: const Icon(Icons.add_a_photo_outlined, color: AppColors.muted),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        CheckboxListTile(
                          value: _activeEmployee,
                          onChanged: (v) => setState(() => _activeEmployee = v ?? true),
                          title: const Text('Active employee'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          value: _autoClock,
                          onChanged: (v) => setState(() => _autoClock = v ?? false),
                          title: const Text('Auto clock-in / clock-out'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          value: _ignoreRota,
                          onChanged: (v) => setState(() => _ignoreRota = v ?? false),
                          title: const Text('Ignore rota deduction'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          value: _ignoreSwipe,
                          onChanged: (v) => setState(() => _ignoreSwipe = v ?? false),
                          title: const Text('Ignore missing swipe'),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDec(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Organisation information', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _field(
                    width: 280,
                    label: 'Employee No.*',
                    child: Row(
                      children: [
                        Expanded(child: TextField(controller: _empNo)),
                        const SizedBox(width: 8),
                        OutlinedButton(onPressed: () {}, child: const Text('Auto generate')),
                      ],
                    ),
                  ),
                  _dropdownField(
                    'Employment status*',
                    _employmentStatus,
                    const ['Permanent', 'Contract', 'Probation'],
                    (v) => setState(() => _employmentStatus = v),
                  ),
                  _field(label: 'Company*', child: TextField(controller: _company)),
                  _field(label: 'Location*', child: TextField(controller: _location)),
                  _field(label: 'Branch', child: TextField(controller: _branch)),
                  _dropdownField(
                    'Department*',
                    '-- Select --',
                    const ['-- Select --', 'Engineering', 'HR', 'Operations'],
                    (_) {},
                  ),
                  _dropdownField(
                    'Section',
                    '-- Select --',
                    const ['-- Select --', 'Core', 'Platform'],
                    (_) {},
                  ),
                  _dropdownField(
                    'Position*',
                    '-- Select --',
                    const ['-- Select --', 'Engineer', 'Lead'],
                    (_) {},
                  ),
                  _dropdownField(
                    'Job type*',
                    _jobType,
                    const ['Full-time', 'Part-time'],
                    (v) => setState(() => _jobType = v),
                  ),
                  _dropdownField(
                    'Type of appointment',
                    _appointment,
                    const ['Confirmed', 'Probation'],
                    (v) => setState(() => _appointment = v),
                  ),
                  _dropdownField(
                    'Job grade',
                    '-- Select --',
                    const ['-- Select --', 'G6', 'G7'],
                    (_) {},
                  ),
                  _field(
                    label: 'Join date*',
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'dd/mm/yyyy',
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                  ),
                  _field(
                    label: 'Position start date',
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'dd/mm/yyyy',
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                  ),
                  _dropdownField(
                    'Reports to',
                    '-- Select --',
                    const ['-- Select --', 'CTO', 'Engineering Manager'],
                    (_) {},
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _employerNote,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Employer's note",
                  hintText: 'Internal notes visible only to HR admins...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _remarks,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Remarks',
                  hintText: 'General remarks about this employee...',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepPlaceholder(String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDec(),
      child: Text(subtitle, style: GoogleFonts.dmSans(color: AppColors.textMuted)),
    );
  }

  Widget _review() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDec(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review & submit', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('${_empNo.text} · ${_company.text}', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            'Confirm organisation details for ${AppStrings.brandName} before saving.',
            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDec() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    );
  }

  Widget _field({required String label, required Widget child, double? width}) {
    final field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        child,
      ],
    );
    if (width != null) {
      return SizedBox(width: width, child: field);
    }
    return field;
  }

  Widget _dropdownField(
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged, {
    double fieldWidth = 240,
  }) {
    final v = items.contains(value) ? value : items.first;
    return SizedBox(
      width: fieldWidth,
      child: _field(
        label: label,
        child: DropdownButtonFormField<String>(
          // TODO: migrate to DropdownMenu + initialValue when target SDK requires it
          // ignore: deprecated_member_use
          value: v,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (x) {
            if (x != null) onChanged(x);
          },
        ),
      ),
    );
  }
}
