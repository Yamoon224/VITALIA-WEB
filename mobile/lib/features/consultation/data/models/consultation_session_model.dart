import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_hypothesis.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_session.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_status.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/orientation_level.dart';

class ConsultationSessionModel {
  const ConsultationSessionModel({
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

  factory ConsultationSessionModel.fromJson(Map<String, dynamic> json) =>
      ConsultationSessionModel(
        id: json['id'].toString(),
        conversationId: json['conversation_id'].toString(),
        status: ConsultationStatus.fromApi(json['status'] as String),
        answers: ((json['answers'] as Map<String, dynamic>?) ?? {}).map(
          (key, value) => MapEntry(key, value.toString()),
        ),
        motif: json['motif'] as String?,
        protocolCode: json['protocol_code'] as String?,
        summary: json['summary'] as String?,
        hypotheses: ((json['hypotheses'] as List<dynamic>?) ?? [])
            .map(
              (raw) => ConsultationHypothesis(
                condition: (raw as Map<String, dynamic>)['condition'] as String,
                confidence: (raw['confidence'] as num).toDouble(),
              ),
            )
            .toList(),
        orientationLevel: OrientationLevel.fromApi(
          json['orientation_level'] as String?,
        ),
        redFlags: ((json['red_flags'] as List<dynamic>?) ?? [])
            .map((e) => e.toString())
            .toList(),
        completedAt: json['completed_at'] == null
            ? null
            : DateTime.tryParse(json['completed_at'] as String),
      );

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

  ConsultationSession toEntity() => ConsultationSession(
    id: id,
    conversationId: conversationId,
    status: status,
    answers: answers,
    motif: motif,
    protocolCode: protocolCode,
    summary: summary,
    hypotheses: hypotheses,
    orientationLevel: orientationLevel,
    redFlags: redFlags,
    completedAt: completedAt,
  );
}
