import 'package:compass/features/import/domain/csv_import_models.dart';
import 'package:csv/csv.dart';

/// Parses Deckbox / Moxfield / generic collection CSVs into [ImportRow]s.
class CsvCollectionParser {
  static const int warnRowThreshold = 5000;

  static const _nameHeaders = {
    'name',
    'simple name',
    'card',
    'card name',
  };
  static const _quantityHeaders = {
    'count',
    'quantity',
    'qty',
    'amount',
  };
  static const _setHeaders = {
    'edition',
    'set',
    'set code',
    'edition code',
    'set id',
    'set name',
    'set_hint',
    'set hint',
  };
  static const _collectorHeaders = {
    'card number',
    'collector number',
    'collector #',
  };
  static const _finishHeaders = {
    'foil',
    'printing',
    'finish',
    'premium',
  };
  static const _scryfallHeaders = {
    'scryfall id',
    'scryfallid',
  };
  static const _cardFormHeaders = {
    'card_form',
    'card form',
    'layout',
    'card layout',
  };
  static const _conditionHeaders = {
    'condition',
    'cond',
  };
  static const _pathHeaders = {
    'path',
  };

  /// Parse UTF-8 CSV [content]. Throws [CsvParseException] on bad input.
  CsvParseResult parse(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      throw CsvParseException('CSV file is empty.');
    }

    final table = const CsvToListConverter(
      shouldParseNumbers: false,
      eol: '\n',
    ).convert(_normalizeNewlines(trimmed));

    if (table.isEmpty) {
      throw CsvParseException('CSV file is empty.');
    }

    final rawHeaders = table.first.map((cell) => '$cell'.trim()).toList();
    if (rawHeaders.every((h) => h.isEmpty)) {
      throw CsvParseException('CSV has no header row.');
    }

    final headers = [
      for (final header in rawHeaders) header.toLowerCase(),
    ];
    final nameIndex = _firstIndex(headers, _nameHeaders);
    if (nameIndex == null) {
      throw CsvParseException(
        'CSV needs a Name column (Name, Simple Name, Card, or Card Name).',
      );
    }

    final quantityIndex = _firstIndex(headers, _quantityHeaders);
    final setIndex = _firstIndex(headers, _setHeaders);
    final collectorIndex = _firstIndex(headers, _collectorHeaders);
    final finishIndex = _firstIndex(headers, _finishHeaders);
    final scryfallIndex = _firstIndex(headers, _scryfallHeaders);
    final cardFormIndex = _firstIndex(headers, _cardFormHeaders);
    final conditionIndex = _firstIndex(headers, _conditionHeaders);
    final pathIndex = _firstIndex(headers, _pathHeaders);
    final dialect = detectDialect(headers);

    final rows = <ImportRow>[];
    var skipped = 0;

    for (var i = 1; i < table.length; i++) {
      final raw = table[i];
      String cell(int? index) {
        if (index == null || index >= raw.length) {
          return '';
        }
        return '${raw[index]}'.trim();
      }

      final name = cell(nameIndex);
      if (name.isEmpty) {
        skipped++;
        continue;
      }

      final quantity = _parseQuantity(cell(quantityIndex));
      final setValue = _nullIfEmpty(cell(setIndex));
      final collector = _nullIfEmpty(cell(collectorIndex));
      final finish = _normalizeFinish(cell(finishIndex));
      final scryfallId = _nullIfEmpty(cell(scryfallIndex));
      final cardForm = _normalizeCardForm(cell(cardFormIndex));
      final condition = _nullIfEmpty(cell(conditionIndex));
      final path = _nullIfEmpty(cell(pathIndex));

      rows.add(
        ImportRow(
          name: name,
          quantity: quantity,
          dialect: dialect,
          setValue: setValue,
          collectorNumber: collector,
          finish: finish,
          scryfallId: scryfallId,
          cardForm: cardForm,
          condition: condition,
          path: path,
        ),
      );
    }

    if (rows.isEmpty) {
      throw CsvParseException('CSV has no rows with a card name.');
    }

    return CsvParseResult(
      dialect: dialect,
      rows: rows,
      skippedEmptyNames: skipped,
    );
  }

  /// Public for unit tests.
  CsvDialect detectDialect(List<String> normalizedHeaders) {
    final set = normalizedHeaders.toSet();
    // Compass export fingerprint: Path column (checked before other dialects).
    if (set.contains('path')) {
      return CsvDialect.compass;
    }
    final hasTradelist = set.contains('tradelist count');
    final hasCollectorNumber = set.contains('collector number');
    final hasCardNumber = set.contains('card number');
    final hasEdition = set.contains('edition');

    if (hasTradelist && hasCardNumber && hasEdition) {
      return CsvDialect.deckbox;
    }
    if (hasCollectorNumber && hasEdition) {
      return CsvDialect.moxfield;
    }
    if (hasTradelist && hasEdition) {
      return CsvDialect.deckbox;
    }
    return CsvDialect.generic;
  }

  static String _normalizeNewlines(String input) {
    return input.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  }

  static int? _firstIndex(List<String> headers, Set<String> aliases) {
    for (var i = 0; i < headers.length; i++) {
      if (aliases.contains(headers[i])) {
        return i;
      }
    }
    return null;
  }

  static int _parseQuantity(String raw) {
    if (raw.isEmpty) {
      return 1;
    }
    final parsed = int.tryParse(raw);
    if (parsed == null || parsed < 1) {
      return 1;
    }
    return parsed;
  }

  static String? _nullIfEmpty(String value) {
    if (value.isEmpty) {
      return null;
    }
    return value;
  }

  static String? _normalizeFinish(String raw) {
    final value = raw.trim().toLowerCase();
    if (value.isEmpty ||
        value == 'normal' ||
        value == 'false' ||
        value == 'no' ||
        value == 'nonfoil') {
      return null;
    }
    if (value == 'true' || value == 'yes') {
      return 'foil';
    }
    return value;
  }

  /// Maps export card_form values onto Scryfall-ish layout keys when possible.
  static String? _normalizeCardForm(String raw) {
    final value = raw.trim().toLowerCase().replaceAll(' ', '_');
    if (value.isEmpty || value == 'single' || value == 'normal') {
      return null;
    }
    return switch (value) {
      'double_faced' || 'dfc' || 'transform' => 'transform',
      'modal_dfc' || 'mdfc' => 'modal_dfc',
      'split' => 'split',
      'flip' => 'flip',
      'adventure' => 'adventure',
      'meld' => 'meld',
      _ => value,
    };
  }
}
