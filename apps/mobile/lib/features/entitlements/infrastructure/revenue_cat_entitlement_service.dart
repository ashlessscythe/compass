import 'dart:async';

import 'package:compass/features/entitlements/domain/entitlement_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat-backed entitlements. Safe no-op when API key is missing.
class RevenueCatEntitlementService implements EntitlementService {
  RevenueCatEntitlementService({required this.apiKey});

  final String apiKey;

  bool _ready = false;
  bool _subscribed = false;
  final _controller = StreamController<bool>.broadcast();

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
    final active =
        info.entitlements.active.containsKey(EntitlementIds.entitlement);
    if (_subscribed == active) {
      return;
    }
    _subscribed = active;
    _controller.add(active);
  }

  @override
  bool get isSubscribed => _subscribed;

  @override
  Stream<bool> get subscriptionChanges => _controller.stream;

  @override
  Future<EntitlementActionResult> purchase() async {
    if (!_ready) {
      return EntitlementActionResult.unavailable;
    }
    try {
      final offerings = await Purchases.getOfferings();
      final packages = offerings.current?.availablePackages ?? const <Package>[];
      final package = offerings.current?.monthly ??
          (packages.isEmpty ? null : packages.first);
      if (package == null) {
        return EntitlementActionResult.unavailable;
      }
      final result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      _apply(result.customerInfo);
      return _subscribed
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
      return _subscribed
          ? EntitlementActionResult.success
          : EntitlementActionResult.unavailable;
    } on Object {
      return EntitlementActionResult.failed;
    }
  }
}
