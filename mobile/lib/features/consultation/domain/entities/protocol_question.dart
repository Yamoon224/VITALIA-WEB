import 'package:equatable/equatable.dart';

/// Question-clé d'un protocole clinique (section 5.3) : posée une par une,
/// jamais sous forme de formulaire.
class ProtocolQuestion extends Equatable {
  const ProtocolQuestion({required this.code, required this.text});

  final String code;
  final String text;

  @override
  List<Object?> get props => [code, text];
}
