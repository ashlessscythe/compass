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
import 'package:compass/features/catalog/presentation/card_details_sheet.dart';
import 'package:compass/features/catalog/presentation/card_printings_sheet.dart';
import 'package:compass/features/catalog/presentation/catalog_match_actions.dart';
import 'package:compass/features/domains/application/domain_asset_catalog.dart';
import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/features/domains/application/pack_csv_adapter.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
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

    final currentAsset = asset;
    final catalogPack = ref.watch(assetCatalogPackProvider(currentAsset));
    final showCatalogUi = catalogPack != null;

    final locationById = {for (final loc in locations) loc.id: loc};
    final containerById = {for (final item in containers) item.id: item};
    final crumbs = assetPathCrumbs(
      context,
      currentAsset,
      locationById,
      containerById,
    );
    final scryfallId = MtgMetadataKeys.scryfallIdOf(currentAsset.metadata.values);
    final setCode = MtgMetadataKeys.stringOf(
      currentAsset.metadata.values,
      MtgMetadataKeys.setCode,
    );
    final collector = MtgMetadataKeys.stringOf(
      currentAsset.metadata.values,
      MtgMetadataKeys.collectorNumber,
    );

    return CompassScaffold(
      title: currentAsset.name,
      actions: [
        IconButton(
          tooltip: 'Rename',
          onPressed: () => _rename(context, ref, currentAsset),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: 'Move',
          onPressed: () => _move(
            context,
            ref,
            currentAsset,
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
                  currentAsset,
                  rematch: true,
                );
              case _AssetMenuAction.clearMatch:
                await runClearCardMatch(context, ref, currentAsset);
              case _AssetMenuAction.delete:
                await _delete(context, ref, name: currentAsset.name);
            }
          },
          itemBuilder: (context) => [
            if (showCatalogUi)
              PopupMenuItem(
                value: _AssetMenuAction.rematch,
                enabled: catalogEnabled,
                child: Text(
                  scryfallId == null ? 'Match with Scryfall' : 'Rematch',
                ),
              ),
            if (showCatalogUi && scryfallId != null)
              const PopupMenuItem(
                value: _AssetMenuAction.clearMatch,
                child: Text('Clear match'),
              ),
            if (showCatalogUi) const PopupMenuDivider(),
            const PopupMenuItem(
              value: _AssetMenuAction.delete,
              child: Text('Delete'),
            ),
          ],
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PathBreadcrumbs(crumbs: crumbs),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: showCatalogUi
                ? (scryfallId != null
                    ? _MatchedCardPanel(
                        asset: currentAsset,
                        scryfallId: scryfallId,
                        catalogEnabled: catalogEnabled,
                        onMatch: () =>
                            runSingleCardMatch(context, ref, currentAsset),
                      )
                    : _UnmatchedCardBody(
                        catalogEnabled: catalogEnabled,
                        onMatch: () =>
                            runSingleCardMatch(context, ref, currentAsset),
                        setCode: setCode,
                        collector: collector,
                      ))
                : _GenericAssetBody(asset: currentAsset),
          ),
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

class _GenericAssetBody extends ConsumerWidget {
  const _GenericAssetBody({required this.asset});

  final Asset asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pack = _packForAsset(ref, asset);
    final adapter = pack == null ? null : PackCsvAdapter(pack);
    final attributeRows = pack == null
        ? const <Widget>[]
        : _attributeRows(
            theme: theme,
            pack: pack,
            adapter: adapter!,
            asset: asset,
          );

    return Padding(
      padding: AppSpacing.pagePadding,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(asset.name, style: theme.textTheme.headlineSmall),
            if (asset.notes != null && asset.notes!.trim().isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(asset.notes!, style: theme.textTheme.bodyLarge),
            ],
            const SizedBox(height: AppSpacing.md),
            Text(
              'Quantity: ${asset.quantity}',
              style: theme.textTheme.bodyMedium,
            ),
            if (attributeRows.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              Text('Details', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ...attributeRows,
            ],
          ],
        ),
      ),
    );
  }

  DomainPack? _packForAsset(WidgetRef ref, Asset asset) {
    final registry = ref.watch(domainPackRegistryProvider).valueOrNull;
    if (registry == null) {
      return null;
    }
    for (final pack in registry.installedPacks) {
      if (pack.assetTypes.any((type) => type.id == asset.assetTypeId)) {
        return pack;
      }
    }
    return null;
  }

  List<Widget> _attributeRows({
    required ThemeData theme,
    required DomainPack pack,
    required PackCsvAdapter adapter,
    required Asset asset,
  }) {
    final typeIds = _typeIdsForAsset(pack, asset.assetTypeId);
    final rows = <Widget>[];
    for (final def in pack.attributeDefinitions) {
      if (def.assetTypeId != null && !typeIds.contains(def.assetTypeId)) {
        continue;
      }
      final raw = asset.metadata.values[def.key]?.toString();
      if (raw == null || raw.trim().isEmpty) {
        continue;
      }
      final label = adapter.labelForAttributeValue(def.key, raw) ?? raw;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  def.displayName ?? def.key,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Text(label, style: theme.textTheme.bodyMedium),
              ),
            ],
          ),
        ),
      );
    }
    return rows;
  }

  Set<String> _typeIdsForAsset(DomainPack pack, String assetTypeId) {
    final ids = <String>{assetTypeId};
    var current = assetTypeId;
    while (true) {
      final type = pack.assetTypes.where((t) => t.id == current).firstOrNull;
      if (type?.parentId == null) {
        break;
      }
      ids.add(type!.parentId!);
      current = type.parentId!;
    }
    return ids;
  }
}

