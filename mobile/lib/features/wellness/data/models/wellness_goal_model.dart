import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal_type.dart';

class WellnessGoalModel {
  const WellnessGoalModel({
    required this.type,
    required this.targetValue,
    this.currentValue,
  });

  factory WellnessGoalModel.fromJson(Map<String, dynamic> json) =>
      WellnessGoalModel(
        type: WellnessGoalType.fromApi(json['type'] as String),
        targetValue: (json['target_value'] as num).toDouble(),
        currentValue: (json['current_value'] as num?)?.toDouble(),
      );

  final WellnessGoalType type;
  final double targetValue;
  final double? currentValue;

  WellnessGoal toEntity() => WellnessGoal(
    type: type,
    targetValue: targetValue,
    currentValue: currentValue,
  );
}
