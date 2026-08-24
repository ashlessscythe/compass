import 'package:compass/features/entitlements/domain/compass_feature.dart';
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

/// Live set of granted features for UI gates.
final activeFeaturesProvider =
    NotifierProvider<ActiveFeaturesController, Set<CompassFeature>>(
  ActiveFeaturesController.new,
);

class ActiveFeaturesController extends Notifier<Set<CompassFeature>> {
  @override
  Set<CompassFeature> build() {
    final service = ref.watch(entitlementServiceProvider);
    final sub = service.featureChanges.listen((value) {
      state = value;
    });
    ref.onDispose(sub.cancel);
    return service.activeFeatures;
  }
}

/// Whether the given feature is currently granted.
final ProviderFamily<bool, CompassFeature> canUseFeatureProvider =
    Provider.family<bool, CompassFeature>((ref, feature) {
  return ref.watch(activeFeaturesProvider).contains(feature);
});
