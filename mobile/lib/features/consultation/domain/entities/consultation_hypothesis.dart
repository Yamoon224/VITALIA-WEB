import 'package:equatable/equatable.dart';

/// Hypothèse plausible avec son niveau d'incertitude (section 5.3) : jamais
/// un diagnostic définitif.
class ConsultationHypothesis extends Equatable {
  const ConsultationHypothesis({
    required this.condition,
    required this.confidence,
  });

  final String condition;
  final double confidence;

  @override
  List<Object?> get props => [condition, confidence];
}
