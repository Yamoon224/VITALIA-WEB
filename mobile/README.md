# VITALIA — Application mobile (Flutter)

Application patient (iOS/Android) : chat avec l'agent, consultation guidée, dossier santé,
ordonnances, bien-être. Seule interface des utilisateurs standard (section 1 du cahier des charges).

## Architecture : Clean Architecture par fonctionnalité

```
lib/
├── core/
│   ├── network/     # ApiClient (Dio), AppConfig (flavors), providers Riverpod racine
│   ├── security/     # SecureStorage (Keychain/Keystore)
│   ├── errors/       # Failure, Result<T>
│   ├── theme/        # Thème unique de l'application
│   └── router/       # Navigation déclarative (go_router)
├── features/
│   ├── auth/
│   │   ├── domain/         # AuthUser, AuthRepository — zéro dépendance Flutter
│   │   ├── data/            # AuthRemoteDataSource (Dio), AuthRepositoryImpl (jeton → SecureStorage)
│   │   └── presentation/     # Écrans connexion/inscription/splash, AuthController (StateNotifier)
│   └── chat/
│       ├── domain/        # Entités, interfaces de dépôt, cas d'usage
│       ├── data/           # Modèles JSON, datasource Dio, implémentation du dépôt
│       └── presentation/    # Écrans, widgets, ChatController (Riverpod StateNotifier)
├── features/emergency/    # Écran d'urgence produit par le code (jamais par le texte du modèle)
└── shared/widgets/         # Design system interne (MessageBubble, WarningBox, UrgencyBadge...)
```

Même convention que le backend (section 11.1) : les widgets affichent, les contrôleurs décident,
les cas d'usage appliquent les règles, les dépôts accèdent aux données. Aucune logique métier ni
appel réseau dans un widget.

`core/router/app_router.dart` protège `/chat` derrière une garde d'authentification : tant que la
session n'est pas authentifiée, toute navigation est redirigée vers `/login` ; au démarrage, un
écran `splash` attend la vérification d'un jeton déjà stocké (section 11.1).

Les 7 domaines du cahier des charges (`auth`, `chat`, `health_record`, `wellness`, `prescription`,
`consultation`, `examination`) sont construits de bout en bout, chacun relié aux endpoints backend
réels.

## Démarrer en local

```bash
flutter pub get
flutter run --dart-define=FLAVOR=dev --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

`10.0.2.2` est l'alias de `localhost` depuis l'émulateur Android ; sur iOS ou un appareil physique,
remplacer par l'adresse IP de la machine qui exécute le backend.

## Qualité

```bash
flutter analyze
flutter test              # unit/ + widget/
```
