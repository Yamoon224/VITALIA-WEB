import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation_topic.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/message.dart';

/// Interface de dépôt (section 11.1 : les dépôts accèdent aux données, les
/// cas d'usage appliquent les règles). Permet un faux dépôt dans les tests.
abstract interface class ChatRepository {
  Future<Result<Conversation>> startConversation(ConversationTopic topic);

  Future<Result<List<Conversation>>> listConversations();

  Future<Result<Message>> sendMessage({
    required String conversationId,
    required String content,
  });
}
