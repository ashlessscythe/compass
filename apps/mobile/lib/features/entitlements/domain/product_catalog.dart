import 'package:compass/features/entitlements/domain/compass_feature.dart';

/// Store / RevenueCat product and entitlement identifiers.
///
/// Localized prices live in App Store / Play. Do not hardcode dollar amounts
/// in feature logic.
abstract final class ProductIds {
  static const proLifetime = 'compass_pro_lifetime';
  static const syncMonthly = 'compass_sync_monthly';
  static const syncYearly = 'compass_sync_yearly';
  static const syncPlusMonthly = 'compass_sync_plus_monthly';
  static const syncPlusYearly = 'compass_sync_plus_yearly';

  /// Transitional RevenueCat entitlement (Themes v1 monthly).
  static const legacyCompassEntitlement = 'compass';

  /// Transitional App Store / RevenueCat product.
  static const legacyMonthlyProduct = 'compass_monthly';
}

/// Debug / mock purchase tiers (no store required).
enum EntitlementTier {
  free,
  pro,
  sync,
  syncPlus,
}

/// Central product → feature map so pricing can change without rewriting UI.
abstract final class ProductFeatureMap {
  static const Set<CompassFeature> proFeatures = {
    CompassFeature.advancedThemes,
    CompassFeature.customAccent,
    CompassFeature.bulkRefresh,
    CompassFeature.advancedSearch,
    CompassFeature.savedSearches,
    CompassFeature.bulkOperations,
    CompassFeature.customSchemas,
  };

  static const Set<CompassFeature> syncFeatures = {
    CompassFeature.cloudBackup,
    CompassFeature.cloudSync,
  };

  static const Set<CompassFeature> syncPlusExtras = {
    CompassFeature.multiDevice,
    CompassFeature.sharedCollections,
    CompassFeature.advancedCloudHistory,
  };

  /// Features granted by a store product or entitlement id.
  static Set<CompassFeature> featuresForProduct(String productOrEntitlementId) {
    return switch (productOrEntitlementId) {
      ProductIds.proLifetime ||
      ProductIds.legacyCompassEntitlement ||
      ProductIds.legacyMonthlyProduct =>
        Set<CompassFeature>.of(proFeatures),
      ProductIds.syncMonthly || ProductIds.syncYearly =>
        Set<CompassFeature>.of(syncFeatures),
      ProductIds.syncPlusMonthly || ProductIds.syncPlusYearly => {
          ...syncFeatures,
          ...syncPlusExtras,
        },
      _ => const <CompassFeature>{},
    };
  }

  /// Features for the local debug tier picker.
  static Set<CompassFeature> featuresForTier(EntitlementTier tier) {
    return switch (tier) {
      EntitlementTier.free => const <CompassFeature>{},
      EntitlementTier.pro => Set<CompassFeature>.of(proFeatures),
      EntitlementTier.sync => Set<CompassFeature>.of(syncFeatures),
      EntitlementTier.syncPlus => {
          ...syncFeatures,
          ...syncPlusExtras,
        },
    };
  }

  /// Union of features for every active product / entitlement id.
  static Set<CompassFeature> featuresForProducts(
    Iterable<String> productOrEntitlementIds,
  ) {
    final out = <CompassFeature>{};
    for (final id in productOrEntitlementIds) {
      out.addAll(featuresForProduct(id));
    }
    return out;
  }
}
