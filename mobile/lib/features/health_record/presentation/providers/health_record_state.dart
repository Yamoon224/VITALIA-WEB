import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/agent_memory_entry.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/health_profile.dart';

/// État immuable émis par [HealthRecordController] (section 11.1).
class HealthRecordState extends Equatable {
  const HealthRecordState({
    this.profile,
    this.pendingEntries = const [],
    this.isLoading = false,
    this.isSaving = false,
    this.failure,
  });

  final HealthProfile? profile;
  final List<AgentMemoryEntry> pendingEntries;
  final bool isLoading;
  final bool isSaving;
  final Failure? failure;

  HealthRecordState copyWith({
    HealthProfile? profile,
    List<AgentMemoryEntry>? pendingEntries,
    bool? isLoading,
    bool? isSaving,
    Failure? failure,
  }) {
    return HealthRecordState(
      profile: profile ?? this.profile,
      pendingEntries: pendingEntries ?? this.pendingEntries,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
    profile,
    pendingEntries,
    isLoading,
    isSaving,
    failure,
  ];
}
