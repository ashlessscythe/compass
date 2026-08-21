import 'package:compass/routing/app_router.dart';
import 'package:compass/theme/effective_theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Root application widget.
class CompassApp extends ConsumerWidget {
  const CompassApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final theme = ref.watch(appThemeDataProvider);

    return MaterialApp.router(
      title: 'Compass',
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: theme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
