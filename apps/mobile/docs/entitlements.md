# Entitlements

Compass gates **features**, not product names. Philosophy and tier copy: [docs/monetization.md](../../../docs/monetization.md).

## Shape

```text
Store adapter (RevenueCat today / Fake in CI)
        ↓
EntitlementService
        ↓
canUse(CompassFeature)
```

- Features: `advancedThemes`, `customAccent`, `bulkRefresh`, plus reserved Sync / Pro ids in [`compass_feature.dart`](../../lib/features/entitlements/domain/compass_feature.dart)
- Product IDs and product→feature map: [`product_catalog.dart`](../../lib/features/entitlements/domain/product_catalog.dart)
- UI must call `canUse` / `canUseFeatureProvider` — never `if (plan == pro)`

## Local / CI (no key)

Without `REVENUECAT_API_KEY`, the app uses [`FakeEntitlementService`](../../lib/features/entitlements/infrastructure/fake_entitlement_service.dart).

Debug builds show a **Debug tier** control on Settings → Themes: Free | Pro | Sync | Sync+. Use it to exercise gates without StoreKit.

## App Store / RevenueCat (transitional)

1. Legacy product `compass_monthly` and entitlement `compass` remain in RevenueCat + App Store Connect for TestFlight.
2. Active `compass` grants the **Pro** feature set (themes, accent, bulk refetch) via the product map — not Sync.
3. StoreKit config: [ios/Runner/StoreKit/CompassThemes.storekit](../../ios/Runner/StoreKit/CompassThemes.storekit) in the Xcode scheme for simulator purchases.
4. Run with:

```bash
flutter run --dart-define=REVENUECAT_API_KEY=appl_xxx
```

**Not yet:** `compass_pro_lifetime`, `compass_sync_monthly` / yearly offerings. Purchase / Restore still hit the transitional monthly SKU while unlock copy describes Compass Pro.

## Free forever (no check)

Full location graph, NFC, CSV import, search, Dark / Light / Gray, per-card Match / Rematch.

## Pro (gated)

Ambience themes, custom accent, container **Refetch all**.

## Sync (reserved)

`cloudBackup` / `cloudSync` exist on the feature enum and debug Sync tier; no cloud UI yet.
