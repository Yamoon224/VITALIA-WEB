import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/core/network/core_providers.dart';
import 'package:vitalia_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:vitalia_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vitalia_mobile/features/auth/domain/repositories/auth_repository.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(ref.watch(dioProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(secureStorageProvider),
  ),
);
