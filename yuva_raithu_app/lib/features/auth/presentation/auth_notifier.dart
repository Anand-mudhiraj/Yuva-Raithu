import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yuva_raithu_app/features/auth/domain/user.dart';
import 'package:yuva_raithu_app/features/auth/data/auth_repository.dart';
import 'package:yuva_raithu_app/core/providers.dart';

class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, User? user, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Initialize state
    Future.microtask(() => checkLoginStatus());
    return AuthState();
  }

  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _authRepository.isLoggedIn();
    if (isLoggedIn) {
      // Fetch the actual user profile to rehydrate the state properly
      final user = await _authRepository.getUserProfile();
      if (user != null) {
        state = state.copyWith(user: user);
      } else {
        // Token is invalid or expired
        await _authRepository.logout();
        state = AuthState();
      }
    }
  }

  Future<bool> login(String phoneNumber, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authRepository.login(phoneNumber, password);
      if (user != null) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      } else {
        state = state.copyWith(isLoading: false, error: 'Login failed');
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> signup(String fullName, String phoneNumber, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final success = await _authRepository.signup(fullName, phoneNumber, password);
      state = state.copyWith(isLoading: false);
      return success;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = AuthState(); // Reset state
  }
}
