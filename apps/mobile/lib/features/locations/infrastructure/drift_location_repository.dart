import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/domain/repositories/location_repository.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/database/mappers.dart';
import 'package:drift/drift.dart';

class DriftLocationRepository implements LocationRepository {
  DriftLocationRepository(this._db);

  final AppDatabase _db;

  Location _toDomain(LocationRow row) {
    return Location(
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
  }

  LocationsCompanion _toCompanion(Location location) {
    return LocationsCompanion.insert(
      id: location.id,
      name: location.name,
      parentLocationId: Value(location.parentLocationId),
      path: Value(location.path),
      nfcTagId: Value(location.nfcTagId),
      notes: Value(location.notes),
      metadataJson: Value(encodeMetadata(location.metadata)),
      createdAt: location.createdAt,
      updatedAt: location.updatedAt,
    );
  }

  @override
  Future<List<Location>> getAll() async {
    final rows = await _db.select(_db.locations).get();
    return rows.map(_toDomain).toList(growable: false);
  }

  @override
  Future<Location?> getById(String id) async {
    final row = await (_db.select(_db.locations)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Stream<List<Location>> watchAll() {
    return _db.select(_db.locations).watch().map(
          (rows) => rows.map(_toDomain).toList(growable: false),
        );
  }

  @override
  Future<Location> create(Location location) async {
    await _db.into(_db.locations).insert(_toCompanion(location));
    return location;
  }

  @override
  Future<Location> update(Location location) async {
    await _db.update(_db.locations).replace(_toCompanion(location));
    return location;
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.locations)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<Location>> searchByName(String query) async {
    final needle = _sanitizeLike(query);
    if (needle.isEmpty) {
      return const [];
    }
    final rows = await (_db.select(_db.locations)
          ..where((t) => t.name.lower().like('%$needle%')))
        .get();
    return rows.map(_toDomain).toList(growable: false);
  }
}

String _sanitizeLike(String query) {
  return query.trim().toLowerCase().replaceAll('%', '').replaceAll('_', '');
}
