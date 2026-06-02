import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/theme/theme_colors.dart';
import '../../../core/ui/app_snackbar.dart';
import '../../../data/models/attendance_log_model.dart';
import '../../../data/services/my_attendance_service.dart';
import '../../../shared/widgets/themed_surface_card.dart';

/// Live clock + punch in/out for dashboard (admin preview or employee self-service).
class DashboardTimeTrackingCard extends StatefulWidget {
  const DashboardTimeTrackingCard({
    super.key,
    this.showLiveBadge = true,
    this.enableLiveClock = true,
    this.enableAttendanceApi = true,
  });

  final bool showLiveBadge;
  final bool enableLiveClock;
  final bool enableAttendanceApi;

  @override
  State<DashboardTimeTrackingCard> createState() => _DashboardTimeTrackingCardState();
}

class _DashboardTimeTrackingCardState extends State<DashboardTimeTrackingCard> {
  final MyAttendanceService _svc = MyAttendanceService();
  Timer? _clock;
  DateTime _now = DateTime.now();

  bool _loading = true;
  bool _busy = false;
  List<AttendanceLogModel> _logs = [];

  @override
  void initState() {
    super.initState();
    if (widget.enableLiveClock) {
      _clock = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _now = DateTime.now());
      });
    }
    if (widget.enableAttendanceApi) {
      unawaited(_primeSession());
    } else {
      _loading = false;
    }
  }

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  String get _todayIso {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  AttendanceLogModel? get _todayLog {
    for (final l in _logs) {
      if (l.workDate == _todayIso) return l;
    }
    return null;
  }

  Future<void> _primeSession() async {
    try {
      await ApiClient.ensureCsrfToken();
    } catch (_) {
      // Punch will retry; avoid blocking the widget.
    }
    if (!mounted) return;
    await _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await _svc.fetchMyLogs();
      if (!mounted) return;
      setState(() {
        _logs = list;
        _loading = false;
      });
    } on ApiException {
      if (!mounted) return;
      setState(() => _loading = false);
    } catch (_) {
      // Defensive: any non-ApiException (e.g. JSON parse error) used to leave the dashboard
      // tracking card spinning forever in a Stack widget that has no obvious "retry" affordance.
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _checkIn() async {
    setState(() => _busy = true);
    try {
      await _svc.checkIn();
      if (!mounted) return;
      await _load();
    } on ApiException catch (e) {
      if (mounted) AppSnackBar.showError(context, e.message);
    } catch (e) {
      if (mounted) AppSnackBar.showError(context, 'Check-in failed: $e');
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
      if (mounted) AppSnackBar.showError(context, e.message);
    } catch (e) {
      if (mounted) AppSnackBar.showError(context, 'Check-out failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _sessionLabel(AttendanceLogModel? today) {
    if (today?.checkInTime == null) return '0h 0m';
    final h = today?.workHours;
    if (h == null) return '0h 0m';
    if (h == h.roundToDouble()) return '${h.toStringAsFixed(0)}h ${((h % 1) * 60).round()}m';
    final hours = h.floor();
    final mins = ((h - hours) * 60).round();
    return '${hours}h ${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    final tc = context;
    final today = _todayLog;
    final canCheckIn = !_loading && today?.checkInTime == null;
    final canCheckOut = !_loading && today?.checkInTime != null && today?.checkOutTime == null;
    final status = today?.checkInTime == null
        ? 'Standby'
        : (today?.checkOutTime == null ? 'Active' : 'Complete');

    return ThemedSurfaceCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'TIME TRACKING',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: tc.secondaryText,
                ),
              ),
              const Spacer(),
              if (widget.showLiveBadge)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: GoogleFonts.dmSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF065F46),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            DateFormat('HH:mm:ss').format(_now),
            style: GoogleFonts.sora(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: tc.primaryText,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            DateFormat('EEEE, d MMMM yyyy').format(_now),
            style: GoogleFonts.dmSans(fontSize: 12, color: tc.secondaryText),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: tc.subtleFill,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                status.toUpperCase(),
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: tc.secondaryText,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _punchBox(
                  context,
                  'CLOCK IN',
                  today?.checkInTime == null
                      ? '--:--'
                      : (AttendanceLogModel.shortTime(today!.checkInTime) ?? '--:--'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _punchBox(
                  context,
                  'CLOCK OUT',
                  today?.checkOutTime == null
                      ? '--:--'
                      : (AttendanceLogModel.shortTime(today!.checkOutTime) ?? '--:--'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  'Total session time',
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const Spacer(),
                Text(
                  _sessionLabel(today),
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: (_busy || !canCheckIn) ? null : _checkIn,
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: Text(_busy ? '…' : 'Punch In'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.brandBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: (_busy || !canCheckOut) ? null : _checkOut,
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: Text(_busy ? '…' : 'Punch Out'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _punchBox(BuildContext context, String label, String value) {
    final tc = context;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tc.subtleFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: tc.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: tc.secondaryText,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: tc.primaryText,
            ),
          ),
        ],
      ),
    );
  }
}
