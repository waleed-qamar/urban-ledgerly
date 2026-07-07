import 'package:supabase_flutter/supabase_flutter.dart';

class PermissionDeniedException implements Exception {
  final String message;
  PermissionDeniedException([this.message = "You don't have permission for this action."]);

  @override
  String toString() => message;
}

Future<T> supabaseSafeCall<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on PostgrestException catch (e) {
    if (e.code == '42501') {
      throw PermissionDeniedException();
    }
    rethrow;
  }
}
