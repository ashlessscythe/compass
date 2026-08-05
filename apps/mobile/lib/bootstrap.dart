import 'package:compass/database/app_database.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:compass/shared/providers/logger_provider.dart';
import 'package:compass/theme/theme_mode_provider.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Initializes platform services and returns a ready [ProviderContainer].
Future<ProviderContainer> bootstrap() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final database = AppDatabase();

  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
    ],
  );

  // Eagerly resolve theme preference so the first frame is consistent.
  final logger = container.read(appLoggerProvider);
  container.read(themeModeProvider);
  logger.info(
    'Compass bootstrap complete (schema v${database.schemaVersion})',
  );

  return container;
}
