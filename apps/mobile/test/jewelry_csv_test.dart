import 'package:compass/features/domains/application/pack_csv_adapter.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_loader.dart';
import 'package:compass/features/export/infrastructure/csv_collection_exporter.dart';
import 'package:compass/features/import/infrastructure/csv_collection_parser.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('jewelry spreadsheet CSV maps attributes', () async {
    final pack = await DomainPackLoader().loadBundled('jewelry');
    const content = 'Item Name,Jewelry Type,Metal Type,Gemstone,Carat Weight,'
        'Brand,Purchase Price,Appraised Value,Condition\n'
        'Grandma Ring,Ring,Gold,Diamond,1.2,Tiffany,5000,8000,Excellent\n';

    final parser = PackCsvAdapter(pack).createParser();
    final result = parser.parse(content);

    expect(result.dialectId, 'spreadsheet');
    expect(result.rowCount, 1);
    final row = result.rows.first;
    expect(row.name, 'Grandma Ring');
    expect(row.field('category'), 'Ring');
    expect(row.field('material'), 'Gold');
    expect(row.field('gemstone'), 'Diamond');
    expect(row.field('carat'), '1.2');
    expect(row.field('maker'), 'Tiffany');
    expect(row.field('purchaseValue'), '5000');
    expect(row.field('appraisalValue'), '8000');
    expect(row.field('condition'), 'Excellent');

    final metadata = PackCsvAdapter(pack).metadataValuesForRow(row);
    expect(metadata['category'], 'Ring');
    expect(metadata['material'], 'Gold');
    expect(metadata['gemstone'], 'Diamond');
    expect(metadata['carat'], '1.2');
    expect(metadata['maker'], 'Tiffany');
    expect(metadata['purchaseValue'], '5000');
    expect(metadata['appraisalValue'], '8000');
    expect(metadata['condition'], 'Excellent');

    expect(
      PackCsvAdapter(pack).assetTypeIdForCategory(row.field('category')),
      'ring',
    );
  });

  test('jewelry Compass export round-trips through parser', () async {
    final pack = await DomainPackLoader().loadBundled('jewelry');
    final adapter = PackCsvAdapter(pack);
    final exporter = adapter.createExporter();
    final parser = adapter.createParser();

    final csv = exporter.build([
      const CsvExportRow(
        name: 'Silver Bracelet',
        quantity: 1,
        attributes: {
          'category': 'Bracelet',
          'material': 'Silver',
          'maker': 'Local Artisan',
        },
        path: 'Bedroom / Jewelry Box / Silver Bracelet',
      ),
    ]);

    final result = parser.parse(csv);
    expect(result.dialectId, 'compass');
    expect(result.rows.first.name, 'Silver Bracelet');
    expect(result.rows.first.field('category'), 'Bracelet');
    expect(result.rows.first.field('material'), 'Silver');
    expect(result.rows.first.field('maker'), 'Local Artisan');
    expect(
      result.rows.first.path,
      'Bedroom / Jewelry Box / Silver Bracelet',
    );
  });
}
