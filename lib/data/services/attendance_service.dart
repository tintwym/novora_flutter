import '../repositories/attendance_repository.dart';

class AttendanceService {
  AttendanceService({AttendanceRepository? repository})
      : repository = repository ?? const AttendanceRepository();

  final AttendanceRepository repository;
}
