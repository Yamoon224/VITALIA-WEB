import 'package:dio/dio.dart';
import 'package:vitalia_mobile/features/chat/data/models/conversation_model.dart';
import 'package:vitalia_mobile/features/chat/data/models/message_model.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation_topic.dart';

/// Seule classe du projet qui connaît la forme JSON exacte de l'API
/// `conversations` (section 11.1). Lance la `DioException` telle quelle :
/// c'est au dépôt de la traduire en [Failure] via `mapDioException`.
class ChatRemoteDataSource {
  const ChatRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ConversationModel> startConversation(ConversationTopic topic) async {
    final response = await _dio.post(
      '/conversations',
      data: {'topic': topic.apiValue},
    );

    return ConversationModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<List<ConversationModel>> listConversations() async {
    final response = await _dio.get('/conversations');
    final rows =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;

    return rows
        .map((row) => ConversationModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<MessageModel> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    final response = await _dio.post(
      '/conversations/$conversationId/messages',
      data: {'content': content},
    );

    return MessageModel.fromAssistantAnswer(
      response.data as Map<String, dynamic>,
    );
  }
}
