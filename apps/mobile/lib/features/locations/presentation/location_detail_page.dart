import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/graph_tile.dart';
import 'package:compass/widgets/name_prompt.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LocationDetailPage extends ConsumerWidget {
  const LocationDetailPage({required this.locationId, super.key});

  final String locationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationsListProvider).valueOrNull ?? const [];
    final containers =
        ref.watch(containersListProvider).valueOrNull ?? const [];
    Location? location;
    for (final item in locations) {
      if (item.id == locationId) {
        location = item;
        break;
      }
    }

    if (location == null) {
      return const CompassScaffold(
        title: 'Place',
        body: Center(child: Text('This place is no longer here.')),
      );
    }

    final childPlaces = locations
        .where((item) => item.parentLocationId == locationId)
        .toList(growable: false);
    final rootContainers = containers
        .where(
          (item) =>
              item.locationId == locationId && item.parentContainerId == null,
        )
        .toList(growable: false);

    return CompassScaffold(
      title: location.name,
      actions: [
        IconButton(
          tooltip: 'Rename',
          onPressed: () => _rename(context, ref, location!),
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
          Text(
            location.path ?? location.name,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Places', style: Theme.of(context).textTheme.titleMedium),
          if (childPlaces.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text('No nested places yet.'),
            )
          else
            ...childPlaces.map(
              (item) => GraphTile(
                title: item.name,
                subtitle: item.path,
                onTap: () => context.push(AppRoutes.locationPath(item.id)),
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addPlace(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add place'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Containers', style: Theme.of(context).textTheme.titleMedium),
          if (rootContainers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text('No containers here yet.'),
            )
          else
            ...rootContainers.map(
              (item) => GraphTile(
                title: item.name,
                icon: Icons.inventory_2_outlined,
                onTap: () => context.push(AppRoutes.containerPath(item.id)),
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _addContainer(context, ref),
              icon: const Icon(Icons.add),
              label: const Text('Add container'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addPlace(BuildContext context, WidgetRef ref) async {
    final name = await promptForName(
      context,
      title: 'New place',
      confirmLabel: 'Add',
    );
    if (name == null) {
      return;
    }
    final result = await ref.read(locationServiceProvider).createLocation(
          name: name,
          parentLocationId: locationId,
        );
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  Future<void> _addContainer(BuildContext context, WidgetRef ref) async {
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
          locationId: locationId,
        );
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  Future<void> _rename(
    BuildContext context,
    WidgetRef ref,
    Location location,
  ) async {
    final name = await promptForName(
      context,
      title: 'Rename place',
      initial: location.name,
    );
    if (name == null) {
      return;
    }
    final result = await ref.read(locationServiceProvider).renameLocation(
          id: location.id,
          name: name,
        );
    if (context.mounted && result.isFailure) {
      showFailureSnackBar(context, result.failureOrNull!.message);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final result =
        await ref.read(locationServiceProvider).deleteLocation(locationId);
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
