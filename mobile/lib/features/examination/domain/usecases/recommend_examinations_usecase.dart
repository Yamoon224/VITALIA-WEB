import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_request.dart';
import 'package:vitalia_mobile/features/examination/domain/repositories/examination_repository.dart';

class RecommendExaminationsUseCase {
  const RecommendExaminationsUseCase(this._repository);

  final ExaminationRepository _repository;

  Future<Result<ExaminationRequest>> call() =>
      _repository.recommendExaminations();
}
