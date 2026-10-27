import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:vitalia_mobile/features/auth/presentation/providers/auth_providers.dart';
import 'package:vitalia_mobile/features/auth/presentation/providers/auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository) : super(const AuthState()) {
    restoreSession();
  }

  final AuthRepository _repository;

  Future<void> restoreSession() async {
    if (!await _repository.hasStoredSession()) {
      state = state.copyWith(isCheckingSession: false);
      return;
    }

    final result = await _repository.currentUser();

    result.when(
      success: (user) =>
          state = state.copyWith(user: user, isCheckingSession: false),
      // Jeton stocké mais invalide côté serveur (expiré, révoqué) : revenir
      // à l'écran de connexion plutôt que bloquer l'application.
      failure: (_) => state = state.copyWith(isCheckingSession: false),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isSubmitting: true);

    final result = await _repository.register(
      name: name,
      email: email,
      password: password,
    );

    result.when(
      success: (user) =>
          state = state.copyWith(user: user, isSubmitting: false),
      failure: (failure) =>
          state = state.copyWith(isSubmitting: false, failure: failure),
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isSubmitting: true);

    final result = await _repository.login(email: email, password: password);

    result.when(
      success: (user) =>
          state = state.copyWith(user: user, isSubmitting: false),
      failure: (failure) =>
          state = state.copyWith(isSubmitting: false, failure: failure),
    );
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(isCheckingSession: false);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController(ref.watch(authRepositoryProvider));
  },
);
