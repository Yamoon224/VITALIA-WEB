/// Erreurs typées (section 11.1, « gestion d'erreurs typée »).
///
/// Les couches `data` traduisent toute exception réseau ou de stockage en
/// une [Failure] avant de remonter vers `domain` : aucune `DioException` ni
/// exception de plateforme ne doit fuiter jusqu'à la présentation.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Connexion impossible. Vérifie ta connexion internet.',
  ]);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.errorCode});

  final String? errorCode;
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure([
    super.message = 'Session expirée. Reconnecte-toi.',
  ]);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, this.errors);

  final Map<String, List<String>> errors;
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Une erreur inattendue est survenue.']);
}
