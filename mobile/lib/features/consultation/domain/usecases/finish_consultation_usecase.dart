import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_session.dart';
import 'package:vitalia_mobile/features/consultation/domain/repositories/consultation_repository.dart';

class FinishConsultationUseCase {
  const FinishConsultationUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<ConsultationSession>> call(String conversationId) =>
      _repository.finish(conversationId);
}
