import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

/// 5-step Employee Directory wizard (Details → Personal → Off duty → Biometric → Review).
class EmployeeDirectoryWizardScreen extends StatefulWidget {
  const EmployeeDirectoryWizardScreen({super.key});

  @override
  State<EmployeeDirectoryWizardScreen> createState() =>
      _EmployeeDirectoryWizardScreenState();
}

enum _DayTap { none, full, half }

class _BioRow {
  _BioRow() : ta = TextEditingController();

  final TextEditingController ta;
  String terminal = '-- Select terminal --';

  void dispose() {
    ta.dispose();
  }
}

class _EmployeeDirectoryWizardScreenState extends State<EmployeeDirectoryWizardScreen> {
  int _step = 0;

  // —— Step 0: Details ——
  final _empNo = TextEditingController(text: 'EMP-0285');
  final _company = TextEditingController(text: 'AperioOccasio Sdn Bhd');
  final _location = TextEditingController(text: 'Kuala Lumpur HQ');
  final _branch = TextEditingController(text: 'Main Branch');
  final _joinDate = TextEditingController();
  final _positionStart = TextEditingController();
  final _employerNote = TextEditingController();
  final _remarks = TextEditingController();

  bool _activeEmployee = true;
  bool _autoClock = false;
  bool _ignoreRota = false;
  bool _ignoreSwipe = false;

  String _employmentStatus = 'Permanent';
  String _department = '-- Select --';
  String _section = '-- Select --';
  String _position = '-- Select --';
  String _jobType = 'Full-time';
  String _appointment = 'Confirmed';
  String _jobGrade = '-- Select --';
  String _reportsTo = '-- Select --';

  // —— Step 1: Personal ——
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _nric = TextEditingController();
  final _dob = TextEditingController();
  String _gender = '-- Select --';
  String _marital = 'Single';
  String _nationality = 'Malaysian';
  String _race = '-- Select --';
  String _religion = '-- Select --';
  final _personalEmail = TextEditingController();
  final _mobile = TextEditingController();
  final _workEmail = TextEditingController();

  bool _passportEnabled = false;
  final _passportNo = TextEditingController();
  final _passportCountryCtrl = TextEditingController(text: 'Malaysia');
  final _passportIssue = TextEditingController();
  final _passportExpiry = TextEditingController();

  final _addr1 = TextEditingController();
  final _addr2 = TextEditingController();
  String _city = '-- Select --';
  String _state = '-- Select --';
  final _postcode = TextEditingController(text: '40170');
  String _addrCountry = 'Malaysia';
  bool _samePermanent = true;

  // —— Step 2: Off duty (Sun=0 … Sat=6); default matches review mock ——
  final List<_DayTap> _dayOff = [
    _DayTap.none,
    _DayTap.full,
    _DayTap.none,
    _DayTap.none,
    _DayTap.none,
    _DayTap.half,
    _DayTap.full,
  ];

  // —— Step 3: Biometric ——
  bool _biometricEnabled = true;
  final List<_BioRow> _bioRows = [_BioRow()];

  static const _stepTitles = [
    'Details',
    'Personal',
    'Off duty',
    'Biometric',
    'Review',
  ];

  static const _footerSubtitles = [
    'Organisation & employment details',
    'Personal & address information',
    'Off duty day configuration',
    'Biometric device registration',
    'Review before saving',
  ];

  @override
  void initState() {
    super.initState();
    if (_bioRows.isNotEmpty) {
      _bioRows.first.ta.text = 'TA-00451';
      _bioRows.first.terminal = 'Main Lobby — Terminal 1';
    }
  }

