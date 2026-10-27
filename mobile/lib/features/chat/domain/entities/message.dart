import 'package:equatable/equatable.dart';

enum MessageSenderType { user, assistant, system }

/// Entité du domaine, sans dépendance au framework (section 11.1 : Clean
/// Architecture — `domain` ignore tout de Dio, JSON ou Flutter).
class Message extends Equatable {
  const Message({
    required this.id,
    required this.senderType,
    required this.content,
    required this.createdAt,
    this.isEmergency = false,
  });

  final String id;
  final MessageSenderType senderType;
  final String content;
  final DateTime createdAt;

  /// Produit par le code à partir du signal du backend, jamais en
  /// interprétant le texte du modèle (section 11.1).
  final bool isEmergency;

  @override
  List<Object?> get props => [id, senderType, content, createdAt, isEmergency];
}
