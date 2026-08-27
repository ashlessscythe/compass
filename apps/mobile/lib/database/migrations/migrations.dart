/// Centralized schema version for the local SQLite database.
///
/// v1 was the empty foundation database.
/// v2 introduced the location graph.
/// v3 adds Asset.quantity and AssetType.parentId (type hierarchy).
/// v4 adds card catalog cache (Scryfall printings + catalog meta).
/// v5 adds card layout + faces_json for multi-face printings.
/// v6 adds sync_outbox + sync_state for offline-first sync protocol.
/// v7 adds Scryfall gameplay / printing details on card_printings.
/// v8 adds domain pack install state + pack attribute/vocab tables.
/// v9 adds cached manifest JSON + source URL for remote install/update.
abstract final class DatabaseMigrations {
  static const int schemaVersion = 9;
}
