import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitalia_mobile/core/theme/app_theme.dart';
import 'package:vitalia_mobile/features/emergency/domain/emergency_numbers.dart';

/// Écran produit entièrement par le code (section 11.1 : « avertissements,
/// état « en attente de validation » et écran d'urgence produits par le
/// code, jamais par le texte du modèle »).
///
/// Le niveau d'urgence détecté prime sur toute autre logique de l'écran
/// (section 5.4) : pas de bouton retour discret, l'action principale est
/// l'appel aux secours.
class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({
    super.key,
    this.countryCode,
    required this.onAcknowledge,
  });

  final String? countryCode;
  final VoidCallback onAcknowledge;

  @override
  Widget build(BuildContext context) {
    final number = EmergencyNumbers.forCountry(countryCode);

    return Scaffold(
      backgroundColor: AppTheme.emergency,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emergency, color: Colors.white, size: 72),
              const SizedBox(height: 24),
              const Text(
                'Ce que tu décris nécessite une attention immédiate.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Contacte les secours maintenant. Ne reste pas seul·e si possible.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => _call(number),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.emergency,
                  minimumSize: const Size.fromHeight(56),
                ),
                icon: const Icon(Icons.call),
                label: Text('Appeler les secours ($number)'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: onAcknowledge,
                child: const Text(
                  "J'ai contacté quelqu'un, revenir à la conversation",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _call(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    await launchUrl(uri);
  }
}
