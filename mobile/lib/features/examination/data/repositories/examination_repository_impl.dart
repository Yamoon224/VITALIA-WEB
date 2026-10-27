import 'package:dio/dio.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/core/network/api_client.dart';
import 'package:vitalia_mobile/features/examination/data/datasources/examination_remote_data_source.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_request.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_result.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/laboratory.dart';
import 'package:vitalia_mobile/features/examination/domain/repositories/examination_repository.dart';

class ExaminationRepositoryImpl implements ExaminationRepository {
  const ExaminationRepositoryImpl(this._remote);

  final ExaminationRemoteDataSource _remote;

  @override
  Future<Result<ExaminationRequest>> recommendExaminations() =>
      _guard(() async => (await _remote.recommendExaminations()).toEntity());

  @override
  Future<Result<List<ExaminationRequest>>> listRequests() => _guard(
    () async =>
        (await _remote.listRequests()).map((r) => r.toEntity()).toList(),
  );

  @override
  Future<Result<List<ExaminationResult>>> listResults() => _guard(
    () async => (await _remote.listResults()).map((r) => r.toEntity()).toList(),
  );

  @override
  Future<Result<ExaminationResult>> recordResult({
    required String parameter,
    required double value,
    required String unit,
    double? referenceLow,
    double? referenceHigh,
    String? examinationRequestId,
  }) => _guard(
    () async => (await _remote.recordResult(
      parameter: parameter,
      value: value,
      unit: unit,
      referenceLow: referenceLow,
      referenceHigh: referenceHigh,
      examinationRequestId: examinationRequestId,
    )).toEntity(),
  );

  @override
  Future<Result<List<Laboratory>>> listLaboratories({String? city}) => _guard(
    () async => (await _remote.listLaboratories(
      city: city,
    )).map((l) => l.toEntity()).toList(),
  );

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
