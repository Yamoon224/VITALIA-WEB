import 'package:flutter/material.dart';

/// Écran transitoire pendant la vérification d'une session déjà stockée
/// (section 11.1). Le routeur redirige automatiquement dès que l'état
/// d'authentification est connu ; cet écran n'a aucune logique propre.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
