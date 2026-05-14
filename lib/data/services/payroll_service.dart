import '../repositories/payroll_repository.dart';

/// Payroll HTTP calls (stub).
class PayrollService {
  PayrollService({PayrollRepository? repository})
      : repository = repository ?? const PayrollRepository();

  final PayrollRepository repository;
}
