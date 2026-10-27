import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Jetons dans le stockage sécurisé du système (section 8, 11.1 :
/// Keychain iOS / Keystore Android), jamais en clair dans des préférences.
class SecureStorage {
  SecureStorage({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
          );

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'vitalia_api_token';

  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  /// Effacement complet à la déconnexion (section 11.1).
  Future<void> clear() => _storage.deleteAll();
}
