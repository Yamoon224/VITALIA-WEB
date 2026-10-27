import 'package:dio/dio.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/core/network/app_config.dart';
import 'package:vitalia_mobile/core/security/secure_storage.dart';

/// Client HTTP unique du backend (section 11.1).
///
/// Porte l'intercepteur d'authentification (jeton Bearer) et traduit toute
/// `DioException` en [Failure] typée via [mapDioException] — la couche
/// `data` n'a jamais à connaître Dio directement au-delà de ce fichier.
class ApiClient {
  ApiClient({required SecureStorage secureStorage, Dio? dio})
    : _secureStorage = secureStorage,
      dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.current.apiBaseUrl)) {
    this.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _secureStorage.readToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio dio;
  final SecureStorage _secureStorage;
}

Failure mapDioException(DioException exception) {
  if (exception.type == DioExceptionType.connectionError ||
      exception.type == DioExceptionType.connectionTimeout) {
    return const NetworkFailure();
  }

  final status = exception.response?.statusCode;
  final body = exception.response?.data;

  if (status == 401) {
    return const UnauthenticatedFailure();
  }

  if (status == 422 && body is Map<String, dynamic>) {
    final rawErrors = (body['errors'] as Map<String, dynamic>?) ?? {};
    return ValidationFailure(
      body['message'] as String? ?? 'Validation échouée.',
      rawErrors.map(
        (key, value) => MapEntry(key, List<String>.from(value as List)),
      ),
    );
  }

  if (status != null && body is Map<String, dynamic>) {
    return ServerFailure(
      body['message'] as String? ?? 'Erreur serveur.',
      errorCode: body['error_code'] as String?,
    );
  }

  return const UnknownFailure();
}
