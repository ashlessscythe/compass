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
    bool ignoreExistingScryfallId = false,
    bool forceNetwork = false,
    /// When true, resolve by [Asset.name] only (used after rename / Rematch).
    bool preferName = false,
  }) async {
    try {
      final values = asset.metadata.values;
      final printing = await _catalog.resolve(
        scryfallId: ignoreExistingScryfallId || preferName
            ? null
            : MtgMetadataKeys.scryfallIdOf(values),
        setCode: preferName
            ? null
            : MtgMetadataKeys.stringOf(values, MtgMetadataKeys.setCode),
        collectorNumber: preferName
            ? null
            : MtgMetadataKeys.stringOf(
                values,
                MtgMetadataKeys.collectorNumber,
              ),
        name: asset.name,
        allowNetwork: allowNetwork,
        forceNetwork: forceNetwork,
      );
      if (printing == null) {
        return const Result.success(null);
      }
      await _bindAsset(
        asset,
        printing,
        replaceExisting: ignoreExistingScryfallId || forceNetwork || preferName,
      );
      if (prefetchImage) {
        await _prefetchImages(printing);
      }
      return Result.success(printing);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to match card', cause: error),
      );
    }
  }

  /// Bind [asset] to a specific printing (alternate print picker).
  Future<Result<CardPrinting>> bindPrinting(
    Asset asset,
    CardPrinting printing,
  ) async {
    try {
      await _bindAsset(asset, printing, replaceExisting: true);
      await _prefetchImages(printing);
      return Result.success(printing);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to bind printing',
          cause: error,
        ),
      );
    }
  }

  /// Re-resolve by the asset's **current name**, ignoring bound id / set / #.
  Future<Result<CardPrinting?>> rematchAsset(
    Asset asset, {
    bool allowNetwork = true,
  }) {
    return matchAsset(
      asset,
      allowNetwork: allowNetwork,
      ignoreExistingScryfallId: true,
      forceNetwork: true,
      preferName: true,
    );
  }

  /// Force-network rematch for many assets (set / collector / name keys).
  Future<Result<CardMatchSummary>> rematchAssets(
    List<Asset> assets, {
    required bool allowNetwork,
    void Function(int done, int total)? onProgress,
  }) async {
    try {
      final targets = <Asset>[];
      final keyToAssets = <String, List<Asset>>{};
      final keyOrder = <CatalogMatchKey>[];

      for (final asset in assets) {
        final key = matchKeyFromAsset(
          name: asset.name,
          metadata: asset.metadata.values,
          ignoreScryfallId: true,
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
              forceNetwork: true,
            ),
          SetCollectorKey(:final setCode, :final collectorNumber) =>
            _catalog.resolve(
              setCode: setCode,
              collectorNumber: collectorNumber,
              allowNetwork: allowNetwork,
              forceNetwork: true,
            ),
          NameKey(:final name) => _catalog.resolve(
              name: name,
              allowNetwork: allowNetwork,
              forceNetwork: true,
            ),
        };

        if (printing == null) {
          unresolved += group.length;
        } else {
          for (final asset in group) {
            await _bindAsset(asset, printing, replaceExisting: true);
            matched++;
          }
          await _prefetchImages(printing);
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
        Failure.unexpected(message: 'Failed to rematch cards', cause: error),
      );
    }
  }

  Future<Result<Asset>> clearMatch(Asset asset) async {
    try {
      final values = Map<String, dynamic>.from(asset.metadata.values);
      final hadCatalog = MtgMetadataKeys.scryfallIdOf(values) != null ||
          MtgMetadataKeys.stringOf(values, MtgMetadataKeys.setCode) != null ||
          MtgMetadataKeys.stringOf(values, MtgMetadataKeys.collectorNumber) !=
              null ||
          MtgMetadataKeys.stringOf(values, MtgMetadataKeys.layout) != null;
      values.remove(MtgMetadataKeys.scryfallCardId);
      values.remove(MtgMetadataKeys.legacyScryfallId);
      // Drop printing keys so a later Match / Rematch uses the current name.
      values.remove(MtgMetadataKeys.setCode);
      values.remove(MtgMetadataKeys.collectorNumber);
      values.remove(MtgMetadataKeys.layout);
      if (!hadCatalog) {
        return Result.success(asset);
      }
      return await _assets.updateMetadata(
        id: asset.id,
        metadata: Metadata(values: values),
      );
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to clear match', cause: error),
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
          await _prefetchImages(printing);
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

  /// Cache small + normal art for offline thumbs and detail. Soft-fails.
  Future<void> _prefetchImages(CardPrinting printing) async {
    final faceCount = printing.isMultiFace ? printing.faces.length : 1;
    for (var i = 0; i < faceCount; i++) {
      await _images.ensureImage(
        scryfallId: printing.id,
        size: CardImageSize.small,
        url: printing.imageUrlForFace(i, normal: false),
        faceIndex: i,
      );
      await _images.ensureImage(
        scryfallId: printing.id,
        size: CardImageSize.normal,
        url: printing.imageUrlForFace(i, normal: true),
        faceIndex: i,
      );
    }
  }

  Future<void> _bindAsset(
    Asset asset,
    CardPrinting printing, {
    bool replaceExisting = false,
  }) async {
    final values = Map<String, dynamic>.from(asset.metadata.values);
    final existing = MtgMetadataKeys.scryfallIdOf(values);
    if (!replaceExisting &&
        existing == printing.id &&
        values.containsKey(MtgMetadataKeys.scryfallCardId)) {
      return;
    }
    values[MtgMetadataKeys.scryfallCardId] = printing.id;
    values.remove(MtgMetadataKeys.legacyScryfallId);
    if (replaceExisting ||
        MtgMetadataKeys.stringOf(values, MtgMetadataKeys.setCode) == null) {
      values[MtgMetadataKeys.setCode] = printing.setCode;
    }
    if (replaceExisting ||
        MtgMetadataKeys.stringOf(values, MtgMetadataKeys.collectorNumber) ==
            null) {
      values[MtgMetadataKeys.collectorNumber] = printing.collectorNumber;
    }
    if (printing.layout != null &&
        (replaceExisting ||
            MtgMetadataKeys.stringOf(values, MtgMetadataKeys.layout) == null)) {
      values[MtgMetadataKeys.layout] = printing.layout;
    }
    await _assets.updateMetadata(
      id: asset.id,
      metadata: Metadata(values: values),
    );
  }
}
