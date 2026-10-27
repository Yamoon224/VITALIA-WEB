import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vitalia_mobile/core/router/app_router.dart';
import 'package:vitalia_mobile/core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: VitaliaApp()));
}

class VitaliaApp extends ConsumerWidget {
  const VitaliaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'VITALIA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
