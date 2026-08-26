import 'dart:async';
import 'dart:io';

import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/catalog/application/catalog_prefs.dart';
import 'package:compass/features/catalog/application/catalog_providers.dart';
import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/catalog/infrastructure/card_image_cache.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> runCardMatchForAssets(
  BuildContext context,
  WidgetRef ref, {
  required List<Asset> assets,
  bool ensureCatalog = true,
}) async {
  final enabled = ref.read(catalogEnabledProvider);
  if (!enabled) {
    showFailureSnackBar(
      context,
      'MTG catalog is turned off in Settings.',
    );
    return;
  }

  if (ensureCatalog) {
    final status = await ref.read(mtgCardCatalogProvider).status();
    if (!status.isInstalled && context.mounted) {
      final download = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Download card catalog?'),
          content: const Text(
            'Matching large imports works best with a local Scryfall '
            'catalog (Wi‑Fi recommended). Download now, or match only '
            'missing cards over the API.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('API only'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Download'),
            ),
          ],
        ),
      );
      if ((download ?? false) && context.mounted) {
        await _runBusy(
          context,
          title: 'Downloading catalog…',
          work: () async {
            await ref.read(mtgCardCatalogProvider).ensureCatalog();
            ref.invalidate(catalogStatusProvider);
          },
        );
      }
    }
  }

  if (!context.mounted) {
    return;
  }

  await _runBusy(
    context,
    title: 'Matching cards…',
    work: () async {
      final result = await ref.read(cardMatchServiceProvider).matchAssets(
            assets,
            allowNetwork: true,
            ensureCatalogIfLarge: false,
          );
      if (!context.mounted) {
        return;
      }
      if (result.isFailure) {
        showFailureSnackBar(context, result.failureOrNull!.message);
        return;
      }
      final summary = result.valueOrNull!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Matched ${summary.matched} of ${summary.considered} '
            '(${summary.uniqueKeys} unique)',
          ),
        ),
      );
    },
  );
}

Future<void> runCardRematchForAssets(
  BuildContext context,
  WidgetRef ref, {
  required List<Asset> assets,
}) async {
  final enabled = ref.read(catalogEnabledProvider);
  if (!enabled) {
    showFailureSnackBar(
      context,
      'MTG catalog is turned off in Settings.',
    );
    return;
  }

  if (assets.isEmpty) {
    return;
  }

  await _runBusy(
    context,
    title: 'Refetching cards…',
    work: () async {
      final result = await ref.read(cardMatchServiceProvider).rematchAssets(
            assets,
            allowNetwork: true,
          );
      if (!context.mounted) {
        return;
      }
      if (result.isFailure) {
        showFailureSnackBar(context, result.failureOrNull!.message);
        return;
      }
      final summary = result.valueOrNull!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Refetched ${summary.matched} of ${summary.considered} '
            '(${summary.uniqueKeys} unique)',
          ),
        ),
      );
    },
  );
}

Future<void> runSingleCardMatch(
  BuildContext context,
  WidgetRef ref,
  Asset asset, {
  bool rematch = false,
}) async {
  final enabled = ref.read(catalogEnabledProvider);
  if (!enabled) {
    showFailureSnackBar(
      context,
      'MTG catalog is turned off in Settings.',
    );
    return;
  }

  await _runBusy(
    context,
    title: rematch ? 'Rematching…' : 'Matching…',
    work: () async {
      final result = rematch
          ? await ref.read(cardMatchServiceProvider).rematchAsset(asset)
          : await ref.read(cardMatchServiceProvider).matchAsset(asset);
      if (!context.mounted) {
        return;
      }
      if (result.isFailure) {
        showFailureSnackBar(context, result.failureOrNull!.message);
        return;
      }
      if (result.valueOrNull == null) {
        showFailureSnackBar(context, 'No catalog match found.');
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(rematch ? 'Card rematched' : 'Card matched')),
      );
    },
  );
}

Future<void> runClearCardMatch(
  BuildContext context,
  WidgetRef ref,
  Asset asset,
) async {
  final result = await ref.read(cardMatchServiceProvider).clearMatch(asset);
  if (!context.mounted) {
    return;
  }
  if (result.isFailure) {
    showFailureSnackBar(context, result.failureOrNull!.message);
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Catalog match cleared')),
  );
}

Future<File?> loadCardImage(
  WidgetRef ref, {
  required String scryfallId,
  required CardImageSize size,
  int faceIndex = 0,
  String? urlOverride,
}) async {
  final printing = await ref.read(mtgCardCatalogProvider).getById(scryfallId);
  final url = urlOverride ??
      printing?.imageUrlForFace(
        faceIndex,
        normal: size == CardImageSize.normal,
      );
  final smallUrl = printing?.imageUrlForFace(faceIndex, normal: false);
  return ref.read(cardImageCacheProvider).ensureImageOrFallback(
        scryfallId: scryfallId,
        size: size,
        url: url,
        smallUrl: smallUrl,
        faceIndex: faceIndex,
      );
}

Future<CardPrinting?> loadCardPrinting(WidgetRef ref, Asset asset) async {
  final id = MtgMetadataKeys.scryfallIdOf(asset.metadata.values);
  if (id == null) {
    return null;
  }
  final catalog = ref.read(mtgCardCatalogProvider);
  final local = await catalog.getById(id);
  if (local != null && !local.needsCatalogHydration) {
    return local;
  }
  // Hydrate faces for printings cached before multi-face support.
  // Soft-fail offline: prefer local stats/URLs over a hard error.
  try {
    final fresh = await catalog.resolve(scryfallId: id);
    return fresh ?? local;
  } on Object {
    return local;
  }
}

Future<void> _runBusy(
  BuildContext context, {
  required String title,
  required Future<void> Function() work,
}) async {
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.md),
            Text('This may take a moment.'),
          ],
        ),
      ),
    ),
  );
  try {
    await work();
  } finally {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
