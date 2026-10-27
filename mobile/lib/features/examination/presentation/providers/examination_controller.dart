import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/examination/domain/usecases/list_examination_requests_usecase.dart';
import 'package:vitalia_mobile/features/examination/domain/usecases/list_examination_results_usecase.dart';
import 'package:vitalia_mobile/features/examination/domain/usecases/list_laboratories_usecase.dart';
import 'package:vitalia_mobile/features/examination/domain/usecases/record_examination_result_usecase.dart';
import 'package:vitalia_mobile/features/examination/domain/usecases/recommend_examinations_usecase.dart';
import 'package:vitalia_mobile/features/examination/presentation/providers/examination_providers.dart';
import 'package:vitalia_mobile/features/examination/presentation/providers/examination_state.dart';

/// Décide ; ne connaît ni widget ni appel réseau direct (section 11.1).
class ExaminationController extends StateNotifier<ExaminationState> {
  ExaminationController({
    required RecommendExaminationsUseCase recommendExaminations,
    required ListExaminationRequestsUseCase listRequests,
    required ListExaminationResultsUseCase listResults,
    required RecordExaminationResultUseCase recordResult,
    required ListLaboratoriesUseCase listLaboratories,
  }) : _recommendExaminations = recommendExaminations,
       _listRequests = listRequests,
       _listResults = listResults,
       _recordResult = recordResult,
       _listLaboratories = listLaboratories,
       super(const ExaminationState());

  final RecommendExaminationsUseCase _recommendExaminations;
  final ListExaminationRequestsUseCase _listRequests;
  final ListExaminationResultsUseCase _listResults;
  final RecordExaminationResultUseCase _recordResult;
  final ListLaboratoriesUseCase _listLaboratories;

  Future<void> load() async {
    state = state.copyWith(isLoading: true);

    final requestsResult = await _listRequests();
    final resultsResult = await _listResults();
    final laboratoriesResult = await _listLaboratories();

    requestsResult.when(
      success: (requests) => state = state.copyWith(requests: requests),
      failure: (failure) => state = state.copyWith(failure: failure),
    );

    resultsResult.when(
      success: (results) => state = state.copyWith(results: results),
      failure: (failure) => state = state.copyWith(failure: failure),
    );

    laboratoriesResult.when(
      success: (laboratories) =>
          state = state.copyWith(laboratories: laboratories),
      failure: (failure) => state = state.copyWith(failure: failure),
    );

    state = state.copyWith(isLoading: false);
  }

  Future<void> requestRecommendation() async {
    state = state.copyWith(isRecommending: true);

    final result = await _recommendExaminations();

    result.when(
      success: (request) => state = state.copyWith(
        requests: [request, ...state.requests],
        isRecommending: false,
      ),
      failure: (failure) =>
          state = state.copyWith(isRecommending: false, failure: failure),
    );
  }

  Future<void> recordResult({
    required String parameter,
    required double value,
    required String unit,
    double? referenceLow,
    double? referenceHigh,
  }) async {
    state = state.copyWith(isSavingResult: true);

    final result = await _recordResult(
      parameter: parameter,
      value: value,
      unit: unit,
      referenceLow: referenceLow,
      referenceHigh: referenceHigh,
    );

    result.when(
      success: (entry) => state = state.copyWith(
        results: [entry, ...state.results],
        isSavingResult: false,
      ),
      failure: (failure) =>
          state = state.copyWith(isSavingResult: false, failure: failure),
    );
  }

  Future<void> filterLaboratoriesByCity(String city) async {
    final result = await _listLaboratories(city: city);

    result.when(
      success: (laboratories) =>
          state = state.copyWith(laboratories: laboratories),
      failure: (failure) => state = state.copyWith(failure: failure),
    );
  }
}

final examinationControllerProvider =
    StateNotifierProvider.autoDispose<ExaminationController, ExaminationState>((
      ref,
    ) {
      return ExaminationController(
        recommendExaminations: ref.watch(recommendExaminationsUseCaseProvider),
        listRequests: ref.watch(listExaminationRequestsUseCaseProvider),
        listResults: ref.watch(listExaminationResultsUseCaseProvider),
        recordResult: ref.watch(recordExaminationResultUseCaseProvider),
        listLaboratories: ref.watch(listLaboratoriesUseCaseProvider),
      );
    });
