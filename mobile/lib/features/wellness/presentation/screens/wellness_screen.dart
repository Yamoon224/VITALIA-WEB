import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/mood_entry.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal.dart';
import 'package:vitalia_mobile/features/wellness/domain/entities/wellness_goal_type.dart';
import 'package:vitalia_mobile/features/wellness/presentation/providers/wellness_controller.dart';

/// Bien-être : nutrition, sommeil, activité, santé mentale (section 5.9).
/// Composé uniquement de widgets ; aucune logique métier ici (section 11.1).
class WellnessScreen extends ConsumerStatefulWidget {
  const WellnessScreen({super.key});

  @override
  ConsumerState<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends ConsumerState<WellnessScreen> {
  int _selectedMoodLevel = 3;
  final _moodNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(wellnessControllerProvider.notifier).load(),
    );
  }

  @override
  void dispose() {
    _moodNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wellnessControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Bien-être')),
      body: state.isLoading && state.goals.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Objectifs',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (final type in WellnessGoalType.values)
                  _GoalTile(type: type, goal: _goalFor(state.goals, type)),
                const SizedBox(height: 24),
                Text(
                  "Humeur du jour",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (var level = 1; level <= 5; level++)
                      IconButton(
                        tooltip: 'Humeur $level/5',
                        onPressed: () =>
                            setState(() => _selectedMoodLevel = level),
                        icon: Icon(
                          _moodIcon(level),
                          color: _selectedMoodLevel == level
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                      ),
                  ],
                ),
                TextField(
                  controller: _moodNoteController,
                  decoration: const InputDecoration(
                    labelText: 'Note (facultatif)',
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: state.isLoggingMood
                      ? null
                      : () {
                          ref
                              .read(wellnessControllerProvider.notifier)
                              .logMood(
                                moodLevel: _selectedMoodLevel,
                                note: _moodNoteController.text.trim().isEmpty
                                    ? null
                                    : _moodNoteController.text.trim(),
                              );
                          _moodNoteController.clear();
                        },
                  child: state.isLoggingMood
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Enregistrer l'humeur"),
                ),
                if (state.failure != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    state.failure!.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  'Historique',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (state.moodEntries.isEmpty)
                  const Text('Aucune humeur enregistrée pour le moment.')
                else
                  ...state.moodEntries.map(
                    (entry) => _MoodHistoryTile(entry: entry),
                  ),
              ],
            ),
    );
  }

  WellnessGoal? _goalFor(List<WellnessGoal> goals, WellnessGoalType type) {
    for (final goal in goals) {
      if (goal.type == type) {
        return goal;
      }
    }

    return null;
  }

  IconData _moodIcon(int level) => switch (level) {
    1 => Icons.sentiment_very_dissatisfied,
    2 => Icons.sentiment_dissatisfied,
    3 => Icons.sentiment_neutral,
    4 => Icons.sentiment_satisfied,
    _ => Icons.sentiment_very_satisfied,
  };
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({required this.type, required this.goal});

  final WellnessGoalType type;
  final WellnessGoal? goal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(type.label),
        subtitle: goal == null
            ? const Text('Aucun objectif défini')
            : Text(
                "Objectif : ${goal!.targetValue.toStringAsFixed(0)}"
                "${goal!.currentValue != null ? ' · actuel : ${goal!.currentValue!.toStringAsFixed(0)}' : ''}",
              ),
        trailing: IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => _promptTargetValue(context),
        ),
      ),
    );
  }

  void _promptTargetValue(BuildContext context) {
    final controller = TextEditingController(
      text: goal?.targetValue.toStringAsFixed(0) ?? '',
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(type.label),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Nouvel objectif'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Annuler'),
          ),
          Consumer(
            builder: (context, ref, _) => FilledButton(
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value != null) {
                  ref
                      .read(wellnessControllerProvider.notifier)
                      .saveGoal(type: type, targetValue: value);
                }
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Enregistrer'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodHistoryTile extends StatelessWidget {
  const _MoodHistoryTile({required this.entry});

  final MoodEntry entry;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('${entry.moodLevel}')),
      title: entry.note == null ? null : Text(entry.note!),
      subtitle: Text(
        '${entry.recordedAt.day}/${entry.recordedAt.month}/${entry.recordedAt.year}',
      ),
    );
  }
}
