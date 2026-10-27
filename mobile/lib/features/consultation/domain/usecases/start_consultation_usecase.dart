import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_session.dart';
import 'package:vitalia_mobile/features/consultation/domain/repositories/consultation_repository.dart';

class StartConsultationUseCase {
  const StartConsultationUseCase(this._repository);

  final ConsultationRepository _repository;

  Future<Result<ConsultationSession>> call({String? motif}) =>
      _repository.start(motif: motif);
}
