import 'dart:io';

import 'package:compass/features/import/domain/csv_import_models.dart';
import 'package:compass/features/import/infrastructure/csv_collection_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = CsvCollectionParser();

  test('parses Deckbox-style CSV and detects dialect', () {
    final content = File('test/fixtures/import/deckbox_sample.csv')
        .readAsStringSync();
    final result = parser.parse(content);

    expect(result.dialect, CsvDialect.deckbox);
    expect(result.rowCount, 3);
    expect(result.rows.first.name, 'Lightning Bolt');
    expect(result.rows.first.quantity, 1);
    expect(result.rows.first.setValue, 'Magic 2010');
    expect(result.rows.first.collectorNumber, '146');
    expect(result.rows.first.finish, isNull);

    final foil = result.rows[1];
    expect(foil.name, 'Counterspell');
    expect(foil.quantity, 2);
    expect(foil.finish, 'foil');

    expect(result.rows[2].name, 'Farm // Table');
  });

  test('parses Moxfield-style CSV and detects dialect', () {
    final content = File('test/fixtures/import/moxfield_sample.csv')
        .readAsStringSync();
    final result = parser.parse(content);

    expect(result.dialect, CsvDialect.moxfield);
    expect(result.rowCount, 3);
    expect(result.rows.first.name, 'Lightning Bolt');
    expect(result.rows.first.setValue, 'm10');
    expect(result.rows.first.collectorNumber, '146');

    final foil = result.rows[1];
    expect(foil.name, 'Sol Ring');
    expect(foil.finish, 'foil');
    expect(foil.collectorNumber, '1');
  });

  test('maps generic aliases and defaults quantity', () {
    const content = 'Card Name,Qty,Set Code\n'
        'Opt, ,znr\n'
        'Shock,4,m21\n';
    final result = parser.parse(content);

    expect(result.dialect, CsvDialect.generic);
    expect(result.rows.first.quantity, 1);
    expect(result.rows.first.setValue, 'znr');
    expect(result.rows[1].quantity, 4);
  });

  test('rejects CSV without a name column', () {
    expect(
      () => parser.parse('Count,Edition\n1,m10\n'),
      throwsA(isA<CsvParseException>()),
    );
  });

  test('skips empty name rows', () {
    const content = 'Name,Count\n'
        'Bolt,1\n'
        ',2\n'
        'Opt,1\n';
    final result = parser.parse(content);
    expect(result.rowCount, 2);
    expect(result.skippedEmptyNames, 1);
  });
}
