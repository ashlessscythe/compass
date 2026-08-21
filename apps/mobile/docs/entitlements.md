# Entitlements (RevenueCat)

Compass uses a thin [EntitlementService](../../lib/features/entitlements/domain/entitlement_service.dart) so StoreKit-only can replace RevenueCat later.

## Local / CI (no key)

Without `REVENUECAT_API_KEY`, the app uses [FakeEntitlementService](../../lib/features/entitlements/infrastructure/fake_entitlement_service.dart). Debug builds show a **Debug: subscribed** toggle on Settings → Themes.

## App Store / RevenueCat

1. Create product `compass_monthly` (~$2/mo) and entitlement `compass` in RevenueCat + App Store Connect.
2. Attach StoreKit config: [ios/Runner/StoreKit/CompassThemes.storekit](../../ios/Runner/StoreKit/CompassThemes.storekit) in the Xcode scheme for simulator purchases.
3. Run with:

```bash
flutter run --dart-define=REVENUECAT_API_KEY=appl_xxx
```

Unlock covers ambience themes, custom accent, and container Refetch all. Dark / Light / Gray and per-card Match stay free.
