import 'package:compass/features/catalog/domain/card_metadata_provider.dart';
import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/catalog/infrastructure/card_printing_store.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_bulk_importer.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_rate_limited_queue.dart';

/// Scryfall-backed [CardMetadataProvider]: SQLite first, then queue.
class ScryfallCardMetadataProvider implements CardMetadataProvider {
  ScryfallCardMetadataProvider({
    required CardPrintingStore store,
    required ScryfallRateLimitedQueue queue,
    required ScryfallBulkImporter bulkImporter,
  })  : _store = store,
        _queue = queue,
        _bulk = bulkImporter;

  final CardPrintingStore _store;
  final ScryfallRateLimitedQueue _queue;
  final ScryfallBulkImporter _bulk;

  @override
  Future<CatalogStatus> status() => _store.status();

  @override
  Future<CardPrinting?> getById(String scryfallId) => _store.getById(scryfallId);

  @override
  Future<CardPrinting?> getBySetCollector({
    required String setCode,
    required String collectorNumber,
  }) {
    return _store.getBySetCollector(
      setCode: setCode,
      collectorNumber: collectorNumber,
    );
  }

  @override
  Future<CardPrinting?> findByExactName(String name) {
    return _store.findByExactName(name);
  }

  @override
  Future<CardPrinting?> findSimilarName(String name) {
    return _store.findSimilarName(name);
  }

  @override
  Future<void> ensureCatalog({
    void Function(CatalogSyncProgress progress)? onProgress,
    bool forceRefresh = false,
  }) async {
    final current = await _store.status();
    if (current.isInstalled && !forceRefresh) {
      return;
    }
    await _bulk.downloadAndImport(
      onProgress: (p) => onProgress?.call(
        CatalogSyncProgress(
          phase: p.phase,
          fraction: p.fraction,
          detail: p.detail,
        ),
      ),
    );
  }

  /// Test / offline path: seed from JSON list without network.
  Future<int> importFixtureCatalog(List<dynamic> cards) {
    return _bulk.importJsonList(cards);
  }

  @override
  Future<CardPrinting?> resolve({
    String? scryfallId,
    String? setCode,
    String? collectorNumber,
    String? name,
    bool allowNetwork = true,
    bool forceNetwork = false,
  }) async {
    if (scryfallId != null && scryfallId.isNotEmpty) {
      return _resolveLocalThenNetwork(
        local: () => _store.getById(scryfallId),
        key: CatalogMatchKey.scryfallId(scryfallId),
        allowNetwork: allowNetwork,
        forceNetwork: forceNetwork,
      );
    }

    if (setCode != null &&
        setCode.isNotEmpty &&
        collectorNumber != null &&
        collectorNumber.isNotEmpty) {
      return _resolveLocalThenNetwork(
        local: () => _store.getBySetCollector(
          setCode: setCode,
          collectorNumber: collectorNumber,
        ),
        key: CatalogMatchKey.setCollector(
          setCode: setCode,
          collectorNumber: collectorNumber,
        ),
        allowNetwork: allowNetwork,
        forceNetwork: forceNetwork,
      );
    }

    if (name != null && name.trim().isNotEmpty) {
      final trimmed = name.trim();
      final exact = await _store.findByExactName(trimmed);
      if (exact != null &&
          !forceNetwork &&
          !exact.needsFaceHydration) {
        return exact;
      }
      final similar = forceNetwork || (exact?.needsFaceHydration ?? false)
          ? null
          : await _store.findSimilarName(trimmed);
      if (similar != null && !similar.needsFaceHydration) {
        return similar;
      }
      if (allowNetwork) {
        try {
          final fresh = await _queue.enqueue(
            CatalogMatchKey.name(trimmed),
            bypassCache: forceNetwork ||
                (exact?.needsFaceHydration ?? false) ||
                (similar?.needsFaceHydration ?? false),
          );
          return fresh ?? exact ?? similar;
        } on Object {
          return exact ?? similar;
        }
      }
      return exact ?? similar;
    }
    return null;
  }

  Future<CardPrinting?> _resolveLocalThenNetwork({
    required Future<CardPrinting?> Function() local,
    required CatalogMatchKey key,
    required bool allowNetwork,
    required bool forceNetwork,
  }) async {
    final cached = await local();
    final stale = cached?.needsFaceHydration ?? false;
    if (cached != null && !forceNetwork && !stale) {
      return cached;
    }
    if (allowNetwork) {
      try {
        final fresh = await _queue.enqueue(
          key,
          bypassCache: forceNetwork || stale,
        );
        return fresh ?? cached;
      } on Object {
        return cached;
      }
    }
    return cached;
  }
}
