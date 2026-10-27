import 'package:dio/dio.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/core/network/api_client.dart';
import 'package:vitalia_mobile/features/health_record/data/datasources/health_record_remote_data_source.dart';
import 'package:vitalia_mobile/features/health_record/data/models/health_profile_model.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/agent_memory_entry.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/health_profile.dart';
import 'package:vitalia_mobile/features/health_record/domain/repositories/health_record_repository.dart';

class HealthRecordRepositoryImpl implements HealthRecordRepository {
  const HealthRecordRepositoryImpl(this._remote);

  final HealthRecordRemoteDataSource _remote;

  @override
  Future<Result<HealthProfile>> getProfile() =>
      _guard(() async => (await _remote.getProfile()).toEntity());

  @override
  Future<Result<HealthProfile>> updateProfile(HealthProfile profile) => _guard(
    () async => (await _remote.updateProfile(
      HealthProfileModel.fromEntity(profile),
    )).toEntity(),
  );

  @override
  Future<Result<List<AgentMemoryEntry>>> pendingMemoryEntries() => _guard(
    () async => (await _remote.pendingMemoryEntries())
        .map((e) => e.toEntity())
        .toList(),
  );

  @override
  Future<Result<AgentMemoryEntry>> acceptMemoryEntry(String entryId) =>
      _guard(() async => (await _remote.acceptMemoryEntry(entryId)).toEntity());

  @override
  Future<Result<AgentMemoryEntry>> rejectMemoryEntry(String entryId) =>
      _guard(() async => (await _remote.rejectMemoryEntry(entryId)).toEntity());

  /// Traduit toute `DioException` en [Failure] typée (section 11.1).
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
