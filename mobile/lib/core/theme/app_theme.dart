import 'package:flutter/material.dart';

/// Thème unique de l'application (section 11.1 : design system interne,
/// réutilisé partout plutôt que des styles ad hoc dans chaque écran).
class AppTheme {
  const AppTheme._();

  static const Color primary = Color(0xFF0E6E55);
  static const Color emergency = Color(0xFFC62828);
  static const Color warningBackground = Color(0xFFFFF3E0);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    );

    return ThemeData(useMaterial3: true, colorScheme: colorScheme);
  }
}
