import 'package:compass/core/domain/entities/location.dart';

/// Persistence contract for [Location] aggregates.
abstract interface class LocationRepository {
  Future<List<Location>> getAll();

  Future<Location?> getById(String id);

  Stream<List<Location>> watchAll();

  Future<Location> create(Location location);

  Future<Location> update(Location location);

  Future<void> delete(String id);

  Future<List<Location>> searchByName(String query);
}
