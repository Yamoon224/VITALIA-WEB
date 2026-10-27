import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/features/prescription/domain/usecases/list_prescriptions_usecase.dart';
import 'package:vitalia_mobile/features/prescription/presentation/providers/prescription_providers.dart';
import 'package:vitalia_mobile/features/prescription/presentation/providers/prescription_state.dart';

/// Décide ; ne connaît ni widget ni appel réseau direct (section 11.1).
class PrescriptionController extends StateNotifier<PrescriptionState> {
  PrescriptionController({required ListPrescriptionsUseCase listPrescriptions})
    : _listPrescriptions = listPrescriptions,
      super(const PrescriptionState());

  final ListPrescriptionsUseCase _listPrescriptions;

  Future<void> load() async {
    state = state.copyWith(isLoading: true);

    final result = await _listPrescriptions();

    result.when(
      success: (prescriptions) => state = state.copyWith(
        prescriptions: prescriptions,
        isLoading: false,
      ),
      failure: (failure) =>
          state = state.copyWith(isLoading: false, failure: failure),
    );
  }
}

final prescriptionControllerProvider =
    StateNotifierProvider.autoDispose<
      PrescriptionController,
      PrescriptionState
    >((ref) {
      return PrescriptionController(
        listPrescriptions: ref.watch(listPrescriptionsUseCaseProvider),
      );
    });
