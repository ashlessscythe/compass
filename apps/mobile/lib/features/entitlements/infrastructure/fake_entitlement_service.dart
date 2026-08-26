import 'dart:async';

import 'package:compass/features/entitlements/domain/compass_feature.dart';
import 'package:compass/features/entitlements/domain/entitlement_service.dart';
import 'package:compass/features/entitlements/domain/product_catalog.dart';

/// In-memory entitlements for tests and local development without StoreKit.
class FakeEntitlementService implements EntitlementService {
  FakeEntitlementService({EntitlementTier initialTier = EntitlementTier.free})
    : _tier = initialTier,
      _features = ProductFeatureMap.featuresForTier(initialTier);

  EntitlementTier _tier;
  Set<CompassFeature> _features;
  final _controller = StreamController<Set<CompassFeature>>.broadcast();

  EntitlementTier get tier => _tier;

  void setTier(EntitlementTier tier) {
    if (_tier == tier) {
      return;
    }
    _tier = tier;
    _features = ProductFeatureMap.featuresForTier(tier);
    _controller.add(Set<CompassFeature>.of(_features));
  }

  @override
  bool canUse(CompassFeature feature) => _features.contains(feature);

  @override
  Set<CompassFeature> get activeFeatures => Set<CompassFeature>.of(_features);

  @override
  Stream<Set<CompassFeature>> get featureChanges => _controller.stream;

  @override
  Future<EntitlementActionResult> purchaseProduct(String productId) async {
    final tier = ProductFeatureMap.tierForPurchase(productId);
    if (tier == null) {
      return EntitlementActionResult.unavailable;
    }
    setTier(tier);
    return EntitlementActionResult.success;
  }

  @override
  Future<String?> priceLabel(String productId) async => null;

  @override
  Future<EntitlementActionResult> restore() async {
    if (_tier == EntitlementTier.free) {
      return EntitlementActionResult.unavailable;
    }
    return EntitlementActionResult.success;
  }

  void dispose() {
    unawaited(_controller.close());
  }
}
