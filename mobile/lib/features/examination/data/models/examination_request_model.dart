import 'package:vitalia_mobile/features/examination/domain/entities/examination_item.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_request.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_request_status.dart';

class ExaminationRequestModel {
  const ExaminationRequestModel({
    required this.id,
    required this.status,
    required this.items,
    this.refusalReason,
    this.validatedAt,
  });

  factory ExaminationRequestModel.fromJson(Map<String, dynamic> json) =>
      ExaminationRequestModel(
        id: json['id'].toString(),
        status: ExaminationRequestStatus.fromApi(json['status'] as String),
        items: ((json['items'] as List<dynamic>?) ?? [])
            .map((raw) => _itemFromJson(raw as Map<String, dynamic>))
            .toList(),
        refusalReason: json['refusal_reason'] as String?,
        validatedAt: json['validated_at'] == null
            ? null
            : DateTime.tryParse(json['validated_at'] as String),
      );

  final String id;
  final ExaminationRequestStatus status;
  final List<ExaminationItem> items;
  final String? refusalReason;
  final DateTime? validatedAt;

  static ExaminationItem _itemFromJson(Map<String, dynamic> json) {
    final prepInstructions = json['prep_instructions'] as String?;

    return ExaminationItem(
      name: json['name'] as String,
      reason: json['reason'] as String,
      prepInstructions: prepInstructions == null || prepInstructions.isEmpty
          ? null
          : prepInstructions,
    );
  }

  ExaminationRequest toEntity() => ExaminationRequest(
    id: id,
    status: status,
    items: items,
    refusalReason: refusalReason,
    validatedAt: validatedAt,
  );
}
