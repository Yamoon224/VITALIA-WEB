import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal.dart';
import 'package:vitalia_mobile/features/wellness/domain/repositories/wellness_repository.dart';

class ListWellnessGoalsUseCase {
  const ListWellnessGoalsUseCase(this._repository);

  final WellnessRepository _repository;

  Future<Result<List<WellnessGoal>>> call() => _repository.listGoals();
}
