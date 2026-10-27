import 'package:flutter_test/flutter_test.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/agent_memory_entry.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/health_profile.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/memory_entry_status.dart';
import 'package:vitalia_mobile/features/health_record/presentation/providers/health_record_state.dart';

void main() {
  group('HealthRecordState', () {
    test('starts empty and not loading', () {
      const state = HealthRecordState();

      expect(state.profile, isNull);
      expect(state.pendingEntries, isEmpty);
      expect(state.isLoading, isFalse);
    });

    test('copyWith preserves fields that are not overridden', () {
      const state = HealthRecordState(isLoading: true);

      final updated = state.copyWith(isSaving: true);

      expect(updated.isLoading, isTrue);
      expect(updated.isSaving, isTrue);
    });

    test('copyWith replaces the pending entries list', () {
      final entry = AgentMemoryEntry(
        id: '1',
        content: 'Allergie au pollen',
        status: MemoryEntryStatus.proposed,
        createdAt: DateTime(2026, 1, 1),
      );
      const state = HealthRecordState();

      final updated = state.copyWith(pendingEntries: [entry]);

      expect(updated.pendingEntries, [entry]);
    });
  });

  group('HealthProfile', () {
    test('copyWith merges fields and keeps others untouched', () {
      const profile = HealthProfile(birthYear: 1990, sex: 'female');

      final updated = profile.copyWith(heightCm: 165);

      expect(updated.birthYear, 1990);
      expect(updated.sex, 'female');
      expect(updated.heightCm, 165);
    });
  });

  group('MemoryEntryStatus', () {
    test('fromApi maps known values and defaults to proposed', () {
      expect(MemoryEntryStatus.fromApi('accepted'), MemoryEntryStatus.accepted);
      expect(MemoryEntryStatus.fromApi('rejected'), MemoryEntryStatus.rejected);
      expect(
        MemoryEntryStatus.fromApi('anything-else'),
        MemoryEntryStatus.proposed,
      );
    });
  });
}
