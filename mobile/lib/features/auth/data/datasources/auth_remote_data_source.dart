import 'package:dio/dio.dart';
import 'package:vitalia_mobile/features/auth/domain/entities/auth_user.dart';

class AuthResponseModel {
  const AuthResponseModel({required this.user, required this.token});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>;

    return AuthResponseModel(
      user: AuthUser(
        id: userJson['id'] as int,
        name: userJson['name'] as String,
        email: userJson['email'] as String?,
        phone: userJson['phone'] as String?,
      ),
      token: json['token'] as String,
    );
  }

  final AuthUser user;
  final String token;
}

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
    );

    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthUser> me() async {
    final response = await _dio.get('/auth/me');
    final json = response.data as Map<String, dynamic>;

    return AuthUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Future<void> logout() => _dio.post('/auth/logout');
}
