import 'package:compass/core/domain/entities/photo.dart';

/// Persistence contract for [Photo] attachments.
abstract interface class PhotoRepository {
  Future<List<Photo>> getAll();

  Future<Photo?> getById(String id);

  Future<List<Photo>> getByEntityId(String entityId);

  Stream<List<Photo>> watchAll();

  Future<Photo> create(Photo photo);

  Future<Photo> update(Photo photo);

  Future<void> delete(String id);
}
