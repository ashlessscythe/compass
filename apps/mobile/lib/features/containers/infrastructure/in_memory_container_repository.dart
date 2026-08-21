import 'dart:async';

import 'package:compass/core/domain/entities/container.dart';
import 'package:compass/core/domain/repositories/container_repository.dart';

/// In-memory [ContainerRepository] until Drift tables are introduced.
class InMemoryContainerRepository implements ContainerRepository {
  final Map<String, Container> _store = {};
  final _controller = StreamController<List<Container>>.broadcast();

  void _emit() => _controller.add(_store.values.toList(growable: false));

  @override
  Future<List<Container>> getAll() async =>
      _store.values.toList(growable: false);

  @override
  Future<Container?> getById(String id) async => _store[id];

  @override
  Stream<List<Container>> watchAll() async* {
    yield _store.values.toList(growable: false);
    yield* _controller.stream;
  }

  @override
  Future<Container> create(Container container) async {
    _store[container.id] = container;
    _emit();
    return container;
  }

  @override
  Future<Container> update(Container container) async {
    _store[container.id] = container;
    _emit();
    return container;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
    _emit();
  }

  @override
  Future<List<Container>> searchByName(String query) async {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) {
      return const [];
    }
    return _store.values
        .where((container) => container.name.toLowerCase().contains(needle))
        .toList(growable: false);
  }

  @override
  Future<Container?> getByNfcTagId(String nfcTagId) async {
    final tag = nfcTagId.trim();
    if (tag.isEmpty) {
      return null;
    }
    for (final container in _store.values) {
      if (container.nfcTagId == tag) {
        return container;
      }
    }
    return null;
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
