import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/container.dart';
import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/domain/repositories/asset_repository.dart';
import 'package:compass/core/domain/repositories/container_repository.dart';
import 'package:compass/core/domain/repositories/location_repository.dart';
import 'package:compass/core/utils/display_path.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/features/domains/application/module_scope.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:compass/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SearchHitKind { location, container, asset }

class SearchHit {
  const SearchHit({
    required this.kind,
    required this.id,
    required this.name,
    required this.path,
  });

  final SearchHitKind kind;
  final String id;
  final String name;
  final String path;
}

class SearchService {
  SearchService({
    required this.locations,
    required this.containers,
    required this.assets,
  });

  final LocationRepository locations;
  final ContainerRepository containers;
  final AssetRepository assets;

  Future<List<SearchHit>> query(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      return const [];
    }

    final locations = await this.locations.searchByName(query);
    final containers = await this.containers.searchByName(query);
    final assets = await this.assets.searchByName(query);

    final allLocations = await this.locations.getAll();
    final allContainers = await this.containers.getAll();
    final locationById = {for (final loc in allLocations) loc.id: loc};
    final containerById = {for (final c in allContainers) c.id: c};

    final hits = <SearchHit>[
      for (final location in locations)
        SearchHit(
          kind: SearchHitKind.location,
          id: location.id,
          name: location.name,
          path: location.path ?? location.name,
        ),
      for (final container in containers)
        SearchHit(
          kind: SearchHitKind.container,
          id: container.id,
          name: container.name,
          path: containerPath(container, locationById, containerById),
        ),
      for (final asset in assets)
        SearchHit(
          kind: SearchHitKind.asset,
          id: asset.id,
          name: asset.name,
          path: assetPath(asset, locationById, containerById),
        ),
    ];

    return hits;
  }

  /// Same as [query], but drops asset hits outside [pack]'s collection.
  Future<List<SearchHit>> queryForModule(
    String rawQuery, {
    required DomainPack pack,
    String? activeModuleId,
    List<Asset>? assetsCache,
  }) async {
    final hits = await query(rawQuery);
    if (hits.every((hit) => hit.kind != SearchHitKind.asset)) {
      return hits;
    }
    final assets = assetsCache ?? await this.assets.getAll();
    final assetById = {for (final asset in assets) asset.id: asset};
    return [
      for (final hit in hits)
        if (hit.kind != SearchHitKind.asset)
          hit
        else ...[
          if (assetById[hit.id] != null &&
              assetBelongsToModule(
                assetById[hit.id]!,
                pack,
                activeModuleId: activeModuleId,
              ))
            hit,
        ],
    ];
  }
}

String containerPath(
  Container container,
  Map<String, Location> locations,
  Map<String, Container> containers,
) {
  final names = <String>[container.name];
  var current = container;
  while (current.parentContainerId != null) {
    final parent = containers[current.parentContainerId];
    if (parent == null) {
      break;
    }
    names.add(parent.name);
    current = parent;
  }
  final locationPath = current.locationId == null
      ? null
      : locations[current.locationId!]?.path;
  var path = names.reversed.join(DisplayPath.separator);
  if (locationPath != null && locationPath.isNotEmpty) {
    path = DisplayPath.join(locationPath, path);
  }
  return path;
}

String assetPath(
  Asset asset,
  Map<String, Location> locations,
  Map<String, Container> containers,
) {
  if (asset.containerId != null) {
    final container = containers[asset.containerId];
    if (container != null) {
      return DisplayPath.join(
        containerPath(container, locations, containers),
        asset.name,
      );
    }
  }
  if (asset.locationId != null) {
    final location = locations[asset.locationId];
    if (location != null) {
      return DisplayPath.join(location.path, asset.name);
    }
  }
  return asset.name;
}

final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService(
    locations: ref.watch(locationRepositoryProvider),
    containers: ref.watch(containerRepositoryProvider),
    assets: ref.watch(assetRepositoryProvider),
  );
});

final FutureProviderFamily<List<SearchHit>, String> searchHitsProvider =
    FutureProvider.family<List<SearchHit>, String>((ref, query) async {
  return ref.watch(searchServiceProvider).query(query);
});

typedef ModuleSearchQuery = ({String? moduleId, String query});

final moduleSearchHitsProvider =
    FutureProvider.family<List<SearchHit>, ModuleSearchQuery>((ref, args) async {
  final trimmed = args.query.trim();
  if (trimmed.isEmpty) {
    return const [];
  }
  final service = ref.watch(searchServiceProvider);
  final moduleId = args.moduleId;
  if (moduleId == null) {
    return service.query(trimmed);
  }
  final pack =
      ref.watch(domainPackRegistryProvider).valueOrNull?.packForModule(moduleId);
  if (pack == null) {
    return service.query(trimmed);
  }
  final assets = ref.watch(assetsListProvider).valueOrNull;
  return service.queryForModule(
    trimmed,
    pack: pack,
    activeModuleId: ref.watch(activeModuleIdProvider),
    assetsCache: assets,
  );
});
