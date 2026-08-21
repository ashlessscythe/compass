import 'dart:io';

import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/container.dart' as graph;
import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/catalog/application/catalog_prefs.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/catalog/infrastructure/card_image_cache.dart';
import 'package:compass/features/catalog/presentation/catalog_match_actions.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/confirm_delete.dart';
import 'package:compass/widgets/mana_cost_row.dart';
import 'package:compass/widgets/move_target_picker.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:compass/widgets/path_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AssetDetailPage extends ConsumerWidget {
  const AssetDetailPage({required this.assetId, super.key});

  final String assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationsListProvider).valueOrNull ?? const [];
    final containers =
        ref.watch(containersListProvider).valueOrNull ?? const [];
    final assets = ref.watch(assetsListProvider).valueOrNull ?? const [];
    final catalogEnabled = ref.watch(catalogEnabledProvider);

    Asset? asset;
    for (final item in assets) {
      if (item.id == assetId) {
        asset = item;
        break;
      }
    }

    if (asset == null) {
      return const CompassScaffold(
        title: 'Asset',
        body: Center(child: Text('This asset is no longer here.')),
      );
    }

    final locationById = {for (final loc in locations) loc.id: loc};
    final containerById = {for (final item in containers) item.id: item};
    final crumbs = assetPathCrumbs(
      context,
      asset,
      locationById,
      containerById,
    );
    final scryfallId = MtgMetadataKeys.scryfallIdOf(asset.metadata.values);
    final setCode =
        MtgMetadataKeys.stringOf(asset.metadata.values, MtgMetadataKeys.setCode);
    final collector = MtgMetadataKeys.stringOf(
      asset.metadata.values,
      MtgMetadataKeys.collectorNumber,
    );

    return CompassScaffold(
      title: asset.name,
      actions: [
        IconButton(
          tooltip: 'Rename',
          onPressed: () => _rename(context, ref, asset!),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: 'Move',
          onPressed: () => _move(
            context,
            ref,
            asset!,
            containers,
            locationById,
            containerById,
          ),
          icon: const Icon(Icons.drive_file_move_outline),
        ),
        IconButton(
          tooltip: 'Delete',
          onPressed: () => _delete(context, ref, name: asset!.name),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
      body: ListView(
        children: [
          _CardArtBlock(
            asset: asset,
            scryfallId: scryfallId,
            catalogEnabled: catalogEnabled,
            onMatch: () => runSingleCardMatch(context, ref, asset!),
          ),
          if (scryfallId != null) ...[
            const SizedBox(height: AppSpacing.md),
            FutureBuilder(
              future: loadCardPrinting(ref, asset),
              builder: (context, snapshot) {
                final printing = snapshot.data;
                if (printing == null) {
                  return const SizedBox.shrink();
                }
                final theme = Theme.of(context);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (printing.typeLine != null)
                      Text(printing.typeLine!, style: theme.textTheme.bodyLarge),
                    if (printing.manaCost != null &&
                        printing.manaCost!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      ManaCostRow(printing.manaCost!),
                    ],
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${printing.setCode.toUpperCase()} · '
                      '#${printing.collectorNumber}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              },
            ),
          ] else if (setCode != null || collector != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              [
                if (setCode != null) setCode.toUpperCase(),
                if (collector != null) '#$collector',
              ].join(' · '),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Where',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          PathBreadcrumbs(crumbs: crumbs),
        ],
      ),
    );
  }

  Future<void> _rename(
    BuildContext context,
    WidgetRef ref,
    Asset asset,
  ) async {
    final name = await promptForName(
      context,
      title: 'Rename asset',
      initial: asset.name,
    );
    if (name == null) {
      return;
    }
    final result = await ref.read(assetServiceProvider).renameAsset(
          id: asset.id,
          name: name,
        );
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  Future<void> _move(
    BuildContext context,
    WidgetRef ref,
    Asset asset,
    List<graph.Container> containers,
    Map<String, Location> locationById,
    Map<String, graph.Container> containerById,
  ) async {
    final destinations = [
      for (final item in containers)
        if (item.id != asset.containerId)
          MoveDestination(
            key: item.id,
            label: item.name,
            subtitle: containerPath(item, locationById, containerById),
            icon: Icons.inventory_2_outlined,
          ),
    ];

    final picked = await pickMoveDestination(
      context,
      title: 'Move ${asset.name}',
      destinations: destinations,
    );
    if (picked == null || !context.mounted) {
      return;
    }

    final result = await ref.read(assetServiceProvider).moveAsset(
          id: asset.id,
          containerId: picked.key,
        );
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref, {
    required String name,
  }) async {
    final confirmed = await confirmDelete(
      context,
      title: 'Delete asset?',
      body: 'Delete “$name”? This cannot be undone.',
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    final result = await ref.read(assetServiceProvider).deleteAsset(assetId);
    if (!context.mounted) {
      return;
    }
    if (result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
      return;
    }
    context.pop();
  }
}

class _CardArtBlock extends ConsumerWidget {
  const _CardArtBlock({
    required this.asset,
    required this.scryfallId,
    required this.catalogEnabled,
    required this.onMatch,
  });

  final Asset asset;
  final String? scryfallId;
  final bool catalogEnabled;
  final VoidCallback onMatch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    if (scryfallId == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 5 / 7,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant,
                  width: 1.5,
                ),
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.style_outlined,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No catalog match',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.tonal(
                    onPressed: catalogEnabled ? onMatch : null,
                    child: const Text('Match with Scryfall'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return FutureBuilder<File?>(
      future: loadCardImage(
        ref,
        scryfallId: scryfallId!,
        size: CardImageSize.normal,
      ),
      builder: (context, snapshot) {
        final file = snapshot.data;
        if (file != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              file,
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
          );
        }
        return AspectRatio(
          aspectRatio: 5 / 7,
          child: Center(
            child: snapshot.connectionState == ConnectionState.waiting
                ? const CircularProgressIndicator()
                : FilledButton.tonal(
                    onPressed: catalogEnabled ? onMatch : null,
                    child: const Text('Retry match'),
                  ),
          ),
        );
      },
    );
  }
}
