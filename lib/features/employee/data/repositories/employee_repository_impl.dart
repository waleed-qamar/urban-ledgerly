import 'package:ledgerly/features/employee/data/datasource/employee_remote_datasource.dart';
import 'package:ledgerly/features/employee/domain/entities/operator_entity.dart';

import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDatasource _dataSource;

  EmployeeRepositoryImpl(this._dataSource);
  @override
  Future<void> addEmployee(OperatorEntity employee) =>
      _dataSource.addOperator(employee);

  @override
  Future<void> deleteEmployee(int employeeId) =>
      _dataSource.deleteEmployee(employeeId);

  @override
  Future<List<OperatorEntity>> getEmployees() => _dataSource.getOperators();

  @override
  Future<void> updateEmployee(OperatorEntity employee) =>
      _dataSource.updateEmployee(employee);
}
