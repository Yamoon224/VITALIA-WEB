import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/prescription/domain/entities/prescription.dart';

/// Interface de dépôt (section 11.1) : le domaine ne connaît ni Dio ni la
/// forme JSON de l'API `prescriptions`.
abstract interface class PrescriptionRepository {
  Future<Result<List<Prescription>>> listPrescriptions();
}
