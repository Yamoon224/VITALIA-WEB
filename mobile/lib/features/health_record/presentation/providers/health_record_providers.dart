import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/core/network/core_providers.dart';
import 'package:vitalia_mobile/features/health_record/data/datasources/health_record_remote_data_source.dart';
import 'package:vitalia_mobile/features/health_record/data/repositories/health_record_repository_impl.dart';
import 'package:vitalia_mobile/features/health_record/domain/repositories/health_record_repository.dart';
import 'package:vitalia_mobile/features/health_record/domain/usecases/get_health_profile_usecase.dart';
import 'package:vitalia_mobile/features/health_record/domain/usecases/list_pending_memory_entries_usecase.dart';
import 'package:vitalia_mobile/features/health_record/domain/usecases/review_memory_entry_usecase.dart';
import 'package:vitalia_mobile/features/health_record/domain/usecases/update_health_profile_usecase.dart';

final healthRecordRemoteDataSourceProvider =
    Provider<HealthRecordRemoteDataSource>(
      (ref) => HealthRecordRemoteDataSource(ref.watch(dioProvider)),
    );

final healthRecordRepositoryProvider = Provider<HealthRecordRepository>(
  (ref) => HealthRecordRepositoryImpl(
    ref.watch(healthRecordRemoteDataSourceProvider),
  ),
);

final getHealthProfileUseCaseProvider = Provider<GetHealthProfileUseCase>(
  (ref) => GetHealthProfileUseCase(ref.watch(healthRecordRepositoryProvider)),
);

final updateHealthProfileUseCaseProvider = Provider<UpdateHealthProfileUseCase>(
  (ref) =>
      UpdateHealthProfileUseCase(ref.watch(healthRecordRepositoryProvider)),
);

final listPendingMemoryEntriesUseCaseProvider =
    Provider<ListPendingMemoryEntriesUseCase>(
      (ref) => ListPendingMemoryEntriesUseCase(
        ref.watch(healthRecordRepositoryProvider),
      ),
    );

final reviewMemoryEntryUseCaseProvider = Provider<ReviewMemoryEntryUseCase>(
  (ref) => ReviewMemoryEntryUseCase(ref.watch(healthRecordRepositoryProvider)),
);
