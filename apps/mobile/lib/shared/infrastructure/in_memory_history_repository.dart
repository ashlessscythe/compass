import 'dart:async';

import 'package:compass/core/domain/entities/history_entry.dart';
import 'package:compass/core/domain/repositories/history_repository.dart';

/// In-memory [HistoryRepository] until Drift tables are introduced.
class InMemoryHistoryRepository implements HistoryRepository {
  final Map<String, HistoryEntry> _store = {};
  final _controller = StreamController<List<HistoryEntry>>.broadcast();

  void _emit() => _controller.add(_store.values.toList(growable: false));

  @override
  Future<List<HistoryEntry>> getAll() async =>
      _store.values.toList(growable: false);

  @override
  Future<HistoryEntry?> getById(String id) async => _store[id];

  @override
  Future<List<HistoryEntry>> getByEntityId(String entityId) async =>
      _store.values
          .where((e) => e.entityId == entityId)
          .toList(growable: false);

  @override
  Stream<List<HistoryEntry>> watchAll() async* {
    yield _store.values.toList(growable: false);
    yield* _controller.stream;
  }

  @override
  Future<HistoryEntry> create(HistoryEntry entry) async {
    _store[entry.id] = entry;
    _emit();
    return entry;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
    _emit();
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
