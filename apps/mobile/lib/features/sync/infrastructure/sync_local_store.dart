import 'dart:convert';

import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/asset_type.dart';
import 'package:compass/core/domain/entities/container.dart';
import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/utils/display_path.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/database/mappers.dart';
import 'package:compass/features/sync/domain/sync_apply_order.dart';
import 'package:compass/features/sync/domain/sync_change.dart';
import 'package:drift/drift.dart';

/// Outbox + sync_state + remote apply (skips outbox).
class SyncLocalStore {
  SyncLocalStore(this._db);

  final AppDatabase _db;

  static const int stateRowId = 1;

  Future<void> ensureStateRow() async {
    final existing = await (_db.select(_db.syncState)
          ..where((t) => t.id.equals(stateRowId)))
        .getSingleOrNull();
    if (existing != null) {
      return;
    }
    await _db.into(_db.syncState).insert(
          SyncStateCompanion.insert(id: const Value(stateRowId)),
        );
  }

  Future<SyncStateRow> readState() async {
    await ensureStateRow();
    return (_db.select(_db.syncState)
          ..where((t) => t.id.equals(stateRowId)))
        .getSingle();
  }

  Future<void> saveSession({
    required String sessionToken,
    required String userId,
  }) async {
    await ensureStateRow();
    await (_db.update(_db.syncState)..where((t) => t.id.equals(stateRowId)))
        .write(
      SyncStateCompanion(
        sessionToken: Value(sessionToken),
        userId: Value(userId),
      ),
    );
  }

  Future<void> clearSession() async {
    await ensureStateRow();
    await (_db.update(_db.syncState)..where((t) => t.id.equals(stateRowId)))
        .write(
      const SyncStateCompanion(
        sessionToken: Value(null),
        userId: Value(null),
      ),
    );
  }

  Future<void> advanceCursor({
    required String cursor,
    required bool markInitialComplete,
  }) async {
    await ensureStateRow();
    await (_db.update(_db.syncState)..where((t) => t.id.equals(stateRowId)))
        .write(
      SyncStateCompanion(
        cursor: Value(cursor),
        lastSuccessAt: Value(DateTime.now().toUtc()),
        hasCompletedInitialSync: markInitialComplete
            ? const Value(true)
            : const Value.absent(),
      ),
    );
  }

  Future<void> enqueue({
    required SyncEntityType entityType,
    required String entityId,
    required SyncOp op,
    required DateTime updatedAt,
    Map<String, dynamic>? payload,
  }) async {
    await _db.into(_db.syncOutbox).insert(
          SyncOutboxCompanion.insert(
            entityType: entityType.wire,
            entityId: entityId,
            op: op.wire,
            updatedAt: updatedAt.toUtc(),
            payloadJson: Value(
              payload == null ? null : jsonEncode(payload),
            ),
          ),
        );
  }

