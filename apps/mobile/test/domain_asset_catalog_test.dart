import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/domains/application/domain_asset_catalog.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Asset jewelryAsset;
  late Asset mtgAsset;
  late dynamic mtgPack;
  late dynamic jewelryPack;

  setUp(() async {
    mtgPack = await DomainPackLoader().loadBundled('mtg');
    jewelryPack = await DomainPackLoader().loadBundled('jewelry');
    jewelryAsset = Asset(
      id: 'j1',
      name: 'Gold ring',
      assetTypeId: 'jewelry',
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
    );
    mtgAsset = Asset(
      id: 'm1',
      name: 'Lightning Bolt',
      assetTypeId: 'mtg_card',
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
      metadata: Metadata(
        values: {
          MtgMetadataKeys.scryfallCardId: 'abc-123',
        },
      ),
    );
  });

  test('jewelry asset never resolves a catalog pack when MTG is installed', () {
    expect(
      catalogPackForAsset(
        jewelryAsset,
        [mtgPack, jewelryPack],
      ),
      isNull,
    );
  });

  test('mtg typed asset resolves mtg catalog pack', () {
    final pack = catalogPackForAsset(
      mtgAsset,
      [mtgPack, jewelryPack],
    );
    expect(pack?.moduleId, 'mtg');
    expect(pack?.providers.catalog?.id, 'scryfall');
  });

  test('generic item with mtg metadata does not get catalog without owning pack', () {
    final generic = Asset(
      id: 'g1',
      name: 'Mystery',
      assetTypeId: 'asset-type-item',
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
      metadata: Metadata(
        values: {
          MtgMetadataKeys.setCode: 'LEA',
          MtgMetadataKeys.collectorNumber: '161',
        },
      ),
    );

    expect(
      catalogPackForAsset(generic, [mtgPack, jewelryPack]),
      isNull,
    );
    expect(
      catalogPackForAsset(
        generic,
        [mtgPack, jewelryPack],
        activeModuleId: 'mtg',
      )?.moduleId,
      'mtg',
    );
  });
}
