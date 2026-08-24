import 'package:compass/core/domain/entities/container.dart';
import 'package:compass/core/domain/repositories/container_repository.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/database/mappers.dart';
import 'package:compass/features/sync/domain/sync_change.dart';
import 'package:compass/features/sync/infrastructure/sync_local_store.dart';
import 'package:drift/drift.dart';

class DriftContainerRepository implements ContainerRepository {
  DriftContainerRepository(this._db, this._sync);

  final AppDatabase _db;
  final SyncLocalStore _sync;

  Container _toDomain(ContainerRow row) {
    return Container(
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
  }

  ContainersCompanion _toCompanion(Container container) {
    return ContainersCompanion.insert(
      id: container.id,
      name: container.name,
      parentContainerId: Value(container.parentContainerId),
      locationId: Value(container.locationId),
      nfcTagId: Value(container.nfcTagId),
      notes: Value(container.notes),
      metadataJson: Value(encodeMetadata(container.metadata)),
      createdAt: container.createdAt,
      updatedAt: container.updatedAt,
    );
  }

  @override
  Future<List<Container>> getAll() async {
    final rows = await _db.select(_db.containers).get();
    return rows.map(_toDomain).toList(growable: false);
  }

  @override
  Future<Container?> getById(String id) async {
    final row = await (_db.select(_db.containers)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Stream<List<Container>> watchAll() {
    return _db.select(_db.containers).watch().map(
          (rows) => rows.map(_toDomain).toList(growable: false),
        );
  }

  @override
  Future<Container> create(Container container) async {
    await _db.transaction(() async {
      await _db.into(_db.containers).insert(_toCompanion(container));
      await _sync.enqueue(
        entityType: SyncEntityType.container,
        entityId: container.id,
        op: SyncOp.upsert,
        updatedAt: container.updatedAt,
        payload: container.toJson(),
      );
    });
    return container;
  }

  @override
  Future<Container> update(Container container) async {
    await _db.transaction(() async {
      await _db.update(_db.containers).replace(_toCompanion(container));
      await _sync.enqueue(
        entityType: SyncEntityType.container,
        entityId: container.id,
        op: SyncOp.upsert,
        updatedAt: container.updatedAt,
        payload: container.toJson(),
      );
    });
    return container;
  }

  @override
  Future<void> delete(String id) async {
    final now = DateTime.now().toUtc();
    await _db.transaction(() async {
      await (_db.delete(_db.containers)..where((t) => t.id.equals(id))).go();
      await _sync.enqueue(
        entityType: SyncEntityType.container,
        entityId: id,
        op: SyncOp.delete,
        updatedAt: now,
      );
    });
  }

  @override
  Future<List<Container>> searchByName(String query) async {
    final needle = _sanitizeLike(query);
    if (needle.isEmpty) {
      return const [];
    }
    final rows = await (_db.select(_db.containers)
          ..where((t) => t.name.lower().like('%$needle%')))
        .get();
    return rows.map(_toDomain).toList(growable: false);
  }

  @override
  Future<Container?> getByNfcTagId(String nfcTagId) async {
    final tag = nfcTagId.trim();
    if (tag.isEmpty) {
      return null;
    }
    final row = await (_db.select(_db.containers)
          ..where((t) => t.nfcTagId.equals(tag)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }
}

String _sanitizeLike(String query) {
  return query.trim().toLowerCase().replaceAll('%', '').replaceAll('_', '');
}
