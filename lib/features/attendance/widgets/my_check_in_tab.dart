import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/error/exceptions.dart';
import '../../../data/models/attendance_log_model.dart';
import '../../../data/services/my_attendance_service.dart';

/// Self-service check-in / check-out (Zoho People–style punches) for the signed-in employee.
class MyCheckInTab extends StatefulWidget {
  const MyCheckInTab({super.key});

  @override
  State<MyCheckInTab> createState() => _MyCheckInTabState();
}

class _MyCheckInTabState extends State<MyCheckInTab> {
  final MyAttendanceService _svc = MyAttendanceService();

  bool _loading = true;
  String? _fatalMessage;
  List<AttendanceLogModel> _logs = [];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  String _todayIso() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  AttendanceLogModel? get _todayLog {
    final t = _todayIso();
    for (final l in _logs) {
      if (l.workDate == t) return l;
    }
    return null;
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _fatalMessage = null;
    });
    try {
      final list = await _svc.fetchMyLogs();
      if (!mounted) return;
      setState(() {
        _logs = list;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _fatalMessage = e.message;
      });
    }
  }

  Future<void> _checkIn() async {
    setState(() => _busy = true);
    try {
      await _svc.checkIn();
      if (!mounted) return;
      await _load();
    } on ApiException catch (e) {
      if (!mounted) return;
      _snack(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _checkOut() async {
    setState(() => _busy = true);
    try {
      await _svc.checkOut();
      if (!mounted) return;
      await _load();
    } on ApiException catch (e) {
      if (!mounted) return;
      _snack(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  static String _hoursLabel(double? h) {
    if (h == null) return '—';
    if (h == h.roundToDouble()) return '${h.toStringAsFixed(0)} h';
    return '${h.toStringAsFixed(2)} h';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_fatalMessage != null) {
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Attendance', style: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Text(
                    _fatalMessage!,
                    style: GoogleFonts.dmSans(fontSize: 14, height: 1.4, color: AppColors.textMuted),
                  ),
                  if (_fatalMessage!.toLowerCase().contains('employee not found')) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Your account must be linked to an employee record in HR to use check-in.',
                      style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.muted),
                    ),
                  ] else if (_fatalMessage!.contains('403') ||
                      _fatalMessage!.toLowerCase().contains('forbidden') ||
                      _fatalMessage!.toLowerCase().contains('csrf') ||
                      _fatalMessage!.toLowerCase().contains('session')) ...[
                    const SizedBox(height: 12),
                    Text(
                      'The dashboard may still show sample data when the API is unreachable, but check-in '
                      'always needs a live session. Start ./scripts/run-backend-local.sh, set API_BASE_URL to '
                      'match your browser host, then sign in again.',
                      style: GoogleFonts.dmSans(fontSize: 13, height: 1.4, color: AppColors.muted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }

    final today = _todayLog;
    final canCheckIn = today?.checkInTime == null;
    final canCheckOut = today?.checkInTime != null && today?.checkOutTime == null;

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Today (${_todayIso()})', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _kv(
                        'Check-in',
                        today?.checkInTime == null
                            ? '—'
                            : (AttendanceLogModel.shortTime(today!.checkInTime) ?? today.checkInTime!),
                      ),
                    ),
                    Expanded(
                      child: _kv(
                        'Check-out',
                        today?.checkOutTime == null
                            ? '—'
                            : (AttendanceLogModel.shortTime(today!.checkOutTime) ?? today.checkOutTime!),
                      ),
                    ),
                    Expanded(child: _kv('Work hours', _hoursLabel(today?.workHours))),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: ${today == null || today.status.isEmpty ? '—' : today.status}',
                  style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton(
                      onPressed: (_busy || !canCheckIn) ? null : _checkIn,
                      style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
                      child: Text(_busy ? 'Working…' : 'Check in'),
                    ),
                    FilledButton(
                      onPressed: (_busy || !canCheckOut) ? null : _checkOut,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFBCFE8),
                        foregroundColor: const Color(0xFF9D174D),
                      ),
                      child: Text(_busy ? 'Working…' : 'Check out'),
                    ),
                  ],
                ),
                if (!canCheckIn && !canCheckOut && today != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      'You have completed today’s punches.',
                      style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.muted),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Recent days', style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                if (_logs.isEmpty)
                  Text('No attendance rows yet.', style: GoogleFonts.dmSans(color: AppColors.muted))
                else
                  ..._logs.take(14).map(_logRow),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.muted)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _logRow(AttendanceLogModel l) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(l.workDate, style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              '${AttendanceLogModel.shortTime(l.checkInTime) ?? '—'} → ${AttendanceLogModel.shortTime(l.checkOutTime) ?? '—'}',
              style: GoogleFonts.dmSans(fontSize: 13),
            ),
          ),
          Text(_hoursLabel(l.workHours), style: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(8)),
            child: Text(l.status, style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
