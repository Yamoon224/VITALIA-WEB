import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_hypothesis.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_status.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/orientation_level.dart';

/// Entretien structuré piloté par l'agent (section 5.3), adossé à une
/// conversation. `summary`/`hypotheses`/`orientationLevel`/`redFlags` ne
/// sont renseignés qu'une fois l'entretien terminé (`finish`).
class ConsultationSession extends Equatable {
  const ConsultationSession({
    required this.id,
    required this.conversationId,
    required this.status,
    required this.answers,
    this.motif,
    this.protocolCode,
    this.summary,
    this.hypotheses = const [],
    this.orientationLevel,
    this.redFlags = const [],
    this.completedAt,
  });

  final String id;
  final String conversationId;
  final ConsultationStatus status;
  final Map<String, String> answers;
  final String? motif;
  final String? protocolCode;
  final String? summary;
  final List<ConsultationHypothesis> hypotheses;
  final OrientationLevel? orientationLevel;
  final List<String> redFlags;
  final DateTime? completedAt;

  bool get isCompleted => status == ConsultationStatus.completed;

  @override
  List<Object?> get props => [
    id,
    conversationId,
    status,
    answers,
    motif,
    protocolCode,
    summary,
    hypotheses,
    orientationLevel,
    redFlags,
    completedAt,
  ];
}
