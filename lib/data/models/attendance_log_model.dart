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
      final y = v[0] as int;
      final m = v[1] as int;
      final d = v[2] as int;
      return '$y-${m.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
    }
    return '';
  }

  static String? _parseLocalTimeToString(Object? v) {
    if (v == null) return null;
    if (v is String) return v;
    if (v is List && v.length >= 2) {
      final h = v[0] as int;
      final m = v[1] as int;
      final s = v.length > 2 ? v[2] as int : 0;
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
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
