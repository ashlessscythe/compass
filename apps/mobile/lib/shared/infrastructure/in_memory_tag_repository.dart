import 'dart:async';

import 'package:compass/core/domain/entities/tag.dart';
import 'package:compass/core/domain/repositories/tag_repository.dart';

/// In-memory [TagRepository] until Drift tables are introduced.
class InMemoryTagRepository implements TagRepository {
  final Map<String, Tag> _store = {};
  final _controller = StreamController<List<Tag>>.broadcast();

  void _emit() => _controller.add(_store.values.toList(growable: false));

  @override
  Future<List<Tag>> getAll() async => _store.values.toList(growable: false);

  @override
  Future<Tag?> getById(String id) async => _store[id];

  @override
  Stream<List<Tag>> watchAll() async* {
    yield _store.values.toList(growable: false);
    yield* _controller.stream;
  }

  @override
  Future<Tag> create(Tag tag) async {
    _store[tag.id] = tag;
    _emit();
    return tag;
  }

  @override
  Future<Tag> update(Tag tag) async {
    _store[tag.id] = tag;
    _emit();
    return tag;
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
