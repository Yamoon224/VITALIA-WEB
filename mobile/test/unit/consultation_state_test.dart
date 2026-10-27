import 'package:flutter_test/flutter_test.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_session.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_status.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/orientation_level.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/protocol_question.dart';
import 'package:vitalia_mobile/features/consultation/presentation/providers/consultation_state.dart';

ConsultationSession _session({
  ConsultationStatus status = ConsultationStatus.inProgress,
}) => ConsultationSession(
  id: '1',
  conversationId: '1',
  status: status,
  answers: const {},
);

void main() {
  group('ConsultationState', () {
    test('has not started without a session', () {
      const state = ConsultationState();

      expect(state.hasStarted, isFalse);
      expect(state.readyToFinish, isFalse);
    });

    test('is ready to finish once started with no current question', () {
      final state = ConsultationState(session: _session());

      expect(state.hasStarted, isTrue);
      expect(state.readyToFinish, isTrue);
    });

    test('is not ready to finish while a question is pending', () {
      final state = ConsultationState(
        session: _session(),
        currentQuestion: const ProtocolQuestion(
          code: 'duree',
          text: 'Depuis quand ?',
        ),
      );

      expect(state.readyToFinish, isFalse);
    });

    test('is not ready to finish once the session is completed', () {
      final state = ConsultationState(
        session: _session(status: ConsultationStatus.completed),
      );

      expect(state.readyToFinish, isFalse);
    });

    test('copyWith with clearCurrentQuestion removes the pending question', () {
      final state = ConsultationState(
        currentQuestion: const ProtocolQuestion(
          code: 'duree',
          text: 'Depuis quand ?',
        ),
      );

      final updated = state.copyWith(clearCurrentQuestion: true);

      expect(updated.currentQuestion, isNull);
    });
  });

  group('OrientationLevel', () {
    test('fromApi maps every known backend value', () {
      expect(OrientationLevel.fromApi('emergency'), OrientationLevel.emergency);
      expect(
        OrientationLevel.fromApi('urgent_consultation_24h'),
        OrientationLevel.urgentConsultation,
      );
      expect(
        OrientationLevel.fromApi('scheduled_consultation'),
        OrientationLevel.scheduledConsultation,
      );
      expect(
        OrientationLevel.fromApi('self_care_with_monitoring'),
        OrientationLevel.selfCareWithMonitoring,
      );
    });

    test('fromApi returns null for an absent or unknown value', () {
      expect(OrientationLevel.fromApi(null), isNull);
      expect(OrientationLevel.fromApi('???'), isNull);
    });
  });

  group('ConsultationSession', () {
    test('isCompleted reflects the status', () {
      expect(_session().isCompleted, isFalse);
      expect(
        _session(status: ConsultationStatus.completed).isCompleted,
        isTrue,
      );
    });
  });
}
