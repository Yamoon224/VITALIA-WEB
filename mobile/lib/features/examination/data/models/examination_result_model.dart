import 'package:vitalia_mobile/features/examination/domain/entities/examination_result.dart';

class ExaminationResultModel {
  const ExaminationResultModel({
    required this.id,
    required this.parameter,
    required this.value,
    required this.unit,
    required this.isAbnormal,
    required this.recordedAt,
    this.referenceLow,
    this.referenceHigh,
  });

  factory ExaminationResultModel.fromJson(Map<String, dynamic> json) =>
      ExaminationResultModel(
        id: json['id'].toString(),
        parameter: json['parameter'] as String,
        value: (json['value'] as num).toDouble(),
        unit: json['unit'] as String,
        referenceLow: (json['reference_low'] as num?)?.toDouble(),
        referenceHigh: (json['reference_high'] as num?)?.toDouble(),
        isAbnormal: json['is_abnormal'] as bool? ?? false,
        recordedAt:
            DateTime.tryParse(json['recorded_at'] as String? ?? '') ??
            DateTime.now(),
      );

  final String id;
  final String parameter;
  final double value;
  final String unit;
  final double? referenceLow;
  final double? referenceHigh;
  final bool isAbnormal;
  final DateTime recordedAt;

  ExaminationResult toEntity() => ExaminationResult(
    id: id,
    parameter: parameter,
    value: value,
    unit: unit,
    referenceLow: referenceLow,
    referenceHigh: referenceHigh,
    isAbnormal: isAbnormal,
    recordedAt: recordedAt,
  );
}
