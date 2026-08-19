import 'package:compass/core/domain/entities/asset_type.dart';
import 'package:compass/core/domain/repositories/asset_type_repository.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/database/mappers.dart';
import 'package:drift/drift.dart';

class DriftAssetTypeRepository implements AssetTypeRepository {
  DriftAssetTypeRepository(this._db);

  final AppDatabase _db;

  AssetType _toDomain(AssetTypeRow row) {
    return AssetType(
      id: row.id,
      name: row.name,
      moduleId: row.moduleId,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      description: row.description,
      metadata: decodeMetadata(row.metadataJson),
    );
  }

  AssetTypesCompanion _toCompanion(AssetType type) {
    return AssetTypesCompanion.insert(
      id: type.id,
      name: type.name,
      moduleId: type.moduleId,
      description: Value(type.description),
      metadataJson: Value(encodeMetadata(type.metadata)),
      createdAt: type.createdAt,
      updatedAt: type.updatedAt,
    );
  }

  @override
  Future<List<AssetType>> getAll() async {
    final rows = await _db.select(_db.assetTypes).get();
    return rows.map(_toDomain).toList(growable: false);
  }

  @override
  Future<AssetType?> getById(String id) async {
    final row = await (_db.select(_db.assetTypes)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Stream<List<AssetType>> watchAll() {
    return _db.select(_db.assetTypes).watch().map(
          (rows) => rows.map(_toDomain).toList(growable: false),
        );
  }

  @override
  Future<AssetType> create(AssetType assetType) async {
    await _db.into(_db.assetTypes).insert(_toCompanion(assetType));
    return assetType;
  }

  @override
  Future<AssetType> update(AssetType assetType) async {
    await _db.update(_db.assetTypes).replace(_toCompanion(assetType));
    return assetType;
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.assetTypes)..where((t) => t.id.equals(id))).go();
  }
}
