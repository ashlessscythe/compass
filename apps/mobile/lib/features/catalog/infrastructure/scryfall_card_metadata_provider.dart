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
  }) async {
    if (scryfallId != null && scryfallId.isNotEmpty) {
      final local = await _store.getById(scryfallId);
      if (local != null) {
        return local;
      }
      if (allowNetwork) {
        return _queue.enqueue(CatalogMatchKey.scryfallId(scryfallId));
      }
      return null;
    }

    if (setCode != null &&
        setCode.isNotEmpty &&
        collectorNumber != null &&
        collectorNumber.isNotEmpty) {
      final local = await _store.getBySetCollector(
        setCode: setCode,
        collectorNumber: collectorNumber,
      );
      if (local != null) {
        return local;
      }
      if (allowNetwork) {
        return _queue.enqueue(
          CatalogMatchKey.setCollector(
            setCode: setCode,
            collectorNumber: collectorNumber,
          ),
        );
      }
      return null;
    }

    if (name != null && name.trim().isNotEmpty) {
      final exact = await _store.findByExactName(name);
      if (exact != null) {
        return exact;
      }
      final similar = await _store.findSimilarName(name);
      if (similar != null) {
        return similar;
      }
      if (allowNetwork) {
        return _queue.enqueue(CatalogMatchKey.name(name.trim()));
      }
    }
    return null;
  }
}
