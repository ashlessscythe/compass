import 'package:compass/database/app_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides the application [AppDatabase] instance.
///
/// Overridden during bootstrap with a concrete connection.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw StateError(
    'appDatabaseProvider must be overridden in bootstrap()',
  );
});
