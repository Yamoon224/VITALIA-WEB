import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/core/network/core_providers.dart';
import 'package:vitalia_mobile/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:vitalia_mobile/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:vitalia_mobile/features/chat/domain/repositories/chat_repository.dart';
import 'package:vitalia_mobile/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:vitalia_mobile/features/chat/domain/usecases/start_conversation_usecase.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>(
  (ref) => ChatRemoteDataSource(ref.watch(dioProvider)),
);

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepositoryImpl(ref.watch(chatRemoteDataSourceProvider)),
);

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>(
  (ref) => SendMessageUseCase(ref.watch(chatRepositoryProvider)),
);

final startConversationUseCaseProvider = Provider<StartConversationUseCase>(
  (ref) => StartConversationUseCase(ref.watch(chatRepositoryProvider)),
);
