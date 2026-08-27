# Compass Monetization & Entitlements

## Philosophy

Compass should be a genuinely useful free application.

We do **not** use artificial limitations, excessive nagging, or subscription-only access to basic functionality.

> Free = complete local product.
>
> Pro = power tools and advanced functionality.
>
> Subscription = ongoing cloud infrastructure and services.

Users should be able to maintain their entire collection locally and offline without paying. A user should never feel that their data is being held hostage by a subscription.

Implementation notes for mobile: [apps/mobile/docs/entitlements.md](../apps/mobile/docs/entitlements.md).

---

## Product tiers

### Compass Free

$0 forever. Complete local-first inventory.

Include:

- Unlimited local assets, containers, locations
- NFC, search, filtering, basic history
- Offline operation
- CSV import / CSV export
- Individual metadata refresh / individual price refresh
- Local backup / export
- Basic themes (Dark, Light, Gray)

Do **not** implement collection-size caps, search quotas, NFC tag limits, or similar artificial restrictions.

### Compass Pro

Target: approximately **$9.99–$14.99** one-time lifetime purchase.

Unlocks advanced **software** that does not inherently require ongoing server infrastructure.

Examples: advanced themes, custom accent, advanced search / saved searches, bulk operations, bulk metadata / price refresh, advanced dashboards / stats, custom asset schemas, advanced import mapping, duplicate resolution, reporting.

Lifetime = lifetime access to the Pro software features purchased. It does **not** promise unlimited future cloud infrastructure.

### Compass Sync

Target: approximately **$2.99/month**.

Ongoing cloud infrastructure: backup, account storage, automatic / cross-device sync, conflict resolution, cloud history where supported.

The user pays for a continuing service, not a software switch.

### Compass Sync Plus

Potential future tier (~$4.99/month): everything in Sync plus multi-device extras, advanced cloud history, larger storage, shared / family collections, collaboration.

**Do not implement Sync Plus** until there is a real need. Prefer a single clear Sync price over per-device microcharges.

---

## Entitlement architecture

Do **not** hardcode product or subscription checks in feature UI.

```text
PurchaseService / store adapter
        ↓
EntitlementService
        ↓
canUse(Feature)
```

Features query entitlements, not product names or prices:

```dart
entitlements.canUse(CompassFeature.bulkRefresh)
```

not:

```dart
if (subscription == "pro") { ... }
```

### Features (entitlements)

| Feature | Typical grant |
|---------|----------------|
| `advancedThemes` | Pro |
| `customAccent` | Pro |
| `bulkRefresh` | Pro |
| `advancedSearch` | Pro (reserved) |
| `savedSearches` | Pro (reserved) |
| `bulkOperations` | Pro (reserved) |
| `customSchemas` | Pro (reserved) |
| `cloudBackup` | Sync |
| `cloudSync` | Sync |
| `multiDevice` | Sync Plus (reserved) |
| `sharedCollections` | Sync Plus (reserved) |
| `advancedCloudHistory` | Sync Plus (reserved) |

Free local inventory, NFC, CSV import, per-item refresh, and basic themes need **no** entitlement check.

### Product vs entitlement

A **product** is what the user purchases. An **entitlement** (`CompassFeature`) is what they receive. Multiple products may grant the same feature. Product→feature mapping lives in one place so pricing can change without rewriting gates.

### Product identifiers

Stores own localized prices. App uses IDs only:

```text
compass_pro_lifetime
compass_sync_monthly
compass_sync_yearly
compass_sync_plus_monthly
compass_sync_plus_yearly
```

**Cutover:** current offering sells `compass_pro_lifetime` (Pro) and `compass_sync_monthly` / `compass_sync_yearly` (Sync). Legacy entitlement `compass` + product `compass_monthly` stay mapped to **Pro** for existing TestFlight subscribers; that SKU is not in the current offering. Dashboard steps: [apps/mobile/docs/entitlements.md](../apps/mobile/docs/entitlements.md). Catalog fields (prints, colors, costs, pricing) can still change after cutover — only product IDs and IAP types are sticky.

---

## Individual vs bulk

| Free | Pro |
|------|-----|
| Refresh this card / item | Refresh all |
| Match one printing | Bulk rematch / normalize |
| Import a file | Advanced import mapping |
| Search | Saved searches / advanced facets |

Free users can accomplish the task manually; Pro automates at scale. Prefer this over hiding underlying information.

---

## Themes

Free: Dark, Light, Gray (brand steel accent).

Pro: ambience skins, custom accent, further customization.

Themes are **software** (Pro), not cloud services (Sync).

---

## Data ownership

Export remains free. Subscription cancellation must not be destructive.

If Sync expires: local inventory, NFC, search, import/export keep working; only cloud sync becomes unavailable. Explain grace / cloud retention clearly when Sync ships. Never lock users out of their own inventory.

---

## Paywall UX

Contextual, informative sheets only (never launch interstitials). No fake urgency, dark patterns, or guilt copy.

Distinguish in purchase UI:

- **Compass Pro** — one-time: “Unlock advanced Compass features permanently.”
- **Compass Sync** — subscription: “Keep your collection synchronized and backed up across devices.”

---

## Entitlement persistence

Cache grants locally so offline Pro software still works. Cloud subscriptions may need periodic online verification. Never require a live network check for basic local functionality.

---

## Store integration

Abstract billing behind a purchase / entitlement adapter (RevenueCat today; StoreKit / Play later). Do not scatter store SDK calls through feature widgets.

---

## Analytics (later)

Useful: `pro_feature_viewed`, `paywall_viewed`, `purchase_*`, `subscription_*`, `sync_enabled` / `sync_disabled`.

Do **not** send private inventory contents to analytics.

---

## Recommended initial model

1. **Free** — complete local app  
2. **Pro** — lifetime advanced local features  
3. **Sync** — ~$2.99/mo cloud  

Defer Sync Plus. Feature entitlement layer is in place; store products are `compass_pro_lifetime` and `compass_sync_monthly` / yearly.

---

## Core product line

> You can use Compass for free. Your collection is yours. Pay once if you want advanced tools, or subscribe if you want us to provide cloud infrastructure.
