import 'dart:async';

import 'package:compass/features/entitlements/domain/compass_feature.dart';
import 'package:compass/features/entitlements/domain/entitlement_service.dart';
import 'package:compass/features/entitlements/domain/product_catalog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat-backed entitlements.
///
/// Current offering sells [ProductIds.proLifetime] and Sync monthly / yearly.
/// Legacy entitlement [ProductIds.legacyCompassEntitlement] still grants Pro
/// for existing `compass_monthly` subscribers.
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
    final activeIds = <String>{
      ...info.entitlements.active.keys,
      ...info.activeSubscriptions,
    };
    for (final txn in info.nonSubscriptionTransactions) {
      activeIds.add(txn.productIdentifier);
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

  /// Package whose store product id matches [productId].
  ///
  /// Prefers the current offering, then searches every offering.
  @visibleForTesting
  static Package? packageForProduct(Offerings offerings, String productId) {
    Package? inOffering(Offering? offering) {
      if (offering == null) {
        return null;
      }
      for (final package in offering.availablePackages) {
        if (package.storeProduct.identifier == productId) {
          return package;
        }
      }
      return null;
    }

    final fromCurrent = inOffering(offerings.current);
    if (fromCurrent != null) {
      return fromCurrent;
    }
    for (final offering in offerings.all.values) {
      final match = inOffering(offering);
      if (match != null) {
        return match;
      }
    }
    return null;
  }

  @override
  bool canUse(CompassFeature feature) => _features.contains(feature);

  @override
  Set<CompassFeature> get activeFeatures => Set<CompassFeature>.of(_features);

  @override
  Stream<Set<CompassFeature>> get featureChanges => _controller.stream;

  @override
  Future<String?> priceLabel(String productId) async {
    if (!_ready) {
      return null;
    }
    try {
      final offerings = await Purchases.getOfferings();
      return packageForProduct(offerings, productId)?.storeProduct.priceString;
    } on Object {
      return null;
    }
  }

  @override
  Future<EntitlementActionResult> purchaseProduct(String productId) async {
    if (!_ready) {
      return EntitlementActionResult.unavailable;
    }
    try {
      final offerings = await Purchases.getOfferings();
      final package = packageForProduct(offerings, productId);
      if (package == null) {
        return EntitlementActionResult.unavailable;
      }
      final result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      _apply(result.customerInfo);
      final expected = ProductFeatureMap.featuresForProduct(productId);
      if (expected.isEmpty) {
        return EntitlementActionResult.failed;
      }
      return expected.every(canUse)
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
