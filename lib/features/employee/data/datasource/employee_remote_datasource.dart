import 'package:ledgerly/features/employee/domain/entities/employee_entity.dart';
import 'package:ledgerly/features/employee/domain/entities/operator_entity.dart';
import 'package:ledgerly/core/utils/supabase_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmployeeRemoteDatasource {
  final SupabaseClient _client;

  EmployeeRemoteDatasource(this._client);

  // ----------------------------------------------------
  // Operators (Factory / Labour Employees)
  // ----------------------------------------------------
  Future<List<OperatorEntity>> getOperators() async {
    final response = await _client
        .from('operators')
        .select()
        .order('id', ascending: true);
    return (response as List)
        .map((json) => OperatorEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<int> addOperator(OperatorEntity operator) async {
    return await supabaseSafeCall(() async {
      final payload = operator.toJson()
        ..remove('id')
        ..remove('created_at');
      final res = await _client
          .from('operators')
          .insert(payload)
          .select('id')
          .single();

      return res['id'] as int;
    });
  }

  Future<void> updateOperator(OperatorEntity operator) async {
    await supabaseSafeCall(() async {
      final payload = operator.toJson()
        ..remove('id')
        ..remove('created_at');
      await _client.from('operators').update(payload).eq('id', operator.id);
    });
  }

  Future<void> deleteOperator(int operatorId) async {
    await supabaseSafeCall(() async {
      await _client.from('operators').delete().eq('id', operatorId);
    });
  }

  // ----------------------------------------------------
  // Company Employees (For Users & Roster)
  // ----------------------------------------------------
  Future<List<EmployeeEntity>> fetchEmployees() async {
    final response = await _client.from('employees').select('*, roles(name)');
    return response.map((json) {
      final roleMap = json['roles'] as Map?;
      final roleName = roleMap?['name'] as String?;
      final normalized = Map<String, dynamic>.from(json)
        ..['role'] = roleName
        ..['userId'] = json['user_id']; // g.dart reads 'userId' (not 'user_id')
      return EmployeeEntity.fromJson(normalized);
    }).toList();
  }


  /// Creates a Supabase Auth account + employee row by calling the
  /// `create-employee-account` Edge Function (deployed on Supabase).
  ///
  /// The Edge Function runs with the Service Role key server-side, so the
  /// admin's client session is never affected.
  Future<int> createEmployeeWithAccount({
    required String email,
    required String password,
    required String name,
    required String phone,
    String? cnic,
    required DateTime joiningDate,
    required bool isActive,
    int? roleId,
  }) async {
    final response = await _client.functions.invoke(
      'create-employee-account',
      body: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
        'cnic': cnic,
        'joining_date': joiningDate.toIso8601String().split('T')[0],
        'is_active': isActive,
        'role_id': roleId,
      },
    );

    if (response.data == null) {
      throw Exception('Edge Function returned no data');
    }

    final data = response.data as Map<String, dynamic>;
    if (data.containsKey('error')) {
      throw Exception(data['error']);
    }

    return (data['employeeId'] as num).toInt();
  }


  Future<void> addEmployee(EmployeeEntity employee) async {
    await supabaseSafeCall(() async {
      final payload = {
        'name': employee.name,
        'phone': employee.phone,
        'cnic': employee.cnic,
        'joining_date': employee.joiningDate.toIso8601String().split('T')[0],
        'is_active': employee.isActive,
        'role_id': employee.roleId,
        if (employee.userId != null) 'user_id': employee.userId,
      };
      await _client.from('employees').insert(payload);
    });
  }

  Future<void> updateEmployeeRecord(EmployeeEntity employee) async {
    await supabaseSafeCall(() async {
      final payload = {
        'name': employee.name,
        'phone': employee.phone,
        'cnic': employee.cnic,
        'joining_date': employee.joiningDate.toIso8601String().split('T')[0],
        'is_active': employee.isActive,
        'role_id': employee.roleId,
        if (employee.userId != null) 'user_id': employee.userId,
      };
      await _client.from('employees').update(payload).eq('id', employee.id);
    });
  }

  Future<void> deactivateEmployee(int id) async {
    await supabaseSafeCall(() async {
      await _client.from('employees').update({'is_active': false}).eq('id', id);
    });
  }

  // ----------------------------------------------------
  // RBAC Roles & Permissions Mapping
  // ----------------------------------------------------
  Future<List<Map<String, dynamic>>> fetchRoles() async {
    final response = await _client.from('roles').select('id, name');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchPermissions() async {
    final response = await _client
        .from('permissions')
        .select('id, module, action, key');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchRolePermissions() async {
    final response = await _client
        .from('role_permissions')
        .select('role_id, permission_id');
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addRolePermission(int roleId, int permissionId) async {
    await supabaseSafeCall(() async {
      await _client.from('role_permissions').insert({
        'role_id': roleId,
        'permission_id': permissionId,
      });
    });
  }

  Future<void> removeRolePermission(int roleId, int permissionId) async {
    await supabaseSafeCall(() async {
      await _client
          .from('role_permissions')
          .delete()
          .eq('role_id', roleId)
          .eq('permission_id', permissionId);
    });
  }
}
