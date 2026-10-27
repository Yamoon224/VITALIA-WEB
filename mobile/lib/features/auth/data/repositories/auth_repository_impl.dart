import 'package:dio/dio.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/core/network/api_client.dart';
import 'package:vitalia_mobile/core/security/secure_storage.dart';
import 'package:vitalia_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vitalia_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:vitalia_mobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._secureStorage);

  final AuthRemoteDataSource _remote;
  final SecureStorage _secureStorage;

  @override
  Future<Result<AuthUser>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final response = await _remote.register(
        name: name,
        email: email,
        password: password,
      );
      await _secureStorage.saveToken(response.token);

      return response.user;
    });
  }

  @override
  Future<Result<AuthUser>> login({
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final response = await _remote.login(email: email, password: password);
      await _secureStorage.saveToken(response.token);

      return response.user;
    });
  }

  @override
  Future<Result<AuthUser>> currentUser() => _guard(() => _remote.me());

  @override
  Future<Result<bool>> logout() {
    return _guard(() async {
      await _remote.logout().catchError((_) {});
      await _secureStorage.clear();

      return true;
    });
  }

  @override
  Future<bool> hasStoredSession() async =>
      (await _secureStorage.readToken()) != null;

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Result.success(await action());
    } on DioException catch (exception) {
      return Result.failure(mapDioException(exception));
    } catch (_) {
      return const Result.failure(UnknownFailure());
    }
  }
}