  Future<List<SyncChange>> pendingChanges() async {
    final rows = await (_db.select(_db.syncOutbox)
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
    return rows
        .map(
          (row) => SyncChange(
            entityType: SyncEntityType.fromWire(row.entityType),
            entityId: row.entityId,
            op: SyncOp.fromWire(row.op),
            updatedAt: row.updatedAt.toUtc(),
            payload: row.payloadJson == null
                ? null
                : jsonDecode(row.payloadJson!) as Map<String, dynamic>,
            localId: row.id,
          ),
        )
        .toList(growable: false);
  }

  Future<void> clearOutboxIds(Iterable<int> ids) async {
    final list = ids.toList(growable: false);
    if (list.isEmpty) {
      return;
    }
    await (_db.delete(_db.syncOutbox)..where((t) => t.id.isIn(list))).go();
  }

  /// Enqueue every local graph row (first sync bootstrap).
  Future<void> enqueueFullSnapshot() async {
    final types = await _db.select(_db.assetTypes).get();
    for (final row in types) {
      final entity = _assetTypeFromRow(row);
      await enqueue(
        entityType: SyncEntityType.assetType,
        entityId: entity.id,
        op: SyncOp.upsert,
        updatedAt: entity.updatedAt,
        payload: entity.toJson(),
      );
    }
    final locations = await _db.select(_db.locations).get();
    for (final row in locations) {
      final entity = _locationFromRow(row);
      await enqueue(
        entityType: SyncEntityType.location,
        entityId: entity.id,
        op: SyncOp.upsert,
        updatedAt: entity.updatedAt,
        payload: entity.toJson(),
      );
    }
    final containers = await _db.select(_db.containers).get();
    for (final row in containers) {
      final entity = _containerFromRow(row);
      await enqueue(
        entityType: SyncEntityType.container,
        entityId: entity.id,
        op: SyncOp.upsert,
        updatedAt: entity.updatedAt,
        payload: entity.toJson(),
      );
    }
    final assets = await _db.select(_db.assets).get();
    for (final row in assets) {
      final entity = _assetFromRow(row);
      await enqueue(
        entityType: SyncEntityType.asset,
        entityId: entity.id,
        op: SyncOp.upsert,
        updatedAt: entity.updatedAt,
        payload: entity.toJson(),
      );
    }
  }

  Future<void> applyRemote(SyncChange change) async {
    await applyRemoteChanges([change]);
  }

  /// Apply pull batch in dependency order with retries for missing FK parents.
  Future<void> applyRemoteChanges(List<SyncChange> changes) async {
    if (changes.isEmpty) {
      return;
    }
    final ordered = sortChangesForApply(changes);
    final upserts =
        ordered.where((change) => change.op == SyncOp.upsert).toList();
    final deletes =
        ordered.where((change) => change.op == SyncOp.delete).toList();

    final appliedUpserts = <String>{};
    for (var pass = 0; pass < upserts.length + 1; pass++) {
      var progress = false;
      for (final change in upserts) {
        final key = '${change.entityType.wire}:${change.entityId}';
        if (appliedUpserts.contains(key)) {
          continue;
        }
        final payload = change.payload;
        if (payload == null) {
          appliedUpserts.add(key);
          continue;
        }
        final applied = await _tryApplyUpsert(
          change.entityType,
          change.updatedAt,
          payload,
        );
        if (applied) {
          appliedUpserts.add(key);
          progress = true;
        }
      }
      if (!progress) {
        break;
      }
    }

    for (final change in deletes) {
      await _deleteLocal(change.entityType, change.entityId);
    }
  }

  Future<void> recomputeAllLocationPaths() async {
    final rows = await _db.select(_db.locations).get();
    final byId = {for (final row in rows) row.id: row};
    final roots = rows.where((r) => r.parentLocationId == null);
    for (final root in roots) {
      await _recomputeSubtree(byId, root.id, null);
    }
  }

  Future<void> _recomputeSubtree(
    Map<String, LocationRow> byId,
    String id,
    String? parentPath,
  ) async {
    final row = byId[id];
    if (row == null) {
      return;
    }
    final path = DisplayPath.join(parentPath, row.name);
    if (row.path != path) {
      await (_db.update(_db.locations)..where((t) => t.id.equals(id))).write(
        LocationsCompanion(
          path: Value(path),
          updatedAt: Value(row.updatedAt),
        ),
      );
    }
    final children =
        byId.values.where((r) => r.parentLocationId == id).toList();
    for (final child in children) {
      await _recomputeSubtree(byId, child.id, path);
    }
  }

  Future<void> _deleteLocal(SyncEntityType type, String id) async {
    switch (type) {
      case SyncEntityType.location:
        await (_db.delete(_db.locations)..where((t) => t.id.equals(id))).go();
      case SyncEntityType.container:
        await (_db.delete(_db.containers)..where((t) => t.id.equals(id))).go();
      case SyncEntityType.asset:
        await (_db.delete(_db.assets)..where((t) => t.id.equals(id))).go();
      case SyncEntityType.assetType:
        await (_db.delete(_db.assetTypes)..where((t) => t.id.equals(id))).go();
    }
  }

  Future<bool> _tryApplyUpsert(
    SyncEntityType type,
    DateTime remoteUpdatedAt,
    Map<String, dynamic> payload,
  ) async {
    switch (type) {
      case SyncEntityType.assetType:
        return _upsertAssetType(remoteUpdatedAt, payload);
      case SyncEntityType.location:
        return _upsertLocation(remoteUpdatedAt, payload);
      case SyncEntityType.container:
        return _upsertContainer(remoteUpdatedAt, payload);
      case SyncEntityType.asset:
        return _upsertAsset(remoteUpdatedAt, payload);
    }
  }

  Future<bool> _locationExists(String id) async {
    return (_db.select(_db.locations)..where((t) => t.id.equals(id)))
            .getSingleOrNull()
        .then((row) => row != null);
  }

  Future<bool> _containerExists(String id) async {
    return (_db.select(_db.containers)..where((t) => t.id.equals(id)))
            .getSingleOrNull()
        .then((row) => row != null);
  }

  Future<bool> _assetTypeExists(String id) async {
    return (_db.select(_db.assetTypes)..where((t) => t.id.equals(id)))
            .getSingleOrNull()
        .then((row) => row != null);
  }

  Future<bool> _upsertLocation(
    DateTime remoteUpdatedAt,
    Map<String, dynamic> payload,
  ) async {
    final entity = Location.fromJson(payload);
    final existing = await (_db.select(_db.locations)
          ..where((t) => t.id.equals(entity.id)))
        .getSingleOrNull();
    if (existing != null &&
        existing.updatedAt.toUtc().isAfter(remoteUpdatedAt.toUtc())) {
      return true;
    }
    final parentId = entity.parentLocationId;
    if (parentId != null &&
        parentId != entity.id &&
        !await _locationExists(parentId)) {
      return false;
    }
    await _db.into(_db.locations).insertOnConflictUpdate(
          LocationsCompanion.insert(
            id: entity.id,
            name: entity.name,
            parentLocationId: Value(entity.parentLocationId),
            path: Value(entity.path),
            nfcTagId: Value(entity.nfcTagId),
            notes: Value(entity.notes),
            metadataJson: Value(encodeMetadata(entity.metadata)),
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt,
          ),
        );
    return true;
  }

  Future<bool> _upsertContainer(
    DateTime remoteUpdatedAt,
    Map<String, dynamic> payload,
  ) async {
    final entity = Container.fromJson(payload);
    final existing = await (_db.select(_db.containers)
          ..where((t) => t.id.equals(entity.id)))
        .getSingleOrNull();
    if (existing != null &&
        existing.updatedAt.toUtc().isAfter(remoteUpdatedAt.toUtc())) {
      return true;
    }
    final parentContainerId = entity.parentContainerId;
    if (parentContainerId != null &&
        parentContainerId != entity.id &&
        !await _containerExists(parentContainerId)) {
      return false;
    }
    final locationId = entity.locationId;
    if (locationId != null && !await _locationExists(locationId)) {
      return false;
    }
    await _db.into(_db.containers).insertOnConflictUpdate(
          ContainersCompanion.insert(
            id: entity.id,
            name: entity.name,
            parentContainerId: Value(entity.parentContainerId),
            locationId: Value(entity.locationId),
            nfcTagId: Value(entity.nfcTagId),
            notes: Value(entity.notes),
            metadataJson: Value(encodeMetadata(entity.metadata)),
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt,
          ),
        );
    return true;
  }

  Future<bool> _upsertAsset(
    DateTime remoteUpdatedAt,
    Map<String, dynamic> payload,
  ) async {
    final entity = Asset.fromJson(payload);
    final existing = await (_db.select(_db.assets)
          ..where((t) => t.id.equals(entity.id)))
        .getSingleOrNull();
    if (existing != null &&
        existing.updatedAt.toUtc().isAfter(remoteUpdatedAt.toUtc())) {
      return true;
    }
    if (!await _assetTypeExists(entity.assetTypeId)) {
      return false;
    }
    final containerId = entity.containerId;
    if (containerId != null && !await _containerExists(containerId)) {
      return false;
    }
    final locationId = entity.locationId;
    if (locationId != null && !await _locationExists(locationId)) {
      return false;
    }
    await _db.into(_db.assets).insertOnConflictUpdate(
          AssetsCompanion.insert(
            id: entity.id,
            name: entity.name,
            assetTypeId: entity.assetTypeId,
            quantity: Value(entity.quantity),
            containerId: Value(entity.containerId),
            locationId: Value(entity.locationId),
            notes: Value(entity.notes),
            metadataJson: Value(encodeMetadata(entity.metadata)),
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt,
          ),
        );
    return true;
  }

  Future<bool> _upsertAssetType(
    DateTime remoteUpdatedAt,
    Map<String, dynamic> payload,
  ) async {
    final entity = AssetType.fromJson(payload);
    final existing = await (_db.select(_db.assetTypes)
          ..where((t) => t.id.equals(entity.id)))
        .getSingleOrNull();
    if (existing != null &&
        existing.updatedAt.toUtc().isAfter(remoteUpdatedAt.toUtc())) {
      return true;
    }
    final parentId = entity.parentId;
    if (parentId != null &&
        parentId != entity.id &&
        !await _assetTypeExists(parentId)) {
      return false;
    }
    await _db.into(_db.assetTypes).insertOnConflictUpdate(
          AssetTypesCompanion.insert(
            id: entity.id,
            name: entity.name,
            moduleId: entity.moduleId,
            parentId: Value(entity.parentId),
            description: Value(entity.description),
            metadataJson: Value(encodeMetadata(entity.metadata)),
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt,
          ),
        );
    return true;
  }

  Location _locationFromRow(LocationRow row) => Location(
        id: row.id,
        name: row.name,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        parentLocationId: row.parentLocationId,
        path: row.path,
        nfcTagId: row.nfcTagId,
        notes: row.notes,
        metadata: decodeMetadata(row.metadataJson),
      );

  Container _containerFromRow(ContainerRow row) => Container(
        id: row.id,
        name: row.name,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        parentContainerId: row.parentContainerId,
        locationId: row.locationId,
        nfcTagId: row.nfcTagId,
        notes: row.notes,
        metadata: decodeMetadata(row.metadataJson),
      );

  Asset _assetFromRow(AssetRow row) => Asset(
        id: row.id,
        name: row.name,
        assetTypeId: row.assetTypeId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        quantity: row.quantity,
        containerId: row.containerId,
        locationId: row.locationId,
        notes: row.notes,
        metadata: decodeMetadata(row.metadataJson),
      );

  AssetType _assetTypeFromRow(AssetTypeRow row) => AssetType(
        id: row.id,
        name: row.name,
        moduleId: row.moduleId,
        createdAt: row.createdAt,
        updatedAt: row.updatedAt,
        parentId: row.parentId,
        description: row.description,
        metadata: decodeMetadata(row.metadataJson),
      );
}
