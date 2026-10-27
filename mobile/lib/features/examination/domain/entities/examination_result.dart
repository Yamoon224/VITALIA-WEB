import 'package:equatable/equatable.dart';

/// Valeur d'un bilan biologique (section 5.6) : comparée aux normes,
/// l'indication « hors normes » est calculée côté serveur par des règles
/// déterministes, jamais par le mobile.
class ExaminationResult extends Equatable {
  const ExaminationResult({
    required this.id,
    required this.parameter,
    required this.value,
    required this.unit,
    required this.isAbnormal,
    required this.recordedAt,
    this.referenceLow,
    this.referenceHigh,
  });

  final String id;
  final String parameter;
  final double value;
  final String unit;
  final double? referenceLow;
  final double? referenceHigh;
  final bool isAbnormal;
  final DateTime recordedAt;

  @override
  List<Object?> get props => [
    id,
    parameter,
    value,
    unit,
    referenceLow,
    referenceHigh,
    isAbnormal,
    recordedAt,
  ];
}
