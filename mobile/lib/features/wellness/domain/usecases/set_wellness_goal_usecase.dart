import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal_type.dart';
import 'package:vitalia_mobile/features/wellness/domain/repositories/wellness_repository.dart';

class SetWellnessGoalUseCase {
  const SetWellnessGoalUseCase(this._repository);

  final WellnessRepository _repository;

  Future<Result<WellnessGoal>> call({
    required WellnessGoalType type,
    required double targetValue,
  }) => _repository.setGoal(type: type, targetValue: targetValue);
}
