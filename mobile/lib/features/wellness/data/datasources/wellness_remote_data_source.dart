import 'package:dio/dio.dart';
import 'package:vitalia_mobile/features/wellness/data/models/mood_entry_model.dart';
import 'package:vitalia_mobile/features/wellness/data/models/wellness_goal_model.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal_type.dart';

/// Seule classe du projet qui connaît la forme JSON exacte des endpoints
/// `wellness/goals` et `wellness/mood` (section 11.1).
class WellnessRemoteDataSource {
  const WellnessRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<WellnessGoalModel>> listGoals() async {
    final response = await _dio.get('/wellness/goals');
    final rows =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;

    return rows
        .map((row) => WellnessGoalModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<WellnessGoalModel> setGoal({
    required WellnessGoalType type,
    required double targetValue,
  }) async {
    final response = await _dio.post(
      '/wellness/goals',
      data: {'type': type.apiValue, 'target_value': targetValue},
    );

    return WellnessGoalModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<List<MoodEntryModel>> listMoodEntries() async {
    final response = await _dio.get('/wellness/mood');
    final rows =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;

    return rows
        .map((row) => MoodEntryModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<MoodEntryModel> logMood({required int moodLevel, String? note}) async {
    final response = await _dio.post(
      '/wellness/mood',
      data: {'mood_level': moodLevel, 'note': note},
    );

    return MoodEntryModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }
}
