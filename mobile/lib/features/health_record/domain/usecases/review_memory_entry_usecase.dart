import 'package:vitalia_mobile/core/errors/result.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/agent_memory_entry.dart';
import 'package:vitalia_mobile/features/health_record/domain/repositories/health_record_repository.dart';

/// Accepte ou rejette une proposition de mémoire (section 5.8). Les deux
/// actions sont symétriques côté API : une seule classe les couvre, comme
/// `SignerOrdonnanceAction` / `RefuserOrdonnanceAction` côté backend restent
/// néanmoins séparées parce qu'elles portent des règles différentes — ici
/// il n'y a aucune règle métier à diverger, seul l'appel distant change.
class ReviewMemoryEntryUseCase {
  const ReviewMemoryEntryUseCase(this._repository);

  final HealthRecordRepository _repository;

  Future<Result<AgentMemoryEntry>> accept(String entryId) =>
      _repository.acceptMemoryEntry(entryId);

  Future<Result<AgentMemoryEntry>> reject(String entryId) =>
      _repository.rejectMemoryEntry(entryId);
}
