import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/features/prescription/domain/entities/prescription_status.dart';

/// Ordonnance du patient (section 5.7) : brouillon généré par l'IA jusqu'à
/// signature par un praticien. `items` et `safetyAlerts` restent des
/// instantanés JSON — aucun schéma fixe n'est encore imposé côté backend, le
/// mobile les affiche tels quels plutôt que d'inventer une structure.
class Prescription extends Equatable {
  const Prescription({
    required this.id,
    required this.status,
    required this.items,
    this.safetyAlerts = const [],
    this.refusalReason,
    this.signedAt,
    this.transmittedAt,
  });

  final String id;
  final PrescriptionStatus status;
  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> safetyAlerts;
  final String? refusalReason;
  final DateTime? signedAt;
  final DateTime? transmittedAt;

  @override
  List<Object?> get props => [
    id,
    status,
    items,
    safetyAlerts,
    refusalReason,
    signedAt,
    transmittedAt,
  ];
}
