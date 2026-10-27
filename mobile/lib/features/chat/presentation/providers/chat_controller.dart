import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation_topic.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/message.dart';
import 'package:vitalia_mobile/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:vitalia_mobile/features/chat/domain/usecases/start_conversation_usecase.dart';
import 'package:vitalia_mobile/features/chat/presentation/providers/chat_providers.dart';
import 'package:vitalia_mobile/features/chat/presentation/providers/chat_state.dart';

/// Décide ; ne connaît ni widget ni appel réseau direct (section 11.1,
/// « les widgets affichent, les gestionnaires d'état décident »).
class ChatController extends StateNotifier<ChatState> {
  ChatController({
    required StartConversationUseCase startConversation,
    required SendMessageUseCase sendMessage,
  }) : _startConversation = startConversation,
       _sendMessage = sendMessage,
       super(const ChatState());

  final StartConversationUseCase _startConversation;
  final SendMessageUseCase _sendMessage;

  Future<void> start(ConversationTopic topic) async {
    state = state.copyWith(isLoading: true);

    final result = await _startConversation(topic);

    result.when(
      success: (conversation) =>
          state = state.copyWith(conversation: conversation, isLoading: false),
      failure: (failure) =>
          state = state.copyWith(isLoading: false, failure: failure),
    );
  }

  Future<void> sendMessage(String content) async {
    final conversation = state.conversation;
    if (conversation == null || content.trim().isEmpty) {
      return;
    }

    final optimisticUserMessage = Message(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      senderType: MessageSenderType.user,
      content: content,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      conversation: conversation.copyWith(
        messages: [...conversation.messages, optimisticUserMessage],
      ),
      isSendingMessage: true,
    );

    final result = await _sendMessage(
      conversationId: conversation.id,
      content: content,
    );

    result.when(
      success: (reply) {
        final updated = state.conversation!.copyWith(
          messages: [...state.conversation!.messages, reply],
        );

        state = state.copyWith(
          conversation: updated,
          isSendingMessage: false,
          urgencyLevel: reply.isEmergency ? 'emergency' : null,
        );
      },
      failure: (failure) =>
          state = state.copyWith(isSendingMessage: false, failure: failure),
    );
  }

  /// L'utilisateur quitte l'écran d'urgence : efface le signal pour revenir
  /// au fil de conversation normal.
  void acknowledgeEmergency() {
    state = state.copyWith();
  }
}

final chatControllerProvider =
    StateNotifierProvider.autoDispose<ChatController, ChatState>((ref) {
      return ChatController(
        startConversation: ref.watch(startConversationUseCaseProvider),
        sendMessage: ref.watch(sendMessageUseCaseProvider),
      );
    });
