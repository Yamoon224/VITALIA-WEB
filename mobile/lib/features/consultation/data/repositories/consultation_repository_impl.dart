import 'package:dio/dio.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/core/network/api_client.dart';
import 'package:vitalia_mobile/features/consultation/data/datasources/consultation_remote_data_source.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_session.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/protocol_question.dart';
import 'package:vitalia_mobile/features/consultation/domain/repositories/consultation_repository.dart';

class ConsultationRepositoryImpl implements ConsultationRepository {
  const ConsultationRepositoryImpl(this._remote);

  final ConsultationRemoteDataSource _remote;

  @override
  Future<Result<ConsultationSession>> start({String? motif}) =>
      _guard(() async => (await _remote.start(motif: motif)).toEntity());

  @override
  Future<Result<ProtocolQuestion?>> nextQuestion(String conversationId) =>
      _guard(() async {
        final raw = await _remote.nextQuestion(conversationId);

        return raw == null
            ? null
            : ProtocolQuestion(code: raw['code']!, text: raw['text']!);
      });

  @override
  Future<Result<ConsultationSession>> answer({
    required String conversationId,
    required String questionCode,
    required String answer,
  }) => _guard(
    () async => (await _remote.answer(
      conversationId: conversationId,
      questionCode: questionCode,
      answer: answer,
    )).toEntity(),
  );

  @override
  Future<Result<ConsultationSession>> finish(String conversationId) =>
      _guard(() async => (await _remote.finish(conversationId)).toEntity());

  /// Traduit toute `DioException` en [Failure] typée (section 11.1).
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
