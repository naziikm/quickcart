import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import 'firebase_providers.dart';

class AuthViewState {
  final bool isLoading;
  final String? errorMessage;
  final String? verificationId;
  final bool isCodeSent;

  const AuthViewState({
    this.isLoading = false,
    this.errorMessage,
    this.verificationId,
    this.isCodeSent = false,
  });

  AuthViewState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? verificationId,
    bool? isCodeSent,
  }) {
    return AuthViewState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      verificationId: verificationId ?? this.verificationId,
      isCodeSent: isCodeSent ?? this.isCodeSent,
    );
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(firebaseAuthProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(firebaseAuthProvider).authStateChanges();
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthViewState>((ref) {
      return AuthController(ref.read(authServiceProvider));
    });

class AuthController extends StateNotifier<AuthViewState> {
  AuthController(this._authService) : super(const AuthViewState());

  final AuthService _authService;

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.signInWithEmail(email: email, password: password);
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.message ?? 'Login failed. Please try again.',
      );
      return false;
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.signUpWithEmail(email: email, password: password);
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.message ?? 'Signup failed. Please try again.',
      );
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await _authService.sendOtp(
      phoneNumber: phoneNumber,
      codeSent: (verificationId) {
        state = state.copyWith(
          isLoading: false,
          verificationId: verificationId,
          isCodeSent: true,
        );
      },
      onError: (message) {
        state = state.copyWith(isLoading: false, errorMessage: message);
      },
      onAutoVerified: (credential) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<bool> verifyOtp(String smsCode) async {
    final verificationId = state.verificationId;
    if (verificationId == null) {
      state = state.copyWith(errorMessage: 'Please request a new code first.');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.verifyOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.message ?? 'Verification failed.',
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
