/// Cycle de vie d'une ordonnance (section 3, 5.7) : `draft → in_review →
/// signed|refused`, puis `signed → transmitted`. Aucun autre chemin n'existe
/// côté backend ; le mobile ne fait qu'afficher cet état, jamais le décider.
enum PrescriptionStatus {
  draft,
  inReview,
  signed,
  refused,
  transmitted;

  static PrescriptionStatus fromApi(String value) => switch (value) {
    'in_review' => PrescriptionStatus.inReview,
    'signed' => PrescriptionStatus.signed,
    'refused' => PrescriptionStatus.refused,
    'transmitted' => PrescriptionStatus.transmitted,
    _ => PrescriptionStatus.draft,
  };

  String get label => switch (this) {
    PrescriptionStatus.draft => 'Brouillon',
    PrescriptionStatus.inReview => 'En attente de validation',
    PrescriptionStatus.signed => 'Signée',
    PrescriptionStatus.refused => 'Refusée',
    PrescriptionStatus.transmitted => 'Transmise à la pharmacie',
  };
}
