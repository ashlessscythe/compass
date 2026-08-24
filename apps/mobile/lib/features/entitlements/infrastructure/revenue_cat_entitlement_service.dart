import 'dart:async';

import 'package:compass/features/entitlements/domain/compass_feature.dart';
import 'package:compass/features/entitlements/domain/entitlement_service.dart';
import 'package:compass/features/entitlements/domain/product_catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat-backed entitlements.
///
/// Active legacy entitlement [ProductIds.legacyCompassEntitlement] grants the
/// **Pro** feature set until Pro lifetime / Sync products ship.
class RevenueCatEntitlementService implements EntitlementService {
  RevenueCatEntitlementService({required this.apiKey});

  final String apiKey;

  bool _ready = false;
  Set<CompassFeature> _features = const {};
  final _controller = StreamController<Set<CompassFeature>>.broadcast();

  Future<void> initialize() async {
    if (apiKey.isEmpty) {
      debugPrint('RevenueCat: no API key; entitlements stay locked.');
      return;
    }
    try {
      await Purchases.configure(PurchasesConfiguration(apiKey));
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfo);
      final info = await Purchases.getCustomerInfo();
      _apply(info);
      _ready = true;
    } on Object catch (error, stack) {
      debugPrint('RevenueCat init failed: $error\n$stack');
    }
  }

  void _onCustomerInfo(CustomerInfo info) => _apply(info);

  void _apply(CustomerInfo info) {
    final activeIds = <String>{};
    for (final key in info.entitlements.active.keys) {
      activeIds.add(key);
    }
    final next = ProductFeatureMap.featuresForProducts(activeIds);
    if (_sameFeatures(_features, next)) {
      return;
    }
    _features = next;
    _controller.add(Set<CompassFeature>.of(_features));
  }

  static bool _sameFeatures(Set<CompassFeature> a, Set<CompassFeature> b) {
    if (a.length != b.length) {
      return false;
    }
    return a.containsAll(b);
  }

  @override
  bool canUse(CompassFeature feature) => _features.contains(feature);

  @override
  Set<CompassFeature> get activeFeatures => Set<CompassFeature>.of(_features);

  @override
  Stream<Set<CompassFeature>> get featureChanges => _controller.stream;

  @override
  Future<EntitlementActionResult> purchase() async {
    if (!_ready) {
      return EntitlementActionResult.unavailable;
    }
    try {
      final offerings = await Purchases.getOfferings();
      final packages =
          offerings.current?.availablePackages ?? const <Package>[];
      final package = offerings.current?.monthly ??
          (packages.isEmpty ? null : packages.first);
      if (package == null) {
        return EntitlementActionResult.unavailable;
      }
      final result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      _apply(result.customerInfo);
      return canUse(CompassFeature.advancedThemes)
          ? EntitlementActionResult.success
          : EntitlementActionResult.failed;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        return EntitlementActionResult.cancelled;
      }
      return EntitlementActionResult.failed;
    } on Object {
      return EntitlementActionResult.failed;
    }
  }

  @override
  Future<EntitlementActionResult> restore() async {
    if (!_ready) {
      return EntitlementActionResult.unavailable;
    }
    try {
      final info = await Purchases.restorePurchases();
      _apply(info);
      return _features.isNotEmpty
          ? EntitlementActionResult.success
          : EntitlementActionResult.unavailable;
    } on Object {
      return EntitlementActionResult.failed;
    }
  }
}
