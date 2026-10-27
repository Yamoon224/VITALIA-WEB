import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/core/network/api_client.dart';
import 'package:vitalia_mobile/core/security/secure_storage.dart';

/// Racine de l'injection de dépendances (section 11.1 : dépôts derrière des
/// interfaces, pour permettre des faux dans les tests via `overrideWith`).
final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(secureStorage: ref.watch(secureStorageProvider));
});

final dioProvider = Provider<Dio>((ref) => ref.watch(apiClientProvider).dio);
