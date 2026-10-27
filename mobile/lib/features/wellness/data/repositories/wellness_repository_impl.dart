import 'package:dio/dio.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/core/network/api_client.dart';
import 'package:vitalia_mobile/features/wellness/data/datasources/wellness_remote_data_source.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/mood_entry.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal_type.dart';
import 'package:vitalia_mobile/features/wellness/domain/repositories/wellness_repository.dart';

class WellnessRepositoryImpl implements WellnessRepository {
  const WellnessRepositoryImpl(this._remote);

  final WellnessRemoteDataSource _remote;

  @override
  Future<Result<List<WellnessGoal>>> listGoals() => _guard(
    () async => (await _remote.listGoals()).map((g) => g.toEntity()).toList(),
  );

  @override
  Future<Result<WellnessGoal>> setGoal({
    required WellnessGoalType type,
    required double targetValue,
  }) => _guard(
    () async => (await _remote.setGoal(
      type: type,
      targetValue: targetValue,
    )).toEntity(),
  );

  @override
  Future<Result<List<MoodEntry>>> listMoodEntries() => _guard(
    () async =>
        (await _remote.listMoodEntries()).map((e) => e.toEntity()).toList(),
  );

  @override
  Future<Result<MoodEntry>> logMood({required int moodLevel, String? note}) =>
      _guard(
        () async => (await _remote.logMood(
          moodLevel: moodLevel,
          note: note,
        )).toEntity(),
      );

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
