import 'dart:async';

import 'package:compass/features/entitlements/domain/entitlement_service.dart';

/// In-memory entitlement for tests and local development without StoreKit.
class FakeEntitlementService implements EntitlementService {
  FakeEntitlementService({bool initiallySubscribed = false})
      : _subscribed = initiallySubscribed;

  bool _subscribed;
  final _controller = StreamController<bool>.broadcast();

  @override
  bool get isSubscribed => _subscribed;

  @override
  Stream<bool> get subscriptionChanges => _controller.stream;

  void setSubscribed({required bool value}) {
    if (_subscribed == value) {
      return;
    }
    _subscribed = value;
    _controller.add(value);
  }

  @override
  Future<EntitlementActionResult> purchase() async {
    setSubscribed(value: true);
    return EntitlementActionResult.success;
  }

  @override
  Future<EntitlementActionResult> restore() async {
    // Fake restore keeps current state; tests toggle via [setSubscribed].
    return _subscribed
        ? EntitlementActionResult.success
        : EntitlementActionResult.unavailable;
  }

  void dispose() {
    unawaited(_controller.close());
  }
}
