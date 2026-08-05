import 'dart:async';

import 'package:compass/core/domain/entities/photo.dart';
import 'package:compass/core/domain/repositories/photo_repository.dart';

/// In-memory [PhotoRepository] until Drift tables are introduced.
class InMemoryPhotoRepository implements PhotoRepository {
  final Map<String, Photo> _store = {};
  final _controller = StreamController<List<Photo>>.broadcast();

  void _emit() => _controller.add(_store.values.toList(growable: false));

  @override
  Future<List<Photo>> getAll() async =>
      _store.values.toList(growable: false);

  @override
  Future<Photo?> getById(String id) async => _store[id];

  @override
  Future<List<Photo>> getByEntityId(String entityId) async => _store.values
      .where((p) => p.entityId == entityId)
      .toList(growable: false);

  @override
  Stream<List<Photo>> watchAll() async* {
    yield _store.values.toList(growable: false);
    yield* _controller.stream;
  }

  @override
  Future<Photo> create(Photo photo) async {
    _store[photo.id] = photo;
    _emit();
    return photo;
  }

  @override
  Future<Photo> update(Photo photo) async {
    _store[photo.id] = photo;
    _emit();
    return photo;
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
