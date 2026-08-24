/// Gated capabilities. UI checks these — never product or plan names.
enum CompassFeature {
  /// Ambience theme skins (Pro).
  advancedThemes,

  /// Custom accent color (Pro).
  customAccent,

  /// Bulk metadata / catalog rematch (Pro).
  bulkRefresh,

  /// Reserved — advanced search facets (Pro).
  advancedSearch,

  /// Reserved — saved searches (Pro).
  savedSearches,

  /// Reserved — batch edit / move / normalize (Pro).
  bulkOperations,

  /// Reserved — custom asset schemas (Pro).
  customSchemas,

  /// Cloud backup (Sync).
  cloudBackup,

  /// Cross-device sync (Sync).
  cloudSync,

  /// Reserved — Sync Plus multi-device extras.
  multiDevice,

  /// Reserved — shared / family collections (Sync Plus).
  sharedCollections,

  /// Reserved — advanced cloud history (Sync Plus).
  advancedCloudHistory,
}
