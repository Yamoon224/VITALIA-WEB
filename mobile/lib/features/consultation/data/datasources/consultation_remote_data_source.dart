import 'package:dio/dio.dart';
import 'package:vitalia_mobile/features/consultation/data/models/consultation_session_model.dart';

/// Seule classe du projet qui connaît la forme JSON exacte des API
/// `conversations` et `consultation` (section 11.1).
class ConsultationRemoteDataSource {
  const ConsultationRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ConsultationSessionModel> start({String? motif}) async {
    final conversationId = await _startConversation();

    final response = await _dio.post(
      '/conversations/$conversationId/consultation/start',
      data: {if (motif != null && motif.isNotEmpty) 'motif': motif},
    );

    return ConsultationSessionModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<String> _startConversation() async {
    final response = await _dio.post(
      '/conversations',
      data: {'topic': 'consultation'},
    );

    return ((response.data as Map<String, dynamic>)['data']
            as Map<String, dynamic>)['id']
        .toString();
  }

  Future<Map<String, String>?> nextQuestion(String conversationId) async {
    final response = await _dio.get(
      '/conversations/$conversationId/consultation/next-question',
    );
    final data = (response.data as Map<String, dynamic>)['data'];

    if (data == null) {
      return null;
    }

    final question = data as Map<String, dynamic>;

    return {
      'code': question['code'] as String,
      'text': question['text'] as String,
    };
  }

  Future<ConsultationSessionModel> answer({
    required String conversationId,
    required String questionCode,
    required String answer,
  }) async {
    final response = await _dio.post(
      '/conversations/$conversationId/consultation/answer',
      data: {'question_code': questionCode, 'answer': answer},
    );

    return ConsultationSessionModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<ConsultationSessionModel> finish(String conversationId) async {
    final response = await _dio.post(
      '/conversations/$conversationId/consultation/finish',
    );

    return ConsultationSessionModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }
}
