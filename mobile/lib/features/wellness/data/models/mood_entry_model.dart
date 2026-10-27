import 'package:vitalia_mobile/features/wellness/domain/entities/mood_entry.dart';

class MoodEntryModel {
  const MoodEntryModel({
    required this.id,
    required this.moodLevel,
    required this.recordedAt,
    this.note,
  });

  factory MoodEntryModel.fromJson(Map<String, dynamic> json) => MoodEntryModel(
    id: json['id'].toString(),
    moodLevel: json['mood_level'] as int,
    recordedAt:
        DateTime.tryParse(json['recorded_at'] as String? ?? '') ??
        DateTime.now(),
    note: json['note'] as String?,
  );

  final String id;
  final int moodLevel;
  final DateTime recordedAt;
  final String? note;

  MoodEntry toEntity() => MoodEntry(
    id: id,
    moodLevel: moodLevel,
    recordedAt: recordedAt,
    note: note,
  );
}
