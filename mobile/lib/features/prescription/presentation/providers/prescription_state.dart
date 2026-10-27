import 'package:equatable/equatable.dart';
import 'package:vitalia_mobile/core/errors/failure.dart';
import 'package:vitalia_mobile/features/prescription/domain/entities/prescription.dart';

/// État immuable émis par [PrescriptionController] (section 11.1).
class PrescriptionState extends Equatable {
  const PrescriptionState({
    this.prescriptions = const [],
    this.isLoading = false,
    this.failure,
  });

  final List<Prescription> prescriptions;
  final bool isLoading;
  final Failure? failure;

  PrescriptionState copyWith({
    List<Prescription>? prescriptions,
    bool? isLoading,
    Failure? failure,
  }) {
    return PrescriptionState(
      prescriptions: prescriptions ?? this.prescriptions,
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [prescriptions, isLoading, failure];
}
