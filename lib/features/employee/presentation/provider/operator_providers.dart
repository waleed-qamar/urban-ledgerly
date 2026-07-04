import 'package:ledgerly/core/providers/app_providers.dart';
import 'package:ledgerly/features/employee/data/datasource/employee_remote_datasource.dart';
import 'package:ledgerly/features/employee/data/repositories/employee_repository_impl.dart';
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
EmployeeRepository operatorRepository(Ref ref) {
  return EmployeeRepositoryImpl(ref.watch(operatorRemoteDatasourceProvider));
}

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
