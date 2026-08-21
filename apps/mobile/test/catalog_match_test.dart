import 'dart:convert';
import 'dart:io';

import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/catalog/application/card_match_service.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/catalog/infrastructure/card_image_cache.dart';
import 'package:compass/features/catalog/infrastructure/card_printing_store.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_bulk_importer.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_card_metadata_provider.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_http_client.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_rate_limited_queue.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase database;
  late ProviderContainer container;
  late ScryfallCardMetadataProvider catalog;
  late CardMatchService matchService;
  var networkCalls = 0;

  setUp(() async {
    networkCalls = 0;
    database = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(database),
      ],
    );
    await database.customSelect('SELECT 1').get();

    final store = CardPrintingStore(database);
    final client = ScryfallHttpClient(
      client: MockClient((request) async {
        networkCalls++;
        return http.Response('{"object":"error"}', 404);
      }),
    );
    final queue = ScryfallRateLimitedQueue(
      store: store,
      client: client,
      minInterval: Duration.zero,
    );
    final bulk = ScryfallBulkImporter(store: store, client: client);
    catalog = ScryfallCardMetadataProvider(
      store: store,
      queue: queue,
      bulkImporter: bulk,
    );
    matchService = CardMatchService(
      assets: container.read(assetServiceProvider),
      catalog: catalog,
      images: CardImageCache(
        client: MockClient((request) async {
          return http.Response.bytes(List<int>.filled(8, 0), 200);
        }),
      ),
    );
  });

  tearDown(() async {
    container.dispose();
    await database.close();
  });

  Future<void> seedFixtureCatalog() async {
    final raw = await File(
      'test/fixtures/scryfall_default_cards_sample.json',
    ).readAsString();
    final list = jsonDecode(raw) as List<dynamic>;
    await catalog.importFixtureCatalog(list);
  }

  test('fixture bulk import populates SQLite; resolve hits cache with no HTTP',
      () async {
    await seedFixtureCatalog();
    final status = await catalog.status();
    expect(status.printingCount, 3);
    expect(status.isInstalled, isTrue);

    networkCalls = 0;
    final byId = await catalog.resolve(
      scryfallId: 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
    );
    expect(byId?.name, 'Lightning Bolt');
    expect(networkCalls, 0);

    final bySet = await catalog.resolve(
      setCode: 'm10',
      collectorNumber: '146',
    );
    expect(bySet?.id, 'bbbbbbbb-bbbb-cccc-dddd-eeeeeeeeeeee');
    expect(networkCalls, 0);
  });

  test('matchAssets dedupes identical keys and writes scryfall.card_id',
      () async {
    await seedFixtureCatalog();

    final office = (await container
            .read(locationServiceProvider)
            .createLocation(name: 'Office'))
        .valueOrNull!;
    final binder =
        (await container.read(containerServiceProvider).createContainer(
              name: 'Binder',
              locationId: office.id,
            ))
            .valueOrNull!;

    final assets = <Asset>[];
    for (var i = 0; i < 3; i++) {
      final created = await container.read(assetServiceProvider).createAsset(
            name: 'Lightning Bolt',
            containerId: binder.id,
            metadata: const Metadata(
              values: {
                MtgMetadataKeys.setCode: 'lea',
                MtgMetadataKeys.collectorNumber: '161',
              },
            ),
          );
      assets.add(created.valueOrNull!);
    }

    networkCalls = 0;
    final summary = await matchService.matchAssets(
      assets,
      allowNetwork: true,
      ensureCatalogIfLarge: false,
    );
    expect(summary.isSuccess, isTrue);
    expect(summary.valueOrNull!.uniqueKeys, 1);
    expect(summary.valueOrNull!.matched, 3);
    expect(networkCalls, 0);

    final refreshed =
        await container.read(assetServiceProvider).getAsset(assets.first.id);
    expect(
      MtgMetadataKeys.scryfallIdOf(refreshed.valueOrNull!.metadata.values),
      'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
    );
  });

  test('legacy scryfallId metadata is accepted', () {
    final id = MtgMetadataKeys.scryfallIdOf({
      MtgMetadataKeys.legacyScryfallId: 'legacy-id',
    });
    expect(id, 'legacy-id');
    final canonical = MtgMetadataKeys.scryfallIdOf({
      MtgMetadataKeys.scryfallCardId: 'canonical',
      MtgMetadataKeys.legacyScryfallId: 'legacy-id',
    });
    expect(canonical, 'canonical');
  });

  test('printingFromJson tolerates null optional fields', () {
    final printing = ScryfallHttpClient.printingFromJson({
      'id': 'dddddddd-bbbb-cccc-dddd-eeeeeeeeeeee',
      'oracle_id': null,
      'name': 'Tok Token',
      'set': 'tlea',
      'collector_number': '1',
      'type_line': null,
      'mana_cost': null,
      'image_uris': null,
      'card_faces': [
        {
          'name': 'Tok Token',
          'image_uris': {
            'small': 'https://example.com/t-small.jpg',
            'normal': null,
          },
        },
      ],
    });
    expect(printing, isNotNull);
    expect(printing!.id, 'dddddddd-bbbb-cccc-dddd-eeeeeeeeeeee');
    expect(printing.imageSmallUrl, 'https://example.com/t-small.jpg');
    expect(printing.imageNormalUrl, isNull);
    expect(printing.oracleId, isNull);
  });
}
