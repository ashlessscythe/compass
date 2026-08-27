import 'package:compass/database/app_database.dart';
import 'package:compass/features/domains/application/pack_csv_adapter.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_loader.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_seeder.dart';
import 'package:compass/features/export/infrastructure/csv_collection_exporter.dart';
import 'package:compass/features/import/infrastructure/csv_collection_parser.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => '.',
    );
  });

  group('domain pack', () {
    test('bundled MTG v1.json parses', () async {
      final pack = await DomainPackLoader().loadBundled('mtg');
      expect(pack.id, 'mtg');
      expect(pack.moduleId, 'mtg');
      expect(pack.defaultAssetTypeId, 'mtg_card');
      expect(pack.providers.catalog?.id, 'scryfall');
      expect(
        pack.csvImport.fields.any((f) => f.key == 'name' && f.required == true),
        isTrue,
      );
    });

    test('bundled jewelry v1.json parses', () async {
      final pack = await DomainPackLoader().loadBundled('jewelry');
      expect(pack.id, 'jewelry');
      expect(pack.moduleId, 'jewelry');
      expect(pack.defaultAssetTypeId, 'jewelry');
      expect(pack.tagline, 'Know where every piece is.');
      expect(pack.providers.catalog, isNull);
      expect(pack.assetTypes.length, greaterThanOrEqualTo(6));
    });

    test('pack CSV import maps scryfall field to attribute key', () async {
      final pack = await DomainPackLoader().loadBundled('mtg');
      expect(
        pack.attributeKeyForCsvField('scryfallId'),
        'scryfall.card_id',
      );
    });

    test('seeder installs both packs with types and attribute definitions',
        () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      final loader = DomainPackLoader();
      final seeder = DomainPackSeeder(db);
      for (final packId in DomainPackLoader.bundledPackAssets.keys) {
        await seeder.seedIfNeeded(await loader.loadBundled(packId));
      }

      final installed = await db.select(db.installedDomainPacks).get();
      expect(installed, hasLength(2));
      expect(
        installed.map((row) => row.packId).toSet(),
        {'mtg', 'jewelry'},
      );

      final types = await db.select(db.assetTypes).get();
      expect(types.any((t) => t.id == 'mtg_card'), isTrue);
      expect(types.any((t) => t.id == 'ring'), isTrue);
      expect(types.any((t) => t.id == 'engagement_ring'), isTrue);

      final defs = await db.select(db.packAttributeDefinitions).get();
      expect(defs.length, greaterThanOrEqualTo(20));
    });
  });
}
