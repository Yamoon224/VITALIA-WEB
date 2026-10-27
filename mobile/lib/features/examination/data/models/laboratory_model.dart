import 'package:vitalia_mobile/features/examination/domain/entities/laboratory.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/laboratory_type.dart';

class LaboratoryModel {
  const LaboratoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.address,
    this.latitude,
    this.longitude,
    this.phone,
  });

  factory LaboratoryModel.fromJson(Map<String, dynamic> json) =>
      LaboratoryModel(
        id: json['id'].toString(),
        name: json['name'] as String,
        type: LaboratoryType.fromApi(json['type'] as String),
        city: json['city'] as String,
        address: json['address'] as String,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        phone: json['phone'] as String?,
      );

  final String id;
  final String name;
  final LaboratoryType type;
  final String city;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? phone;

  Laboratory toEntity() => Laboratory(
    id: id,
    name: name,
    type: type,
    city: city,
    address: address,
    latitude: latitude,
    longitude: longitude,
    phone: phone,
  );
}
