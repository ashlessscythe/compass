import 'package:compass/core/domain/entities/asset.dart';

/// Persistence contract for [Asset] aggregates.
abstract interface class AssetRepository {
  Future<List<Asset>> getAll();

  Future<Asset?> getById(String id);

  Stream<List<Asset>> watchAll();

  Future<Asset> create(Asset asset);

  Future<Asset> update(Asset asset);

  Future<void> delete(String id);
}
