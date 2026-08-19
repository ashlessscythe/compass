import 'package:compass/core/domain/entities/container.dart';

/// Persistence contract for [Container] aggregates.
abstract interface class ContainerRepository {
  Future<List<Container>> getAll();

  Future<Container?> getById(String id);

  Stream<List<Container>> watchAll();

  Future<Container> create(Container container);

  Future<Container> update(Container container);

  Future<void> delete(String id);

  Future<List<Container>> searchByName(String query);
}
