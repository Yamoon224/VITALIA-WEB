import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/protocol_question.dart';
import 'package:vitalia_mobile/features/consultation/domain/repositories/consultation_repository.dart';

class GetNextQuestionUseCase {
  const GetNextQuestionUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<ProtocolQuestion?>> call(String conversationId) =>
      _repository.nextQuestion(conversationId);
}
