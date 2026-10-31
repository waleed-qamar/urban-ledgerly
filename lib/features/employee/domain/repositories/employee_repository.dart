import 'package:ledgerly/features/employee/domain/entities/employee_entity.dart';
import 'package:ledgerly/features/employee/domain/entities/operator_entity.dart';

abstract class EmployeeRepository {
  // Existing machine operator methods (kept intact)
  Future<List<OperatorEntity>> getEmployees();
  Future<int> addEmployee(OperatorEntity employee);
  Future<void> updateEmployee(OperatorEntity employee);
  Future<void> deleteEmployee(int employeeId);
  Future<void> updateOperatorWageRate(int operatorId, double defaultPerDay);
  // setOperatorWage removed — rates are now columns on operators.
  // The DB trigger (sync_operator_rate_history) auto-archives to operator_wage_rates.

  // New company employees methods
  Future<List<EmployeeEntity>> fetchCompanyEmployees();
  Future<void> addCompanyEmployee(EmployeeEntity employee);
  Future<void> updateCompanyEmployee(EmployeeEntity employee);
  Future<void> deactivateCompanyEmployee(int id);
  Future<int> createEmployeeWithAccount({
    required String email,
    required String password,
    required String name,
    required String phone,
    String? cnic,
    required DateTime joiningDate,
    required bool isActive,
    int? roleId,
  });

  // New RBAC methods
  Future<List<Map<String, dynamic>>> fetchRoles();
  Future<List<Map<String, dynamic>>> fetchPermissions();
  Future<List<Map<String, dynamic>>> fetchRolePermissions();
  Future<void> addRolePermission(int roleId, int permissionId);
  Future<void> removeRolePermission(int roleId, int permissionId);
}
