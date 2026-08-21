import 'dart:convert';
import 'dart:io';

import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/features/catalog/infrastructure/card_printing_store.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_http_client.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Downloads Scryfall bulk `default_cards` and upserts into SQLite.
class ScryfallBulkImporter {
  ScryfallBulkImporter({
    required CardPrintingStore store,
    required ScryfallHttpClient client,
  })  : _store = store,
        _client = client;

  final CardPrintingStore _store;
  final ScryfallHttpClient _client;

  /// Import from an already-decoded JSON array (tests / fixtures).
  Future<int> importJsonList(
    List<dynamic> cards, {
    String bulkType = 'fixture',
    void Function(int done, int total)? onProgress,
  }) async {
    final now = DateTime.now().toUtc();
    final batch = <CardPrinting>[];
    final total = cards.length;
    var done = 0;
    for (final item in cards) {
      if (item is! Map) {
        continue;
      }
      try {
        final printing = ScryfallHttpClient.printingFromJson(
          Map<String, dynamic>.from(item),
        );
        if (printing == null) {
          continue;
        }
        batch.add(printing);
      } on Object {
        continue;
      }
      if (batch.length >= 250) {
        await _store.upsertAll(List<CardPrinting>.from(batch));
        done += batch.length;
        batch.clear();
        onProgress?.call(done, total);
      }
    }
    if (batch.isNotEmpty) {
      await _store.upsertAll(batch);
      done += batch.length;
      onProgress?.call(done, total);
    }
    await _store.setBulkMeta(bulkType: bulkType, updatedAt: now);
    return done;
  }

  Future<int> downloadAndImport({
    void Function(CatalogSyncProgressLike progress)? onProgress,
  }) async {
    onProgress?.call(
      const CatalogSyncProgressLike(phase: 'Locating bulk file'),
    );
    final bulk = await _client.defaultCardsBulk();
    onProgress?.call(
      CatalogSyncProgressLike(
        phase: 'Downloading catalog',
        detail: bulk.size == null
            ? null
            : '~${(bulk.size! / (1024 * 1024)).toStringAsFixed(0)} MB',
      ),
    );

    final dir = await getTemporaryDirectory();
    final isGzipJsonl = bulk.downloadUri.path.contains('.jsonl');
    final file = File(
      p.join(
        dir.path,
        isGzipJsonl
            ? 'scryfall_default_cards.jsonl.gz'
            : 'scryfall_default_cards.json',
      ),
    );

    final bytes = await _client.downloadBytes(
      bulk.downloadUri,
      onBytes: (received, total) {
        onProgress?.call(
          CatalogSyncProgressLike(
            phase: 'Downloading catalog',
            fraction: total == null || total == 0 ? null : received / total,
          ),
        );
      },
    );
    await file.writeAsBytes(bytes, flush: true);

    onProgress?.call(
      const CatalogSyncProgressLike(phase: 'Indexing catalog'),
    );

    final int count;
    if (isGzipJsonl || _looksGzip(bytes)) {
      count = await _importGzipJsonlFile(
        file,
        bulkType: bulk.type,
        onProgress: (done) {
          onProgress?.call(
            CatalogSyncProgressLike(
              phase: 'Indexing catalog',
              detail: '$done cards',
            ),
          );
        },
      );
    } else {
      final decoded = jsonDecode(await file.readAsString()) as List<dynamic>;
      count = await importJsonList(
        decoded,
        bulkType: bulk.type,
        onProgress: (done, total) {
          onProgress?.call(
            CatalogSyncProgressLike(
              phase: 'Indexing catalog',
              fraction: total == 0 ? null : done / total,
              detail: '$done / $total',
            ),
          );
        },
      );
    }

    try {
      await file.delete();
    } on Object {
      // ignore cleanup failures
    }
    return count;
  }

  Future<int> _importGzipJsonlFile(
    File file, {
    required String bulkType,
    void Function(int done)? onProgress,
  }) async {
    final now = DateTime.now().toUtc();
    final batch = <CardPrinting>[];
    var done = 0;

    final lines = file
        .openRead()
        .transform(gzip.decoder)
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is! Map) {
          continue;
        }
        final printing = ScryfallHttpClient.printingFromJson(
          Map<String, dynamic>.from(decoded),
        );
        if (printing == null) {
          continue;
        }
        batch.add(printing);
      } on Object {
        continue;
      }

      if (batch.length >= 250) {
        await _store.upsertAll(List<CardPrinting>.from(batch));
        done += batch.length;
        batch.clear();
        onProgress?.call(done);
      }
    }

    if (batch.isNotEmpty) {
      await _store.upsertAll(batch);
      done += batch.length;
      onProgress?.call(done);
    }

    await _store.setBulkMeta(bulkType: bulkType, updatedAt: now);
    return done;
  }

  bool _looksGzip(List<int> bytes) {
    return bytes.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b;
  }
}

/// Lightweight progress DTO to avoid circular imports with domain.
class CatalogSyncProgressLike {
  const CatalogSyncProgressLike({
    required this.phase,
    this.fraction,
    this.detail,
  });

  final String phase;
  final double? fraction;
  final String? detail;
}
