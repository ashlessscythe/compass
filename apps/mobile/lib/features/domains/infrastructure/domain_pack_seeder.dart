import 'package:compass/database/app_database.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:drift/drift.dart';

/// Upserts pack manifest rows into SQLite (idempotent by pack version).
class DomainPackSeeder {
  DomainPackSeeder(this._db);

  final AppDatabase _db;

  Future<void> seedIfNeeded(DomainPack pack) async {
    final existing = await (_db.select(_db.installedDomainPacks)
          ..where((t) => t.packId.equals(pack.id)))
        .getSingleOrNull();
    if (existing != null && existing.version == pack.version) {
      return;
    }

    final now = DateTime.now().toUtc();
    await _db.transaction(() async {
      await _db.into(_db.installedDomainPacks).insertOnConflictUpdate(
            InstalledDomainPacksCompanion.insert(
              packId: pack.id,
              version: pack.version,
              moduleId: pack.moduleId,
              installedAt: now,
            ),
          );

      for (final type in pack.assetTypes) {
        final typeExisting = await (_db.select(_db.assetTypes)
              ..where((t) => t.id.equals(type.id)))
            .getSingleOrNull();
        if (typeExisting == null) {
          await _db.into(_db.assetTypes).insert(
                AssetTypesCompanion.insert(
                  id: type.id,
                  name: type.name,
                  moduleId: type.moduleId,
                  parentId: Value(type.parentId),
                  description: Value(type.description),
                  createdAt: now,
                  updatedAt: now,
                ),
              );
        }
      }

      for (final def in pack.attributeDefinitions) {
        await _db.into(_db.packAttributeDefinitions).insertOnConflictUpdate(
              PackAttributeDefinitionsCompanion.insert(
                id: def.id,
                packId: pack.id,
                key: def.key,
                valueType: def.valueType,
                assetTypeId: Value(def.assetTypeId),
                moduleId: Value(def.moduleId),
                displayName: Value(def.displayName),
                unit: Value(def.unit),
                vocabularyKey: Value(def.vocabularyKey),
                isRequired: Value(def.required),
              ),
            );
      }

      for (final value in pack.controlledValues) {
        await _db.into(_db.packControlledValues).insertOnConflictUpdate(
              PackControlledValuesCompanion.insert(
                id: value.id,
                packId: pack.id,
                vocabularyKey: value.vocabularyKey,
                canonicalKey: value.canonicalKey,
                label: value.label,
                parentId: Value(value.parentId),
              ),
            );
      }
    });
  }
}
