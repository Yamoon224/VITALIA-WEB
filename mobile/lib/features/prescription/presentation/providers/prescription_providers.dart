import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/core/network/core_providers.dart';
import 'package:vitalia_mobile/features/prescription/data/datasources/prescription_remote_data_source.dart';
import 'package:vitalia_mobile/features/prescription/data/repositories/prescription_repository_impl.dart';
import 'package:vitalia_mobile/features/prescription/domain/repositories/prescription_repository.dart';
import 'package:vitalia_mobile/features/prescription/domain/usecases/list_prescriptions_usecase.dart';

final prescriptionRemoteDataSourceProvider =
    Provider<PrescriptionRemoteDataSource>(
      (ref) => PrescriptionRemoteDataSource(ref.watch(dioProvider)),
    );

final prescriptionRepositoryProvider = Provider<PrescriptionRepository>(
  (ref) => PrescriptionRepositoryImpl(
    ref.watch(prescriptionRemoteDataSourceProvider),
  ),
);

final listPrescriptionsUseCaseProvider = Provider<ListPrescriptionsUseCase>(
  (ref) => ListPrescriptionsUseCase(ref.watch(prescriptionRepositoryProvider)),
);
