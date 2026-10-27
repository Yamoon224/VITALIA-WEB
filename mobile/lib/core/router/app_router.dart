import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vitalia_mobile/features/auth/presentation/providers/auth_controller.dart';
import 'package:vitalia_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:vitalia_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:vitalia_mobile/features/auth/presentation/screens/splash_screen.dart';
import 'package:vitalia_mobile/features/chat/presentation/screens/chat_screen.dart';
import 'package:vitalia_mobile/features/consultation/presentation/screens/consultation_screen.dart';
import 'package:vitalia_mobile/features/examination/presentation/screens/examination_screen.dart';
import 'package:vitalia_mobile/features/health_record/presentation/screens/health_record_screen.dart';
import 'package:vitalia_mobile/features/prescription/presentation/screens/prescription_screen.dart';
import 'package:vitalia_mobile/features/wellness/presentation/screens/wellness_screen.dart';

/// Pont entre l'état Riverpod et `GoRouter`, qui attend un `Listenable`
/// classique (section 11.1 : navigation déclarative, gardes
/// d'authentification).
class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Ref ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (previous?.isAuthenticated != next.isAuthenticated ||
          previous?.isCheckingSession != next.isCheckingSession) {
        notifyListeners();
      }
    });
  }
}

/// Navigation déclarative avec garde d'authentification (section 11.1).
///
/// Les gardes de consentement spécifiques (section 5.1) seront ajoutées de
/// la même façon une fois le parcours de consentement câblé côté mobile.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = _AuthRefreshListenable(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final atSplash = state.matchedLocation == '/';
      final atAuthScreen =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (auth.isCheckingSession) {
        return atSplash ? null : '/';
      }

      if (!auth.isAuthenticated) {
        return atAuthScreen ? null : '/login';
      }

      return (atSplash || atAuthScreen) ? '/chat' : null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: '/health-record',
        name: 'health-record',
        builder: (context, state) => const HealthRecordScreen(),
      ),
      GoRoute(
        path: '/wellness',
        name: 'wellness',
        builder: (context, state) => const WellnessScreen(),
      ),
      GoRoute(
        path: '/prescriptions',
        name: 'prescriptions',
        builder: (context, state) => const PrescriptionScreen(),
      ),
      GoRoute(
        path: '/consultation',
        name: 'consultation',
        builder: (context, state) => const ConsultationScreen(),
      ),
      GoRoute(
        path: '/examination',
        name: 'examination',
        builder: (context, state) => const ExaminationScreen(),
      ),
    ],
  );
});
