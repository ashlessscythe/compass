import 'package:compass/core/domain/entities/relationship.dart';

/// Persistence contract for [Relationship] links.
abstract interface class RelationshipRepository {
  Future<List<Relationship>> getAll();

  Future<Relationship?> getById(String id);

  Future<List<Relationship>> getBySourceId(String sourceId);

  Stream<List<Relationship>> watchAll();

  Future<Relationship> create(Relationship relationship);

  Future<void> delete(String id);
}
