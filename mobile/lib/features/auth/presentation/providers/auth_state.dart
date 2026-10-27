import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/features/auth/domain/entities/auth_user.dart';

class AuthState extends Equatable {
  const AuthState({
    this.user,
    this.isCheckingSession = true,
    this.isSubmitting = false,
    this.failure,
  });

  final AuthUser? user;

  /// Vrai pendant la vérification d'une session déjà stockée au démarrage
  /// (section 11.1) : l'écran racine attend ce signal avant de choisir entre
  /// l'écran de connexion et le chat.
  final bool isCheckingSession;
  final bool isSubmitting;
  final Failure? failure;

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    AuthUser? user,
    bool? isCheckingSession,
    bool? isSubmitting,
    Failure? failure,
  }) {
    return AuthState(
      user: user ?? this.user,
      isCheckingSession: isCheckingSession ?? this.isCheckingSession,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [user, isCheckingSession, isSubmitting, failure];
}
