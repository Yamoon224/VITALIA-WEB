import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_result.dart';
import 'package:vitalia_mobile/features/examination/domain/repositories/examination_repository.dart';

class RecordExaminationResultUseCase {
  const RecordExaminationResultUseCase(this._repository);

  final ExaminationRepository _repository;

  Future<Result<ExaminationResult>> call({
    required String parameter,
    required double value,
    required String unit,
    double? referenceLow,
    double? referenceHigh,
    String? examinationRequestId,
  }) => _repository.recordResult(
    parameter: parameter,
    value: value,
    unit: unit,
    referenceLow: referenceLow,
    referenceHigh: referenceHigh,
    examinationRequestId: examinationRequestId,
  );
}
