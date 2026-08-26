import 'package:compass/features/catalog/domain/card_printing.dart';

/// Optional enrichment for card identity / art / stats.
///
/// Implementations must treat SQLite (or equivalent) as the primary source
/// after retrieval. Network fills gaps only.
abstract interface class CardMetadataProvider {
  Future<CatalogStatus> status();

  Future<CardPrinting?> getById(String scryfallId);

  Future<CardPrinting?> getBySetCollector({
    required String setCode,
    required String collectorNumber,
  });

  Future<CardPrinting?> findByExactName(String name);

  /// Prefix / normalized similar match; may return null.
  Future<CardPrinting?> findSimilarName(String name);

  /// Printings that share [oracleId]. Local cache first; network fills gaps.
  Future<List<CardPrinting>> listPrints(
    String oracleId, {
    bool allowNetwork = true,
  });

  /// Ensure a usable local catalog exists (bulk download if needed).
  Future<void> ensureCatalog({
    void Function(CatalogSyncProgress progress)? onProgress,
    bool forceRefresh = false,
  });

  /// Resolve a single key via local cache, then rate-limited network if enabled.
  ///
  /// When [forceNetwork] is true, always re-fetch and upsert (used by rematch).
  Future<CardPrinting?> resolve({
    String? scryfallId,
    String? setCode,
    String? collectorNumber,
    String? name,
    bool allowNetwork = true,
    bool forceNetwork = false,
  });
}
