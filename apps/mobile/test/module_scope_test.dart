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
}
