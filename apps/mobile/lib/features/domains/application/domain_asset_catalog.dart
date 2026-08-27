import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether [asset] belongs to a domain pack with a catalog provider.
bool assetHasCatalogProvider(Asset asset, DomainPack pack) {
  if (pack.providers.catalog == null) {
    return false;
  }
  if (pack.assetTypes.any((type) => type.id == asset.assetTypeId)) {
    return true;
  }
  return _looksLikeMtgAsset(asset, pack);
}

bool _looksLikeMtgAsset(Asset asset, DomainPack pack) {
  if (pack.moduleId != 'mtg') {
    return false;
  }
  final values = asset.metadata.values;
  return MtgMetadataKeys.scryfallIdOf(values) != null ||
      MtgMetadataKeys.stringOf(values, MtgMetadataKeys.setCode) != null ||
      MtgMetadataKeys.stringOf(values, MtgMetadataKeys.collectorNumber) != null;
}

final assetCatalogPackProvider = Provider.family<DomainPack?, Asset>((ref, asset) {
  final registry = ref.watch(domainPackRegistryProvider).valueOrNull;
  if (registry == null) {
    return null;
  }
  for (final pack in registry.installedPacks) {
    if (assetHasCatalogProvider(asset, pack)) {
      return pack;
    }
  }
  return null;
});

/// Catalog match key order from the asset's domain pack (Scryfall default).
List<String> catalogMatchKeysFor(DomainPack? pack) {
  return pack?.providers.catalog?.matchKeys ??
      const ['scryfall.card_id', 'set+collectorNumber', 'name'];
}
