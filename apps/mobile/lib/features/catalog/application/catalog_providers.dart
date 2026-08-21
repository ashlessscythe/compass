import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/catalog/application/card_match_service.dart';
import 'package:compass/features/catalog/domain/card_metadata_provider.dart';
import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/features/catalog/domain/pricing_provider.dart';
import 'package:compass/features/catalog/infrastructure/card_image_cache.dart';
import 'package:compass/features/catalog/infrastructure/card_printing_store.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_bulk_importer.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_card_metadata_provider.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_http_client.dart';
import 'package:compass/features/catalog/infrastructure/scryfall_rate_limited_queue.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cardPrintingStoreProvider = Provider<CardPrintingStore>((ref) {
  return CardPrintingStore(ref.watch(appDatabaseProvider));
});

final scryfallHttpClientProvider = Provider<ScryfallHttpClient>((ref) {
  final client = ScryfallHttpClient();
  ref.onDispose(client.close);
  return client;
});

final scryfallRateLimitedQueueProvider =
    Provider<ScryfallRateLimitedQueue>((ref) {
  return ScryfallRateLimitedQueue(
    store: ref.watch(cardPrintingStoreProvider),
    client: ref.watch(scryfallHttpClientProvider),
  );
});

final scryfallBulkImporterProvider = Provider<ScryfallBulkImporter>((ref) {
  return ScryfallBulkImporter(
    store: ref.watch(cardPrintingStoreProvider),
    client: ref.watch(scryfallHttpClientProvider),
  );
});

final mtgCardCatalogProvider = Provider<CardMetadataProvider>((ref) {
  return ScryfallCardMetadataProvider(
    store: ref.watch(cardPrintingStoreProvider),
    queue: ref.watch(scryfallRateLimitedQueueProvider),
    bulkImporter: ref.watch(scryfallBulkImporterProvider),
  );
});

final pricingProvider = Provider<PricingProvider>((ref) {
  return NoopPricingProvider();
});

final cardImageCacheProvider = Provider<CardImageCache>((ref) {
  return CardImageCache();
});

final cardMatchServiceProvider = Provider<CardMatchService>((ref) {
  return CardMatchService(
    assets: ref.watch(assetServiceProvider),
    catalog: ref.watch(mtgCardCatalogProvider),
    images: ref.watch(cardImageCacheProvider),
  );
});

final catalogStatusProvider = FutureProvider<CatalogStatus>((ref) async {
  return ref.watch(mtgCardCatalogProvider).status();
});
