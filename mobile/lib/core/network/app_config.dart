/// Variante de build (section 9, 11.1 : flavors dev / staging / prod).
///
/// Valeur injectée à la compilation : `flutter run --dart-define=FLAVOR=dev`.
/// Chaque flavor pointe vers son propre environnement backend, jamais codé
/// en dur dans un widget.
enum AppFlavor { dev, staging, prod }

class AppConfig {
  const AppConfig._({required this.flavor, required this.apiBaseUrl});

  final AppFlavor flavor;
  final String apiBaseUrl;

  static AppConfig get current {
    const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    final flavor = AppFlavor.values.firstWhere(
      (f) => f.name == flavorName,
      orElse: () => AppFlavor.dev,
    );

    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:8000/api/v1',
    );

    return AppConfig._(flavor: flavor, apiBaseUrl: apiBaseUrl);
  }
}
