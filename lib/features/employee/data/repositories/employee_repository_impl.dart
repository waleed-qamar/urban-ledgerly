import 'package:ledgerly/features/employee/data/datasource/employee_remote_datasource.dart';
import 'package:ledgerly/features/employee/domain/entities/employee_entity.dart';
import 'package:ledgerly/features/employee/domain/entities/operator_entity.dart';
import 'package:ledgerly/features/employee/domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDatasource _dataSource;

  EmployeeRepositoryImpl(this._dataSource);

  // ----------------------------------------------------
  // Machine Operators (Kept Intact)
  // ----------------------------------------------------
  @override
  Future<int> addEmployee(OperatorEntity employee) =>
      _dataSource.addOperator(employee);

  // setOperatorWage removed — rate fields are columns on operators.
  // DB trigger sync_operator_rate_history archives history automatically.

  @override
  Future<void> deleteEmployee(int employeeId) =>
      _dataSource.deleteOperator(employeeId);

  @override
  Future<void> updateOperatorWageRate(int operatorId, double defaultPerDay) =>
      _dataSource.updateOperatorWageRate(operatorId, defaultPerDay);

  @override
  Future<List<OperatorEntity>> getEmployees() => _dataSource.getOperators();

  @override
  Future<void> updateEmployee(OperatorEntity employee) =>
      _dataSource.updateOperator(employee);

  // ----------------------------------------------------
  // Company Employees
  // ----------------------------------------------------
  @override
  Future<List<EmployeeEntity>> fetchCompanyEmployees() =>
      _dataSource.fetchEmployees();

  @override
  Future<void> addCompanyEmployee(EmployeeEntity employee) =>
      _dataSource.addEmployee(employee);

  @override
  Future<void> updateCompanyEmployee(EmployeeEntity employee) =>
      _dataSource.updateEmployeeRecord(employee);

  @override
  Future<void> deactivateCompanyEmployee(int id) =>
      _dataSource.deactivateEmployee(id);

  @override
  Future<int> createEmployeeWithAccount({
    required String email,
    required String password,
    required String name,
    required String phone,
    String? cnic,
    required DateTime joiningDate,
    required bool isActive,
    int? roleId,
  }) =>
      _dataSource.createEmployeeWithAccount(
        email: email,
        password: password,
        name: name,
        phone: phone,
        cnic: cnic,
        joiningDate: joiningDate,
        isActive: isActive,
        roleId: roleId,
      );

  // ----------------------------------------------------
  // RBAC Roles & Permissions
  // ----------------------------------------------------
  @override
  Future<List<Map<String, dynamic>>> fetchRoles() => _dataSource.fetchRoles();

  @override
  Future<List<Map<String, dynamic>>> fetchPermissions() =>
      _dataSource.fetchPermissions();

  @override
  Future<List<Map<String, dynamic>>> fetchRolePermissions() =>
      _dataSource.fetchRolePermissions();

  @override
  Future<void> addRolePermission(int roleId, int permissionId) =>
      _dataSource.addRolePermission(roleId, permissionId);

  @override
  Future<void> removeRolePermission(int roleId, int permissionId) =>
      _dataSource.removeRolePermission(roleId, permissionId);
}
