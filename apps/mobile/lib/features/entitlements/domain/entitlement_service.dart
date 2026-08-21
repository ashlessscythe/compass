/// Subscription entitlement for Compass (themes + bulk refetch).
abstract interface class EntitlementService {
  /// Whether the `compass` entitlement is active.
  bool get isSubscribed;

  Stream<bool> get subscriptionChanges;

  /// Starts purchase flow for the monthly subscription.
  Future<EntitlementActionResult> purchase();

  /// Restores prior purchases.
  Future<EntitlementActionResult> restore();
}

enum EntitlementActionResult {
  success,
  cancelled,
  unavailable,
  failed,
}

/// Product / entitlement identifiers (RevenueCat / App Store).
abstract final class EntitlementIds {
  static const entitlement = 'compass';
  static const monthlyProduct = 'compass_monthly';
}
