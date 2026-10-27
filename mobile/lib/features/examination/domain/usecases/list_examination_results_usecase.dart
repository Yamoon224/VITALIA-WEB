import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_result.dart';
import 'package:vitalia_mobile/features/examination/domain/repositories/examination_repository.dart';

class ListExaminationResultsUseCase {
  const ListExaminationResultsUseCase(this._repository);

  final ExaminationRepository _repository;

  Future<Result<List<ExaminationResult>>> call() => _repository.listResults();
}
