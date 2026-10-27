import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/mood_entry.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal_type.dart';

/// Interface de dépôt (section 11.1) : le domaine ne connaît ni Dio ni la
/// forme JSON de l'API `wellness/goals` / `wellness/mood`.
abstract interface class WellnessRepository {
  Future<Result<List<WellnessGoal>>> listGoals();

  Future<Result<WellnessGoal>> setGoal({
    required WellnessGoalType type,
    required double targetValue,
  });

  Future<Result<List<MoodEntry>>> listMoodEntries();

  Future<Result<MoodEntry>> logMood({required int moodLevel, String? note});
}
