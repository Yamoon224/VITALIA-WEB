import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/laboratory.dart';
import 'package:vitalia_mobile/features/examination/domain/repositories/examination_repository.dart';

class ListLaboratoriesUseCase {
  const ListLaboratoriesUseCase(this._repository);

  final ExaminationRepository _repository;

  Future<Result<List<Laboratory>>> call({String? city}) =>
      _repository.listLaboratories(city: city);
}
