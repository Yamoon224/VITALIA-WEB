import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_session.dart';
import 'package:vitalia_mobile/features/consultation/domain/repositories/consultation_repository.dart';

class AnswerConsultationQuestionUseCase {
  const AnswerConsultationQuestionUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<ConsultationSession>> call({
    required String conversationId,
    required String questionCode,
    required String answer,
  }) => _repository.answer(
    conversationId: conversationId,
    questionCode: questionCode,
    answer: answer,
  );
}
