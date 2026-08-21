import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/catalog/domain/card_metadata_provider.dart';
import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/catalog/infrastructure/card_image_cache.dart';

class CardMatchSummary {
  const CardMatchSummary({
    required this.considered,
    required this.matched,
    required this.unresolved,
    required this.uniqueKeys,
  });

  final int considered;
  final int matched;
  final int unresolved;
  final int uniqueKeys;
}

/// Matches inventory assets to [CardMetadataProvider] and writes scryfall ids.
class CardMatchService {
  CardMatchService({
    required AssetService assets,
    required CardMetadataProvider catalog,
    required CardImageCache images,
  })  : _assets = assets,
        _catalog = catalog,
        _images = images;

  final AssetService _assets;
  final CardMetadataProvider _catalog;
  final CardImageCache _images;

  Future<Result<CardPrinting?>> matchAsset(
    Asset asset, {
    bool allowNetwork = true,
    bool prefetchImage = true,
  }) async {
    try {
      final values = asset.metadata.values;
      final printing = await _catalog.resolve(
        scryfallId: MtgMetadataKeys.scryfallIdOf(values),
        setCode: MtgMetadataKeys.stringOf(values, MtgMetadataKeys.setCode),
        collectorNumber: MtgMetadataKeys.stringOf(
          values,
          MtgMetadataKeys.collectorNumber,
        ),
        name: asset.name,
        allowNetwork: allowNetwork,
      );
      if (printing == null) {
        return const Result.success(null);
      }
      await _bindAsset(asset, printing);
      if (prefetchImage) {
        try {
          await _images.ensureImage(
            scryfallId: printing.id,
            size: CardImageSize.small,
            url: printing.imageSmallUrl,
          );
        } on Object {
          // Image cache is best-effort (path_provider may be unavailable in tests).
        }
      }
      return Result.success(printing);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to match card', cause: error),
      );
    }
  }

  Future<Result<CardMatchSummary>> matchAssets(
    List<Asset> assets, {
    required bool allowNetwork,
    void Function(int done, int total)? onProgress,
    bool ensureCatalogIfLarge = true,
  }) async {
    try {
      final targets = <Asset>[];
      final keyToAssets = <String, List<Asset>>{};
      final keyOrder = <CatalogMatchKey>[];

      for (final asset in assets) {
        final key = matchKeyFromAsset(
          name: asset.name,
          metadata: asset.metadata.values,
        );
        if (key == null) {
          continue;
        }
        targets.add(asset);
        final list = keyToAssets.putIfAbsent(key.dedupeId, () {
          keyOrder.add(key);
          return <Asset>[];
        });
        list.add(asset);
      }

      if (ensureCatalogIfLarge && keyOrder.length >= 20 && allowNetwork) {
        final status = await _catalog.status();
        if (!status.isInstalled) {
          await _catalog.ensureCatalog();
        }
      }

      var matched = 0;
      var unresolved = 0;
      var done = 0;
      final total = keyOrder.length;

      for (final key in keyOrder) {
        final group = keyToAssets[key.dedupeId]!;
        final printing = await switch (key) {
          ScryfallIdKey(:final id) => _catalog.resolve(
              scryfallId: id,
              allowNetwork: allowNetwork,
            ),
          SetCollectorKey(:final setCode, :final collectorNumber) =>
            _catalog.resolve(
              setCode: setCode,
              collectorNumber: collectorNumber,
              allowNetwork: allowNetwork,
            ),
          NameKey(:final name) => _catalog.resolve(
              name: name,
              allowNetwork: allowNetwork,
            ),
        };

        if (printing == null) {
          unresolved += group.length;
        } else {
          for (final asset in group) {
            await _bindAsset(asset, printing);
            matched++;
          }
          try {
            await _images.ensureImage(
              scryfallId: printing.id,
              size: CardImageSize.small,
              url: printing.imageSmallUrl,
            );
          } on Object {
            // Image cache is best-effort.
          }
        }
        done++;
        onProgress?.call(done, total);
      }

      return Result.success(
        CardMatchSummary(
          considered: targets.length,
          matched: matched,
          unresolved: unresolved,
          uniqueKeys: keyOrder.length,
        ),
      );
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to match cards', cause: error),
      );
    }
  }

  Future<void> _bindAsset(Asset asset, CardPrinting printing) async {
    final values = Map<String, dynamic>.from(asset.metadata.values);
    final existing = MtgMetadataKeys.scryfallIdOf(values);
    if (existing == printing.id &&
        values.containsKey(MtgMetadataKeys.scryfallCardId)) {
      return;
    }
    values[MtgMetadataKeys.scryfallCardId] = printing.id;
    values.remove(MtgMetadataKeys.legacyScryfallId);
    values.putIfAbsent(MtgMetadataKeys.setCode, () => printing.setCode);
    values.putIfAbsent(
      MtgMetadataKeys.collectorNumber,
      () => printing.collectorNumber,
    );
    await _assets.updateMetadata(
      id: asset.id,
      metadata: Metadata(values: values),
    );
  }
}
