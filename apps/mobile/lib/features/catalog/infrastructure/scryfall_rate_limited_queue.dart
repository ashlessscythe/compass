import 'dart:async';
import 'dart:collection';

import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/catalog/infrastructure/card_printing_store.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_http_client.dart';

/// Single-flight, rate-limited Scryfall resolve queue.
///
/// Skips keys already in SQLite; coalesces in-flight duplicates.
class ScryfallRateLimitedQueue {
  ScryfallRateLimitedQueue({
    required CardPrintingStore store,
    required ScryfallHttpClient client,
    this.minInterval = const Duration(milliseconds: 120),
  })  : _store = store,
        _client = client;

  final CardPrintingStore _store;
  final ScryfallHttpClient _client;
  final Duration minInterval;

  final _pending = Queue<_QueueItem>();
  final _inflight = <String, Future<CardPrinting?>>{};
  var _pumping = false;
  DateTime _nextAllowed = DateTime.fromMillisecondsSinceEpoch(0);

  Future<CardPrinting?> enqueue(
    CatalogMatchKey key, {
    bool bypassCache = false,
  }) {
    final existing = _inflight[key.dedupeId];
    if (existing != null) {
      return existing;
    }

    final completer = Completer<CardPrinting?>();
    final future = completer.future;
    _inflight[key.dedupeId] = future;
    _pending.add(
      _QueueItem(key: key, completer: completer, bypassCache: bypassCache),
    );
    unawaited(_pump());
    return future;
  }

  Future<void> _pump() async {
    if (_pumping) {
      return;
    }
    _pumping = true;
    try {
      while (_pending.isNotEmpty) {
        final item = _pending.removeFirst();
        try {
          if (!item.bypassCache) {
            final cached = await _lookupLocal(item.key);
            if (cached != null) {
              item.completer.complete(cached);
              continue;
            }
          }

          final wait = _nextAllowed.difference(DateTime.now());
          if (wait > Duration.zero) {
            await Future<void>.delayed(wait);
          }
          final printing = await _fetch(item.key);
          _nextAllowed = DateTime.now().add(minInterval);
          if (printing != null) {
            await _store.upsert(printing);
          }
          item.completer.complete(printing);
        } on Object catch (error, stack) {
          item.completer.completeError(error, stack);
        } finally {
          _inflight.remove(item.key.dedupeId);
        }
      }
    } finally {
      _pumping = false;
      if (_pending.isNotEmpty) {
        unawaited(_pump());
      }
    }
  }

  Future<CardPrinting?> _lookupLocal(CatalogMatchKey key) {
    return switch (key) {
      ScryfallIdKey(:final id) => _store.getById(id),
      SetCollectorKey(:final setCode, :final collectorNumber) =>
        _store.getBySetCollector(
          setCode: setCode,
          collectorNumber: collectorNumber,
        ),
      NameKey(:final name) => _store.findByExactName(name),
    };
  }

  Future<CardPrinting?> _fetch(CatalogMatchKey key) {
    return switch (key) {
      ScryfallIdKey(:final id) => _client.fetchById(id),
      SetCollectorKey(:final setCode, :final collectorNumber) =>
        _client.fetchBySetCollector(
          setCode: setCode,
          collectorNumber: collectorNumber,
        ),
      NameKey(:final name) => _client.fetchByExactName(name),
    };
  }
}

class _QueueItem {
  _QueueItem({
    required this.key,
    required this.completer,
    this.bypassCache = false,
  });

  final CatalogMatchKey key;
  final Completer<CardPrinting?> completer;
  final bool bypassCache;
}
