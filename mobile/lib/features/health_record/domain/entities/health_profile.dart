import 'package:equatable/equatable.dart';

/// Profil santé initial progressif (section 5.1) : chaque champ est
/// facultatif et modifiable.
class HealthProfile extends Equatable {
  const HealthProfile({
    this.birthYear,
    this.sex,
    this.heightCm,
    this.weightKg,
    this.allergies = const [],
    this.chronicConditions = const [],
    this.currentMedications = const [],
    this.isPregnant,
    this.lifestyleNotes,
    this.updatedAt,
  });

  final int? birthYear;
  final String? sex;
  final int? heightCm;
  final int? weightKg;
  final List<String> allergies;
  final List<String> chronicConditions;
  final List<String> currentMedications;
  final bool? isPregnant;
  final String? lifestyleNotes;
  final DateTime? updatedAt;

  HealthProfile copyWith({
    int? birthYear,
    String? sex,
    int? heightCm,
    int? weightKg,
    List<String>? allergies,
    List<String>? chronicConditions,
    List<String>? currentMedications,
    bool? isPregnant,
    String? lifestyleNotes,
  }) {
    return HealthProfile(
      birthYear: birthYear ?? this.birthYear,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      allergies: allergies ?? this.allergies,
      chronicConditions: chronicConditions ?? this.chronicConditions,
      currentMedications: currentMedications ?? this.currentMedications,
      isPregnant: isPregnant ?? this.isPregnant,
      lifestyleNotes: lifestyleNotes ?? this.lifestyleNotes,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    birthYear,
    sex,
    heightCm,
    weightKg,
    allergies,
    chronicConditions,
    currentMedications,
    isPregnant,
    lifestyleNotes,
    updatedAt,
  ];
}
