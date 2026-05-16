import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ledgerly/features/employee/domain/entities/employee_entity.dart';
import 'auth_providers.dart';

part 'current_employee_provider.g.dart';

@Riverpod(keepAlive: true)
Future<EmployeeEntity?> currentEmployee(Ref ref) async {
  final authState = ref.watch(authStateStreamProvider);
  final session = authState.when(
    data: (state) => state.session,
    loading: () => null,
    error: (_, __) => null,
  );

  if (session?.user == null) {
    return null;
  }

  try {
    final uid = session!.user.id;
    final response = await Supabase.instance.client
        .from('employees')
        .select()
        .eq('user_id', uid)
        .maybeSingle();

    if (response == null) return null;

    final normalizedResponse = <String, dynamic>{
      'id': response['id'],
      'name': response['name'],
      'phone': response['phone'],
      'cnic': response['cnic'],
      'joiningDate': response['joining_date'],
      'isActive': response['is_active'],
      'role': response['role'],
      'userId': response['user_id'],
      'createdAt': response['created_at'],
    };

    return EmployeeEntity.fromJson(normalizedResponse);
  } catch (e) {
    return null;
  }
}
