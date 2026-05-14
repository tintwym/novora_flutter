import '../models/employee_model.dart';
import '../services/employee_service.dart';

class EmployeeRepository {
  EmployeeRepository({EmployeeService? service})
      : _service = service ?? EmployeeService();
  final EmployeeService _service;

  Future<List<EmployeeModel>> getEmployees() => _service.listEmployees();
}
