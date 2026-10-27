/// Objectifs et suivi (section 5.9) : poids, pas, sommeil, hydratation.
enum WellnessGoalType {
  weight,
  steps,
  sleepHours,
  hydrationLiters;

  String get apiValue => switch (this) {
    WellnessGoalType.weight => 'weight',
    WellnessGoalType.steps => 'steps',
    WellnessGoalType.sleepHours => 'sleep_hours',
    WellnessGoalType.hydrationLiters => 'hydration_liters',
  };

  String get label => switch (this) {
    WellnessGoalType.weight => 'Poids (kg)',
    WellnessGoalType.steps => 'Pas par jour',
    WellnessGoalType.sleepHours => 'Sommeil (h)',
    WellnessGoalType.hydrationLiters => 'Hydratation (L)',
  };

  static WellnessGoalType fromApi(String value) => switch (value) {
    'steps' => WellnessGoalType.steps,
    'sleep_hours' => WellnessGoalType.sleepHours,
    'hydration_liters' => WellnessGoalType.hydrationLiters,
    _ => WellnessGoalType.weight,
  };
}
