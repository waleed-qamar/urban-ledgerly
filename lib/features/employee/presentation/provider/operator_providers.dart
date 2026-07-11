import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:ledgerly/features/employee/data/datasource/employee_remote_datasource.dart';
import 'package:ledgerly/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:ledgerly/features/employee/domain/entities/employee_entity.dart';
import 'package:ledgerly/features/employee/domain/entities/operator_entity.dart';
import 'package:ledgerly/features/employee/domain/repositories/employee_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'operator_providers.g.dart';

@riverpod
EmployeeRemoteDatasource operatorRemoteDatasource(Ref ref) {
  return EmployeeRemoteDatasource(ref.watch(supabaseClientProvider));
}

@riverpod
class OperatorSearchQuery extends _$OperatorSearchQuery {
  @override
  String build() => '';
  void setSearchQuery(String query) => state = query;
}

@riverpod
class EmployeeSearchQuery extends _$EmployeeSearchQuery {
  @override
  String build() => '';
  void setSearchQuery(String query) => state = query;
}

@riverpod
EmployeeRepository operatorRepository(Ref ref) {
  return EmployeeRepositoryImpl(ref.watch(operatorRemoteDatasourceProvider));
}

// ----------------------------------------------------
// Machine Operators (Kept Intact)
// ----------------------------------------------------
@riverpod
Future<List<OperatorEntity>> getAllOperators(Ref ref) {
  return ref.watch(operatorRepositoryProvider).getEmployees();
}

@riverpod
Future<void> addOperator(Ref ref, OperatorEntity employee) {
  return ref.watch(operatorRepositoryProvider).addEmployee(employee);
}

@riverpod
Future<void> deleteOperator(Ref ref, int id) {
  return ref.watch(operatorRepositoryProvider).deleteEmployee(id);
}

@riverpod
Future<void> updateOperator(Ref ref, OperatorEntity employee) {
  return ref.watch(operatorRepositoryProvider).updateEmployee(employee);
}

// ----------------------------------------------------
// Company Employees
// ----------------------------------------------------
@riverpod
Future<List<EmployeeEntity>> getAllEmployees(Ref ref) {
  return ref.watch(operatorRepositoryProvider).fetchCompanyEmployees();
}

// ----------------------------------------------------
// RBAC Setup
// ----------------------------------------------------
@riverpod
Future<List<Map<String, dynamic>>> getAllRoles(Ref ref) {
  return ref.watch(operatorRepositoryProvider).fetchRoles();
}

@riverpod
Future<List<Map<String, dynamic>>> getAllPermissions(Ref ref) {
  return ref.watch(operatorRepositoryProvider).fetchPermissions();
}

@riverpod
Future<List<Map<String, dynamic>>> getRolePermissions(Ref ref) {
  return ref.watch(operatorRepositoryProvider).fetchRolePermissions();
}

@riverpod
Future<List<Map<String, dynamic>>> getAllWorkGroups(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final response = await client.from('work_groups').select('id, name');
  return List<Map<String, dynamic>>.from(response);
}

@riverpod
Future<List<Map<String, dynamic>>> getAllWageRoles(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final response = await client.from('wage_roles').select('id, role_name');
  return List<Map<String, dynamic>>.from(response);
}
