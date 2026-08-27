import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';

/// Metadata key tagging which domain a generic Item belongs to.
const kCompassModuleIdMetadataKey = 'compass.moduleId';

/// Whether [asset] belongs to [pack]'s collection for display/export.
///
/// Typed assets match [DomainPack.assetTypes]. Legacy generic Items
/// (`asset-type-item`) match when tagged with [kCompassModuleIdMetadataKey]
/// or, if untagged, only when [activeModuleId] equals [pack.moduleId].
bool assetBelongsToModule(
  Asset asset,
  DomainPack pack, {
  String? activeModuleId,
}) {
  if (pack.assetTypes.any((type) => type.id == asset.assetTypeId)) {
    return true;
  }
  if (asset.assetTypeId != AppConstants.defaultAssetTypeId) {
    return false;
  }
  final tagged = asset.metadata.values[kCompassModuleIdMetadataKey];
  if (tagged is String && tagged.isNotEmpty) {
    return tagged == pack.moduleId;
  }
  return activeModuleId == pack.moduleId;
}

List<Asset> filterAssetsForModule(
  Iterable<Asset> assets,
  DomainPack? pack, {
  String? activeModuleId,
}) {
  if (pack == null) {
    return assets.toList(growable: false);
  }
  return assets
      .where(
        (asset) => assetBelongsToModule(
          asset,
          pack,
          activeModuleId: activeModuleId,
        ),
      )
      .toList(growable: false);
}

Set<String> assetTypeIdsForPack(DomainPack pack) {
  return pack.assetTypes.map((type) => type.id).toSet();
}

/// Resolves which domain pack owns [asset] for display, catalog, and forms.
DomainPack? owningPackForAsset(
  Asset asset,
  Iterable<DomainPack> installedPacks, {
  String? activeModuleId,
}) {
  for (final pack in installedPacks) {
    if (pack.assetTypes.any((type) => type.id == asset.assetTypeId)) {
      return pack;
    }
  }
  if (asset.assetTypeId != AppConstants.defaultAssetTypeId) {
    return null;
  }
  final tagged = asset.metadata.values[kCompassModuleIdMetadataKey];
  if (tagged is String && tagged.isNotEmpty) {
    for (final pack in installedPacks) {
      if (pack.moduleId == tagged) {
        return pack;
      }
    }
    return null;
  }
  if (activeModuleId != null) {
    for (final pack in installedPacks) {
      if (pack.moduleId == activeModuleId) {
        return pack;
      }
    }
  }
  return null;
}

/// Asset type id plus ancestor ids in [pack] (for attribute applicability).
Set<String> typeIdsForAssetInPack(DomainPack pack, String assetTypeId) {
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

List<DomainPackAttributeDefinition> applicableAttributeDefinitions(
  DomainPack pack,
  String assetTypeId,
) {
  final typeIds = typeIdsForAssetInPack(pack, assetTypeId);
  return pack.attributeDefinitions
      .where(
        (def) =>
            def.assetTypeId == null || typeIds.contains(def.assetTypeId),
      )
      .toList(growable: false);
}
