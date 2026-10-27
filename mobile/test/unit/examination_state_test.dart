import 'package:flutter_test/flutter_test.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_request_status.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/laboratory_type.dart';
import 'package:vitalia_mobile/features/examination/presentation/providers/examination_state.dart';

void main() {
  group('ExaminationState', () {
    test('starts empty and not loading', () {
      const state = ExaminationState();

      expect(state.requests, isEmpty);
      expect(state.results, isEmpty);
      expect(state.laboratories, isEmpty);
      expect(state.isLoading, isFalse);
    });

    test('copyWith preserves fields that are not overridden', () {
      const state = ExaminationState(isLoading: true);

      final updated = state.copyWith(isRecommending: true);

      expect(updated.isLoading, isTrue);
      expect(updated.isRecommending, isTrue);
    });
  });

  group('ExaminationRequestStatus', () {
    test('fromApi maps every known backend value', () {
      expect(
        ExaminationRequestStatus.fromApi('draft'),
        ExaminationRequestStatus.draft,
      );
      expect(
        ExaminationRequestStatus.fromApi('validated'),
        ExaminationRequestStatus.validated,
      );
      expect(
        ExaminationRequestStatus.fromApi('refused'),
        ExaminationRequestStatus.refused,
      );
    });

    test('fromApi defaults to draft for an unknown value', () {
      expect(
        ExaminationRequestStatus.fromApi('???'),
        ExaminationRequestStatus.draft,
      );
    });
  });

  group('LaboratoryType', () {
    test('fromApi maps known values and defaults to laboratory', () {
      expect(
        LaboratoryType.fromApi('imaging_center'),
        LaboratoryType.imagingCenter,
      );
      expect(LaboratoryType.fromApi('laboratory'), LaboratoryType.laboratory);
      expect(LaboratoryType.fromApi('???'), LaboratoryType.laboratory);
    });
  });
}
