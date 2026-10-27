/// Cycle de vie d'une demande d'examens (section 5.6) : `draft → validated
/// | refused`. Aucune émission officielle sans validation par un praticien ;
/// le mobile affiche cet état tel quel, jamais ne le décide.
enum ExaminationRequestStatus {
  draft,
  validated,
  refused;

  static ExaminationRequestStatus fromApi(String value) => switch (value) {
    'validated' => ExaminationRequestStatus.validated,
    'refused' => ExaminationRequestStatus.refused,
    _ => ExaminationRequestStatus.draft,
  };

  String get label => switch (this) {
    ExaminationRequestStatus.draft => 'En attente de validation',
    ExaminationRequestStatus.validated => 'Validée',
    ExaminationRequestStatus.refused => 'Refusée',
  };
}
