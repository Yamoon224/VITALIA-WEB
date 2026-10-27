import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation_topic.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/message.dart';

class Conversation extends Equatable {
  const Conversation({
    required this.id,
    required this.topic,
    this.messages = const [],
  });

  final String id;
  final ConversationTopic topic;
  final List<Message> messages;

  Conversation copyWith({List<Message>? messages}) =>
      Conversation(id: id, topic: topic, messages: messages ?? this.messages);

  @override
  List<Object?> get props => [id, topic, messages];
}
