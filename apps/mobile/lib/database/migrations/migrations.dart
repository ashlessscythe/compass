/// Centralized schema version for the local SQLite database.
///
/// v1 was the empty foundation database. v2 introduces the location graph.
abstract final class DatabaseMigrations {
  static const int schemaVersion = 2;
}
