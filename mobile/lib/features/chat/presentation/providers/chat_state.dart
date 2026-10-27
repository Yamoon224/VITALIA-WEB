import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation.dart';

/// État immuable émis par [ChatController] (section 11.1 : BLoC/Cubit —
/// les évènements entrent, des états immuables sortent).
class ChatState extends Equatable {
  const ChatState({
    this.conversation,
    this.isLoading = false,
    this.isSendingMessage = false,
    this.failure,
    this.urgencyLevel,
  });

  final Conversation? conversation;
  final bool isLoading;
  final bool isSendingMessage;
  final Failure? failure;

  /// Non nul quand la dernière réponse a déclenché un signal d'urgence.
  /// L'écran d'urgence est affiché par le code sur la base de ce champ,
  /// jamais en interprétant le texte du message (section 11.1).
  final String? urgencyLevel;

  bool get hasEmergency => urgencyLevel != null;

  ChatState copyWith({
    Conversation? conversation,
    bool? isLoading,
    bool? isSendingMessage,
    Failure? failure,
    String? urgencyLevel,
  }) {
    return ChatState(
      conversation: conversation ?? this.conversation,
      isLoading: isLoading ?? this.isLoading,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      failure: failure,
      urgencyLevel: urgencyLevel,
    );
  }

  @override
  List<Object?> get props => [
    conversation,
    isLoading,
    isSendingMessage,
    failure,
    urgencyLevel,
  ];
}
