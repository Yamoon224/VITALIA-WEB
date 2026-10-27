import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/core/network/core_providers.dart';
import 'package:vitalia_mobile/features/examination/data/datasources/examination_remote_data_source.dart';
import 'package:vitalia_mobile/features/examination/data/repositories/examination_repository_impl.dart';
import 'package:vitalia_mobile/features/examination/domain/repositories/examination_repository.dart';
import 'package:vitalia_mobile/features/examination/domain/usecases/list_examination_requests_usecase.dart';
import 'package:vitalia_mobile/features/examination/domain/usecases/list_examination_results_usecase.dart';
import 'package:vitalia_mobile/features/examination/domain/usecases/list_laboratories_usecase.dart';
import 'package:vitalia_mobile/features/examination/domain/usecases/record_examination_result_usecase.dart';
import 'package:vitalia_mobile/features/examination/domain/usecases/recommend_examinations_usecase.dart';

final examinationRemoteDataSourceProvider =
    Provider<ExaminationRemoteDataSource>(
      (ref) => ExaminationRemoteDataSource(ref.watch(dioProvider)),
    );

final examinationRepositoryProvider = Provider<ExaminationRepository>(
  (ref) =>
      ExaminationRepositoryImpl(ref.watch(examinationRemoteDataSourceProvider)),
);

final recommendExaminationsUseCaseProvider =
    Provider<RecommendExaminationsUseCase>(
      (ref) => RecommendExaminationsUseCase(
        ref.watch(examinationRepositoryProvider),
      ),
    );

final listExaminationRequestsUseCaseProvider =
    Provider<ListExaminationRequestsUseCase>(
      (ref) => ListExaminationRequestsUseCase(
        ref.watch(examinationRepositoryProvider),
      ),
    );

final listExaminationResultsUseCaseProvider =
    Provider<ListExaminationResultsUseCase>(
      (ref) => ListExaminationResultsUseCase(
        ref.watch(examinationRepositoryProvider),
      ),
    );

final recordExaminationResultUseCaseProvider =
    Provider<RecordExaminationResultUseCase>(
      (ref) => RecordExaminationResultUseCase(
        ref.watch(examinationRepositoryProvider),
      ),
    );

final listLaboratoriesUseCaseProvider = Provider<ListLaboratoriesUseCase>(
  (ref) => ListLaboratoriesUseCase(ref.watch(examinationRepositoryProvider)),
);
