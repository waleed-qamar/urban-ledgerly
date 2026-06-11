import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ledgerly/sidebar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/pages/login_view.dart';
import 'features/auth/presentation/provider/auth_providers.dart';

// Adjust this import path based on exactly where you placed the view
void main() async {
  // Ensure Flutter bindings are initialized before calling async native code
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://obdcybyldpscvqryutxp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9iZGN5YnlsZHBzY3Zxcnl1dHhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY0NDI4OTksImV4cCI6MjA5MjAxODg5OX0.zr7TAZNPdZN6iBvo203z4UWYb3wAEQU231IlPdcxlD0',
  );

  runApp(
    // ProviderScope is absolutely required at the root for Riverpod to work
    ResponsiveSizer(
      builder: (context, orientation, screenType) =>
          const ProviderScope(child: LedgerlyApp()),
    ),
  );
}

class LedgerlyApp extends StatelessWidget {
  const LedgerlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ledgerly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ... (Keep your existing theme config here) ...
      ),
      home: const AuthWrapper(), // We point home to the Wrapper now
    );
  }
}

// The wrapper decides which screen to show based on auth state
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateStreamProvider);

    return authStateAsync.when(
      data: (authState) {
        final session = authState.session;
        // If there is an active session, show the app. Otherwise, show login.
        if (session != null) {
          return const MainLayout();
        } else {
          return const LoginView();
        }
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
