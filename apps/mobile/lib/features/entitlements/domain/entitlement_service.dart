import 'package:compass/features/entitlements/domain/compass_feature.dart';

/// Resolves which [CompassFeature]s the user may use.
///
/// Feature UI must call [canUse] — never product or plan names.
abstract interface class EntitlementService {
  bool canUse(CompassFeature feature);

  Set<CompassFeature> get activeFeatures;

  Stream<Set<CompassFeature>> get featureChanges;

  /// Starts purchase for a store [productId] (not a feature or plan name).
  Future<EntitlementActionResult> purchaseProduct(String productId);

  /// Localized store price for [productId], or null if unknown / unavailable.
  Future<String?> priceLabel(String productId);

  /// Restores prior purchases.
  Future<EntitlementActionResult> restore();
}

enum EntitlementActionResult {
  success,
  cancelled,
  unavailable,
  failed,
}
