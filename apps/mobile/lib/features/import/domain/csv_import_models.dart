/// Detected collection CSV dialect from headers.
enum CsvDialect {
  deckbox,
  moxfield,
  generic,
}

extension CsvDialectLabel on CsvDialect {
  String get label => switch (this) {
        CsvDialect.deckbox => 'Deckbox',
        CsvDialect.moxfield => 'Moxfield',
        CsvDialect.generic => 'Generic',
      };

  String get metadataSource => switch (this) {
        CsvDialect.deckbox => 'deckbox',
        CsvDialect.moxfield => 'moxfield',
        CsvDialect.generic => 'generic',
      };
}

/// One mapped row from a collection CSV.
class ImportRow {
  const ImportRow({
    required this.name,
    required this.quantity,
    required this.dialect,
    this.setValue,
    this.collectorNumber,
    this.finish,
    this.scryfallId,
  });

  final String name;
  final int quantity;
  final CsvDialect dialect;
  final String? setValue;
  final String? collectorNumber;
  final String? finish;
  final String? scryfallId;
}

/// Result of parsing a collection CSV.
class CsvParseResult {
  const CsvParseResult({
    required this.dialect,
    required this.rows,
    this.skippedEmptyNames = 0,
  });

  final CsvDialect dialect;
  final List<ImportRow> rows;
  final int skippedEmptyNames;

  int get rowCount => rows.length;
}

/// Thrown when a CSV cannot be imported.
class CsvParseException implements Exception {
  CsvParseException(this.message);

  final String message;

  @override
  String toString() => message;
}
