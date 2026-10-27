import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_session.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/protocol_question.dart';

/// État immuable émis par [ConsultationController] (section 11.1).
class ConsultationState extends Equatable {
  const ConsultationState({
    this.session,
    this.currentQuestion,
    this.isLoading = false,
    this.isSubmitting = false,
    this.failure,
  });

  final ConsultationSession? session;

  /// Prochaine question du protocole, ou `null` une fois toutes répondues
  /// (section 5.3 : posées une par une, jamais sous forme de formulaire).
  final ProtocolQuestion? currentQuestion;
  final bool isLoading;
  final bool isSubmitting;
  final Failure? failure;

  bool get hasStarted => session != null;

  /// Toutes les questions du protocole ont une réponse, prêt pour `finish`.
  bool get readyToFinish =>
      hasStarted && !session!.isCompleted && currentQuestion == null;

  ConsultationState copyWith({
    ConsultationSession? session,
    ProtocolQuestion? currentQuestion,
    bool clearCurrentQuestion = false,
    bool? isLoading,
    bool? isSubmitting,
    Failure? failure,
  }) {
    return ConsultationState(
      session: session ?? this.session,
      currentQuestion: clearCurrentQuestion
          ? null
          : (currentQuestion ?? this.currentQuestion),
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    session,
    currentQuestion,
    isLoading,
    isSubmitting,
    failure,
  ];
}
