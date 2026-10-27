/// Numéros d'urgence par pays (section 5.4, 5.14).
///
/// Point de départ minimal pour le scaffolding : à étendre avec un service
/// de localisation du pays de l'utilisateur (section 5.4, « aide à la
/// localisation des services d'urgence »).
class EmergencyNumbers {
  const EmergencyNumbers._();

  static const String defaultNumber = '112';

  static const Map<String, String> byCountryCode = {
    'CI': '185', // Côte d'Ivoire — loi n° 2013-450 citée section 8.
    'FR': '15',
    'SN': '15',
  };

  static String forCountry(String? countryCode) =>
      byCountryCode[countryCode?.toUpperCase()] ?? defaultNumber;
}
