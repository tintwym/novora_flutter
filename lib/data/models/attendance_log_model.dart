/// One row from `GET /api/v1/my/attendance` (Spring [AttendanceLogResponse]).
class AttendanceLogModel {
  AttendanceLogModel({
    required this.id,
    required this.employeeId,
    required this.workDate,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.workHours,
    this.notes,
  });

  final String id;
  final String employeeId;
  final String workDate;
  final String status;
  final String? checkInTime;
  final String? checkOutTime;
  final double? workHours;
  final String? notes;

  factory AttendanceLogModel.fromJson(Map<String, dynamic> j) {
    double? wh;
    final rawH = j['workHours'];
    if (rawH is num) {
      wh = rawH.toDouble();
    }

    return AttendanceLogModel(
      id: '${j['id']}',
      employeeId: '${j['employeeId']}',
      workDate: _parseLocalDate(j['workDate']),
      status: j['status'] as String? ?? '',
      checkInTime: _parseLocalTimeToString(j['checkInTime']),
      checkOutTime: _parseLocalTimeToString(j['checkOutTime']),
      workHours: wh,
      notes: j['notes'] as String?,
    );
  }

  static String _parseLocalDate(Object? v) {
    if (v is String) return v.split('T').first;
    if (v is List && v.length >= 3) {
      // Jackson normally emits these as ints, but a configuration change on the backend
      // (or a switch to LocalDate as ISO string) could emit doubles or strings — defensively
      // accept both rather than crashing the entire attendance card with a TypeError.
      final y = _toInt(v[0]);
      final m = _toInt(v[1]);
      final d = _toInt(v[2]);
      if (y == null || m == null || d == null) return '';
      return '$y-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
    }
    return '';
  }

  static String? _parseLocalTimeToString(Object? v) {
    if (v == null) return null;
    if (v is String) return v;
    if (v is List && v.length >= 2) {
      final h = _toInt(v[0]);
      final m = _toInt(v[1]);
      final s = v.length > 2 ? (_toInt(v[2]) ?? 0) : 0;
      if (h == null || m == null) return null;
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return null;
  }

  static int? _toInt(Object? raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  String get statusLabel => status;

  /// "HH:mm" for display if time is "HH:mm:ss"
  static String? shortTime(String? isoTime) {
    if (isoTime == null || isoTime.isEmpty) return null;
    final parts = isoTime.split(':');
    if (parts.length >= 2) return '${parts[0]}:${parts[1]}';
    return isoTime;
  }
}
