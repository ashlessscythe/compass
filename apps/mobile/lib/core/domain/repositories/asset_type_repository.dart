import 'package:compass/core/domain/entities/asset_type.dart';

/// Persistence contract for [AssetType] aggregates.
abstract interface class AssetTypeRepository {
  Future<List<AssetType>> getAll();

  Future<AssetType?> getById(String id);

  Stream<List<AssetType>> watchAll();

  Future<AssetType> create(AssetType assetType);

  Future<AssetType> update(AssetType assetType);

  Future<void> delete(String id);
}
