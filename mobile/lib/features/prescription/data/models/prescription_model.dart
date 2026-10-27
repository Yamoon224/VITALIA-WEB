import 'package:vitalia_mobile/features/prescription/domain/entities/prescription.dart';
import 'package:vitalia_mobile/features/prescription/domain/entities/prescription_status.dart';

class PrescriptionModel {
  const PrescriptionModel({
    required this.id,
    required this.status,
    required this.items,
    this.safetyAlerts = const [],
    this.refusalReason,
    this.signedAt,
    this.transmittedAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) =>
      PrescriptionModel(
        id: json['id'].toString(),
        status: PrescriptionStatus.fromApi(json['status'] as String),
        items: _mapList(json['items']),
        safetyAlerts: _mapList(json['safety_alerts']),
        refusalReason: json['refusal_reason'] as String?,
        signedAt: _parseDate(json['signed_at']),
        transmittedAt: _parseDate(json['transmitted_at']),
      );

  final String id;
  final PrescriptionStatus status;
  final List<Map<String, dynamic>> items;
  final List<Map<String, dynamic>> safetyAlerts;
  final String? refusalReason;
  final DateTime? signedAt;
  final DateTime? transmittedAt;

  static List<Map<String, dynamic>> _mapList(dynamic raw) =>
      ((raw as List<dynamic>?) ?? [])
          .map((e) => e as Map<String, dynamic>)
          .toList();

  static DateTime? _parseDate(dynamic raw) =>
      raw == null ? null : DateTime.tryParse(raw as String);

  Prescription toEntity() => Prescription(
    id: id,
    status: status,
    items: items,
    safetyAlerts: safetyAlerts,
    refusalReason: refusalReason,
    signedAt: signedAt,
    transmittedAt: transmittedAt,
  );
}
