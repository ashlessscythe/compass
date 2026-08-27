import 'dart:io';

import 'package:compass/core/utils/result.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/import/application/import_service.dart';
import 'package:compass/features/import/domain/csv_import_models.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('CSV import into container is searchable with path', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await database.close();
    });
    await database.customSelect('SELECT 1').get();

    final office = (await container.read(locationServiceProvider).createLocation(
          name: 'Office',
        ))
        .valueOrNull!;
    final binder = (await container
            .read(containerServiceProvider)
            .createContainer(name: 'Binder', locationId: office.id))
        .valueOrNull!;

    final csv = File('test/fixtures/import/moxfield_sample.csv').readAsStringSync();
    final result = await container.read(importServiceProvider).importCsv(
          content: csv,
          containerId: binder.id,
        );

    expect(result.isSuccess, isTrue);
    final summary = result.valueOrNull!;
    expect(summary.dialect, CsvDialect.moxfield);
    expect(summary.createdCount, 3);
    expect(summary.containerName, 'Binder');

    final assets = (await container.read(assetServiceProvider).listAssets())
        .valueOrNull!;
    expect(assets.length, 3);
    final bolt = assets.firstWhere((item) => item.name == 'Lightning Bolt');
    expect(bolt.quantity, 1);
    expect(bolt.containerId, binder.id);
    expect(bolt.metadata['import.source'], 'moxfield');
    expect(bolt.metadata['set'], 'm10');
    expect(bolt.metadata['collectorNumber'], '146');
    expect(bolt.notes, 'm10 · #146');

    final sol = assets.firstWhere((item) => item.name == 'Sol Ring');
    expect(sol.metadata['finish'], 'foil');
    expect(sol.notes, 'c21 · #1 · foil');

    final hits = await container.read(searchServiceProvider).query('Lightning');
    expect(hits, isNotEmpty);
    expect(hits.first.name, 'Lightning Bolt');
    expect(hits.first.path, 'Office / Binder / Lightning Bolt');
  });

  test('Compass CSV restores places and containers from Path', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await database.close();
    });
    await database.customSelect('SELECT 1').get();

    const csv = 'Name,Quantity,Set,Collector Number,Path\n'
        'Lightning Bolt,1,m10,146,Office / Binder / Lightning Bolt\n'
        'Sol Ring,2,c21,1,Office / Binder / Sol Ring\n'
        'Opt,4,znr,65,Home / Box / Opt\n';

    final result = await container.read(importServiceProvider).importCsv(
          content: csv,
        );

    expect(result.isSuccess, isTrue);
    final summary = result.valueOrNull!;
    expect(summary.dialect, CsvDialect.compass);
    expect(summary.createdCount, 3);
    expect(summary.destinationLabel, 'CSV paths');
    expect(summary.createdAssetIds, hasLength(3));

    final locations =
        (await container.read(locationServiceProvider).listLocations())
            .valueOrNull!;
    expect(locations.map((item) => item.name), containsAll(['Office', 'Home']));

    final containers =
        (await container.read(containerServiceProvider).listContainers())
            .valueOrNull!;
    expect(containers.map((item) => item.name), containsAll(['Binder', 'Box']));

    final assets = (await container.read(assetServiceProvider).listAssets())
        .valueOrNull!;
    final bolt = assets.firstWhere((item) => item.name == 'Lightning Bolt');
    expect(bolt.metadata['import.source'], 'compass');
    expect(bolt.metadata['set'], 'm10');

    final hits = await container.read(searchServiceProvider).query('Lightning');
    expect(hits, isNotEmpty);
    expect(hits.first.path, 'Office / Binder / Lightning Bolt');

    final optHits = await container.read(searchServiceProvider).query('Opt');
    expect(optHits.first.path, 'Home / Box / Opt');
  });
}
