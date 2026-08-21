import 'dart:convert';
import 'dart:io';

import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/database/app_database.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/catalog/application/card_match_service.dart';
import 'package:compass/features/catalog/domain/card_printing.dart';
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

  test('rematchAssets ignores bound ids and force-refetches by set/name',
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

    final created = await container.read(assetServiceProvider).createAsset(
          name: 'Lightning Bolt',
          containerId: binder.id,
          metadata: const Metadata(
            values: {
              MtgMetadataKeys.scryfallCardId: 'stale-id',
              MtgMetadataKeys.setCode: 'lea',
              MtgMetadataKeys.collectorNumber: '161',
            },
          ),
        );
    final asset = created.valueOrNull!;

    final summary = await matchService.rematchAssets(
      [asset],
      allowNetwork: true,
    );
    expect(summary.isSuccess, isTrue);
    expect(summary.valueOrNull!.matched, 1);

    final refreshed =
        await container.read(assetServiceProvider).getAsset(asset.id);
    expect(
      MtgMetadataKeys.scryfallIdOf(refreshed.valueOrNull!.metadata.values),
      'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
    );
  });

  test('clearMatch drops set/collector; rematchAsset uses current name',
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

    final created = await container.read(assetServiceProvider).createAsset(
          name: 'Lightning Bolt',
          containerId: binder.id,
          metadata: const Metadata(
            values: {
              MtgMetadataKeys.scryfallCardId:
                  'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
              MtgMetadataKeys.setCode: 'lea',
              MtgMetadataKeys.collectorNumber: '161',
            },
          ),
        );
    var asset = created.valueOrNull!;

    final cleared = await matchService.clearMatch(asset);
    expect(cleared.isSuccess, isTrue);
    asset = cleared.valueOrNull!;
    expect(MtgMetadataKeys.scryfallIdOf(asset.metadata.values), isNull);
    expect(
      MtgMetadataKeys.stringOf(asset.metadata.values, MtgMetadataKeys.setCode),
      isNull,
    );

    final renamed = await container.read(assetServiceProvider).renameAsset(
          id: asset.id,
          name: 'Counterspell',
        );
    asset = renamed.valueOrNull!;

    final rematched = await matchService.rematchAsset(asset);
    expect(rematched.isSuccess, isTrue);
    expect(rematched.valueOrNull?.name, 'Counterspell');
    expect(
      rematched.valueOrNull?.id,
      'cccccccc-bbbb-cccc-dddd-eeeeeeeeeeee',
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
    expect(printing.faces, hasLength(1));
  });

  test('printingFromJson keeps both DFC faces and images', () {
    final printing = ScryfallHttpClient.printingFromJson({
      'id': 'dfc-1111-2222-3333-444444444444',
      'name': 'Delver of Secrets // Insectile Aberration',
      'layout': 'transform',
      'set': 'isd',
      'collector_number': '51',
      'card_faces': [
        {
          'name': 'Delver of Secrets',
          'mana_cost': '{U}',
          'type_line': 'Creature — Human Wizard',
          'image_uris': {
            'small': 'https://example.com/delver-front-small.jpg',
            'normal': 'https://example.com/delver-front.jpg',
          },
        },
        {
          'name': 'Insectile Aberration',
          'mana_cost': '',
          'type_line': 'Creature — Human Insect',
          'image_uris': {
            'small': 'https://example.com/delver-back-small.jpg',
            'normal': 'https://example.com/delver-back.jpg',
          },
        },
      ],
    });
    expect(printing, isNotNull);
    expect(printing!.isMultiFace, isTrue);
    expect(printing.layout, 'transform');
    expect(printing.faces, hasLength(2));
    expect(printing.manaCost, '{U}');
    expect(printing.typeLine, 'Creature — Human Wizard');
    expect(
      printing.imageUrlForFace(1, normal: true),
      'https://example.com/delver-back.jpg',
    );
  });

  test('printingFromJson split shares top-level image across faces', () {
    final printing = ScryfallHttpClient.printingFromJson({
      'id': 'split-1111-2222-3333-444444444444',
      'name': 'Fire // Ice',
      'layout': 'split',
      'set': 'apc',
      'collector_number': '128',
      'image_uris': {
        'small': 'https://example.com/fire-ice-small.jpg',
        'normal': 'https://example.com/fire-ice.jpg',
      },
      'card_faces': [
        {
          'name': 'Fire',
          'mana_cost': '{1}{R}',
          'type_line': 'Instant',
        },
        {
          'name': 'Ice',
          'mana_cost': '{1}{U}',
          'type_line': 'Instant',
        },
      ],
    });
    expect(printing, isNotNull);
    expect(printing!.isMultiFace, isTrue);
    expect(printing.faces[0].imageNormalUrl, 'https://example.com/fire-ice.jpg');
    expect(printing.faces[1].manaCost, '{1}{U}');
  });

  test('needsFaceHydration detects stale single-face DFC cache', () {
    final stale = CardPrinting(
      id: 'stale',
      name: 'Shatterskull Smashing // Shatterskull, the Hammer Pass',
      setCode: 'znr',
      collectorNumber: '354',
      typeLine: 'Sorcery // Land',
      faces: const [
        CardFace(name: 'Shatterskull Smashing // Shatterskull, the Hammer Pass'),
      ],
      fetchedAt: DateTime.utc(2024),
    );
    expect(stale.needsFaceHydration, isTrue);
    expect(stale.isMultiFace, isFalse);

    final fresh = CardPrinting(
      id: 'fresh',
      name: 'Shatterskull Smashing // Shatterskull, the Hammer Pass',
      setCode: 'znr',
      collectorNumber: '354',
      layout: 'modal_dfc',
      faces: const [
        CardFace(name: 'Shatterskull Smashing', typeLine: 'Sorcery'),
        CardFace(name: 'Shatterskull, the Hammer Pass', typeLine: 'Land'),
      ],
      fetchedAt: DateTime.utc(2024),
    );
    expect(fresh.needsFaceHydration, isFalse);
    expect(fresh.isMultiFace, isTrue);
  });
}
