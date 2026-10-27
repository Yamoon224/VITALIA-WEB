import 'package:vitalia_mobile/core/errors/failure.dart';

/// Résultat d'une opération pouvant échouer (section 11.1, type `Result`).
///
/// Remplace les exceptions comme mécanisme de contrôle de flux entre `data`
/// et `domain` : un cas d'usage retourne toujours un `Result`, jamais ne
/// laisse une exception se propager jusqu'à la présentation.
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = Error<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    final self = this;
    return switch (self) {
      Success<T>() => success(self.data),
      Error<T>() => failure(self.failure),
    };
  }

  bool get isSuccess => this is Success<T>;
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}
