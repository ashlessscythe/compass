import 'dart:async';

import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/domain/repositories/location_repository.dart';

/// In-memory [LocationRepository] until Drift tables are introduced.
class InMemoryLocationRepository implements LocationRepository {
  final Map<String, Location> _store = {};
  final _controller = StreamController<List<Location>>.broadcast();

  void _emit() => _controller.add(_store.values.toList(growable: false));

  @override
  Future<List<Location>> getAll() async =>
      _store.values.toList(growable: false);

  @override
  Future<Location?> getById(String id) async => _store[id];

  @override
  Stream<List<Location>> watchAll() async* {
    yield _store.values.toList(growable: false);
    yield* _controller.stream;
  }

  @override
  Future<Location> create(Location location) async {
    _store[location.id] = location;
    _emit();
    return location;
  }

  @override
  Future<Location> update(Location location) async {
    _store[location.id] = location;
    _emit();
    return location;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
    _emit();
  }

  @override
  Future<List<Location>> searchByName(String query) async {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) {
      return const [];
    }
    return _store.values
        .where((location) => location.name.toLowerCase().contains(needle))
        .toList(growable: false);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
