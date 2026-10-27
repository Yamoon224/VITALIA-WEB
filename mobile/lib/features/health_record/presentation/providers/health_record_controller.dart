import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/health_profile.dart';
import 'package:vitalia_mobile/features/health_record/domain/usecases/get_health_profile_usecase.dart';
import 'package:vitalia_mobile/features/health_record/domain/usecases/list_pending_memory_entries_usecase.dart';
import 'package:vitalia_mobile/features/health_record/domain/usecases/review_memory_entry_usecase.dart';
import 'package:vitalia_mobile/features/health_record/domain/usecases/update_health_profile_usecase.dart';
import 'package:vitalia_mobile/features/health_record/presentation/providers/health_record_providers.dart';
import 'package:vitalia_mobile/features/health_record/presentation/providers/health_record_state.dart';

/// Décide ; ne connaît ni widget ni appel réseau direct (section 11.1).
class HealthRecordController extends StateNotifier<HealthRecordState> {
  HealthRecordController({
    required GetHealthProfileUseCase getProfile,
    required UpdateHealthProfileUseCase updateProfile,
    required ListPendingMemoryEntriesUseCase listPendingEntries,
    required ReviewMemoryEntryUseCase reviewMemoryEntry,
  }) : _getProfile = getProfile,
       _updateProfile = updateProfile,
       _listPendingEntries = listPendingEntries,
       _reviewMemoryEntry = reviewMemoryEntry,
       super(const HealthRecordState());

  final GetHealthProfileUseCase _getProfile;
  final UpdateHealthProfileUseCase _updateProfile;
  final ListPendingMemoryEntriesUseCase _listPendingEntries;
  final ReviewMemoryEntryUseCase _reviewMemoryEntry;

  Future<void> load() async {
    state = state.copyWith(isLoading: true);

    final profileResult = await _getProfile();
    final entriesResult = await _listPendingEntries();

    profileResult.when(
      success: (profile) => state = state.copyWith(profile: profile),
      failure: (failure) => state = state.copyWith(failure: failure),
    );

    entriesResult.when(
      success: (entries) => state = state.copyWith(pendingEntries: entries),
      failure: (failure) => state = state.copyWith(failure: failure),
    );

    state = state.copyWith(isLoading: false);
  }

  Future<void> saveProfile(HealthProfile profile) async {
    state = state.copyWith(isSaving: true);

    final result = await _updateProfile(profile);

    result.when(
      success: (updated) =>
          state = state.copyWith(profile: updated, isSaving: false),
      failure: (failure) =>
          state = state.copyWith(isSaving: false, failure: failure),
    );
  }

  Future<void> acceptEntry(String entryId) async {
    final result = await _reviewMemoryEntry.accept(entryId);

    result.when(
      success: (_) => _removeEntry(entryId),
      failure: (failure) => state = state.copyWith(failure: failure),
    );
  }

  Future<void> rejectEntry(String entryId) async {
    final result = await _reviewMemoryEntry.reject(entryId);

    result.when(
      success: (_) => _removeEntry(entryId),
      failure: (failure) => state = state.copyWith(failure: failure),
    );
  }

  void _removeEntry(String entryId) {
    state = state.copyWith(
      pendingEntries: state.pendingEntries
          .where((entry) => entry.id != entryId)
          .toList(),
    );
  }
}

final healthRecordControllerProvider =
    StateNotifierProvider.autoDispose<
      HealthRecordController,
      HealthRecordState
    >((ref) {
      return HealthRecordController(
        getProfile: ref.watch(getHealthProfileUseCaseProvider),
        updateProfile: ref.watch(updateHealthProfileUseCaseProvider),
        listPendingEntries: ref.watch(listPendingMemoryEntriesUseCaseProvider),
        reviewMemoryEntry: ref.watch(reviewMemoryEntryUseCaseProvider),
      );
    });
