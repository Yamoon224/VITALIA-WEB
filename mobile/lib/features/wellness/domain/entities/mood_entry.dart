import 'package:equatable/equatable.dart';

/// Journal d'humeur (section 5.9) : niveau de 1 (très mauvaise) à 5
/// (excellente), note libre optionnelle.
class MoodEntry extends Equatable {
  const MoodEntry({
    required this.id,
    required this.moodLevel,
    required this.recordedAt,
    this.note,
  });

  final String id;
  final int moodLevel;
  final DateTime recordedAt;
  final String? note;

  @override
  List<Object?> get props => [id, moodLevel, recordedAt, note];
}
