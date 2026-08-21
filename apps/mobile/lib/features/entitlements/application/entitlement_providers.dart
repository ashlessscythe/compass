import 'dart:async';

import 'package:compass/features/entitlements/domain/entitlement_service.dart';
import 'package:compass/features/entitlements/infrastructure/fake_entitlement_service.dart';
import 'package:compass/features/entitlements/infrastructure/revenue_cat_entitlement_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Compile-time key: `--dart-define=REVENUECAT_API_KEY=...`
const revenueCatApiKey = String.fromEnvironment('REVENUECAT_API_KEY');

final entitlementServiceProvider = Provider<EntitlementService>((ref) {
  if (revenueCatApiKey.isEmpty) {
    final fake = FakeEntitlementService();
    ref.onDispose(fake.dispose);
    return fake;
  }
  final service = RevenueCatEntitlementService(apiKey: revenueCatApiKey)
    ..initialize();
  return service;
});

/// Live subscription flag for UI gates.
final isSubscribedProvider =
    NotifierProvider<IsSubscribedController, bool>(IsSubscribedController.new);

class IsSubscribedController extends Notifier<bool> {
  @override
  bool build() {
    final service = ref.watch(entitlementServiceProvider);
    final sub = service.subscriptionChanges.listen((value) {
      state = value;
    });
    ref.onDispose(sub.cancel);
    return service.isSubscribed;
  }
}

/// Alias for older call sites.
final isSubscribedSyncProvider = isSubscribedProvider;
