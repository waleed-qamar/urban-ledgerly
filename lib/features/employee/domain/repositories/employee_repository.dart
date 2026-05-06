import 'package:ledgerly/features/employee/domain/entities/operator_entity.dart';

abstract class EmployeeRepository {
  Future<List<OperatorEntity>> getEmployees();
  Future<void> addEmployee(OperatorEntity employee);
  Future<void> updateEmployee(OperatorEntity employee);
  Future<void> deleteEmployee(int employeeId);
}
