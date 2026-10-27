import 'package:flutter_test/flutter_test.dart';
import 'package:vitalia_mobile/features/prescription/domain/entities/prescription_status.dart';
import 'package:vitalia_mobile/features/prescription/presentation/providers/prescription_state.dart';

void main() {
  group('PrescriptionState', () {
    test('starts empty and not loading', () {
      const state = PrescriptionState();

      expect(state.prescriptions, isEmpty);
      expect(state.isLoading, isFalse);
    });

    test('copyWith preserves fields that are not overridden', () {
      const state = PrescriptionState(isLoading: true);

      final updated = state.copyWith();

      expect(updated.isLoading, isTrue);
    });
  });

  group('PrescriptionStatus', () {
    test('fromApi maps every known backend value', () {
      expect(PrescriptionStatus.fromApi('draft'), PrescriptionStatus.draft);
      expect(
        PrescriptionStatus.fromApi('in_review'),
        PrescriptionStatus.inReview,
      );
      expect(PrescriptionStatus.fromApi('signed'), PrescriptionStatus.signed);
      expect(PrescriptionStatus.fromApi('refused'), PrescriptionStatus.refused);
      expect(
        PrescriptionStatus.fromApi('transmitted'),
        PrescriptionStatus.transmitted,
      );
    });

    test('fromApi defaults to draft for an unknown value', () {
      expect(PrescriptionStatus.fromApi('???'), PrescriptionStatus.draft);
    });
  });
}
