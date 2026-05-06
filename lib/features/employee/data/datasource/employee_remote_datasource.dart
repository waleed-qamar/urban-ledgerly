import 'package:ledgerly/features/employee/domain/entities/operator_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeRemoteDatasource {
  final SupabaseClient _client;

  EmployeeRemoteDatasource(this._client);

  Future<List<OperatorEntity>> getOperators() async {
    final response = await _client.from('operators').select();

    return response.map((json) => OperatorEntity.fromJson(json)).toList();
  }

  Future<void> addOperator(OperatorEntity operator) async {
    final payload = operator.toJson()..remove('id');
    await _client.from('operators').insert(payload);
  }

  Future<void> updateEmployee(OperatorEntity employee) async {
    final payload = employee.toJson()..remove('id');
    await _client.from('operators').update(payload).eq('id', employee.id);
  }

  Future<void> deleteEmployee(int employeeId) async {
    await _client.from('operators').delete().eq('id', employeeId);
  }
}
