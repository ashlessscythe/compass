import 'package:compass/core/domain/entities/container.dart' as graph;
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/graph_tile.dart';
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
          tooltip: 'Delete',
          onPressed: () => _delete(context, ref),
          icon: const Icon(Icons.delete_outline),
        ),
      ],
      body: ListView(
        children: [
          Text(path, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          Text('Containers', style: Theme.of(context).textTheme.titleMedium),
          if (nested.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text('No nested containers yet.'),
            )
          else
            ...nested.map(
              (item) => GraphTile(
                title: item.name,
                icon: Icons.inventory_2_outlined,
                onTap: () => context.push(AppRoutes.containerPath(item.id)),
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addContainer(context, ref, container!),
              icon: const Icon(Icons.add),
              label: const Text('Add container'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Assets', style: Theme.of(context).textTheme.titleMedium),
          if (heldAssets.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text('No assets in this container yet.'),
            )
          else
            ...heldAssets.map(
              (item) => GraphTile(
                title: item.name,
                icon: Icons.style_outlined,
                onTap: () => context.push(AppRoutes.assetPath(item.id)),
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addAsset(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add asset'),
            ),
          ),
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

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
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
