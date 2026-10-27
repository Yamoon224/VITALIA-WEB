import 'package:dio/dio.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/core/network/api_client.dart';
import 'package:vitalia_mobile/features/prescription/data/datasources/prescription_remote_data_source.dart';
import 'package:vitalia_mobile/features/prescription/domain/entities/prescription.dart';
import 'package:vitalia_mobile/features/prescription/domain/repositories/prescription_repository.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  const PrescriptionRepositoryImpl(this._remote);

  final PrescriptionRemoteDataSource _remote;

  @override
  Future<Result<List<Prescription>>> listPrescriptions() => _guard(
    () async =>
        (await _remote.listPrescriptions()).map((p) => p.toEntity()).toList(),
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
