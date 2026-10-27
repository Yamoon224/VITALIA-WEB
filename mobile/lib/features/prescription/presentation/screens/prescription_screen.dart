import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/prescription/domain/entities/prescription.dart';
import 'package:vitalia_mobile/features/prescription/domain/entities/prescription_status.dart';
import 'package:vitalia_mobile/features/prescription/presentation/providers/prescription_controller.dart';
import 'package:vitalia_mobile/shared/widgets/warning_box.dart';

/// Ordonnances reçues (section 5.14). Composé uniquement de widgets ; aucune
/// logique métier ici (section 11.1) — le statut affiché vient tel quel du
/// backend, jamais interprété côté client.
class PrescriptionScreen extends ConsumerStatefulWidget {
  const PrescriptionScreen({super.key});

  @override
  ConsumerState<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends ConsumerState<PrescriptionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(prescriptionControllerProvider.notifier).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(prescriptionControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ordonnances')),
      body: state.isLoading && state.prescriptions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(prescriptionControllerProvider.notifier).load(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const WarningBox(
                    message:
                        "Un brouillon reste une proposition de l'IA. Seule une "
                        "ordonnance « signée » par un praticien est valide.",
                  ),
                  const SizedBox(height: 16),
                  if (state.failure != null)
                    Text(
                      state.failure!.message,
                      style: const TextStyle(color: Colors.red),
                    )
                  else if (state.prescriptions.isEmpty)
                    const Text('Aucune ordonnance pour le moment.')
                  else
                    ...state.prescriptions.map(
                      (prescription) =>
                          _PrescriptionCard(prescription: prescription),
                    ),
                ],
              ),
            ),
    );
  }
}

class _PrescriptionCard extends StatelessWidget {
  const _PrescriptionCard({required this.prescription});

  final Prescription prescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(prescription.status.label),
                  backgroundColor: _statusColor(context, prescription.status),
                ),
                if (prescription.signedAt != null)
                  Text(_formatDate(prescription.signedAt!)),
              ],
            ),
            const SizedBox(height: 8),
            for (final item in prescription.items) _ItemLine(item: item),
            if (prescription.status == PrescriptionStatus.refused &&
                prescription.refusalReason != null) ...[
              const SizedBox(height: 8),
              Text(
                'Motif du refus : ${prescription.refusalReason}',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _statusColor(BuildContext context, PrescriptionStatus status) =>
      switch (status) {
        PrescriptionStatus.signed ||
        PrescriptionStatus.transmitted => Colors.green.shade100,
        PrescriptionStatus.refused => Colors.red.shade100,
        PrescriptionStatus.inReview => Colors.orange.shade100,
        PrescriptionStatus.draft => Colors.grey.shade200,
      };

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _ItemLine extends StatelessWidget {
  const _ItemLine({required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final label = [
      item['dci'],
      item['dosage'],
      item['duration_days'] != null ? '${item['duration_days']} j' : null,
    ].whereType<Object>().join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        label.isEmpty ? item.values.join(' · ') : label,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
