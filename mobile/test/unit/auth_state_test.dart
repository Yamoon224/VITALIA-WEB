import 'package:flutter_test/flutter_test.dart';
import 'package:vitalia_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:vitalia_mobile/features/auth/presentation/providers/auth_state.dart';

void main() {
  group('AuthState', () {
    test('starts checking the session and unauthenticated', () {
      const state = AuthState();

      expect(state.isCheckingSession, isTrue);
      expect(state.isAuthenticated, isFalse);
    });

    test('is authenticated once a user is set', () {
      const state = AuthState(user: AuthUser(id: 1, name: 'Ada'));

      expect(state.isAuthenticated, isTrue);
    });

    test('copyWith preserves the user when not overridden', () {
      const state = AuthState(
        user: AuthUser(id: 1, name: 'Ada'),
        isCheckingSession: false,
      );

      final updated = state.copyWith(isSubmitting: true);

      expect(updated.user, const AuthUser(id: 1, name: 'Ada'));
      expect(updated.isSubmitting, isTrue);
    });
  });
}
