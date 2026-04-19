import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_providers.g.dart';

// Listens to the live stream of authentication changes
@riverpod
Stream<AuthState> authStateStream(Ref ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
}
