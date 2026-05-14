import '../repositories/leave_repository.dart';

class LeaveService {
  LeaveService({LeaveRepository? repository})
      : repository = repository ?? const LeaveRepository();

  final LeaveRepository repository;
}
