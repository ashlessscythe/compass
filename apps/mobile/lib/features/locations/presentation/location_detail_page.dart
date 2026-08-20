import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:compass/widgets/compass_scaffold.dart';
import 'package:compass/widgets/confirm_delete.dart';
import 'package:compass/widgets/empty_state.dart';
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
          onPressed: () => _delete(
            context,
            ref,
            name: location!.name,
            hasChildren:
                childPlaces.isNotEmpty || rootContainers.isNotEmpty,
          ),
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
          if (childPlaces.isEmpty && rootContainers.isEmpty)
            EmptyState(
              body: 'Add a nested place or a container so things '
                  'have somewhere to live.',
              primaryLabel: 'Add place',
              onPrimary: () => _addPlace(context, ref),
              secondaryLabel: 'Add container',
              onSecondary: () => _addContainer(context, ref),
            )
          else ...[
            GraphChildSection(
              title: 'Places',
              tiles: [
                for (final item in childPlaces)
                  GraphTile(
                    title: item.name,
                    subtitle: item.path,
                    onTap: () => context.push(AppRoutes.locationPath(item.id)),
                  ),
              ],
              addLabel: 'Add place',
              onAdd: () => _addPlace(context, ref),
            ),
            const SizedBox(height: AppSpacing.md),
            GraphChildSection(
              title: 'Containers',
              tiles: [
                for (final item in rootContainers)
                  GraphTile(
                    title: item.name,
                    icon: Icons.inventory_2_outlined,
                    onTap: () =>
                        context.push(AppRoutes.containerPath(item.id)),
                  ),
              ],
              addLabel: 'Add container',
              onAdd: () => _addContainer(context, ref),
            ),
          ],
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

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref, {
    required String name,
    required bool hasChildren,
  }) async {
    final body = hasChildren
        ? 'Delete “$name”? Nested places and containers under it '
            'will also be deleted. Assets will lose their place.'
        : 'Delete “$name”? This cannot be undone.';
    final confirmed = await confirmDelete(
      context,
      title: 'Delete place?',
      body: body,
    );
    if (!confirmed || !context.mounted) {
      return;
    }
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
