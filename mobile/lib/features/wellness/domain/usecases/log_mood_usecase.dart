import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/mood_entry.dart';
import 'package:vitalia_mobile/features/wellness/domain/repositories/wellness_repository.dart';

class LogMoodUseCase {
  const LogMoodUseCase(this._repository);

  final WellnessRepository _repository;

  Future<Result<MoodEntry>> call({required int moodLevel, String? note}) =>
      _repository.logMood(moodLevel: moodLevel, note: note);
}
