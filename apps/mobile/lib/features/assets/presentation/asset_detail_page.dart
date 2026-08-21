import 'dart:io';

import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/container.dart' as graph;
import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/catalog/application/catalog_prefs.dart';
import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/catalog/infrastructure/card_image_cache.dart';
import 'package:compass/features/catalog/presentation/catalog_match_actions.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/confirm_delete.dart';
import 'package:compass/widgets/flipping_card_art.dart';
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
        PopupMenuButton<_AssetMenuAction>(
          tooltip: 'More',
          onSelected: (action) async {
            switch (action) {
              case _AssetMenuAction.rematch:
                await runSingleCardMatch(
                  context,
                  ref,
                  asset!,
                  rematch: true,
                );
              case _AssetMenuAction.clearMatch:
                await runClearCardMatch(context, ref, asset!);
              case _AssetMenuAction.delete:
                await _delete(context, ref, name: asset!.name);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: _AssetMenuAction.rematch,
              enabled: catalogEnabled,
              child: Text(
                scryfallId == null ? 'Match with Scryfall' : 'Rematch',
              ),
            ),
            if (scryfallId != null)
              const PopupMenuItem(
                value: _AssetMenuAction.clearMatch,
                child: Text('Clear match'),
              ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: _AssetMenuAction.delete,
              child: Text('Delete'),
            ),
          ],
        ),
      ],
      body: ListView(
        children: [
          if (scryfallId != null)
            _MatchedCardPanel(
              asset: asset,
              scryfallId: scryfallId,
              catalogEnabled: catalogEnabled,
              onMatch: () => runSingleCardMatch(context, ref, asset!),
            )
          else
            _CardArtBlock(
              asset: asset,
              scryfallId: null,
              catalogEnabled: catalogEnabled,
              onMatch: () => runSingleCardMatch(context, ref, asset!),
            ),
          if (scryfallId == null && (setCode != null || collector != null)) ...[
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

enum _AssetMenuAction { rematch, clearMatch, delete }

class _CardArtBlock extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
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
    );
  }
}

class _MatchedCardPanel extends ConsumerStatefulWidget {
  const _MatchedCardPanel({
    required this.asset,
    required this.scryfallId,
    required this.catalogEnabled,
    required this.onMatch,
  });

  final Asset asset;
  final String scryfallId;
  final bool catalogEnabled;
  final VoidCallback onMatch;

  @override
  ConsumerState<_MatchedCardPanel> createState() => _MatchedCardPanelState();
}

class _MatchedCardPanelState extends ConsumerState<_MatchedCardPanel> {
  var _faceIndex = 0;
  Future<({CardPrinting printing, List<File?> files})>? _bundle;

  @override
  void didUpdateWidget(covariant _MatchedCardPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scryfallId != widget.scryfallId ||
        oldWidget.asset.updatedAt != widget.asset.updatedAt) {
      _bundle = null;
      _faceIndex = 0;
    }
  }

  Future<({CardPrinting printing, List<File?> files})> _loadBundle() async {
    final printing = await loadCardPrinting(ref, widget.asset);
    if (printing == null) {
      throw StateError('missing printing');
    }
    final count = printing.isMultiFace ? printing.faces.length : 1;
    final files = <File?>[];
    for (var i = 0; i < count; i++) {
      files.add(
        await loadCardImage(
          ref,
          scryfallId: widget.scryfallId,
          size: CardImageSize.normal,
          faceIndex: i,
          urlOverride: printing.imageUrlForFace(i, normal: true),
        ),
      );
    }
    return (printing: printing, files: files);
  }

  void _flip(int faceCount) {
    if (faceCount < 2) {
      return;
    }
    setState(() => _faceIndex = (_faceIndex + 1) % faceCount);
  }

  @override
  Widget build(BuildContext context) {
    _bundle ??= _loadBundle();
    return FutureBuilder(
      future: _bundle,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return AspectRatio(
            aspectRatio: 5 / 7,
            child: Center(
              child: FilledButton.tonal(
                onPressed: widget.catalogEnabled ? widget.onMatch : null,
                child: const Text('Retry match'),
              ),
            ),
          );
        }
        final bundle = snapshot.data;
        if (bundle == null) {
          return const AspectRatio(
            aspectRatio: 5 / 7,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final printing = bundle.printing;
        final files = bundle.files;
        final faces = printing.faces;
        final multi = printing.isMultiFace;
        final safeIndex = multi ? _faceIndex.clamp(0, faces.length - 1) : 0;
        final face = printing.faceAt(safeIndex);
        final typeLine = face?.typeLine ?? printing.typeLine;
        final manaCost = face?.manaCost ?? printing.manaCost;
        final faceName = multi ? (face?.name ?? printing.name) : null;
        final theme = Theme.of(context);

        final artFaces = <Widget>[
          for (var i = 0; i < files.length; i++)
            if (files[i] != null)
              Image.file(
                files[i]!,
                fit: BoxFit.fitWidth,
                width: double.infinity,
              )
            else
              const AspectRatio(
                aspectRatio: 5 / 7,
                child: Center(child: Icon(Icons.broken_image_outlined)),
              ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FlippingCardArt(
              faceIndex: safeIndex,
              faces: artFaces,
              onTap: multi ? () => _flip(faces.length) : null,
            ),
            if (multi) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Text(
                    'Face ${safeIndex + 1} of ${faces.length}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: () => _flip(faces.length),
                    icon: const Icon(Icons.flip),
                    label: Text(
                      printing.layout == 'split' ? 'Other half' : 'Flip',
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              child: Column(
                key: ValueKey(safeIndex),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (faceName != null && faceName.isNotEmpty)
                    Text(faceName, style: theme.textTheme.titleMedium),
                  if (typeLine != null)
                    Text(typeLine, style: theme.textTheme.bodyLarge),
                  if (manaCost != null && manaCost.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    ManaCostRow(manaCost),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              [
                printing.setCode.toUpperCase(),
                '#${printing.collectorNumber}',
                if (printing.layout != null && printing.layout!.isNotEmpty)
                  printing.layout!,
              ].join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    );
  }
}
