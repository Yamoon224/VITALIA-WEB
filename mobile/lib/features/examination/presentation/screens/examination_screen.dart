import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_request.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_request_status.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/examination_result.dart';
import 'package:vitalia_mobile/features/examination/domain/entities/laboratory.dart';
import 'package:vitalia_mobile/features/examination/presentation/providers/examination_controller.dart';
import 'package:vitalia_mobile/shared/widgets/warning_box.dart';

/// Examens médicaux : recommandation, résultats et annuaire (section 5.6).
/// Composé uniquement de widgets ; aucune logique métier ici (section 11.1).
class ExaminationScreen extends ConsumerStatefulWidget {
  const ExaminationScreen({super.key});

  @override
  ConsumerState<ExaminationScreen> createState() => _ExaminationScreenState();
}

class _ExaminationScreenState extends ConsumerState<ExaminationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(examinationControllerProvider.notifier).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Examens'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Demandes'),
              Tab(text: 'Résultats'),
              Tab(text: 'Laboratoires'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_RequestsTab(), _ResultsTab(), _LaboratoriesTab()],
        ),
      ),
    );
  }
}

class _RequestsTab extends ConsumerWidget {
  const _RequestsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(examinationControllerProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const WarningBox(
          message:
              "Un brouillon reste une proposition de l'IA. Seul un praticien "
              "valide une demande d'examens.",
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: state.isRecommending
              ? null
              : () => ref
                    .read(examinationControllerProvider.notifier)
                    .requestRecommendation(),
          child: state.isRecommending
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Demander une recommandation'),
        ),
        const SizedBox(height: 16),
        if (state.failure != null)
          Text(
            state.failure!.message,
            style: const TextStyle(color: Colors.red),
          )
        else if (state.requests.isEmpty)
          const Text('Aucune demande pour le moment.')
        else
          ...state.requests.map((request) => _RequestCard(request: request)),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});

  final ExaminationRequest request;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(request.status.label),
              backgroundColor: switch (request.status) {
                ExaminationRequestStatus.validated => Colors.green.shade100,
                ExaminationRequestStatus.refused => Colors.red.shade100,
                ExaminationRequestStatus.draft => Colors.orange.shade100,
              },
            ),
            const SizedBox(height: 8),
            for (final item in request.items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  item.prepInstructions == null
                      ? '• ${item.name} — ${item.reason}'
                      : '• ${item.name} — ${item.reason} '
                            '(préparation : ${item.prepInstructions})',
                ),
              ),
            if (request.status == ExaminationRequestStatus.refused &&
                request.refusalReason != null) ...[
              const SizedBox(height: 8),
              Text(
                'Motif du refus : ${request.refusalReason}',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultsTab extends ConsumerStatefulWidget {
  const _ResultsTab();

  @override
  ConsumerState<_ResultsTab> createState() => _ResultsTabState();
}

class _ResultsTabState extends ConsumerState<_ResultsTab> {
  final _parameterController = TextEditingController();
  final _valueController = TextEditingController();
  final _unitController = TextEditingController();
  final _referenceLowController = TextEditingController();
  final _referenceHighController = TextEditingController();

  @override
  void dispose() {
    _parameterController.dispose();
    _valueController.dispose();
    _unitController.dispose();
    _referenceLowController.dispose();
    _referenceHighController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(examinationControllerProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Ajouter un résultat',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _parameterController,
          decoration: const InputDecoration(labelText: 'Paramètre'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _valueController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Valeur'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Unité'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _referenceLowController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Norme basse'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _referenceHighController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Norme haute'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: state.isSavingResult ? null : _save,
          child: state.isSavingResult
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
        const SizedBox(height: 24),
        Text('Historique', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (state.results.isEmpty)
          const Text('Aucun résultat enregistré.')
        else
          ...state.results.map((result) => _ResultTile(result: result)),
      ],
    );
  }

  void _save() {
    final value = double.tryParse(_valueController.text);
    if (_parameterController.text.trim().isEmpty ||
        value == null ||
        _unitController.text.trim().isEmpty) {
      return;
    }

    ref
        .read(examinationControllerProvider.notifier)
        .recordResult(
          parameter: _parameterController.text.trim(),
          value: value,
          unit: _unitController.text.trim(),
          referenceLow: double.tryParse(_referenceLowController.text),
          referenceHigh: double.tryParse(_referenceHighController.text),
        );

    _parameterController.clear();
    _valueController.clear();
    _unitController.clear();
    _referenceLowController.clear();
    _referenceHighController.clear();
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({required this.result});

  final ExaminationResult result;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        result.isAbnormal ? Icons.warning_amber_rounded : Icons.check_circle,
        color: result.isAbnormal ? Colors.red : Colors.green,
      ),
      title: Text('${result.parameter} : ${result.value} ${result.unit}'),
      subtitle: result.referenceLow == null && result.referenceHigh == null
          ? null
          : Text('Norme : ${result.referenceLow} – ${result.referenceHigh}'),
    );
  }
}

class _LaboratoriesTab extends ConsumerStatefulWidget {
  const _LaboratoriesTab();

  @override
  ConsumerState<_LaboratoriesTab> createState() => _LaboratoriesTabState();
}

class _LaboratoriesTabState extends ConsumerState<_LaboratoriesTab> {
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(examinationControllerProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'Ville'),
                onSubmitted: (city) => ref
                    .read(examinationControllerProvider.notifier)
                    .filterLaboratoriesByCity(city),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => ref
                  .read(examinationControllerProvider.notifier)
                  .filterLaboratoriesByCity(_cityController.text),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (state.laboratories.isEmpty)
          const Text('Aucun laboratoire trouvé.')
        else
          ...state.laboratories.map((lab) => _LaboratoryTile(laboratory: lab)),
      ],
    );
  }
}

class _LaboratoryTile extends StatelessWidget {
  const _LaboratoryTile({required this.laboratory});

  final Laboratory laboratory;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(laboratory.name),
        subtitle: Text(
          '${laboratory.type.label} · ${laboratory.city}\n${laboratory.address}',
        ),
        isThreeLine: true,
      ),
    );
  }
}
