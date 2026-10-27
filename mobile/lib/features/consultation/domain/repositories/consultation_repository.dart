import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_session.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/protocol_question.dart';

/// Interface de dépôt (section 11.1) : le domaine ne connaît ni Dio ni la
/// forme JSON des API `conversations` / `consultation`.
abstract interface class ConsultationRepository {
  /// Crée la conversation support puis démarre l'entretien (section 5.3).
  Future<Result<ConsultationSession>> start({String? motif});

  Future<Result<ProtocolQuestion?>> nextQuestion(String conversationId);

  Future<Result<ConsultationSession>> answer({
    required String conversationId,
    required String questionCode,
    required String answer,
  });

  Future<Result<ConsultationSession>> finish(String conversationId);
}
