import 'dart:async';

import 'package:compass/core/domain/entities/relationship.dart';
import 'package:compass/core/domain/repositories/relationship_repository.dart';

/// In-memory [RelationshipRepository] until Drift tables are introduced.
class InMemoryRelationshipRepository implements RelationshipRepository {
  final Map<String, Relationship> _store = {};
  final _controller = StreamController<List<Relationship>>.broadcast();

  void _emit() => _controller.add(_store.values.toList(growable: false));

  @override
  Future<List<Relationship>> getAll() async =>
      _store.values.toList(growable: false);

  @override
  Future<Relationship?> getById(String id) async => _store[id];

  @override
  Future<List<Relationship>> getBySourceId(String sourceId) async =>
      _store.values
          .where((r) => r.sourceId == sourceId)
          .toList(growable: false);

  @override
  Stream<List<Relationship>> watchAll() async* {
    yield _store.values.toList(growable: false);
    yield* _controller.stream;
  }

  @override
  Future<Relationship> create(Relationship relationship) async {
    _store[relationship.id] = relationship;
    _emit();
    return relationship;
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
