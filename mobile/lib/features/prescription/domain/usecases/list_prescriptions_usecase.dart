import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/prescription/domain/entities/prescription.dart';
import 'package:vitalia_mobile/features/prescription/domain/repositories/prescription_repository.dart';

class ListPrescriptionsUseCase {
  const ListPrescriptionsUseCase(this._repository);

  final PrescriptionRepository _repository;

  Future<Result<List<Prescription>>> call() => _repository.listPrescriptions();
}
