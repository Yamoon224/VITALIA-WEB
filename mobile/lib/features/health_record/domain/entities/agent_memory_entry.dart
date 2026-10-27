import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/memory_entry_status.dart';

/// Élément retenu par l'agent, en attente de validation par l'utilisateur
/// (section 5.8) : l'utilisateur voit, corrige et supprime ce que l'agent a
/// retenu.
class AgentMemoryEntry extends Equatable {
  const AgentMemoryEntry({
    required this.id,
    required this.content,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String content;
  final MemoryEntryStatus status;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, content, status, createdAt];
}
