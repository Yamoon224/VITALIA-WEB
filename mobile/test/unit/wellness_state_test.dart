import 'package:flutter_test/flutter_test.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal_type.dart';
import 'package:vitalia_mobile/features/wellness/presentation/providers/wellness_state.dart';

void main() {
  group('WellnessState', () {
    test('starts empty and not loading', () {
      const state = WellnessState();

      expect(state.goals, isEmpty);
      expect(state.moodEntries, isEmpty);
      expect(state.isLoading, isFalse);
    });

    test('copyWith preserves fields that are not overridden', () {
      const state = WellnessState(isLoading: true);

      final updated = state.copyWith(isSavingGoal: true);

      expect(updated.isLoading, isTrue);
      expect(updated.isSavingGoal, isTrue);
    });
  });

  group('WellnessGoal', () {
    test('progress is zero without a current value', () {
      const goal = WellnessGoal(
        type: WellnessGoalType.steps,
        targetValue: 10000,
      );

      expect(goal.progress, 0);
    });

    test('progress is the ratio of current to target, clamped to 1', () {
      const goal = WellnessGoal(
        type: WellnessGoalType.steps,
        targetValue: 10000,
        currentValue: 15000,
      );

      expect(goal.progress, 1);
    });
  });

  group('WellnessGoalType', () {
    test('fromApi maps known values and defaults to weight', () {
      expect(WellnessGoalType.fromApi('steps'), WellnessGoalType.steps);
      expect(
        WellnessGoalType.fromApi('sleep_hours'),
        WellnessGoalType.sleepHours,
      );
      expect(
        WellnessGoalType.fromApi('hydration_liters'),
        WellnessGoalType.hydrationLiters,
      );
      expect(WellnessGoalType.fromApi('unknown'), WellnessGoalType.weight);
    });
  });
}
