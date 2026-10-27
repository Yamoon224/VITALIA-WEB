import 'package:vitalia_mobile/features/chat/data/models/message_model.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation_topic.dart';

class ConversationModel {
  const ConversationModel({
    required this.id,
    required this.topic,
    this.messages = const [],
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json['id'].toString(),
        topic: _topicFrom(json['topic'] as String? ?? 'consultation'),
        messages: ((json['messages'] as List<dynamic>?) ?? [])
            .map((raw) => MessageModel.fromJson(raw as Map<String, dynamic>))
            .toList(),
      );

  final String id;
  final ConversationTopic topic;
  final List<MessageModel> messages;

  Conversation toEntity() => Conversation(
    id: id,
    topic: topic,
    messages: messages.map((m) => m.toEntity()).toList(),
  );

  static ConversationTopic _topicFrom(String value) => switch (value) {
    'exam_results' => ConversationTopic.examResults,
    'wellness' => ConversationTopic.wellness,
    'follow_up' => ConversationTopic.followUp,
    _ => ConversationTopic.consultation,
  };
}
