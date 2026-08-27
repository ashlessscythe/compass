import 'package:compass/core/utils/result.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/assets/infrastructure/drift_asset_repository.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/containers/infrastructure/drift_container_repository.dart';
import 'package:compass/features/domains/application/pack_csv_adapter.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_loader.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_seeder.dart';
import 'package:compass/features/export/application/export_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/locations/infrastructure/drift_location_repository.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:compass/features/sync/infrastructure/sync_local_store.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('module-scoped export excludes other domain assets', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final sync = SyncLocalStore(db);

    final loader = DomainPackLoader();
    final seeder = DomainPackSeeder(db);
    await seeder.seedIfNeeded(await loader.loadBundled('mtg'));
    await seeder.seedIfNeeded(await loader.loadBundled('jewelry'));

    final assetService = AssetService(DriftAssetRepository(db, sync));
    final locationService =
        LocationService(DriftLocationRepository(db, sync));
    final containerService =
        ContainerService(DriftContainerRepository(db, sync));

    final office =
        (await locationService.createLocation(name: 'Office')).valueOrNull!;
    final box = (await containerService.createContainer(
      name: 'Box',
      locationId: office.id,
    ))
        .valueOrNull!;

    final bolt = await assetService.createAsset(
      name: 'Lightning Bolt',
      containerId: box!.id,
      locationId: office.id,
      assetTypeId: 'mtg_card',
    );
    final ring = await assetService.createAsset(
      name: 'Gold Ring',
      containerId: box.id,
      locationId: office.id,
      assetTypeId: 'ring',
    );
    expect(bolt.isSuccess, isTrue);
    expect(ring.isSuccess, isTrue);

    final listed = (await assetService.listAssets()).valueOrNull!;
    expect(listed, hasLength(2));

    final mtgPack = await DomainPackLoader().loadBundled('mtg');
    final jewelryPack = await DomainPackLoader().loadBundled('jewelry');

    Future<String> exportCsv(String moduleId) async {
      final pack = moduleId == 'mtg' ? mtgPack : jewelryPack;
      final service = ExportService(
        assetService,
        locationService,
        containerService,
        exporter: PackCsvAdapter(pack).createExporter(),
        domainPack: pack,
        activeModuleId: moduleId,
      );
      return (await service.buildCsv()).valueOrNull!;
    }

    final mtgCsv = await exportCsv('mtg');
    final jewelryCsv = await exportCsv('jewelry');

    expect(mtgCsv, contains('Lightning Bolt'));
    expect(mtgCsv, isNot(contains('Gold Ring')));

    expect(jewelryCsv, contains('Gold Ring'));
    expect(jewelryCsv, isNot(contains('Lightning Bolt')));
  });
}
