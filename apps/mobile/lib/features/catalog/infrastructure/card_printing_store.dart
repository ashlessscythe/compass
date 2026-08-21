import 'package:compass/database/app_database.dart';
import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:drift/drift.dart';

/// Local SQLite access for cached Scryfall printings.
class CardPrintingStore {
  CardPrintingStore(this._db);

  final AppDatabase _db;

  static const bulkMetaKey = 'scryfall.bulk';

  Future<int> count() async {
    final row = await _db
        .customSelect('SELECT COUNT(*) AS c FROM card_printings')
        .getSingle();
    return row.read<int>('c');
  }

  Future<CatalogStatus> status() async {
    final printingCount = await count();
    final meta = await (_db.select(_db.catalogMeta)
          ..where((t) => t.key.equals(bulkMetaKey)))
        .getSingleOrNull();
    String? bulkType;
    DateTime? lastUpdated;
    if (meta != null) {
      lastUpdated = meta.updatedAt;
      final parts = meta.value.split('|');
      if (parts.isNotEmpty && parts.first.isNotEmpty) {
        bulkType = parts.first;
      }
    }
    return CatalogStatus(
      printingCount: printingCount,
      lastUpdatedAt: lastUpdated,
      bulkType: bulkType,
    );
  }

  Future<void> setBulkMeta({
    required String bulkType,
    required DateTime updatedAt,
  }) async {
    await _db.into(_db.catalogMeta).insertOnConflictUpdate(
          CatalogMetaCompanion.insert(
            key: bulkMetaKey,
            value: bulkType,
            updatedAt: updatedAt,
          ),
        );
  }

  Future<CardPrinting?> getById(String id) async {
    final row = await (_db.select(_db.cardPrintings)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<CardPrinting?> getBySetCollector({
    required String setCode,
    required String collectorNumber,
  }) async {
    final row = await (_db.select(_db.cardPrintings)
          ..where(
            (t) =>
                t.setCode.lower().equals(setCode.toLowerCase()) &
                t.collectorNumber.lower().equals(collectorNumber.toLowerCase()),
          )
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<CardPrinting?> findByExactName(String name) async {
    final normalized = normalizeCardName(name);
    if (normalized.isEmpty) {
      return null;
    }
    final row = await (_db.select(_db.cardPrintings)
          ..where((t) => t.nameNormalized.equals(normalized))
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  Future<CardPrinting?> findSimilarName(String name) async {
    final normalized = normalizeCardName(name);
    if (normalized.isEmpty) {
      return null;
    }
    final exact = await findByExactName(name);
    if (exact != null) {
      return exact;
    }
    final rows = await (_db.select(_db.cardPrintings)
          ..where((t) => t.nameNormalized.like('$normalized%'))
          ..limit(1))
        .get();
    if (rows.isEmpty) {
      return null;
    }
    return _toDomain(rows.first);
  }

  Future<void> upsert(CardPrinting printing) async {
    await _db.into(_db.cardPrintings).insertOnConflictUpdate(_toCompanion(printing));
  }

  Future<void> upsertAll(List<CardPrinting> printings) async {
    if (printings.isEmpty) {
      return;
    }
    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        _db.cardPrintings,
        printings.map(_toCompanion).toList(growable: false),
      );
    });
  }

  Future<void> clearPrintings() async {
    await _db.delete(_db.cardPrintings).go();
    await (_db.delete(_db.catalogMeta)
          ..where((t) => t.key.equals(bulkMetaKey)))
        .go();
  }

  CardPrintingsCompanion _toCompanion(CardPrinting printing) {
    return CardPrintingsCompanion.insert(
      id: printing.id,
      oracleId: Value(printing.oracleId),
      name: printing.name,
      nameNormalized: normalizeCardName(printing.name),
      setCode: printing.setCode,
      collectorNumber: printing.collectorNumber,
      typeLine: Value(printing.typeLine),
      manaCost: Value(printing.manaCost),
      imageSmallUrl: Value(printing.imageSmallUrl),
      imageNormalUrl: Value(printing.imageNormalUrl),
      fetchedAt: printing.fetchedAt,
    );
  }

  CardPrinting _toDomain(CardPrintingRow row) {
    return CardPrinting(
      id: row.id,
      oracleId: row.oracleId,
      name: row.name,
      setCode: row.setCode,
      collectorNumber: row.collectorNumber,
      typeLine: row.typeLine,
      manaCost: row.manaCost,
      imageSmallUrl: row.imageSmallUrl,
      imageNormalUrl: row.imageNormalUrl,
      fetchedAt: row.fetchedAt,
    );
  }
}
