import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/features/domains/application/module_scope.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Catalog pack for [asset], or null when the owning pack has no catalog provider.
DomainPack? catalogPackForAsset(
  Asset asset,
  Iterable<DomainPack> installedPacks, {
  String? activeModuleId,
}) {
  final owning = owningPackForAsset(
    asset,
    installedPacks,
    activeModuleId: activeModuleId,
  );
  if (owning?.providers.catalog == null) {
    return null;
  }
  return owning;
}

final assetCatalogPackProvider = Provider.family<DomainPack?, Asset>((ref, asset) {
  final registry = ref.watch(domainPackRegistryProvider).valueOrNull;
  if (registry == null) {
    return null;
  }
  return catalogPackForAsset(
    asset,
    registry.installedPacks,
    activeModuleId: ref.watch(activeModuleIdProvider),
  );
});

/// Catalog match key order from the asset's domain pack (Scryfall default).
List<String> catalogMatchKeysFor(DomainPack? pack) {
  return pack?.providers.catalog?.matchKeys ??
      const ['scryfall.card_id', 'set+collectorNumber', 'name'];
}
