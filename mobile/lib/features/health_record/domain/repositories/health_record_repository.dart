import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/agent_memory_entry.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/health_profile.dart';

/// Interface de dépôt (section 11.1) : le domaine ne connaît ni Dio ni la
/// forme JSON de l'API `health-profile` / `agent-memory`.
abstract interface class HealthRecordRepository {
  Future<Result<HealthProfile>> getProfile();

  Future<Result<HealthProfile>> updateProfile(HealthProfile profile);

  Future<Result<List<AgentMemoryEntry>>> pendingMemoryEntries();

  Future<Result<AgentMemoryEntry>> acceptMemoryEntry(String entryId);

  Future<Result<AgentMemoryEntry>> rejectMemoryEntry(String entryId);
}
