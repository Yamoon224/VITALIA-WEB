import 'package:equatable/equatable.dart';

/// Examen recommandé (section 5.6) : justifié par la situation clinique,
/// avec sa préparation éventuelle. Produit par l'IA, jamais par le mobile.
class ExaminationItem extends Equatable {
  const ExaminationItem({
    required this.name,
    required this.reason,
    this.prepInstructions,
  });

  final String name;
  final String reason;
  final String? prepInstructions;

  @override
  List<Object?> get props => [name, reason, prepInstructions];
}
