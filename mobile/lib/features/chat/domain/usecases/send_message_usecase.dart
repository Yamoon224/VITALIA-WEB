import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/message.dart';
import 'package:vitalia_mobile/features/chat/domain/repositories/chat_repository.dart';

/// Un cas d'usage = une classe (section 11.1), symétrique des `Action`
/// Laravel du backend (section 10.1).
class SendMessageUseCase {
  const SendMessageUseCase(this._repository);

  final ChatRepository _repository;

  Future<Result<Message>> call({
    required String conversationId,
    required String content,
  }) {
    return _repository.sendMessage(
      conversationId: conversationId,
      content: content,
    );
  }
}
