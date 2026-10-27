import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  /// Inscription par e-mail (section 5.1). L'OTP par téléphone est une
  /// évolution prévue (section 16, phase 4) : pour l'instant seul le champ
  /// e-mail est exposé côté mobile.
  Future<Result<AuthUser>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  });

  Future<Result<AuthUser>> currentUser();

  Future<Result<bool>> logout();

  Future<bool> hasStoredSession();
}
