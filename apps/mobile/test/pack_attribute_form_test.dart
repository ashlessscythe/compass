import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/features/domains/application/module_scope.dart';
import 'package:compass/features/domains/application/pack_csv_adapter.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('applicableAttributeDefinitions includes jewelry root attrs', () async {
    final pack = await DomainPackLoader().loadBundled('jewelry');
    final defs = applicableAttributeDefinitions(pack, 'jewelry');
    expect(defs.map((d) => d.key), contains('carat'));
    expect(defs.map((d) => d.key), contains('material'));
    expect(defs.map((d) => d.key), contains('condition'));
  });

  test('assetTypeIdForCategoryCanonical maps enum key to type id', () async {
    final pack = await DomainPackLoader().loadBundled('jewelry');
    final adapter = PackCsvAdapter(pack);
    expect(
      adapter.assetTypeIdForCategoryCanonical('jewelry.category.ring'),
      'ring',
    );
    expect(
      adapter.assetTypeIdForCategoryCanonical('jewelry.category.watch'),
      'watch',
    );
  });

  test('controlled vocabulary includes material enum labels', () async {
    final pack = await DomainPackLoader().loadBundled('jewelry');
    final material = pack.controlledValues
        .where((v) => v.vocabularyKey == 'jewelry.material')
        .map((v) => v.label)
        .toSet();
    expect(material, contains('14K Gold'));
    expect(material, contains('Platinum'));
  });

  test('merge metadata preserves compass module tag', () {
    const key = kCompassModuleIdMetadataKey;
    final merged = Map<String, dynamic>.from({
      key: 'jewelry',
      'import.source': 'compass',
    });
    merged['carat'] = '1.25';
    expect(merged[key], 'jewelry');
    expect(merged['carat'], '1.25');
  });
}
