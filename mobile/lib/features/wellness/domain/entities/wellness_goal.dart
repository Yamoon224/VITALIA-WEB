import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal_type.dart';

/// Objectif et progression (section 5.9) : tableaux de progression poids,
/// pas, sommeil, hydratation.
class WellnessGoal extends Equatable {
  const WellnessGoal({
    required this.type,
    required this.targetValue,
    this.currentValue,
  });

  final WellnessGoalType type;
  final double targetValue;
  final double? currentValue;

  double get progress => currentValue == null || targetValue == 0
      ? 0
      : (currentValue! / targetValue).clamp(0, 1);

  @override
  List<Object?> get props => [type, targetValue, currentValue];
}
