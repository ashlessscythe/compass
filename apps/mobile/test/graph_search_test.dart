import 'dart:io';

import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/display_path.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:compass/shared/providers/repository_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('in-memory graph', () {
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
      // Open the database so seed + migrations run.
      await database.customSelect('SELECT 1').get();
    });

  test('creates nested location path and search finds the asset', () async {
    final locations = container.read(locationServiceProvider);
    final containers = container.read(containerServiceProvider);
    final assets = container.read(assetServiceProvider);
    final search = container.read(searchServiceProvider);

    final office = await locations.createLocation(name: 'Office');
    expect(office.isSuccess, isTrue);
    final desk = await locations.createLocation(
      name: 'Desk',
      parentLocationId: office.valueOrNull!.id,
    );
    expect(desk.valueOrNull!.path, 'Office / Desk');

    final binder = await containers.createContainer(
      name: 'Binder',
      locationId: desk.valueOrNull!.id,
    );
    expect(binder.isSuccess, isTrue);

    final card = await assets.createAsset(
      name: 'Lightning Bolt',
      containerId: binder.valueOrNull!.id,
    );
    expect(card.isSuccess, isTrue);

    final type = await container
        .read(assetTypeRepositoryProvider)
        .getById(AppConstants.defaultAssetTypeId);
    expect(type?.name, AppConstants.defaultAssetTypeName);

    final hits = await search.query('Lightning');
    expect(hits, hasLength(1));
    expect(hits.first.kind, SearchHitKind.asset);
    expect(
      hits.first.path,
      DisplayPath.join('Office / Desk / Binder', 'Lightning Bolt'),
    );
  });

  test('renaming a location updates descendant paths', () async {
    final locations = container.read(locationServiceProvider);
    final office = (await locations.createLocation(name: 'Office'))
        .valueOrNull;
    expect(office, isNotNull);
    final desk = (await locations.createLocation(
      name: 'Desk',
      parentLocationId: office!.id,
    )).valueOrNull;
    expect(desk?.path, 'Office / Desk');

    await locations.renameLocation(id: office.id, name: 'Studio');
    final updatedDesk =
        (await locations.getLocation(desk!.id)).valueOrNull;
    expect(updatedDesk?.path, 'Studio / Desk');
  });

  test('moving a container updates search path', () async {
    final locations = container.read(locationServiceProvider);
    final containers = container.read(containerServiceProvider);
    final assets = container.read(assetServiceProvider);
    final search = container.read(searchServiceProvider);

    final office =
        (await locations.createLocation(name: 'Office')).valueOrNull!;
    final desk = (await locations.createLocation(
      name: 'Desk',
      parentLocationId: office.id,
    )).valueOrNull!;
    final shelf = (await locations.createLocation(
      name: 'Shelf',
      parentLocationId: office.id,
    )).valueOrNull!;
    final binder = (await containers.createContainer(
      name: 'Binder',
      locationId: desk.id,
    )).valueOrNull!;
    await assets.createAsset(
      name: 'Lightning Bolt',
      containerId: binder.id,
    );

    final moved = await containers.moveContainer(
      id: binder.id,
      locationId: shelf.id,
    );
    expect(moved.isSuccess, isTrue);
    expect(moved.valueOrNull!.locationId, shelf.id);
    expect(moved.valueOrNull!.parentContainerId, isNull);

    final hits = await search.query('Lightning');
    expect(hits, hasLength(1));
    expect(
      hits.first.path,
      'Office / Shelf / Binder / Lightning Bolt',
    );
  });

  test('rejects moving a place under its descendant', () async {
    final locations = container.read(locationServiceProvider);
    final office =
        (await locations.createLocation(name: 'Office')).valueOrNull!;
    final desk = (await locations.createLocation(
      name: 'Desk',
      parentLocationId: office.id,
    )).valueOrNull!;

    final result = await locations.moveLocation(
      id: office.id,
      parentLocationId: desk.id,
    );
    expect(result.isFailure, isTrue);
    expect(
      result.failureOrNull!.message,
      contains('nested places'),
    );
  });
  });

  test('search path survives reopening sqlite', () async {
    final dir = await Directory.systemTemp.createTemp('compass-graph-');
    addTearDown(() async {
      if (dir.existsSync()) {
        await dir.delete(recursive: true);
      }
    });
    final file = File('${dir.path}/compass.sqlite');

    final firstDb = AppDatabase.forTesting(NativeDatabase(file));
    final first = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(firstDb),
      ],
    );
    await firstDb.customSelect('SELECT 1').get();

    final office = (await first
            .read(locationServiceProvider)
            .createLocation(name: 'Office'))
        .valueOrNull!;
    final desk = (await first.read(locationServiceProvider).createLocation(
          name: 'Desk',
          parentLocationId: office.id,
        ))
        .valueOrNull!;
    final binder = (await first.read(containerServiceProvider).createContainer(
          name: 'Binder',
          locationId: desk.id,
        ))
        .valueOrNull!;
    await first.read(assetServiceProvider).createAsset(
          name: 'Lightning Bolt',
          containerId: binder.id,
        );
    await firstDb.close();
    first.dispose();

    final secondDb = AppDatabase.forTesting(NativeDatabase(file));
    addTearDown(secondDb.close);
    final second = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(secondDb),
      ],
    );
    addTearDown(second.dispose);
    await secondDb.customSelect('SELECT 1').get();

    final hits =
        await second.read(searchServiceProvider).query('Lightning');
    expect(hits, hasLength(1));
    expect(
      hits.first.path,
      DisplayPath.join('Office / Desk / Binder', 'Lightning Bolt'),
    );
  });
}
