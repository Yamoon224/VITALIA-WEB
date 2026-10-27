import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/agent_memory_entry.dart';
import 'package:vitalia_mobile/features/health_record/domain/entities/health_profile.dart';
import 'package:vitalia_mobile/features/health_record/presentation/providers/health_record_controller.dart';
import 'package:vitalia_mobile/shared/widgets/warning_box.dart';

/// Dossier santé et mémoire de l'agent (section 5.8). Composé uniquement de
/// widgets ; aucune logique métier ici (section 11.1).
class HealthRecordScreen extends ConsumerStatefulWidget {
  const HealthRecordScreen({super.key});

  @override
  ConsumerState<HealthRecordScreen> createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends ConsumerState<HealthRecordScreen> {
  final _birthYearController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _chronicConditionsController = TextEditingController();
  final _currentMedicationsController = TextEditingController();
  final _lifestyleNotesController = TextEditingController();
  String? _sex;
  bool _isPregnant = false;
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(healthRecordControllerProvider.notifier).load(),
    );
  }

  @override
  void dispose() {
    _birthYearController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _chronicConditionsController.dispose();
    _currentMedicationsController.dispose();
    _lifestyleNotesController.dispose();
    super.dispose();
  }

  List<String> _splitLines(String value) => value
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthRecordControllerProvider);
    final profile = state.profile;

    if (profile != null && !_prefilled) {
      _prefilled = true;
      _birthYearController.text = profile.birthYear?.toString() ?? '';
      _heightController.text = profile.heightCm?.toString() ?? '';
      _weightController.text = profile.weightKg?.toString() ?? '';
      _allergiesController.text = profile.allergies.join('\n');
      _chronicConditionsController.text = profile.chronicConditions.join('\n');
      _currentMedicationsController.text = profile.currentMedications.join(
        '\n',
      );
      _lifestyleNotesController.text = profile.lifestyleNotes ?? '';
      _sex = profile.sex;
      _isPregnant = profile.isPregnant ?? false;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dossier santé')),
      body: state.isLoading && profile == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const WarningBox(
                  message:
                      "Ces informations personnalisent les réponses de "
                      "l'agent. Elles restent modifiables à tout moment.",
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _birthYearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Année de naissance',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _sex,
                  decoration: const InputDecoration(labelText: 'Sexe'),
                  items: const [
                    DropdownMenuItem(value: 'female', child: Text('Femme')),
                    DropdownMenuItem(value: 'male', child: Text('Homme')),
                    DropdownMenuItem(value: 'other', child: Text('Autre')),
                  ],
                  onChanged: (value) => setState(() => _sex = value),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Taille (cm)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Poids (kg)'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Grossesse en cours'),
                  value: _isPregnant,
                  onChanged: (value) => setState(() => _isPregnant = value),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _allergiesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Allergies (une par ligne)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _chronicConditionsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Antécédents (un par ligne)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _currentMedicationsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Traitements en cours (un par ligne)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _lifestyleNotesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Habitudes de vie',
                  ),
                ),
                if (state.failure != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    state.failure!.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: state.isSaving ? null : _save,
                  child: state.isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Enregistrer'),
                ),
                const SizedBox(height: 32),
                Text(
                  "Mémoire de l'agent",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (state.pendingEntries.isEmpty)
                  const Text('Rien en attente de validation.')
                else
                  ...state.pendingEntries.map(
                    (entry) => _MemoryEntryTile(entry: entry),
                  ),
              ],
            ),
    );
  }

  void _save() {
    final current = ref.read(healthRecordControllerProvider).profile;

    ref
        .read(healthRecordControllerProvider.notifier)
        .saveProfile(
          (current ?? const HealthProfile()).copyWith(
            birthYear: int.tryParse(_birthYearController.text),
            sex: _sex,
            heightCm: int.tryParse(_heightController.text),
            weightKg: int.tryParse(_weightController.text),
            allergies: _splitLines(_allergiesController.text),
            chronicConditions: _splitLines(_chronicConditionsController.text),
            currentMedications: _splitLines(_currentMedicationsController.text),
            isPregnant: _isPregnant,
            lifestyleNotes: _lifestyleNotesController.text.trim().isEmpty
                ? null
                : _lifestyleNotesController.text.trim(),
          ),
        );
  }
}

class _MemoryEntryTile extends ConsumerWidget {
  const _MemoryEntryTile({required this.entry});

  final AgentMemoryEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(entry.content),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Accepter',
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () => ref
                  .read(healthRecordControllerProvider.notifier)
                  .acceptEntry(entry.id),
            ),
            IconButton(
              tooltip: 'Rejeter',
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => ref
                  .read(healthRecordControllerProvider.notifier)
                  .rejectEntry(entry.id),
            ),
          ],
        ),
      ),
    );
  }
}
