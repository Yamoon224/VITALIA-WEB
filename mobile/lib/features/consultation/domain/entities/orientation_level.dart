/// Quatre niveaux d'orientation (section 5.3) : le niveau affiché vient tel
/// quel du backend, jamais interprété depuis le texte libre du modèle.
enum OrientationLevel {
  emergency,
  urgentConsultation,
  scheduledConsultation,
  selfCareWithMonitoring;

  static OrientationLevel? fromApi(String? value) => switch (value) {
    'emergency' => OrientationLevel.emergency,
    'urgent_consultation_24h' => OrientationLevel.urgentConsultation,
    'scheduled_consultation' => OrientationLevel.scheduledConsultation,
    'self_care_with_monitoring' => OrientationLevel.selfCareWithMonitoring,
    _ => null,
  };

  String get label => switch (this) {
    OrientationLevel.emergency => 'Urgence immédiate',
    OrientationLevel.urgentConsultation => 'Consultation rapide (24 h)',
    OrientationLevel.scheduledConsultation => 'Consultation programmée',
    OrientationLevel.selfCareWithMonitoring => 'Auto-soins avec surveillance',
  };
}
