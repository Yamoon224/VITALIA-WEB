import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/consultation_session.dart';
import 'package:vitalia_mobile/features/consultation/domain/entities/orientation_level.dart';
import 'package:vitalia_mobile/features/consultation/presentation/providers/consultation_controller.dart';
import 'package:vitalia_mobile/features/emergency/presentation/screens/emergency_screen.dart';
import 'package:vitalia_mobile/shared/widgets/warning_box.dart';

/// Consultation guidée (anamnèse et orientation, section 5.3). Composé
/// uniquement de widgets ; aucune logique métier ici (section 11.1) — le
/// niveau d'orientation affiché vient tel quel du backend.
class ConsultationScreen extends ConsumerStatefulWidget {
  const ConsultationScreen({super.key});

  @override
  ConsumerState<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends ConsumerState<ConsultationScreen> {
  final _motifController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  void dispose() {
    _motifController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(consultationControllerProvider);

    if (state.session?.orientationLevel == OrientationLevel.emergency) {
      return EmergencyScreen(
        onAcknowledge: () =>
            ref.read(consultationControllerProvider.notifier).reset(),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Consultation guidée')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: !state.hasStarted
            ? _MotifForm(
                controller: _motifController,
                isLoading: state.isLoading,
              )
            : state.session!.isCompleted
            ? _SynthesisView(session: state.session!)
            : _QuestionView(
                answerController: _answerController,
                onAnswerSubmitted: () => _answerController.clear(),
              ),
      ),
    );
  }
}

class _MotifForm extends ConsumerWidget {
  const _MotifForm({required this.controller, required this.isLoading});

  final TextEditingController controller;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WarningBox(
          message:
              "L'agent recueille tes symptômes et t'oriente. Il ne pose pas "
              "de diagnostic définitif : en cas de doute, consulte un "
              "professionnel de santé.",
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Quel est le motif de ta visite ?',
            hintText: 'Ex. fièvre, toux, douleur abdominale...',
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: isLoading
              ? null
              : () => ref
                    .read(consultationControllerProvider.notifier)
                    .start(motif: controller.text.trim()),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text("Commencer l'entretien"),
        ),
      ],
    );
  }
}

class _QuestionView extends ConsumerWidget {
  const _QuestionView({
    required this.answerController,
    required this.onAnswerSubmitted,
  });

  final TextEditingController answerController;
  final VoidCallback onAnswerSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(consultationControllerProvider);
    final question = state.currentQuestion;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.failure != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              state.failure!.message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        if (question != null) ...[
          Text(question.text, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          TextField(
            controller: answerController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Ta réponse'),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: state.isSubmitting
                ? null
                : () {
                    ref
                        .read(consultationControllerProvider.notifier)
                        .submitAnswer(answerController.text);
                    onAnswerSubmitted();
                  },
            child: state.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Répondre'),
          ),
        ] else ...[
          const Text("Toutes les questions ont une réponse."),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: state.isSubmitting
                ? null
                : () => ref
                      .read(consultationControllerProvider.notifier)
                      .finish(),
            child: state.isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text("Terminer l'entretien"),
          ),
        ],
      ],
    );
  }
}

class _SynthesisView extends ConsumerWidget {
  const _SynthesisView({required this.session});

  final ConsultationSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        if (session.orientationLevel != null)
          Chip(label: Text(session.orientationLevel!.label)),
        const SizedBox(height: 12),
        if (session.summary != null) ...[
          Text('Résumé', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(session.summary!),
          const SizedBox(height: 16),
        ],
        if (session.hypotheses.isNotEmpty) ...[
          Text(
            'Hypothèses plausibles',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          for (final hypothesis in session.hypotheses)
            Text(
              '• ${hypothesis.condition} (confiance : '
              '${(hypothesis.confidence * 100).round()} %)',
            ),
          const SizedBox(height: 16),
        ],
        if (session.redFlags.isNotEmpty) ...[
          Text(
            "Signes d'alerte à surveiller",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.red),
          ),
          const SizedBox(height: 4),
          for (final redFlag in session.redFlags)
            Text('• $redFlag', style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
        ],
        const WarningBox(
          message:
              "Information et orientation, pas un diagnostic. Partage cette "
              "synthèse avec un professionnel de santé si besoin.",
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () =>
              ref.read(consultationControllerProvider.notifier).reset(),
          child: const Text('Nouvel entretien'),
        ),
      ],
    );
  }
}
