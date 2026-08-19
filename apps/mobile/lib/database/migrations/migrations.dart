/// Centralized schema version for the local SQLite database.
///
/// v1 was the empty foundation database.
/// v2 introduced the location graph.
/// v3 adds Asset.quantity and AssetType.parentId (type hierarchy).
abstract final class DatabaseMigrations {
  static const int schemaVersion = 3;
}
