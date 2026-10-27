import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/mood_entry.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal.dart';

/// État immuable émis par [WellnessController] (section 11.1).
class WellnessState extends Equatable {
  const WellnessState({
    this.goals = const [],
    this.moodEntries = const [],
    this.isLoading = false,
    this.isSavingGoal = false,
    this.isLoggingMood = false,
    this.failure,
  });

  final List<WellnessGoal> goals;
  final List<MoodEntry> moodEntries;
  final bool isLoading;
  final bool isSavingGoal;
  final bool isLoggingMood;
  final Failure? failure;

  WellnessState copyWith({
    List<WellnessGoal>? goals,
    List<MoodEntry>? moodEntries,
    bool? isLoading,
    bool? isSavingGoal,
    bool? isLoggingMood,
    Failure? failure,
  }) {
    return WellnessState(
      goals: goals ?? this.goals,
      moodEntries: moodEntries ?? this.moodEntries,
      isLoading: isLoading ?? this.isLoading,
      isSavingGoal: isSavingGoal ?? this.isSavingGoal,
      isLoggingMood: isLoggingMood ?? this.isLoggingMood,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    goals,
    moodEntries,
    isLoading,
    isSavingGoal,
    isLoggingMood,
    failure,
  ];
}
