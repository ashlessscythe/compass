/// Centralized schema version for the local SQLite database.
///
/// v1 was the empty foundation database.
/// v2 introduced the location graph.
/// v3 adds Asset.quantity and AssetType.parentId (type hierarchy).
/// v4 adds card catalog cache (Scryfall printings + catalog meta).
/// v5 adds card layout + faces_json for multi-face printings.
/// v6 adds sync_outbox + sync_state for offline-first sync protocol.
abstract final class DatabaseMigrations {
  static const int schemaVersion = 6;
}
