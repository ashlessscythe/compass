import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/repositories/asset_repository.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/database/mappers.dart';
import 'package:drift/drift.dart';

class DriftAssetRepository implements AssetRepository {
  DriftAssetRepository(this._db);

  final AppDatabase _db;

  Asset _toDomain(AssetRow row) {
    return Asset(
      id: row.id,
      name: row.name,
      assetTypeId: row.assetTypeId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      containerId: row.containerId,
      locationId: row.locationId,
      notes: row.notes,
      metadata: decodeMetadata(row.metadataJson),
    );
  }

  AssetsCompanion _toCompanion(Asset asset) {
    return AssetsCompanion.insert(
      id: asset.id,
      name: asset.name,
      assetTypeId: asset.assetTypeId,
      containerId: Value(asset.containerId),
      locationId: Value(asset.locationId),
      notes: Value(asset.notes),
      metadataJson: Value(encodeMetadata(asset.metadata)),
      createdAt: asset.createdAt,
      updatedAt: asset.updatedAt,
    );
  }

  @override
  Future<List<Asset>> getAll() async {
    final rows = await _db.select(_db.assets).get();
    return rows.map(_toDomain).toList(growable: false);
  }

  @override
  Future<Asset?> getById(String id) async {
    final row = await (_db.select(_db.assets)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Stream<List<Asset>> watchAll() {
    return _db.select(_db.assets).watch().map(
          (rows) => rows.map(_toDomain).toList(growable: false),
        );
  }

  @override
  Future<Asset> create(Asset asset) async {
    await _db.into(_db.assets).insert(_toCompanion(asset));
    return asset;
  }

  @override
  Future<Asset> update(Asset asset) async {
    await _db.update(_db.assets).replace(_toCompanion(asset));
    return asset;
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.assets)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<Asset>> searchByName(String query) async {
    final needle = _sanitizeLike(query);
    if (needle.isEmpty) {
      return const [];
    }
    final rows = await (_db.select(_db.assets)
          ..where((t) => t.name.lower().like('%$needle%')))
        .get();
    return rows.map(_toDomain).toList(growable: false);
  }
}

String _sanitizeLike(String query) {
  return query.trim().toLowerCase().replaceAll('%', '').replaceAll('_', '');
}
