import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation_topic.dart';
import 'package:vitalia_mobile/features/chat/domain/repositories/chat_repository.dart';

class StartConversationUseCase {
  const StartConversationUseCase(this._repository);

  final ChatRepository _repository;

  Future<Result<Conversation>> call(ConversationTopic topic) {
    return _repository.startConversation(topic);
  }
}