  @override
  void dispose() {
    _empNo.dispose();
    _company.dispose();
    _location.dispose();
    _branch.dispose();
    _joinDate.dispose();
    _positionStart.dispose();
    _employerNote.dispose();
    _remarks.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _nric.dispose();
    _dob.dispose();
    _personalEmail.dispose();
    _mobile.dispose();
    _workEmail.dispose();
    _passportNo.dispose();
    _passportCountryCtrl.dispose();
    _passportIssue.dispose();
    _passportExpiry.dispose();
    _addr1.dispose();
    _addr2.dispose();
    _postcode.dispose();
    for (final r in _bioRows) {
      r.dispose();
    }
    super.dispose();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _next() {
    if (_step < 4) {
      setState(() => _step++);
    } else {
      _toast('Employee saved (mock)');
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

  void _tapOffDutyDay(int index, _DayTap rowMode) {
    setState(() {
      if (rowMode == _DayTap.full) {
        if (_dayOff[index] == _DayTap.full) {
          _dayOff[index] = _DayTap.none;
        } else {
          _dayOff[index] = _DayTap.full;
        }
      } else {
        if (_dayOff[index] == _DayTap.half) {
          _dayOff[index] = _DayTap.none;
        } else {
          _dayOff[index] = _DayTap.half;
        }
      }
    });
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
        surfaceTintColor: Colors.transparent,
        actions: [
          TextButton(onPressed: () => _toast('Draft saved (mock)'), child: const Text('Save as draft')),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 960;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: wide ? 3 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.surface,
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      child: _stepIndicator(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          child: KeyedSubtree(
                            key: ValueKey<int>(_step),
                            child: [
                              _stepDetails(),
                              _stepPersonal(),
                              _stepOffDuty(),
                              _stepBiometric(),
                              _stepReview(),
                            ][_step],
                          ),
                        ),
                      ),
                    ),
                    _footerBar(),
                  ],
                ),
              ),
              if (wide) _sidePanel(),
            ],
          );
        },
      ),
    );
  }

  Widget _sidePanel() {
    return Container(
      width: 300,
      margin: const EdgeInsets.fromLTRB(0, 0, 20, 20),
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Step ${_step + 1} of 5', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
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
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tips', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Text(
                      _tipsForStep(_step),
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _tipsForStep(int s) {
    switch (s) {
      case 0:
        return '• Employee No. can be auto-generated via Settings.\n'
            '• Employment Status, Department and Position must be set up in Settings first.\n'
            "• Tick 'Active' to mark the employee as currently working.";
      case 1:
        return '• Nationality and Religion dropdowns are configured in Settings.\n'
            '• Passport section is optional—enable it with the checkbox.\n'
            '• Tick "same address" if current and permanent addresses match.';
      case 2:
        return '• Select days the employee does not work.\n'
            '• Full day off means no attendance required.\n'
            '• Half day applies to mornings or afternoons based on shift.';
      case 3:
        return '• The TA Number must match the number on the physical biometric device.\n'
            '• Multiple terminals can be added with the + button.\n'
            '• Enable auto clock-in to skip manual swipes.';
      default:
        return '• Check all sections before saving.\n'
            '• You can go back to any step to make changes.\n'
            '• Once saved the employee record goes live immediately.';
    }
  }

  Widget _footerBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, c) {
          final narrow = c.maxWidth < 520;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (narrow)
                Text(
                  'Step ${_step + 1}: ${_footerSubtitles[_step]}',
                  style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                  textAlign: TextAlign.center,
                )
              else
                Text(
                  'Step ${_step + 1}: ${_footerSubtitles[_step]}',
                  style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                ),
              SizedBox(height: narrow ? 12 : 0),
              Row(
                mainAxisAlignment: narrow ? MainAxisAlignment.center : MainAxisAlignment.end,
                children: [
                  if (!narrow) const Spacer(),
                  if (_step > 0) OutlinedButton(onPressed: _back, child: const Text('Back')),
                  if (_step > 0) const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_step == 4 ? 'Save employee' : 'Next step'),
                        if (_step < 4) ...[
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ],
                    ),
                  ),
                ],
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
        final isLast = i == 4;
        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (i > 0)
                          Expanded(
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.only(right: 4),
                              color: i <= _step ? AppColors.primary : AppColors.border,
                            ),
                          ),
                        _stepDot(done: done, active: active, index: i + 1),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.only(left: 4),
                              color: i < _step ? AppColors.primary : AppColors.border,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _stepTitles[i],
                      style: GoogleFonts.dmSans(
                        fontSize: 11,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        color: active
                            ? AppColors.primary
                            : done
                                ? AppColors.success
                                : AppColors.muted,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _stepDot({required bool done, required bool active, required int index}) {
    if (done) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: Theme.of(context).colorScheme.surface, size: 16),
      );
    }
    if (active) {
      return Container(
        width: 28,
        height: 28,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 2),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Text(
          '$index',
          style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 12),
        ),
      );
    }
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.bg,
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        '$index',
        style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, color: AppColors.muted, fontSize: 12),
      ),
    );
  }

  // ——————————————————————————————————————————————————————————
  // Step 0: Details
  // ——————————————————————————————————————————————————————————

  Widget _stepDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _whiteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile photo & options', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _toast('Photo upload (mock)'),
                    borderRadius: BorderRadius.circular(48),
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                        color: AppColors.bg,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: AppColors.primary),
                          Text('Upload', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _wizCheck(_activeEmployee, 'Active employee', (v) => setState(() => _activeEmployee = v)),
                        _wizCheck(_autoClock, 'Auto clock-in / clock-out', (v) => setState(() => _autoClock = v)),
                        _wizCheck(_ignoreRota, 'Ignore rota deduction', (v) => setState(() => _ignoreRota = v)),
                        _wizCheck(_ignoreSwipe, 'Ignore missing swipe', (v) => setState(() => _ignoreSwipe = v)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _whiteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Organisation information', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(width: 8),
                  Text(
                    '(required)',
                    style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.danger),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Employment', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.navyMid)),
              const SizedBox(height: 10),
              LayoutBuilder(
                builder: (context, c) {
                  final w = (c.maxWidth - 16) / 2;
                  final colW = c.maxWidth >= 640 ? w.clamp(220.0, 400.0) : c.maxWidth;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 14,
                    children: [
                      SizedBox(
                        width: colW,
                        child: _labeled(
                          'Employee No.*',
                          Row(
                            children: [
                              Expanded(child: _outlineField(controller: _empNo)),
                              const SizedBox(width: 8),
                              OutlinedButton(onPressed: () => _toast('Auto-generated (mock)'), child: const Text('Auto generate')),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Employment status*',
                          _employmentStatus,
                          const ['Permanent', 'Contract', 'Probation'],
                          (v) => setState(() => _employmentStatus = v),
                        ),
                      ),
                      SizedBox(width: colW, child: _labeled('Company*', _outlineField(controller: _company))),
                      SizedBox(width: colW, child: _labeled('Location*', _outlineField(controller: _location))),
                      SizedBox(width: colW, child: _labeled('Branch', _outlineField(controller: _branch))),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Department*',
                          _department,
                          const ['-- Select --', 'Engineering', 'HR', 'Operations'],
                          (v) => setState(() => _department = v),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Section',
                          _section,
                          const ['-- Select --', 'Core', 'Platform'],
                          (v) => setState(() => _section = v),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Position*',
                          _position,
                          const ['-- Select --', 'Senior Developer', 'Engineer', 'Lead'],
                          (v) => setState(() => _position = v),
                        ),
                      ),
                      const SizedBox(width: double.infinity, height: 0),
                      Text('Classification', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.navyMid)),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Job type*',
                          _jobType,
                          const ['Full-time', 'Part-time'],
                          (v) => setState(() => _jobType = v),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Type of appointment',
                          _appointment,
                          const ['Confirmed', 'Probation'],
                          (v) => setState(() => _appointment = v),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Job grade',
                          _jobGrade,
                          const ['-- Select --', 'G-6', 'G-7 / Sub B'],
                          (v) => setState(() => _jobGrade = v),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _labeled(
                          'Join date*',
                          _outlineField(
                            controller: _joinDate,
                            hint: 'dd/mm/yyyy',
                            suffix: Icons.calendar_today_outlined,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _labeled(
                          'Position start date',
                          _outlineField(
                            controller: _positionStart,
                            hint: 'dd/mm/yyyy',
                            suffix: Icons.calendar_today_outlined,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Reports to',
                          _reportsTo,
                          const ['-- Select --', 'David Ng', 'Engineering Manager'],
                          (v) => setState(() => _reportsTo = v),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Text('Notes', style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: AppColors.navyMid)),
              const SizedBox(height: 8),
              _outlineField(
                controller: _employerNote,
                maxLines: 3,
                hint: 'Internal notes visible only to HR admins...',
                label: "Employer's note",
              ),
              const SizedBox(height: 12),
              _outlineField(
                controller: _remarks,
                maxLines: 3,
                hint: 'General remarks about this employee...',
                label: 'Remarks',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _wizCheck(bool value, String label, ValueChanged<bool> onChanged) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(label, style: GoogleFonts.dmSans(fontSize: 14)),
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  // ——————————————————————————————————————————————————————————
  // Step 1: Personal
  // ——————————————————————————————————————————————————————————

  Widget _stepPersonal() {
    final passportFields = IgnorePointer(
      ignoring: !_passportEnabled,
      child: Opacity(
        opacity: _passportEnabled ? 1 : 0.45,
        child: LayoutBuilder(
          builder: (context, c) {
            final w = (c.maxWidth - 16) / 2;
            final colW = c.maxWidth >= 640 ? w.clamp(200.0, 420.0) : c.maxWidth;
            return Wrap(
              spacing: 16,
              runSpacing: 14,
              children: [
                SizedBox(width: colW, child: _labeled('Passport no.', _outlineField(controller: _passportNo))),
                SizedBox(width: colW, child: _labeled('Country of issue', _outlineField(controller: _passportCountryCtrl))),
                SizedBox(
                  width: colW,
                  child: _labeled(
                    'Issue date',
                    _outlineField(controller: _passportIssue, hint: 'dd/mm/yyyy', suffix: Icons.calendar_today_outlined),
                  ),
                ),
                SizedBox(
                  width: colW,
                  child: _labeled(
                    'Expiry date',
                    _outlineField(controller: _passportExpiry, hint: 'dd/mm/yyyy', suffix: Icons.calendar_today_outlined),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _whiteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Personal information', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(width: 8),
                  Text(
                    '(required)',
                    style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.danger),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Identity', style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, c) {
                  final w = (c.maxWidth - 16) / 2;
                  final colW = c.maxWidth >= 640 ? w.clamp(200.0, 420.0) : c.maxWidth;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 14,
                    children: [
                      SizedBox(width: colW, child: _labeled('First name*', _outlineField(controller: _firstName, hint: 'e.g. Sarah'))),
                      SizedBox(width: colW, child: _labeled('Last name*', _outlineField(controller: _lastName, hint: 'e.g. Lim Wei Ling'))),
                      SizedBox(width: colW, child: _labeled('NRIC / National ID*', _outlineField(controller: _nric, hint: 'e.g. 910314-10-5678'))),
                      SizedBox(
                        width: colW,
                        child: _labeled(
                          'Date of birth*',
                          _outlineField(controller: _dob, hint: 'dd/mm/yyyy', suffix: Icons.calendar_today_outlined),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Gender*',
                          _gender,
                          const ['-- Select --', 'Female', 'Male'],
                          (v) => setState(() => _gender = v),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Marital status',
                          _marital,
                          const ['Single', 'Married', 'Divorced'],
                          (v) => setState(() => _marital = v),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Nationality*',
                          _nationality,
                          const ['Malaysian', 'Singaporean', 'Other'],
                          (v) => setState(() => _nationality = v),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Race',
                          _race,
                          const ['-- Select --', 'Chinese', 'Malay', 'Indian', 'Other'],
                          (v) => setState(() => _race = v),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Religion',
                          _religion,
                          const ['-- Select --', 'Buddhism', 'Islam', 'Christianity', 'Other'],
                          (v) => setState(() => _religion = v),
                        ),
                      ),
                      SizedBox(width: colW, child: _labeled('Personal email', _outlineField(controller: _personalEmail, hint: 'name@email.com'))),
                      SizedBox(width: colW, child: _labeled('Mobile no.', _outlineField(controller: _mobile, hint: '+60 12-345 6789'))),
                      SizedBox(width: colW, child: _labeled('Work email', _outlineField(controller: _workEmail, hint: 'name@aperiooccasio.com'))),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _whiteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Passport details', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 15)),
                  const Spacer(),
                  Row(
                    children: [
                      Checkbox(
                        value: _passportEnabled,
                        onChanged: (v) => setState(() => _passportEnabled = v ?? false),
                      ),
                      Text('Enable', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              passportFields,
            ],
          ),
        ),
        const SizedBox(height: 16),
        _whiteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current address', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 12),
              _labeled('Address line 1', _outlineField(controller: _addr1)),
              const SizedBox(height: 12),
              _labeled('Address line 2 (optional)', _outlineField(controller: _addr2)),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, c) {
                  final w = (c.maxWidth - 16) / 2;
                  final colW = c.maxWidth >= 560 ? w.clamp(180.0, 400.0) : c.maxWidth;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 14,
                    children: [
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'City*',
                          _city,
                          const ['-- Select --', 'Shah Alam', 'Kuala Lumpur'],
                          (v) => setState(() => _city = v),
                        ),
                      ),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'State',
                          _state,
                          const ['-- Select --', 'Selangor', 'KL'],
                          (v) => setState(() => _state = v),
                        ),
                      ),
                      SizedBox(width: colW, child: _labeled('Postcode', _outlineField(controller: _postcode, hint: '40170'))),
                      SizedBox(
                        width: colW,
                        child: _dropdownLabeled(
                          'Country*',
                          _addrCountry,
                          const ['Malaysia', 'Singapore'],
                          (v) => setState(() => _addrCountry = v),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                value: _samePermanent,
                onChanged: (v) => setState(() => _samePermanent = v ?? true),
                title: Text('Permanent address is the same as current address', style: GoogleFonts.dmSans(fontSize: 13)),
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ——————————————————————————————————————————————————————————
  // Step 2: Off duty
  // ——————————————————————————————————————————————————————————

  static const _dayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  Widget _stepOffDuty() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Off duty days', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 8),
          Text(
            'Select the days this employee is off. Click once for full day off, twice for half day, third click to clear.',
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted, height: 1.45),
          ),
          const SizedBox(height: 20),
          _dayRowLabel('Full day off', const Color(0xFFDBEAFE), AppColors.primary),
          const SizedBox(height: 8),
          _dayButtonRow(_DayTap.full),
          const SizedBox(height: 20),
          _dayRowLabel('Half day off', const Color(0xFFFFEDD5), AppColors.warning),
          const SizedBox(height: 8),
          _dayButtonRow(_DayTap.half),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _legendBox(const Color(0xFF93C5FD), 'Full day off'),
              _legendBox(const Color(0xFFFDBA74), 'Half day off'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dayRowLabel(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700, color: fg)),
    );
  }

  Widget _legendBox(Color c, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _dayButtonRow(_DayTap modeRow) {
    return Row(
      children: List.generate(7, (i) {
        final st = _dayOff[i];
        final on = modeRow == _DayTap.full ? st == _DayTap.full : st == _DayTap.half;
        Color bg;
        Color border;
        if (modeRow == _DayTap.full) {
          bg = on ? const Color(0xFFDBEAFE) : AppColors.bg;
          border = on ? AppColors.primary : AppColors.border;
        } else {
          bg = on ? const Color(0xFFFFEDD5) : AppColors.bg;
          border = on ? AppColors.warning : AppColors.border;
        }
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 6 ? 8 : 0),
            child: Material(
              color: bg,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => _tapOffDutyDay(i, modeRow),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: border, width: on ? 2 : 1),
                  ),
                  alignment: Alignment.center,
                  child: Text(_dayLabels[i], style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ——————————————————————————————————————————————————————————
  // Step 3: Biometric
  // ——————————————————————————————————————————————————————————

  static const _terminals = [
    '-- Select terminal --',
    'Main Lobby — Terminal 1',
    'Level 3 — Terminal 2',
  ];

  Widget _stepBiometric() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Biometric registration', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 15)),
              const Spacer(),
              Row(
                children: [
                  Checkbox(
                    value: _biometricEnabled,
                    onChanged: (v) => setState(() => _biometricEnabled = v ?? true),
                  ),
                  Text('Enable biometric', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Register the employee on one or more biometric terminals. The TA Number must match the number enrolled on the physical device.',
            style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted, height: 1.45),
          ),
          const SizedBox(height: 16),
          ...List.generate(_bioRows.length, (i) {
            final row = _bioRows[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: LayoutBuilder(
                builder: (context, c) {
                  final narrow = c.maxWidth < 600;
                  if (narrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _labeled('TA Number *', _outlineField(controller: row.ta, hint: 'e.g. TA-00451')),
                        const SizedBox(height: 10),
                        _labeled(
                          'Terminal *',
                          DropdownButtonFormField<String>(
                            key: ValueKey('bio-term-$i-${row.terminal}'),
                            initialValue: _terminals.contains(row.terminal) ? row.terminal : _terminals.first,
                            decoration: _inputDec(),
                            items: _terminals.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: _biometricEnabled
                                ? (v) {
                                    if (v != null) setState(() => row.terminal = v);
                                  }
                                : null,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: _bioRows.length > 1 && _biometricEnabled
                                ? () => setState(() {
                                      final removed = _bioRows.removeAt(i);
                                      removed.dispose();
                                    })
                                : null,
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _labeled(
                          'TA Number *',
                          _outlineField(controller: row.ta, hint: 'e.g. TA-00451'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: _labeled(
                          'Terminal *',
                          DropdownButtonFormField<String>(
                            key: ValueKey('bio-term-row-$i-${row.terminal}'),
                            initialValue: _terminals.contains(row.terminal) ? row.terminal : _terminals.first,
                            decoration: _inputDec(),
                            items: _terminals.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: _biometricEnabled
                                ? (v) {
                                    if (v != null) setState(() => row.terminal = v);
                                  }
                                : null,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _bioRows.length > 1 && _biometricEnabled
                            ? () => setState(() {
                                  final removed = _bioRows.removeAt(i);
                                  removed.dispose();
                                })
                            : null,
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  );
                },
              ),
            );
          }),
          TextButton.icon(
            onPressed: _biometricEnabled
                ? () => setState(() => _bioRows.add(_BioRow()))
                : null,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add another terminal'),
          ),
        ],
      ),
    );
  }

  // ——————————————————————————————————————————————————————————
  // Step 4: Review
  // ——————————————————————————————————————————————————————————

  String _offDutySummary() {
    final full = <String>[];
    final half = <String>[];
    for (var i = 0; i < 7; i++) {
      if (_dayOff[i] == _DayTap.full) full.add(_dayLabels[i]);
      if (_dayOff[i] == _DayTap.half) half.add(_dayLabels[i]);
    }
    final parts = <String>[];
    if (full.isNotEmpty) parts.add('${full.join(', ')} (full day)');
    if (half.isNotEmpty) parts.add('${half.join(', ')} (half day)');
    return parts.isEmpty ? '—' : parts.join(' · ');
  }

  int _terminalCount() {
    var n = 0;
    for (final r in _bioRows) {
      if (r.ta.text.trim().isNotEmpty && r.terminal != '-- Select terminal --') n++;
    }
    return n;
  }

  Widget _stepReview() {
    final dept = _department == '-- Select --' ? 'Engineering' : _department;
    final pos = _position == '-- Select --' ? 'Senior Developer' : _position;
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review & confirm', style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF93C5FD), AppColors.brandBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'NE',
                  style: GoogleFonts.dmSans(fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New Employee',
                      style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_empNo.text} · $dept · $pos',
                      style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, c) {
              final twoCol = c.maxWidth >= 720;
              final details = _reviewBlock(
                'Details',
                [
                  ('Company', _company.text.isEmpty ? '—' : _company.text),
                  ('Department', dept),
                  ('Job type', '$_jobType · $_employmentStatus'),
                  ('Join date', _joinDate.text.isEmpty ? '—' : _joinDate.text),
                  ('Grade', _jobGrade == '-- Select --' ? '—' : _jobGrade),
                ],
              );
              final personal = _reviewBlock(
                'Personal',
                [
                  ('Nationality', _nationality),
                  ('Date of birth', _dob.text.isEmpty ? '—' : _dob.text),
                  ('NRIC', _nric.text.isEmpty ? '—' : _nric.text),
                  ('Mobile', _mobile.text.isEmpty ? '—' : _mobile.text),
                  ('Address', _addr1.text.isEmpty ? '—' : _addr1.text),
                ],
              );
              final off = _reviewBlock('Off duty', [('Schedule', _offDutySummary())]);
              final bio = _reviewBlock(
                'Biometric',
                [
                  ('Terminals', '${_terminalCount()} registered'),
                  ('Auto clock-in', _autoClock ? 'On' : 'Off'),
                ],
              );
              if (twoCol) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: details),
                        const SizedBox(width: 16),
                        Expanded(child: personal),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: off),
                        const SizedBox(width: 16),
                        Expanded(child: bio),
                      ],
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [details, const SizedBox(height: 16), personal, const SizedBox(height: 16), off, const SizedBox(height: 16), bio],
              );
            },
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.brandBlueSoft.withValues(alpha: 0.5)),
            ),
            child: Text(
              'Please review all information above. Once saved, the employee record will be active and accessible in the directory.',
              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.navyMid, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewBlock(String title, List<(String, String)> rows) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 10),
          ...rows.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 110,
                    child: Text(e.$1, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
                  ),
                  Expanded(child: Text(e.$2, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ——————————————————————————————————————————————————————————
  // Shared UI
  // ——————————————————————————————————————————————————————————

  Widget _whiteCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }

  InputDecoration _inputDec() {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Widget _labeled(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navyMid)),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _outlineField({
    TextEditingController? controller,
    String? hint,
    String? label,
    int maxLines = 1,
    IconData? suffix,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      decoration: _inputDec().copyWith(
        hintText: hint,
        labelText: label,
        suffixIcon: suffix == null ? null : Icon(suffix, size: 18, color: AppColors.muted),
      ),
    );
  }

  Widget _dropdownLabeled(String label, String value, List<String> items, ValueChanged<String> onChanged) {
    final v = items.contains(value) ? value : items.first;
    return _labeled(
      label,
      DropdownButtonFormField<String>(
        key: ValueKey('$label-$v'),
        initialValue: v,
        decoration: _inputDec(),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
        onChanged: (x) {
          if (x != null) onChanged(x);
        },
      ),
    );
  }
}
