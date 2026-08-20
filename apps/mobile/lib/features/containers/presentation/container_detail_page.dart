import 'package:compass/core/domain/entities/container.dart' as graph;
import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/confirm_delete.dart';
import 'package:compass/widgets/empty_state.dart';
import 'package:compass/widgets/graph_tile.dart';
import 'package:compass/widgets/move_target_picker.dart';
import 'package:compass/widgets/name_prompt.dart';
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
    final path = containerPath(container, locationById, containerById);
    final nested = containers
        .where((item) => item.parentContainerId == containerId)
        .toList(growable: false);
    final heldAssets = assets
        .where((item) => item.containerId == containerId)
        .toList(growable: false);

    return CompassScaffold(
      title: container.name,
      actions: [
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
          Text(path, style: Theme.of(context).textTheme.bodyMedium),
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
                  GraphTile(
                    title: item.name,
                    icon: Icons.style_outlined,
                    onTap: () => context.push(AppRoutes.assetPath(item.id)),
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
    final result = await ref.read(assetServiceProvider).createAsset(
          name: name,
          containerId: containerId,
        );
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
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
