import 'package:ledgerly/features/employee/data/datasource/employee_remote_datasource.dart';

import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDatasource _dataSource;

  EmployeeRepositoryImpl(this._dataSource);
  @override
  Future<void> addEmployee(EmployeeEntity employee) =>
      _dataSource.addEmployee(employee);

  @override
  Future<void> deleteEmployee(int employeeId) =>
      _dataSource.deleteEmployee(employeeId);

  @override
  Future<List<EmployeeEntity>> getEmployees() => _dataSource.getEmployees();

  @override
  Future<void> updateEmployee(EmployeeEntity employee) =>
      _dataSource.updateEmployee(employee);
}
