import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_controller.dart';
import '../../providers/firebase_providers.dart';
import '../../services/seed_service.dart';
import '../../widgets/loading_view.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  bool _seeded = false;

  Future<void> _seedOnce() async {
    if (_seeded) return;
    _seeded = true;
    final firestore = ref.read(firestoreProvider);
    await SeedService(firestore).seedProducts();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          _seedOnce();
          return const HomeScreen();
        }
        _seedOnce();
        return const LoginScreen();
      },
      loading: () => const Scaffold(body: LoadingView()),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Auth error: $error'))),
    );
  }
}
