import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ledgerly/features/employee/domain/entities/employee_entity.dart';
import 'auth_providers.dart';

part 'current_employee_provider.g.dart';

@Riverpod(keepAlive: true)
Future<EmployeeEntity?> currentEmployee(Ref ref) async {
  final authState = await ref.watch(authStateStreamProvider.future);
  
  if (authState.session?.user == null) {
    return null;
  }

  try {
    final uid = authState.session!.user.id;
    final response = await Supabase.instance.client
        .from('employees')
        .select()
        .eq('user_id', uid)
        .maybeSingle();

    if (response == null) return null;
    return EmployeeEntity.fromJson(response);
  } catch (e) {
    return null;
  }
}
