import 'package:compass/database/connection/connection.dart';
import 'package:compass/database/migrations/migrations.dart';
import 'package:drift/drift.dart';

part 'app_database.g.dart';

/// Local SQLite database for Compass.
///
/// Schema tables are intentionally empty in this foundation milestone.
/// Migration infrastructure is ready for incremental schema evolution.
@DriftDatabase()
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? openConnection());

  /// Visible for testing with an in-memory executor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => DatabaseMigrations.schemaVersion;

  @override
  MigrationStrategy get migration => DatabaseMigrations.strategy;
}
