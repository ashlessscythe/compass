/// Labels for known CSV dialect ids (pack-defined + legacy MTG sources).
extension CsvDialectId on String {
  String get label => switch (this) {
        'compass' => 'Compass',
        'deckbox' => 'Deckbox',
        'moxfield' => 'Moxfield',
        'spreadsheet' => 'Spreadsheet',
        'generic' => 'Generic',
        _ => this,
      };

  String get metadataSource => this;

  bool get isCompass => this == 'compass';
}

/// One mapped row from a collection CSV.
class ImportRow {
  const ImportRow({
    required this.name,
    required this.quantity,
    required this.dialectId,
    this.fieldValues = const {},
    this.path,
  });

  final String name;
  final int quantity;

  /// Pack dialect id (`compass`, `deckbox`, `spreadsheet`, …).
  final String dialectId;

  /// Values keyed by pack `csvImport.fields[].key`.
  final Map<String, String?> fieldValues;

  /// Compass display path (`Place / … / Container / Name`).
  final String? path;

  String? field(String key) => fieldValues[key];

  // MTG back-compat getters for existing tests and call sites.
  String? get setValue => fieldValues['set'];
  String? get collectorNumber => fieldValues['collectorNumber'];
  String? get finish => fieldValues['finish'];
  String? get scryfallId => fieldValues['scryfallId'];
  String? get cardForm => fieldValues['layout'];
  String? get condition => fieldValues['condition'];
}

/// Result of parsing a collection CSV.
class CsvParseResult {
  const CsvParseResult({
    required this.dialectId,
    required this.rows,
    this.skippedEmptyNames = 0,
  });

  final String dialectId;
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