class _UnmatchedCardBody extends StatelessWidget {
  const _UnmatchedCardBody({
    required this.catalogEnabled,
    required this.onMatch,
    required this.setCode,
    required this.collector,
  });

  final bool catalogEnabled;
  final VoidCallback onMatch;
  final String? setCode;
  final String? collector;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StickyCardArt(
          child: _CardArtPlaceholder(
            catalogEnabled: catalogEnabled,
            onMatch: onMatch,
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            children: [
              if (setCode != null || collector != null)
                Text(
                  [
                    if (setCode != null) setCode!.toUpperCase(),
                    if (collector != null) '#$collector',
                  ].join(' · '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardArtPlaceholder extends StatelessWidget {
  const _CardArtPlaceholder({
    required this.catalogEnabled,
    required this.onMatch,
  });

  final bool catalogEnabled;
  final VoidCallback onMatch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1.5,
        ),
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
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
    );
  }
}

/// Caps card art height so sticky header leaves room for scroll content.
class _StickyCardArt extends StatelessWidget {
  const _StickyCardArt({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxArtHeight = MediaQuery.sizeOf(context).height * 0.45;
        final width = constraints.maxWidth;
        var artHeight = width * 7 / 5;
        var artWidth = width;
        if (artHeight > maxArtHeight) {
          artHeight = maxArtHeight;
          artWidth = artHeight * 5 / 7;
        }
        return Center(
          child: SizedBox(
            width: artWidth,
            height: artHeight,
            child: child,
          ),
        );
      },
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StickyCardArt(
                child: Center(
                  child: FilledButton.tonal(
                    onPressed: widget.catalogEnabled ? widget.onMatch : null,
                    child: const Text('Retry match'),
                  ),
                ),
              ),
              const Spacer(),
            ],
          );
        }
        final bundle = snapshot.data;
        if (bundle == null) {
          return const Column(
            children: [
              Expanded(child: Center(child: CircularProgressIndicator())),
            ],
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
        final oracleText = face?.oracleText ?? printing.oracleText;
        final combat = printing.combatStatsForFace(safeIndex);
        final theme = Theme.of(context);

        final artFaces = <Widget>[
          for (var i = 0; i < files.length; i++)
            if (files[i] != null)
              Image.file(
                files[i]!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            else
              const Center(child: Icon(Icons.broken_image_outlined)),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StickyCardArt(
              child: FlippingCardArt(
                faceIndex: safeIndex,
                faces: artFaces,
                onTap: multi ? () => _flip(faces.length) : null,
              ),
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
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.sm,
              children: [
                TextButton(
                  onPressed: () => showCardDetailsSheet(
                    context,
                    printing: printing,
                    face: face,
                  ),
                  child: const Text('Details'),
                ),
                if (printing.oracleId != null && printing.oracleId!.isNotEmpty)
                  TextButton(
                    onPressed: () => showCardPrintingsSheet(
                      context,
                      ref,
                      asset: widget.asset,
                      current: printing,
                      catalogEnabled: widget.catalogEnabled,
                    ),
                    child: const Text('Other printings'),
                  ),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                children: [
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
                        const SizedBox(height: AppSpacing.xs),
                        _ManaAndColorRow(
                          manaCost: manaCost,
                          cmc: printing.cmc,
                          colors: (face != null && face.colors.isNotEmpty)
                              ? face.colors
                              : printing.colors,
                          colorIdentity: printing.colorIdentity,
                        ),
                        if (oracleText != null && oracleText.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(oracleText, style: theme.textTheme.bodyMedium),
                        ],
                        if (combat != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(combat, style: theme.textTheme.titleMedium),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    [
                      if (printing.setName != null &&
                          printing.setName!.isNotEmpty)
                        printing.setName!
                      else
                        printing.setCode.toUpperCase(),
                      '#${printing.collectorNumber}',
                      if (printing.rarity != null &&
                          printing.rarity!.isNotEmpty)
                        titleCase(printing.rarity!),
                    ].join(' · '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (printing.artist != null && printing.artist!.isNotEmpty)
                    Text(
                      printing.artist!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ManaAndColorRow extends StatelessWidget {
  const _ManaAndColorRow({
    required this.manaCost,
    required this.cmc,
    required this.colors,
    required this.colorIdentity,
  });

  final String? manaCost;
  final double? cmc;
  final List<String> colors;
  final List<String> colorIdentity;

  bool get _identityDiffers {
    if (colorIdentity.isEmpty) {
      return false;
    }
    if (colors.length != colorIdentity.length) {
      return true;
    }
    for (var i = 0; i < colors.length; i++) {
      if (colors[i] != colorIdentity[i]) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final hasMana = manaCost != null && manaCost!.isNotEmpty;
    final cmcLabel = formatCmc(cmc);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (hasMana) ManaCostRow(manaCost!),
            if (cmcLabel.isNotEmpty) Text('CMC $cmcLabel', style: muted),
          ],
        ),
        if (colors.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text('Color', style: muted),
              const SizedBox(width: AppSpacing.xs),
              ManaCostRow.fromSymbols(colors),
            ],
          ),
        ],
        if (_identityDiffers) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text('Identity', style: muted),
              const SizedBox(width: AppSpacing.xs),
              ManaCostRow.fromSymbols(colorIdentity),
            ],
          ),
        ],
      ],
    );
  }
}
