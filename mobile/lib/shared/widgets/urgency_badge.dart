import 'package:flutter/material.dart';
import 'package:vitalia_mobile/core/theme/app_theme.dart';

/// Badge d'urgence (section 11.1, design system) : produit par le code à
/// partir d'un champ structuré du backend, jamais en interprétant le texte
/// d'une réponse de l'agent.
class UrgencyBadge extends StatelessWidget {
  const UrgencyBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.emergency,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
