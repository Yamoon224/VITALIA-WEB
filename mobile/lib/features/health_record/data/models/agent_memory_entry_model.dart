import 'package:vitalia_mobile/features/health_record/domain/entities/agent_memory_entry.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/memory_entry_status.dart';

class AgentMemoryEntryModel {
  const AgentMemoryEntryModel({
    required this.id,
    required this.content,
    required this.status,
    required this.createdAt,
  });

  factory AgentMemoryEntryModel.fromJson(Map<String, dynamic> json) =>
      AgentMemoryEntryModel(
        id: json['id'].toString(),
        content: json['content'] as String,
        status: MemoryEntryStatus.fromApi(json['status'] as String? ?? ''),
        createdAt:
            DateTime.tryParse(json['created_at'] as String? ?? '') ??
            DateTime.now(),
      );

  final String id;
  final String content;
  final MemoryEntryStatus status;
  final DateTime createdAt;

  AgentMemoryEntry toEntity() => AgentMemoryEntry(
    id: id,
    content: content,
    status: status,
    createdAt: createdAt,
  );
}
