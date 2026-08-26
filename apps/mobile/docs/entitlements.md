# Entitlements

Compass gates **features**, not product names. Philosophy and tier copy: [docs/monetization.md](../../../docs/monetization.md).

## Shape

```text
Store adapter (RevenueCat today / Fake in CI)
        ↓
EntitlementService.purchaseProduct(productId)
        ↓
canUse(CompassFeature)
```

- Features: `advancedThemes`, `customAccent`, `bulkRefresh`, plus reserved Sync / Pro ids in [`compass_feature.dart`](../../lib/features/entitlements/domain/compass_feature.dart)
- Product IDs and product→feature map: [`product_catalog.dart`](../../lib/features/entitlements/domain/product_catalog.dart)
- UI must call `canUse` / `canUseFeatureProvider` — never `if (plan == pro)`

## Local / CI (no key)

Without `REVENUECAT_API_KEY`, the app uses [`FakeEntitlementService`](../../lib/features/entitlements/infrastructure/fake_entitlement_service.dart).

The public Apple SDK key (`appl_…`) is a Flutter **compile-time** define. It is **not** read from `apps/web/.env.local` (Next.js only).

```bash
flutter run -d "iPhone 17 Pro" \
  --dart-define=REVENUECAT_API_KEY=appl_xxx
```

TestFlight / IPA: pass the same `appl_` define to `flutter build ipa` / [`tool/build_ipa.sh`](../../tool/build_ipa.sh). Do not commit the key or bake it into xcconfigs.

A RevenueCat **secret** REST key (`sk_…`) may live in `apps/web/.env.local` / Vercel for later server checks. Unused in v0. Never dart-define it; never `NEXT_PUBLIC_`.

Debug builds show a **Debug tier** control on Settings → Themes: Free | Pro | Sync | Sync+. Use it to exercise gates without StoreKit. Fake purchase CTAs set an exclusive tier (Pro **or** Sync, not both). Live RevenueCat can grant both.

## App Store Connect + RevenueCat (ops)

Products exist in App Store Connect (`app.compass.mobile`). Leave them **Ready to Submit** until the binary that buys these IDs goes to App Store review. Sandbox / TestFlight work without IAP approval if metadata is complete.

**App Store Connect**

1. Non-consumable `compass_pro_lifetime` (Compass Pro — unlock advanced features permanently). Target display **$12.99** (editable later).
2. Auto-renewable `compass_sync_monthly` and `compass_sync_yearly` in subscription group **`compass_sync`** (not the legacy Themes `compass_group`). Targets **$2.99/mo** and **$29.99/yr**.
3. Leave `compass_monthly` in ASC so existing TestFlight subscribers keep renewing. Do not delete it. Do not put it in the current RevenueCat offering.
4. Submit IAP metadata with the next public app binary (screenshot of the in-app purchase path). Paid Apps agreement, banking/tax, and an app privacy policy URL are required for subscriptions.

**RevenueCat**

1. Entitlements: keep `compass`; add `pro` (attach `compass_pro_lifetime`) and `sync` (attach both Sync products).
2. Current offering: **Pro lifetime + Sync monthly + Sync yearly only**. Remove `compass_monthly` from the current offering (stop selling). Keep `compass_monthly` attached to entitlement `compass` so restorers still get Pro.
3. Do not create Sync Plus products.

**Grandfathering:** testers still subscribed to `compass_monthly` keep Pro via entitlement `compass`. Apple cannot convert that subscription into a lifetime non-consumable. They can cancel and buy Pro separately.

Play Console products are not part of this cutover. Same product IDs apply later.

## App Store / RevenueCat (app)

1. Purchase / restore buy by product id: Themes and bulk refetch → `compass_pro_lifetime`; Settings → Sync → monthly / yearly.
2. CustomerInfo grants are the union of active entitlement keys, active subscription product IDs, and non-subscription product IDs. `pro` / `compass` / `compass_pro_lifetime` / `compass_monthly` → Pro. `sync` / `compass_sync_monthly` / `compass_sync_yearly` → Sync.
3. StoreKit config: [ios/Runner/StoreKit/CompassThemes.storekit](../../ios/Runner/StoreKit/CompassThemes.storekit) attached to the Runner scheme for simulator purchases (includes lifetime + Sync; legacy monthly remains for restore simulation only).
4. Server-side RevenueCat checks stay Later ([sync-protocol.md](../../../docs/sync-protocol.md)). `COMPASS_SYNC_DEV_SECRET` remains for TestFlight until a public release.

Catalog work (alternate prints, colors, costs, pricing providers) is unrestricted after cutover. Product **IDs** and lifetime vs subscription types are the hard part.

## Free forever (no check)

Full location graph, NFC, CSV import, search, Dark / Light / Gray, per-card Match / Rematch.

## Pro (gated)

Ambience themes, custom accent, container **Refetch all**. Purchase: `compass_pro_lifetime`.

## Sync (gated)

`cloudBackup` / `cloudSync` — Settings → Sync (subscribe monthly/yearly, sign-in, sync now). Protocol: [docs/sync-protocol.md](../../../docs/sync-protocol.md).
