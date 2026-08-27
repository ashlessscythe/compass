import 'dart:convert';

import 'package:compass/database/app_database.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:drift/drift.dart';

/// Reads and writes cached domain pack manifests in SQLite.
class DomainPackManifestRepository {
  DomainPackManifestRepository(this._db);

  final AppDatabase _db;

  Future<List<InstalledDomainPackRow>> listInstalledRows() {
    return (_db.select(_db.installedDomainPacks)
          ..orderBy([(t) => OrderingTerm.asc(t.moduleId)]))
        .get();
  }

  Future<InstalledDomainPackRow?> rowForPackId(String packId) {
    return (_db.select(_db.installedDomainPacks)
          ..where((t) => t.packId.equals(packId)))
        .getSingleOrNull();
  }

  Future<List<DomainPack>> loadCachedPacks() async {
    final rows = await _db.select(_db.installedDomainPacks).get();
    final packs = <DomainPack>[];
    for (final row in rows) {
      final raw = row.manifestJson;
      if (raw == null || raw.trim().isEmpty) {
        continue;
      }
      try {
        final json = jsonDecode(raw);
        if (json is Map<String, dynamic>) {
          packs.add(DomainPack.fromJson(json));
        }
      } on Object {
        continue;
      }
    }
    return packs;
  }

  Future<void> upsertManifest({
    required DomainPack pack,
    required String sourceUrl,
    required String manifestJson,
  }) async {
    final now = DateTime.now().toUtc();
    await _db.into(_db.installedDomainPacks).insertOnConflictUpdate(
          InstalledDomainPacksCompanion.insert(
            packId: pack.id,
            version: pack.version,
            moduleId: pack.moduleId,
            installedAt: now,
            sourceUrl: Value(sourceUrl),
            manifestJson: Value(manifestJson),
          ),
        );
  }

  Future<void> backfillBundledIfMissing({
    required DomainPack pack,
    required String sourceUrl,
    required String manifestJson,
  }) async {
    final existing = await rowForPackId(pack.id);
    if (existing?.manifestJson != null && existing!.manifestJson!.isNotEmpty) {
      return;
    }
    await upsertManifest(
      pack: pack,
      sourceUrl: sourceUrl,
      manifestJson: manifestJson,
    );
  }
}
