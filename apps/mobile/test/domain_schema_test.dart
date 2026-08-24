import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/core/domain/entities/entities.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/assets/infrastructure/drift_asset_type_repository.dart';
import 'package:compass/features/sync/infrastructure/sync_local_store.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('domain schema foundation', () {
    test('Asset stays generic; vertical data lives in metadata', () {
      final now = DateTime.utc(2026, 8, 19);
      const scryfallId = 'e3285e6b-3e84-4a43-9c17-7b0c7d0e0c01';
      final asset = Asset(
        id: 'asset-1',
        name: 'Lightning Bolt',
        assetTypeId: 'mtg_card',
        createdAt: now,
        updatedAt: now,
        metadata: const Metadata(
          values: {
            'scryfall.card_id': scryfallId,
            'finish': 'mtg.finish.foil',
          },
        ),
      );

      expect(asset.quantity, 1);
      expect(asset.metadata['scryfall.card_id'], scryfallId);
      expect(asset.toJson().containsKey('set'), isFalse);
      expect(asset.toJson().containsKey('foil'), isFalse);
      expect(asset.toJson().containsKey('collectorNumber'), isFalse);
    });

    test('AssetType may nest without domain columns', () {
      final now = DateTime.utc(2026, 8, 19);
      final jewelry = AssetType(
        id: 'jewelry',
        name: 'Jewelry',
        moduleId: 'jewelry',
        createdAt: now,
        updatedAt: now,
      );
      final ring = jewelry.copyWith(
        id: 'ring',
        name: 'Ring',
        parentId: jewelry.id,
      );
      final engagement = ring.copyWith(
        id: 'engagement_ring',
        name: 'Engagement Ring',
        parentId: ring.id,
      );

      expect(engagement.parentId, 'ring');
      expect(engagement.toJson().containsKey('material'), isFalse);
    });

    test('controlled values use a canonical key', () {
      const gold14k = ControlledValue(
        id: 'cv-gold-14k',
        vocabularyKey: 'material',
        canonicalKey: 'material.gold.14k',
        label: '14K Gold',
      );

      expect(gold14k.canonicalKey, 'material.gold.14k');
      expect(
        gold14k.canonicalKey,
        isNot(anyOf('Gold', '14k gold', '14 Karat')),
      );
    });

    test('external identifiers do not lock to one taxonomy', () {
      final now = DateTime.utc(2026, 8, 19);
      const entityId = 'controlled-gold';
      final wikidata = ExternalIdentifier(
        id: 'ext-1',
        entityId: entityId,
        entityKind: 'controlled_value',
        source: 'wikidata',
        externalId: 'Q897',
        createdAt: now,
      );
      final google = wikidata.copyWith(
        id: 'ext-2',
        source: 'google_taxonomy',
        externalId: '166',
      );

      expect(wikidata.entityId, google.entityId);
      expect({wikidata.source, google.source}, {
        'wikidata',
        'google_taxonomy',
      });
    });

    test('attribute definitions describe a type schema', () {
      const carat = AttributeDefinition(
        id: 'attr-carat',
        key: 'carat',
        valueType: AttributeValueType.decimal,
        assetTypeId: 'ring',
        moduleId: 'jewelry',
        unit: 'ct',
      );
      const value = AttributeValue(
        id: 'val-1',
        assetId: 'asset-ring',
        definitionId: 'attr-carat',
        value: 1.25,
        unit: 'ct',
      );

      expect(carat.valueType, AttributeValueType.decimal);
      expect(value.value, 1.25);
    });
  });

  group('persisted core fields', () {
    late AppDatabase database;
    late ProviderContainer container;

    setUp(() async {
      database = AppDatabase.forTesting(NativeDatabase.memory());
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(database),
        ],
      );
      addTearDown(database.close);
      addTearDown(container.dispose);
      await database.customSelect('SELECT 1').get();
    });

    test('created assets default quantity to 1', () async {
      final result = await container
          .read(assetServiceProvider)
          .createAsset(name: 'Wrench');
      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull!.quantity, 1);
    });

    test('asset types persist a parent hierarchy', () async {
      final types = DriftAssetTypeRepository(
        database,
        SyncLocalStore(database),
      );
      final now = DateTime.now().toUtc();
      await types.create(
        AssetType(
          id: 'tool',
          name: 'Tool',
          moduleId: 'tools',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await types.create(
        AssetType(
          id: 'power_tool',
          name: 'Power Tool',
          moduleId: 'tools',
          parentId: 'tool',
          createdAt: now,
          updatedAt: now,
        ),
      );

      final child = await types.getById('power_tool');
      expect(child?.parentId, 'tool');
      expect(
        (await types.getById(AppConstants.defaultAssetTypeId))?.parentId,
        isNull,
      );
    });
  });
}
