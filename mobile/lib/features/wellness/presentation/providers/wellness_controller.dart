import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal_type.dart';
import 'package:vitalia_mobile/features/wellness/domain/usecases/list_mood_entries_usecase.dart';
import 'package:vitalia_mobile/features/wellness/domain/usecases/list_wellness_goals_usecase.dart';
import 'package:vitalia_mobile/features/wellness/domain/usecases/log_mood_usecase.dart';
import 'package:vitalia_mobile/features/wellness/domain/usecases/set_wellness_goal_usecase.dart';
import 'package:vitalia_mobile/features/wellness/presentation/providers/wellness_providers.dart';
import 'package:vitalia_mobile/features/wellness/presentation/providers/wellness_state.dart';

/// Décide ; ne connaît ni widget ni appel réseau direct (section 11.1).
class WellnessController extends StateNotifier<WellnessState> {
  WellnessController({
    required ListWellnessGoalsUseCase listGoals,
    required SetWellnessGoalUseCase setGoal,
    required ListMoodEntriesUseCase listMoodEntries,
    required LogMoodUseCase logMood,
  }) : _listGoals = listGoals,
       _setGoal = setGoal,
       _listMoodEntries = listMoodEntries,
       _logMood = logMood,
       super(const WellnessState());

  final ListWellnessGoalsUseCase _listGoals;
  final SetWellnessGoalUseCase _setGoal;
  final ListMoodEntriesUseCase _listMoodEntries;
  final LogMoodUseCase _logMood;

  Future<void> load() async {
    state = state.copyWith(isLoading: true);

    final goalsResult = await _listGoals();
    final moodResult = await _listMoodEntries();

    goalsResult.when(
      success: (goals) => state = state.copyWith(goals: goals),
      failure: (failure) => state = state.copyWith(failure: failure),
    );

    moodResult.when(
      success: (entries) => state = state.copyWith(moodEntries: entries),
      failure: (failure) => state = state.copyWith(failure: failure),
    );

    state = state.copyWith(isLoading: false);
  }

  Future<void> saveGoal({
    required WellnessGoalType type,
    required double targetValue,
  }) async {
    state = state.copyWith(isSavingGoal: true);

    final result = await _setGoal(type: type, targetValue: targetValue);

    result.when(
      success: (goal) {
        final updatedGoals = [
          ...state.goals.where((g) => g.type != goal.type),
          goal,
        ];
        state = state.copyWith(goals: updatedGoals, isSavingGoal: false);
      },
      failure: (failure) =>
          state = state.copyWith(isSavingGoal: false, failure: failure),
    );
  }

  Future<void> logMood({required int moodLevel, String? note}) async {
    state = state.copyWith(isLoggingMood: true);

    final result = await _logMood(moodLevel: moodLevel, note: note);

    result.when(
      success: (entry) => state = state.copyWith(
        moodEntries: [entry, ...state.moodEntries],
        isLoggingMood: false,
      ),
      failure: (failure) =>
          state = state.copyWith(isLoggingMood: false, failure: failure),
    );
  }
}

final wellnessControllerProvider =
    StateNotifierProvider.autoDispose<WellnessController, WellnessState>((ref) {
      return WellnessController(
        listGoals: ref.watch(listWellnessGoalsUseCaseProvider),
        setGoal: ref.watch(setWellnessGoalUseCaseProvider),
        listMoodEntries: ref.watch(listMoodEntriesUseCaseProvider),
        logMood: ref.watch(logMoodUseCaseProvider),
      );
    });
