import 'package:vitalia_mobile/features/chat/domain/entities/message.dart';

/// DTO de la couche `data` (section 11.1) : traduit le JSON de l'API en
/// entité de domaine via [toEntity]. Le domaine ne voit jamais ce type.
class MessageModel {
  const MessageModel({
    required this.id,
    required this.senderType,
    required this.content,
    required this.createdAt,
    this.isEmergency = false,
    this.urgencyLevel,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'].toString(),
    senderType: _senderTypeFrom(json['sender_type'] as String? ?? 'assistant'),
    content: json['content'] as String,
    createdAt:
        DateTime.tryParse(json['created_at'] as String? ?? '') ??
        DateTime.now(),
    isEmergency: json['is_emergency'] as bool? ?? false,
    urgencyLevel: json['urgency_level'] as String?,
  );

  /// La réponse de `POST /conversations/{id}/messages` (section 11.1,
  /// `ConversationController::sendMessage`) n'est pas une ressource complète
  /// : pas d'identifiant persistant, juste le texte et les deux champs de
  /// sécurité produits par le code côté serveur.
  factory MessageModel.fromAssistantAnswer(Map<String, dynamic> json) =>
      MessageModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        senderType: MessageSenderType.assistant,
        content: json['content'] as String,
        createdAt: DateTime.now(),
        isEmergency: json['is_emergency'] as bool? ?? false,
        urgencyLevel: json['urgency_level'] as String?,
      );

  final String id;
  final MessageSenderType senderType;
  final String content;
  final DateTime createdAt;
  final bool isEmergency;
  final String? urgencyLevel;

  Message toEntity() => Message(
    id: id,
    senderType: senderType,
    content: content,
    createdAt: createdAt,
    isEmergency: isEmergency,
  );

  static MessageSenderType _senderTypeFrom(String value) => switch (value) {
    'user' => MessageSenderType.user,
    'system' => MessageSenderType.system,
    _ => MessageSenderType.assistant,
  };
}
