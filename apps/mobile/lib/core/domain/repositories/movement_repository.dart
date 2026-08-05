import 'package:compass/core/domain/entities/movement.dart';

/// Persistence contract for [Movement] records.
abstract interface class MovementRepository {
  Future<List<Movement>> getAll();

  Future<Movement?> getById(String id);

  Future<List<Movement>> getBySubjectId(String subjectId);

  Stream<List<Movement>> watchAll();

  Future<Movement> create(Movement movement);

  Future<void> delete(String id);
}
