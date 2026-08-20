import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/container.dart' as graph;
import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/routing/routes.dart';
import 'package:compass/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PathCrumb {
  const PathCrumb({
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;
}

/// Tappable path trail: ancestors navigate; the last crumb stays plain text.
class PathBreadcrumbs extends StatelessWidget {
  const PathBreadcrumbs({
    required this.crumbs,
    super.key,
  });

  final List<PathCrumb> crumbs;

  @override
  Widget build(BuildContext context) {
    if (crumbs.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final children = <Widget>[];
    for (var i = 0; i < crumbs.length; i++) {
      if (i > 0) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            child: Text(
              '/',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        );
      }
      final crumb = crumbs[i];
      final isLast = i == crumbs.length - 1;
      if (crumb.onTap != null && !isLast) {
        children.add(
          InkWell(
            onTap: crumb.onTap,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxs,
                vertical: 2,
              ),
              child: Text(
                crumb.label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      } else {
        children.add(
          Text(
            crumb.label,
            style: theme.textTheme.bodyLarge,
          ),
        );
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }
}

List<PathCrumb> locationPathCrumbs(
  BuildContext context,
  Location location,
  Map<String, Location> locationsById, {
  String? currentLocationId,
}) {
  final chain = <Location>[];
  Location? current = location;
  while (current != null) {
    chain.add(current);
    final parentId = current.parentLocationId;
    current = parentId == null ? null : locationsById[parentId];
  }

  return [
    for (final item in chain.reversed)
      PathCrumb(
        label: item.name,
        onTap: item.id == currentLocationId
            ? null
            : () => context.push(AppRoutes.locationPath(item.id)),
      ),
  ];
}

List<PathCrumb> containerPathCrumbs(
  BuildContext context,
  graph.Container container,
  Map<String, Location> locationsById,
  Map<String, graph.Container> containersById, {
  String? currentContainerId,
}) {
  final containerChain = <graph.Container>[];
  graph.Container? cursor = container;
  while (cursor != null) {
    containerChain.add(cursor);
    final parentId = cursor.parentContainerId;
    cursor = parentId == null ? null : containersById[parentId];
  }

  final root = containerChain.last;
  final crumbs = <PathCrumb>[];
  if (root.locationId != null) {
    final location = locationsById[root.locationId!];
    if (location != null) {
      crumbs.addAll(
        locationPathCrumbs(context, location, locationsById),
      );
    }
  }

  for (final item in containerChain.reversed) {
    crumbs.add(
      PathCrumb(
        label: item.name,
        onTap: item.id == currentContainerId
            ? null
            : () => context.push(AppRoutes.containerPath(item.id)),
      ),
    );
  }
  return crumbs;
}

List<PathCrumb> assetPathCrumbs(
  BuildContext context,
  Asset asset,
  Map<String, Location> locationsById,
  Map<String, graph.Container> containersById,
) {
  if (asset.containerId != null) {
    final container = containersById[asset.containerId!];
    if (container != null) {
      return [
        ...containerPathCrumbs(
          context,
          container,
          locationsById,
          containersById,
        ),
        PathCrumb(label: asset.name),
      ];
    }
  }
  if (asset.locationId != null) {
    final location = locationsById[asset.locationId!];
    if (location != null) {
      return [
        ...locationPathCrumbs(context, location, locationsById),
        PathCrumb(label: asset.name),
      ];
    }
  }
  return [PathCrumb(label: asset.name)];
}
