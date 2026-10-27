import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/consultation/domain/usecases/answer_consultation_question_usecase.dart';
import 'package:vitalia_mobile/features/consultation/domain/usecases/finish_consultation_usecase.dart';
import 'package:vitalia_mobile/features/consultation/domain/usecases/get_next_question_usecase.dart';
import 'package:vitalia_mobile/features/consultation/domain/usecases/start_consultation_usecase.dart';
import 'package:vitalia_mobile/features/consultation/presentation/providers/consultation_providers.dart';
import 'package:vitalia_mobile/features/consultation/presentation/providers/consultation_state.dart';

/// Décide ; ne connaît ni widget ni appel réseau direct (section 11.1).
class ConsultationController extends StateNotifier<ConsultationState> {
  ConsultationController({
    required StartConsultationUseCase startConsultation,
    required GetNextQuestionUseCase getNextQuestion,
    required AnswerConsultationQuestionUseCase answerQuestion,
    required FinishConsultationUseCase finishConsultation,
  }) : _startConsultation = startConsultation,
       _getNextQuestion = getNextQuestion,
       _answerQuestion = answerQuestion,
       _finishConsultation = finishConsultation,
       super(const ConsultationState());

  final StartConsultationUseCase _startConsultation;
  final GetNextQuestionUseCase _getNextQuestion;
  final AnswerConsultationQuestionUseCase _answerQuestion;
  final FinishConsultationUseCase _finishConsultation;

  Future<void> start({String? motif}) async {
    state = state.copyWith(isLoading: true);

    final result = await _startConsultation(motif: motif);

    final session = result.when(
      success: (session) {
        state = state.copyWith(session: session);
        return session;
      },
      failure: (failure) {
        state = state.copyWith(isLoading: false, failure: failure);
        return null;
      },
    );

    if (session != null) {
      await _loadNextQuestion(session.conversationId);
    }

    state = state.copyWith(isLoading: false);
  }

  Future<void> submitAnswer(String answerText) async {
    final session = state.session;
    final question = state.currentQuestion;
    if (session == null || question == null || answerText.trim().isEmpty) {
      return;
    }

    state = state.copyWith(isSubmitting: true);

    final result = await _answerQuestion(
      conversationId: session.conversationId,
      questionCode: question.code,
      answer: answerText.trim(),
    );

    final updated = result.when(
      success: (updated) {
        state = state.copyWith(session: updated);
        return updated;
      },
      failure: (failure) {
        state = state.copyWith(isSubmitting: false, failure: failure);
        return null;
      },
    );

    if (updated != null) {
      await _loadNextQuestion(updated.conversationId);
    }

    state = state.copyWith(isSubmitting: false);
  }

  Future<void> finish() async {
    final session = state.session;
    if (session == null) {
      return;
    }

    state = state.copyWith(isSubmitting: true);

    final result = await _finishConsultation(session.conversationId);

    result.when(
      success: (completed) => state = state.copyWith(
        session: completed,
        isSubmitting: false,
        clearCurrentQuestion: true,
      ),
      failure: (failure) =>
          state = state.copyWith(isSubmitting: false, failure: failure),
    );
  }

  /// Nouvel entretien : repart d'un état vierge (section 5.3, un entretien
  /// par conversation).
  void reset() {
    state = const ConsultationState();
  }

  Future<void> _loadNextQuestion(String conversationId) async {
    final result = await _getNextQuestion(conversationId);

    result.when(
      success: (question) => state = state.copyWith(
        currentQuestion: question,
        clearCurrentQuestion: question == null,
      ),
      failure: (failure) => state = state.copyWith(failure: failure),
    );
  }
}

final consultationControllerProvider =
    StateNotifierProvider.autoDispose<
      ConsultationController,
      ConsultationState
    >((ref) {
      return ConsultationController(
        startConsultation: ref.watch(startConsultationUseCaseProvider),
        getNextQuestion: ref.watch(getNextQuestionUseCaseProvider),
        answerQuestion: ref.watch(answerConsultationQuestionUseCaseProvider),
        finishConsultation: ref.watch(finishConsultationUseCaseProvider),
      );
    });
