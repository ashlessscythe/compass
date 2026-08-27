import 'dart:io';

import 'package:compass/features/import/domain/csv_import_models.dart';
import 'package:compass/features/import/infrastructure/csv_collection_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final parser = CsvCollectionParser();

  test('parses Deckbox-style CSV and detects dialect', () {
    final content =
        File('test/fixtures/import/deckbox_sample.csv').readAsStringSync();
    final result = parser.parse(content);

    expect(result.dialectId, 'deckbox');
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
    final content =
        File('test/fixtures/import/moxfield_sample.csv').readAsStringSync();
    final result = parser.parse(content);

    expect(result.dialectId, 'moxfield');
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

    expect(result.dialectId, 'generic');
    expect(result.rows.first.quantity, 1);
    expect(result.rows.first.setValue, 'znr');
    expect(result.rows[1].quantity, 4);
  });

  test('detects Compass dialect from Path column', () {
    const content = 'Name,Quantity,Set,Collector Number,Path\n'
        'Lightning Bolt,1,m10,146,Office / Binder / Lightning Bolt\n';
    final result = parser.parse(content);

    expect(result.dialectId, 'compass');
    expect(result.rows.first.name, 'Lightning Bolt');
    expect(result.rows.first.setValue, 'm10');
    expect(result.rows.first.collectorNumber, '146');
    expect(result.rows.first.path, 'Office / Binder / Lightning Bolt');
    expect(result.rows.first.dialectId.metadataSource, 'compass');
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

  test('recognizes set_hint, card_form, and // multi-face names', () {
    const content = 'name,quantity,condition,finish,card_form,set_hint\n'
        'Liliana of the Veil,2,SP,foil,single,EMN\n'
        'Brazen Borrower // Petty Theft,2,NM,nonfoil,double_faced,ELD\n'
        'Valakut Awakening // Valakut Stoneforge,2,SP,nonfoil,modal_dfc,ZNR\n';
    final result = parser.parse(content);

    expect(result.dialectId, 'generic');
    expect(result.rowCount, 3);

    final single = result.rows[0];
    expect(single.setValue, 'EMN');
    expect(single.finish, 'foil');
    expect(single.condition, 'SP');
    expect(single.cardForm, isNull);

    final dfc = result.rows[1];
    expect(dfc.name, 'Brazen Borrower // Petty Theft');
    expect(dfc.setValue, 'ELD');
    expect(dfc.finish, isNull);
    expect(dfc.cardForm, 'transform');

    final mdfc = result.rows[2];
    expect(mdfc.cardForm, 'modal_dfc');
    expect(mdfc.setValue, 'ZNR');
  });
}
