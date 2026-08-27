import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/features/domains/application/module_scope.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('typed mtg assets belong to mtg pack only', () async {
    final mtg = await DomainPackLoader().loadBundled('mtg');
    final jewelry = await DomainPackLoader().loadBundled('jewelry');
    final card = Asset(
      id: '1',
      name: 'Bolt',
      assetTypeId: 'mtg_card',
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
    );

    expect(assetBelongsToModule(card, mtg), isTrue);
    expect(assetBelongsToModule(card, jewelry), isFalse);
  });

  test('generic items respect module tag and active module', () async {
    final mtg = await DomainPackLoader().loadBundled('mtg');
    final jewelry = await DomainPackLoader().loadBundled('jewelry');
    final tagged = Asset(
      id: '2',
      name: 'Ring',
      assetTypeId: AppConstants.defaultAssetTypeId,
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
      metadata: Metadata(values: {kCompassModuleIdMetadataKey: 'jewelry'}),
    );
    final untagged = Asset(
      id: '3',
      name: 'Thing',
      assetTypeId: AppConstants.defaultAssetTypeId,
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
    );

    expect(assetBelongsToModule(tagged, jewelry), isTrue);
    expect(assetBelongsToModule(tagged, mtg), isFalse);
    expect(
      assetBelongsToModule(untagged, mtg, activeModuleId: 'mtg'),
      isTrue,
    );
    expect(
      assetBelongsToModule(untagged, jewelry, activeModuleId: 'mtg'),
      isFalse,
    );
  });

  test('owningPackForAsset resolves typed and tagged generic items', () async {
    final mtg = await DomainPackLoader().loadBundled('mtg');
    final jewelry = await DomainPackLoader().loadBundled('jewelry');
    final packs = [mtg, jewelry];

    final ring = Asset(
      id: '4',
      name: 'Ring',
      assetTypeId: 'ring',
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
    );
    expect(owningPackForAsset(ring, packs)?.moduleId, 'jewelry');

    final tagged = Asset(
      id: '5',
      name: 'Tagged',
      assetTypeId: AppConstants.defaultAssetTypeId,
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
      metadata: Metadata(values: {kCompassModuleIdMetadataKey: 'jewelry'}),
    );
    expect(owningPackForAsset(tagged, packs)?.moduleId, 'jewelry');

    final untagged = Asset(
      id: '6',
      name: 'Untagged',
      assetTypeId: AppConstants.defaultAssetTypeId,
      createdAt: DateTime.utc(2024),
      updatedAt: DateTime.utc(2024),
    );
    expect(
      owningPackForAsset(untagged, packs, activeModuleId: 'mtg')?.moduleId,
      'mtg',
    );
  });
}
