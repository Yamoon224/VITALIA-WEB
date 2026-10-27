import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_request.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_result.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/laboratory.dart';

/// Interface de dépôt (section 11.1) : le domaine ne connaît ni Dio ni la
/// forme JSON des API `conversations`, `examination-requests`,
/// `examination-results` et `laboratories`.
abstract interface class ExaminationRepository {
  /// Crée la conversation support puis demande une recommandation d'examens
  /// justifiée par son contenu (section 5.6).
  Future<Result<ExaminationRequest>> recommendExaminations();

  Future<Result<List<ExaminationRequest>>> listRequests();

  Future<Result<List<ExaminationResult>>> listResults();

  Future<Result<ExaminationResult>> recordResult({
    required String parameter,
    required double value,
    required String unit,
    double? referenceLow,
    double? referenceHigh,
    String? examinationRequestId,
  });

  Future<Result<List<Laboratory>>> listLaboratories({String? city});
}
