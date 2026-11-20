import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ledgerly/features/employee/domain/entities/employee_entity.dart';
import 'package:ledgerly/core/providers/app_providers.dart';
import 'auth_providers.dart';

part 'current_employee_provider.g.dart';

@Riverpod(keepAlive: true)
Future<EmployeeEntity?> currentEmployee(Ref ref) async {
  final authStateAsync = ref.watch(authStateStreamProvider);
  final session = authStateAsync.maybeWhen(
    data: (state) => state.session,
    orElse: () => Supabase.instance.client.auth.currentSession,
  );

  if (session?.user == null) {
    print('DEBUG: No active Supabase user session found.');
    return null;
  }

  try {
    final uid = session!.user.id;
    print('DEBUG: Fetching employee profile via RPC for user_id: $uid');

    // Use a SECURITY DEFINER function to bypass RLS on the employees table.
    // This is safe: the function only returns the row where user_id = auth.uid().
    final List<dynamic> result = await Supabase.instance.client
        .rpc('get_my_employee_profile');

    if (result.isEmpty) {
      print('DEBUG: No employee row found via RPC for user_id: $uid');
      return null;
    }

    final response = result.first as Map<String, dynamic>;
    print('DEBUG: Employee DB raw row via RPC: $response');

    final normalizedResponse = <String, dynamic>{
      'id': response['id'],
      'name': response['name'],
      'phone': response['phone'],
      'cnic': response['cnic'],
      'email': response['email'],
      'joining_date': response['joining_date'],
      'is_active': response['is_active'],
      'role': response['role'] ?? await _fetchRoleName(response['role_id']),
      'role_id': response['role_id'],
      'userId': response['user_id'],   // g.dart still reads 'userId' for this field
      'created_at': response['created_at'],
    };

    final employee = EmployeeEntity.fromJson(normalizedResponse);
    print('DEBUG: Resolved employee entity role="${employee.role}" roleId=${employee.roleId}');
    return employee;
  } catch (e, stack) {
    print('DEBUG EXCEPTION in currentEmployee: $e');
    print(stack);
    return null;
  }
}

Future<String?> _fetchRoleName(int? roleId) async {
  if (roleId == null) return null;
  try {
    final response = await Supabase.instance.client
        .from('roles')
        .select('name')
        .eq('id', roleId)
        .maybeSingle();
    return response?['name'] as String?;
  } catch (e) {
    print('DEBUG: _fetchRoleName error: $e');
    return null;
  }
}

@riverpod
bool isAli(Ref ref) {
  final employee = ref.watch(currentEmployeeProvider).value;
  final role = employee?.role?.trim().toLowerCase();
  final name = employee?.name.trim().toLowerCase();
  final check = role == 'ali' || name == 'ali';
  print('DEBUG: isAli check: $check (role is ${employee?.role}, name is ${employee?.name})');
  return check;
}

@riverpod
bool isMaster(Ref ref) {
  final employee = ref.watch(currentEmployeeProvider).value;
  final role = employee?.role?.trim().toLowerCase();
  final name = employee?.name.trim().toLowerCase();
  final check = role == 'master' || role == 'ali' || name == 'ali';
  print('DEBUG: isMaster check: $check (role is ${employee?.role})');
  return check;
}

@Riverpod(keepAlive: true)
Future<Set<String>> userPermissions(Ref ref) async {
  final employee = ref.watch(currentEmployeeProvider).value;
  if (employee == null || employee.roleId == null) {
    print('DEBUG: userPermissions skipped. Employee or roleId is null.');
    return {};
  }

  try {
    final client = ref.read(supabaseClientProvider);
    final response = await client
        .from('role_permissions')
        .select('permissions(key)')
        .eq('role_id', employee.roleId!);

    final Set<String> keys = {};
    for (final row in response as List) {
      final perm = row['permissions'] as Map?;
      if (perm != null && perm['key'] != null) {
        keys.add(perm['key'] as String);
      }
    }
    print('DEBUG: User permissions keys fetched: $keys');
    return keys;
  } catch (e, stack) {
    print('DEBUG EXCEPTION in userPermissions: $e');
    print(stack);
    return {};
  }
}

@riverpod
bool hasPermission(Ref ref, String permissionKey) {
  final employee = ref.watch(currentEmployeeProvider).value;
  print('DEBUG: hasPermission("$permissionKey") check for role: "${employee?.role}"');
  final role = employee?.role?.trim().toLowerCase();
  final name = employee?.name.trim().toLowerCase();
  if (role == 'master' || role == 'ali' || name == 'ali') {
    print('DEBUG: hasPermission("$permissionKey") is true (master/ali bypass)');
    return true;
  }

  final permissionsAsync = ref.watch(userPermissionsProvider);
  final hasPerm = permissionsAsync.maybeWhen(
    data: (perms) => perms.contains(permissionKey),
    orElse: () => false,
  );
  print('DEBUG: hasPermission("$permissionKey") check result: $hasPerm');
  return hasPerm;
}

