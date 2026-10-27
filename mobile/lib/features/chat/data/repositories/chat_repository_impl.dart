import 'package:dio/dio.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/core/network/api_client.dart';
import 'package:vitalia_mobile/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/conversation_topic.dart';
import 'package:vitalia_mobile/features/chat/domain/entities/message.dart';
import 'package:vitalia_mobile/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._remote);

  final ChatRemoteDataSource _remote;

  @override
  Future<Result<Conversation>> startConversation(ConversationTopic topic) =>
      _guard(() async => (await _remote.startConversation(topic)).toEntity());

  @override
  Future<Result<List<Conversation>>> listConversations() => _guard(
    () async =>
        (await _remote.listConversations()).map((c) => c.toEntity()).toList(),
  );

  @override
  Future<Result<Message>> sendMessage({
    required String conversationId,
    required String content,
  }) => _guard(
    () async => (await _remote.sendMessage(
      conversationId: conversationId,
      content: content,
    )).toEntity(),
  );

  /// Traduit toute `DioException` en [Failure] typée (section 11.1) : le
  /// reste de l'application ne manipule jamais Dio directement.
  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Result.success(await action());
    } on DioException catch (exception) {
      return Result.failure(mapDioException(exception));
    } catch (_) {
      return const Result.failure(UnknownFailure());
    }
  }
}
