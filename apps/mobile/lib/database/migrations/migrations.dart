import 'package:drift/drift.dart';

/// Centralized migration strategy for the local SQLite database.
///
/// Add numbered upgrade steps here as tables are introduced.
abstract final class DatabaseMigrations {
  static const int schemaVersion = 1;

  static MigrationStrategy get strategy => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Schema upgrades will be appended here as the model grows.
          // Example:
          // if (from < 2) { await m.createTable(assets); }
        },
        beforeOpen: (details) async {
          // Enable foreign keys when relational tables are introduced.
        },
      );
}
