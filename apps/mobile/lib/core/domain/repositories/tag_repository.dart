import 'package:compass/core/domain/entities/tag.dart';

/// Persistence contract for [Tag] labels.
abstract interface class TagRepository {
  Future<List<Tag>> getAll();

  Future<Tag?> getById(String id);

  Stream<List<Tag>> watchAll();

  Future<Tag> create(Tag tag);

  Future<Tag> update(Tag tag);

  Future<void> delete(String id);
}
