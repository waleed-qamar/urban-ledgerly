import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:ledgerly/features/employee/data/datasource/employee_remote_datasource.dart';
import 'package:ledgerly/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:ledgerly/features/employee/domain/entities/employee_entity.dart';
import 'package:ledgerly/features/employee/domain/repositories/employee_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employee_providers.g.dart';

@riverpod
EmployeeRemoteDatasource employeeRemoteDatasource(Ref ref) {
  return EmployeeRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
EmployeeRepository employeeRepository(Ref ref) {
  return EmployeeRepositoryImpl(ref.watch(employeeRemoteDatasourceProvider));
}

@riverpod
Future<List<EmployeeEntity>> getAllEmployees(Ref ref) {
  return ref.watch(employeeRepositoryProvider).getEmployees();
}

@riverpod
Future<void> addEmployee(Ref ref, EmployeeEntity employee) {
  return ref.watch(employeeRepositoryProvider).addEmployee(employee);
}

@riverpod
Future<void> deleteEmployee(Ref ref, int id) {
  return ref.watch(employeeRepositoryProvider).deleteEmployee(id);
}

@riverpod
Future<void> updateEmployee(Ref ref, EmployeeEntity employee) {
  return ref.watch(employeeRepositoryProvider).updateEmployee(employee);
}
