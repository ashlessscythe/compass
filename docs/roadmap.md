# Roadmap

## Now — Foundation

- [x] Monorepo scaffolding
- [x] Marketing website (`apps/web`)
- [x] Shared packages (`api`, `branding`, `ui`)
- [x] Waitlist capture endpoint
- [x] Documentation (vision, architecture, branding)
- [x] Flutter mobile scaffold initialization
- [x] Persist waitlist to a durable store
- [x] Generic domain schema foundation (see [taxonomy.md](./taxonomy.md))

The Flutter client (`apps/mobile`) ships Clean Architecture layers, domain entities, Riverpod, GoRouter, and an on-device Drift location graph (places, containers, assets) with name search.

iOS UI craft for the location graph is through UX-6 (stills). Store products are Pro lifetime + Sync monthly/yearly (legacy `compass_monthly` still grants Pro). Offline catalog art hardened. Feature entitlements (Free / Pro / Sync) are in place. Offline-first sync protocol (v0) ships structured Postgres replica + client outbox. Sequence and exit criteria: [mobile-ux.md](./mobile-ux.md). Monetization model: [monetization.md](./monetization.md). Sync protocol: [sync-protocol.md](./sync-protocol.md).

## Next — MTG MVP

- [x] Local asset + location data model (on-device SQLite; see architecture)
- [x] Nested containers (location = place, container = vessel)
- [x] Search: item → location path
- [x] iOS UX pass (first run → confirm delete → move → chrome → sheets → stills)
- [x] NFC tag association for containers (chip UID; Home → Scan NFC)
- [x] Import from CSV (Deckbox / Moxfield / generic headers → container; Settings → Import CSV)
- [x] Import adapters for Deckbox and Moxfield (header dialects on the shared CSV surface)
- [x] Scryfall catalog for MTG images/stats (CardMetadataProvider; local SQLite + bulk; thumbs / full art)
- [x] Themes + transitional subscription (Dark/Light/Gray free; ambience + accent + bulk refetch via RevenueCat `compass` → Pro features)
- [x] Offline catalog art (match prefetches small+normal; soft-fail + small fallback when airplane)
- [x] Monetization architecture + feature entitlements (Free / Pro / Sync; mock tier provider; see [monetization.md](./monetization.md))
- [x] Remap Themes / bulk refetch gates from binary `compass` monthly checks → Pro `canUse(Feature)`
- [x] Offline-first sync protocol (v0) — local graph remains source of truth; Postgres replica + push/pull; Sync-gated (see [sync-protocol.md](./sync-protocol.md))

Pricing model: **Free** = complete local app; **Pro** = lifetime advanced software; **Sync** = cloud subscription. See [monetization.md](./monetization.md) and [apps/mobile/docs/entitlements.md](../apps/mobile/docs/entitlements.md). Legacy `compass_monthly` remains mapped to Pro for existing TestFlight subscribers; it is not in the current offering.

Manual TestFlight uploads are in progress (bundle id `app.compass.mobile`). Home-screen label is **Compass Inventory** (ASC rejects bare `Compass`); in-app title stays Compass. Automating store uploads for iOS and Android testing is Phase 1 under Later.

## Later — Platform

Schema contract for every vertical: [taxonomy.md](./taxonomy.md). Do not add domain columns to core Asset.

Shipped:

- [x] Store product cutover — `compass_pro_lifetime`, `compass_sync_monthly` / yearly (replace transitional `compass_monthly`)
- [x] CSV export (free; data ownership)
- [x] **Domain packs (MTG first)** — see [domain-packs-roadmap.md](./domain-packs-roadmap.md) (pack JSON, domain picker, pack-driven import/export/display)
- [x] **Domain packs — jewelry (DP-5)** — second bundled pack, taxonomy-aligned types, spreadsheet CSV
- [x] **Domain packs — pack attribute editing (DP-5.1)** — jewelry Edit/Save; catalog UI scoped to owning pack
- [x] **Domain packs — remote install (DP-5.2)** — Compass URL install from Settings; offline cache

Remaining work is sequenced in phases. Finish a phase's exit criteria before starting the next, except where noted.

### Phase 1 — Foundation

Unblocks everything else; mostly no product risk.

- [ ] Flutter CI job — `flutter analyze` + `flutter test` on PRs into `dev` (CI currently covers web only)
- [ ] Automate release builds for tester distribution
  - Versioning and tagging: release workflow that bumps `pubspec.yaml` (build number from the CI run), tags, and creates a GitHub Release; replaces the force-push in `sync_public.sh`; one tag scheme
  - iOS → TestFlight: GitHub Actions `macos` runner (or fastlane) + App Store Connect API key; replaces manual Transporter upload
  - Android: real release keystore and `signingConfigs.release` (release is currently debug-signed), then Play internal testing / closed track (or Firebase App Distribution) via the Play Developer API
  - Gate release jobs on the quality + Flutter jobs and a protected GitHub environment
- [ ] Replace the placeholder About page
- [ ] Store-review readiness — IAP metadata and screenshot, privacy policy URL, Paid Apps agreement (see [entitlements.md](../apps/mobile/docs/entitlements.md))

### Phase 2 — Make Pro worth the price

Pro (lifetime) currently unlocks only themes, custom accent and bulk refetch. These `CompassFeature` ids are defined in `compass_feature.dart` but have no UI behind them yet. Each item ships behind `canUse(...)`.

- [ ] Advanced search (`advancedSearch`) — multi-field and filtered search across the location graph
- [ ] Artist and element filters — filter the collection by artist and by element/color
- [ ] Saved searches (`savedSearches`)
- [ ] Bulk operations (`bulkOperations`) — multi-select move, retag and delete
- [ ] Custom schemas (`customSchemas`) — user-defined attributes within the taxonomy contract

Exit: every feature Pro is marketed with is implemented and gated.

### Phase 3 — Make Sync real

- [ ] Multi-device behavior (`multiDevice`) — second-device onboarding and conflict handling on the v0 protocol
- [ ] Cloud backup and restore (`cloudBackup`) — user-visible restore flow
- [ ] Monetization analytics events (paywall / purchase / restore; no inventory contents)
- [ ] Advanced cloud history (`advancedCloudHistory`) — only with Sync Plus

Exit: a Sync subscriber can set up a second device and restore from nothing.

### Phase 4 — Reach

- [ ] Pricing provider (TCGplayer / Cardmarket) behind `PricingProvider` (currently a no-op stub)
- [ ] GPS / location capture — tag items with captured location
- [ ] Web collection browser
- [ ] Sharing / household spaces (`sharedCollections`) and Sync Plus tier — only when needed
- [ ] Cross-module search

### Phase 5 — Platform

- [ ] Taxonomy model, versioning, external taxonomy import, reference entities (after MTG pack gate)
- [ ] Domain packs expansion (tools, clothing, collectibles, …)
- [ ] Public API for power users
- [ ] Hardware partnerships (NFC labels, storage kits)

## Branching strategy

| Branch   | Purpose                                      |
|----------|----------------------------------------------|
| `dev`    | Active development integration (CI)          |
| `public` | Default / production-facing release          |

Feature work lands via PRs into `dev`, then promotes to `public` for release.

Production site: [getcompass.space](https://getcompass.space)
