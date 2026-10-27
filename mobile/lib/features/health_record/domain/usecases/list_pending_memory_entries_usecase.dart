import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/agent_memory_entry.dart';
import 'package:vitalia_mobile/features/health_record/domain/repositories/health_record_repository.dart';

class ListPendingMemoryEntriesUseCase {
  const ListPendingMemoryEntriesUseCase(this._repository);

  final HealthRecordRepository _repository;

  Future<Result<List<AgentMemoryEntry>>> call() =>
      _repository.pendingMemoryEntries();
}
