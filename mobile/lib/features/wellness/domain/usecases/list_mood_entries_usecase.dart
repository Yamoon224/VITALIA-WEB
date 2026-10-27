import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/mood_entry.dart';
import 'package:vitalia_mobile/features/wellness/domain/repositories/wellness_repository.dart';

class ListMoodEntriesUseCase {
  const ListMoodEntriesUseCase(this._repository);

  final WellnessRepository _repository;

  Future<Result<List<MoodEntry>>> call() => _repository.listMoodEntries();
}
