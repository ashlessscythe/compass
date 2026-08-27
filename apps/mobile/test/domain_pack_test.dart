import 'package:compass/database/app_database.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_loader.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_seeder.dart';
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

    test('pack CSV import maps scryfall field to attribute key', () async {
      final pack = await DomainPackLoader().loadBundled('mtg');
      expect(
        pack.attributeKeyForCsvField('scryfallId'),
        'scryfall.card_id',
      );
    });

    test('seeder installs mtg_card type and attribute definitions', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);

      final pack = await DomainPackLoader().loadBundled('mtg');
      await DomainPackSeeder(db).seedIfNeeded(pack);

      final installed = await db.select(db.installedDomainPacks).get();
      expect(installed, hasLength(1));
      expect(installed.single.packId, 'mtg');

      final types = await db.select(db.assetTypes).get();
      expect(types.any((t) => t.id == 'mtg_card'), isTrue);

      final defs = await db.select(db.packAttributeDefinitions).get();
      expect(defs.length, greaterThanOrEqualTo(6));
    });
  });
}
