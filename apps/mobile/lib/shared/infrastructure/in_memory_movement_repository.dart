import 'dart:async';

import 'package:compass/core/domain/entities/movement.dart';
import 'package:compass/core/domain/repositories/movement_repository.dart';

/// In-memory [MovementRepository] until Drift tables are introduced.
class InMemoryMovementRepository implements MovementRepository {
  final Map<String, Movement> _store = {};
  final _controller = StreamController<List<Movement>>.broadcast();

  void _emit() => _controller.add(_store.values.toList(growable: false));

  @override
  Future<List<Movement>> getAll() async =>
      _store.values.toList(growable: false);

  @override
  Future<Movement?> getById(String id) async => _store[id];

  @override
  Future<List<Movement>> getBySubjectId(String subjectId) async => _store.values
      .where((m) => m.subjectId == subjectId)
      .toList(growable: false);

  @override
  Stream<List<Movement>> watchAll() async* {
    yield _store.values.toList(growable: false);
    yield* _controller.stream;
  }

  @override
  Future<Movement> create(Movement movement) async {
    _store[movement.id] = movement;
    _emit();
    return movement;
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
