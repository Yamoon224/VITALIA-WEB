import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_item.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_request_status.dart';

/// Demande d'examens du patient (section 5.6) : brouillon généré par l'IA
/// jusqu'à validation par un praticien.
class ExaminationRequest extends Equatable {
  const ExaminationRequest({
    required this.id,
    required this.status,
    required this.items,
    this.refusalReason,
    this.validatedAt,
  });

  final String id;
  final ExaminationRequestStatus status;
  final List<ExaminationItem> items;
  final String? refusalReason;
  final DateTime? validatedAt;

  @override
  List<Object?> get props => [id, status, items, refusalReason, validatedAt];
}
