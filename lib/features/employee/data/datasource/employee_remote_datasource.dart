import 'package:ledgerly/features/employee/domain/entities/employee_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeRemoteDatasource {
  final SupabaseClient _client;

  EmployeeRemoteDatasource(this._client);

  Future<List<EmployeeEntity>> getEmployees() async {
    final response = await _client.from('employees').select();

    return response.map((json) => EmployeeEntity.fromJson(json)).toList();
  }

  Future<void> addEmployee(EmployeeEntity employee) async {
    final payload = employee.toJson()..remove('id');
    await _client.from('employees').insert(payload);
  }

  Future<void> updateEmployee(EmployeeEntity employee) async {
    final payload = employee.toJson()..remove('id');
    await _client.from('employees').update(payload).eq('id', employee.id);
  }

  Future<void> deleteEmployee(int employeeId) async {
    await _client.from('employees').delete().eq('id', employeeId);
  }
}
