import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_request.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_result.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/laboratory.dart';

/// État immuable émis par [ExaminationController] (section 11.1).
class ExaminationState extends Equatable {
  const ExaminationState({
    this.requests = const [],
    this.results = const [],
    this.laboratories = const [],
    this.isLoading = false,
    this.isRecommending = false,
    this.isSavingResult = false,
    this.failure,
  });

  final List<ExaminationRequest> requests;
  final List<ExaminationResult> results;
  final List<Laboratory> laboratories;
  final bool isLoading;
  final bool isRecommending;
  final bool isSavingResult;
  final Failure? failure;

  ExaminationState copyWith({
    List<ExaminationRequest>? requests,
    List<ExaminationResult>? results,
    List<Laboratory>? laboratories,
    bool? isLoading,
    bool? isRecommending,
    bool? isSavingResult,
    Failure? failure,
  }) {
    return ExaminationState(
      requests: requests ?? this.requests,
      results: results ?? this.results,
      laboratories: laboratories ?? this.laboratories,
      isLoading: isLoading ?? this.isLoading,
      isRecommending: isRecommending ?? this.isRecommending,
      isSavingResult: isSavingResult ?? this.isSavingResult,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    requests,
    results,
    laboratories,
    isLoading,
    isRecommending,
    isSavingResult,
    failure,
  ];
}
