import 'package:dio/dio.dart';
import 'package:vitalia_mobile/features/prescription/data/models/prescription_model.dart';

/// Seule classe du projet qui connaît la forme JSON exacte de l'API
/// `prescriptions` (section 11.1).
class PrescriptionRemoteDataSource {
  const PrescriptionRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<PrescriptionModel>> listPrescriptions() async {
    final response = await _dio.get('/prescriptions');
    final rows =
        (response.data as Map<String, dynamic>)['data'] as List<dynamic>;

    return rows
        .map((row) => PrescriptionModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }
}
