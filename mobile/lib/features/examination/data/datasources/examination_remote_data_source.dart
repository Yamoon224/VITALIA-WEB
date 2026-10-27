import 'package:dio/dio.dart';
import 'package:vitalia_mobile/features/examination/data/models/examination_request_model.dart';
import 'package:vitalia_mobile/features/examination/data/models/examination_result_model.dart';
import 'package:vitalia_mobile/features/examination/data/models/laboratory_model.dart';

/// Seule classe du projet qui connaît la forme JSON exacte des API
/// `conversations`, `examination-requests`, `examination-results` et
/// `laboratories` (section 11.1).
class ExaminationRemoteDataSource {
  const ExaminationRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ExaminationRequestModel> recommendExaminations() async {
    final conversationId = await _startConversation();

    final response = await _dio.post(
      '/conversations/$conversationId/examination-recommendation',
    );

    return ExaminationRequestModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<String> _startConversation() async {
    final response = await _dio.post(
      '/conversations',
      data: {'topic': 'exam_results'},
    );

    return ((response.data as Map<String, dynamic>)['data']
            as Map<String, dynamic>)['id']
        .toString();
  }

  Future<List<ExaminationRequestModel>> listRequests() async {
    final response = await _dio.get('/examination-requests');
    final rows =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;

    return rows
        .map(
          (row) =>
              ExaminationRequestModel.fromJson(row as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<ExaminationResultModel>> listResults() async {
    final response = await _dio.get('/examination-results');
    final rows =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;

    return rows
        .map(
          (row) => ExaminationResultModel.fromJson(row as Map<String, dynamic>),
        )
        .toList();
  }

  Future<ExaminationResultModel> recordResult({
    required String parameter,
    required double value,
    required String unit,
    double? referenceLow,
    double? referenceHigh,
    String? examinationRequestId,
  }) async {
    final response = await _dio.post(
      '/examination-results',
      data: {
        'parameter': parameter,
        'value': value,
        'unit': unit,
        'reference_low': referenceLow,
        'reference_high': referenceHigh,
        'examination_request_id': examinationRequestId,
      },
    );

    return ExaminationResultModel.fromJson(
      (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
    );
  }

  Future<List<LaboratoryModel>> listLaboratories({String? city}) async {
    final response = await _dio.get(
      '/laboratories',
      queryParameters: city == null || city.isEmpty ? null : {'city': city},
    );
    final rows =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;

    return rows
        .map((row) => LaboratoryModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }
}
