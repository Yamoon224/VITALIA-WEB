import 'package:vitalia_mobile/features/health_record/domain/entities/health_profile.dart';

class HealthProfileModel {
  const HealthProfileModel({
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

  factory HealthProfileModel.fromJson(Map<String, dynamic> json) =>
      HealthProfileModel(
        birthYear: json['birth_year'] as int?,
        sex: json['sex'] as String?,
        heightCm: json['height_cm'] as int?,
        weightKg: json['weight_kg'] as int?,
        allergies: _stringList(json['allergies']),
        chronicConditions: _stringList(json['chronic_conditions']),
        currentMedications: _stringList(json['current_medications']),
        isPregnant: json['is_pregnant'] as bool?,
        lifestyleNotes: json['lifestyle_notes'] as String?,
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.tryParse(json['updated_at'] as String),
      );

  factory HealthProfileModel.fromEntity(HealthProfile profile) =>
      HealthProfileModel(
        birthYear: profile.birthYear,
        sex: profile.sex,
        heightCm: profile.heightCm,
        weightKg: profile.weightKg,
        allergies: profile.allergies,
        chronicConditions: profile.chronicConditions,
        currentMedications: profile.currentMedications,
        isPregnant: profile.isPregnant,
        lifestyleNotes: profile.lifestyleNotes,
      );

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

  static List<String> _stringList(dynamic raw) =>
      ((raw as List<dynamic>?) ?? []).map((e) => e.toString()).toList();

  /// Corps de la requête `PUT /health-profile` (section 5.1 : chaque champ
  /// est facultatif et modifiable).
  Map<String, dynamic> toJson() => {
    'birth_year': birthYear,
    'sex': sex,
    'height_cm': heightCm,
    'weight_kg': weightKg,
    'allergies': allergies,
    'chronic_conditions': chronicConditions,
    'current_medications': currentMedications,
    'is_pregnant': isPregnant,
    'lifestyle_notes': lifestyleNotes,
  };

  HealthProfile toEntity() => HealthProfile(
    birthYear: birthYear,
    sex: sex,
    heightCm: heightCm,
    weightKg: weightKg,
    allergies: allergies,
    chronicConditions: chronicConditions,
    currentMedications: currentMedications,
    isPregnant: isPregnant,
    lifestyleNotes: lifestyleNotes,
    updatedAt: updatedAt,
  );
}
