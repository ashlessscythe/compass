import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/core/domain/entities/container.dart' as graph;
import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/catalog/presentation/catalog_match_actions.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/features/domains/application/module_scope.dart';
import 'package:compass/features/entitlements/application/entitlement_providers.dart';
import 'package:compass/features/entitlements/domain/compass_feature.dart';
import 'package:compass/features/entitlements/presentation/unlock_sheet.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/nfc/application/nfc_service.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/asset_card_tile.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/confirm_delete.dart';
import 'package:compass/widgets/empty_state.dart';
import 'package:compass/widgets/graph_tile.dart';
import 'package:compass/widgets/move_target_picker.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:compass/widgets/path_breadcrumbs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ContainerDetailPage extends ConsumerWidget {
  const ContainerDetailPage({required this.containerId, super.key});

  final String containerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationsListProvider).valueOrNull ?? const [];
    final containers =
        ref.watch(containersListProvider).valueOrNull ?? const [];
    final assets = ref.watch(assetsListProvider).valueOrNull ?? const [];

    graph.Container? container;
    for (final item in containers) {
      if (item.id == containerId) {
        container = item;
        break;
      }
    }

    if (container == null) {
      return const CompassScaffold(
        title: 'Container',
        body: Center(child: Text('This container is no longer here.')),
      );
    }

    final locationById = {for (final loc in locations) loc.id: loc};
    final containerById = {for (final item in containers) item.id: item};
    final activeModuleId = ref.watch(activeModuleIdProvider);
    final pack = activeModuleId == null
        ? null
        : ref
            .watch(domainPackRegistryProvider)
            .valueOrNull
            ?.packForModule(activeModuleId);
    final nested = containers
        .where((item) => item.parentContainerId == containerId)
        .toList(growable: false);
    final heldAssets = filterAssetsForModule(
      assets.where((item) => item.containerId == containerId),
      pack,
      activeModuleId: activeModuleId,
    );

    final nfcPaired = container.nfcTagId != null;
    final scheme = Theme.of(context).colorScheme;

    return CompassScaffold(
      title: container.name,
      actions: [
        if (heldAssets.isNotEmpty && pack?.moduleId == 'mtg')
          IconButton(
            tooltip: ref.watch(
              canUseFeatureProvider(CompassFeature.bulkRefresh),
            )
                ? 'Refetch all'
                : 'Refetch all · Pro',
            onPressed: () async {
              if (!ref.read(
                canUseFeatureProvider(CompassFeature.bulkRefresh),
              )) {
                await showRefetchUnlockSheet(context, ref);
                return;
              }
              await runCardRematchForAssets(
                context,
                ref,
                assets: heldAssets,
              );
            },
            icon: const Icon(Icons.refresh),
          ),
        IconButton(
          tooltip: nfcPaired ? 'Unpair NFC' : 'Pair NFC',
          onPressed: () => _nfcAction(context, ref, container!),
          icon: Badge(
            isLabelVisible: nfcPaired,
            smallSize: 8,
            backgroundColor: scheme.primary,
            child: Icon(
              nfcPaired ? Icons.nfc : Icons.nfc_outlined,
              color: nfcPaired ? scheme.primary : null,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Rename',
          onPressed: () => _rename(context, ref, container!),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: 'Move',
          onPressed: () => _move(
            context,
            ref,
            container!,
            locations,
            containers,
            locationById,
            containerById,
          ),
          icon: const Icon(Icons.drive_file_move_outline),
        ),
        IconButton(
          tooltip: 'Delete',
          onPressed: () => _delete(
            context,
            ref,
            name: container!.name,
            hasNested: nested.isNotEmpty,
            hasAssets: heldAssets.isNotEmpty,
          ),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
      body: ListView(
        children: [
          PathBreadcrumbs(
            crumbs: containerPathCrumbs(
              context,
              container,
              locationById,
              containerById,
              currentContainerId: containerId,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _NfcStatusRow(
            paired: nfcPaired,
            tagId: container.nfcTagId,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (nested.isEmpty && heldAssets.isEmpty)
            EmptyState(
              body: 'Add a nested container or an asset.',
              primaryLabel: 'Add container',
              onPrimary: () => _addContainer(context, ref, container!),
              secondaryLabel: 'Add asset',
              onSecondary: () => _addAsset(context, ref),
            )
          else ...[
            GraphChildSection(
              title: 'Containers',
              tiles: [
                for (final item in nested)
                  GraphTile(
                    title: item.name,
                    icon: Icons.inventory_2_outlined,
                    onTap: () => context.push(AppRoutes.containerPath(item.id)),
                  ),
              ],
              addLabel: 'Add container',
              onAdd: () => _addContainer(context, ref, container!),
            ),
            const SizedBox(height: AppSpacing.md),
            GraphChildSection(
              title: 'Assets',
              tiles: [
                for (final item in heldAssets)
                  AssetCardTile(
                    asset: item,
                    onTap: () => context.push(AppRoutes.assetPath(item.id)),
                    onMatch: () => runSingleCardMatch(context, ref, item),
                  ),
              ],
              addLabel: 'Add asset',
              onAdd: () => _addAsset(context, ref),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _addContainer(
    BuildContext context,
    WidgetRef ref,
    graph.Container parent,
  ) async {
    final name = await promptForName(
      context,
      title: 'New container',
      confirmLabel: 'Add',
    );
    if (name == null) {
      return;
    }
    final result = await ref.read(containerServiceProvider).createContainer(
          name: name,
          locationId: parent.locationId,
          parentContainerId: parent.id,
        );
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  Future<void> _addAsset(BuildContext context, WidgetRef ref) async {
    final name = await promptForName(
      context,
      title: 'New asset',
      confirmLabel: 'Add',
    );
    if (name == null) {
      return;
    }
    final moduleId = ref.read(activeModuleIdProvider);
    final pack = moduleId == null
        ? null
        : ref
            .read(domainPackRegistryProvider)
            .valueOrNull
            ?.packForModule(moduleId);
    final metadata = moduleId == null
        ? Metadata.empty
        : Metadata(values: {kCompassModuleIdMetadataKey: moduleId});
    final result = await ref.read(assetServiceProvider).createAsset(
          name: name,
          containerId: containerId,
          assetTypeId: pack?.defaultAssetTypeId,
          metadata: metadata,
        );
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  Future<void> _nfcAction(
    BuildContext context,
    WidgetRef ref,
    graph.Container container,
  ) async {
    if (container.nfcTagId != null) {
      final confirmed = await confirmDelete(
        context,
        title: 'Unpair NFC tag?',
        body: 'This sticker will no longer open ${container.name}. '
            'You can pair it again later.',
        confirmLabel: 'Unpair',
      );
      if (!confirmed || !context.mounted) {
        return;
      }
      final result =
          await ref.read(nfcServiceProvider).unpairContainer(container.id);
      if (!context.mounted) {
        return;
      }
      if (result.isFailure) {
        showFailureSnackBar(context, result.failureOrNull!.message);
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NFC tag unpaired')),
      );
      return;
    }

    final result = await ref.read(nfcServiceProvider).pairContainer(
      container.id,
      confirmReassign: (ownerPath) {
        if (!context.mounted) {
          return Future.value(false);
        }
        return confirmDelete(
          context,
          title: 'Move this NFC tag?',
          body: 'Already opens $ownerPath. '
              'Use it for ${container.name} instead?',
          confirmLabel: 'Move tag',
        );
      },
    );
    if (!context.mounted) {
      return;
    }
    if (result.isFailure) {
      final failure = result.failureOrNull!;
      if (failure.message == 'NFC scan cancelled' ||
          failure.message == 'NFC pair cancelled') {
        return;
      }
      showFailureSnackBar(context, failure.message);
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Paired NFC · ${result.valueOrNull!.nfcTagId}'),
      ),
    );
  }

  Future<void> _rename(
    BuildContext context,
    WidgetRef ref,
    graph.Container container,
  ) async {
    final name = await promptForName(
      context,
      title: 'Rename container',
      initial: container.name,
    );
    if (name == null) {
      return;
    }
    final result = await ref.read(containerServiceProvider).renameContainer(
          id: container.id,
          name: name,
        );
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  Future<void> _move(
    BuildContext context,
    WidgetRef ref,
    graph.Container container,
    List<Location> locations,
    List<graph.Container> containers,
    Map<String, Location> locationById,
    Map<String, graph.Container> containerById,
  ) async {
    final destinations = <MoveDestination>[
      for (final place in locations)
        MoveDestination(
          key: 'location:${place.id}',
          label: place.name,
          subtitle: 'In ${place.path ?? place.name}',
        ),
      for (final item in containers)
        if (item.id != container.id &&
            !_isUnderContainer(
              containerById,
              ancestorId: container.id,
              candidateId: item.id,
            ))
          MoveDestination(
            key: 'container:${item.id}',
            label: item.name,
            subtitle: containerPath(item, locationById, containerById),
            icon: Icons.inventory_2_outlined,
          ),
    ];

    final picked = await pickMoveDestination(
      context,
      title: 'Move ${container.name}',
      destinations: destinations,
    );
    if (picked == null || !context.mounted) {
      return;
    }

    final Result<graph.Container> result;
    if (picked.key.startsWith('location:')) {
      result = await ref.read(containerServiceProvider).moveContainer(
            id: container.id,
            locationId: picked.key.substring('location:'.length),
          );
    } else {
      result = await ref.read(containerServiceProvider).moveContainer(
            id: container.id,
            parentContainerId: picked.key.substring('container:'.length),
          );
    }
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref, {
    required String name,
    required bool hasNested,
    required bool hasAssets,
  }) async {
    final body = switch ((hasNested, hasAssets)) {
      (true, true) =>
        'Delete “$name”? Nested containers will also be deleted. '
            'Assets inside will no longer be in this container.',
      (true, false) =>
        'Delete “$name”? Nested containers will also be deleted.',
      (false, true) =>
        'Delete “$name”? Assets inside will no longer be in '
            'this container.',
      (false, false) => 'Delete “$name”? This cannot be undone.',
    };
    final confirmed = await confirmDelete(
      context,
      title: 'Delete container?',
      body: body,
    );
    if (!confirmed || !context.mounted) {
      return;
    }
    final result =
        await ref.read(containerServiceProvider).deleteContainer(containerId);
    if (!context.mounted) {
      return;
    }
    if (result.isFailure) {
      showResultFailure(context, result);
      return;
    }
    context.pop();
  }
}

class _NfcStatusRow extends StatelessWidget {
  const _NfcStatusRow({required this.paired, this.tagId});

  final bool paired;
  final String? tagId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.bodySmall;
    if (!paired) {
      return Text(
        'No NFC tag paired',
        style: style?.copyWith(color: scheme.onSurfaceVariant),
      );
    }
    return Row(
      children: [
        Icon(Icons.nfc, size: 16, color: scheme.primary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            'NFC paired · $tagId',
            style: style?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

bool _isUnderContainer(
  Map<String, graph.Container> byId, {
  required String ancestorId,
  required String candidateId,
}) {
  var current = byId[candidateId];
  while (current?.parentContainerId != null) {
    if (current!.parentContainerId == ancestorId) {
      return true;
    }
    current = byId[current.parentContainerId];
  }
  return false;
}
