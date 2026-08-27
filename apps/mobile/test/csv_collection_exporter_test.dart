import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/export/infrastructure/csv_collection_exporter.dart';
import 'package:compass/features/import/domain/csv_import_models.dart';
import 'package:compass/features/import/infrastructure/csv_collection_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final exporter = CsvCollectionExporter();
  final parser = CsvCollectionParser();

  test('builds header row and maps asset metadata', () {
    final asset = Asset(
      id: 'a1',
      name: 'Lightning Bolt',
      assetTypeId: 'type',
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
      quantity: 3,
      notes: 'binder top',
      metadata: Metadata(
        values: {
          MtgMetadataKeys.setCode: 'm10',
          MtgMetadataKeys.collectorNumber: '146',
          MtgMetadataKeys.finish: 'foil',
          MtgMetadataKeys.condition: 'NM',
          MtgMetadataKeys.scryfallCardId: 'abc-123',
          MtgMetadataKeys.layout: 'normal',
        },
      ),
    );

    final row = exporter.rowForAsset(asset, 'Office / Desk / Binder / Lightning Bolt');
    final csv = exporter.build([row]);
    final lines = csv
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .trim()
        .split('\n');

    expect(lines.first, CsvCollectionExporter.headers.join(','));
    expect(
      lines[1],
      'Lightning Bolt,3,m10,146,foil,NM,abc-123,normal,binder top,'
      'Office / Desk / Binder / Lightning Bolt',
    );
  });

  test('empty collection is header-only', () {
    final csv = exporter
        .build(const [])
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .trim();
    expect(csv, CsvCollectionExporter.headers.join(','));
  });

  test('Path header detects Compass dialect and parses fields', () {
    final csv = exporter.build([
      const CsvExportRow(
        name: 'Opt',
        quantity: 4,
        setValue: 'znr',
        collectorNumber: '65',
        finish: null,
        condition: 'SP',
        scryfallId: 'sf-1',
        layout: null,
        notes: null,
        path: 'Home / Box / Opt',
      ),
    ]);

    final result = parser.parse(csv);
    expect(result.dialect, CsvDialect.compass);
    expect(result.rowCount, 1);
    expect(result.rows.first.name, 'Opt');
    expect(result.rows.first.quantity, 4);
    expect(result.rows.first.setValue, 'znr');
    expect(result.rows.first.collectorNumber, '65');
    expect(result.rows.first.condition, 'SP');
    expect(result.rows.first.scryfallId, 'sf-1');
    expect(result.rows.first.path, 'Home / Box / Opt');
    expect(result.rows.first.dialect, CsvDialect.compass);
    expect(result.rows.first.dialect.metadataSource, 'compass');
  });

  test('detectDialect prefers Path over Moxfield-like columns', () {
    expect(
      parser.detectDialect([
        'name',
        'collector number',
        'edition',
        'path',
      ]),
      CsvDialect.compass,
    );
  });
}
