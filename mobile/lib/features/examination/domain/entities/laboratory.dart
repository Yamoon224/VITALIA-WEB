import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/laboratory_type.dart';

/// Laboratoire ou centre d'imagerie partenaire (section 5.6) : annuaire
/// géolocalisé vers lequel orienter le patient.
class Laboratory extends Equatable {
  const Laboratory({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.address,
    this.latitude,
    this.longitude,
    this.phone,
  });

  final String id;
  final String name;
  final LaboratoryType type;
  final String city;
  final String address;
  final double? latitude;
  final double? longitude;
  final String? phone;

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    city,
    address,
    latitude,
    longitude,
    phone,
  ];
}
