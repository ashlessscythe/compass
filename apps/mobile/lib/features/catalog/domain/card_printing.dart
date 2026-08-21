/// Domain snapshot of a card printing (catalog metadata, not inventory).
class CardPrinting {
  const CardPrinting({
    required this.id,
    required this.name,
    required this.setCode,
    required this.collectorNumber,
    required this.fetchedAt,
    this.oracleId,
    this.typeLine,
    this.manaCost,
    this.imageSmallUrl,
    this.imageNormalUrl,
  });

  final String id;
  final String? oracleId;
  final String name;
  final String setCode;
  final String collectorNumber;
  final String? typeLine;
  final String? manaCost;
  final String? imageSmallUrl;
  final String? imageNormalUrl;
  final DateTime fetchedAt;
}

/// Status of the on-device card catalog.
class CatalogStatus {
  const CatalogStatus({
    required this.printingCount,
    this.lastUpdatedAt,
    this.bulkType,
  });

  final int printingCount;
  final DateTime? lastUpdatedAt;
  final String? bulkType;

  bool get isInstalled => printingCount > 0;
}

/// Progress while downloading / importing bulk catalog data.
class CatalogSyncProgress {
  const CatalogSyncProgress({
    required this.phase,
    this.fraction,
    this.detail,
  });

  final String phase;
  final double? fraction;
  final String? detail;
}
