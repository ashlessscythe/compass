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

iOS UI craft for the location graph is through UX-6 (stills). Themes shipped under a transitional monthly SKU (now mapped to Pro features). Offline catalog art hardened. Feature entitlements (Free / Pro / Sync) are in place. Sequence and exit criteria: [mobile-ux.md](./mobile-ux.md). Monetization model: [monetization.md](./monetization.md). Next product work: offline-first sync protocol.

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
- [ ] Offline-first sync protocol (v0) — local graph remains source of truth; grants Sync entitlements when cloud ships

Pricing model: **Free** = complete local app; **Pro** = lifetime advanced software; **Sync** = cloud subscription. See [monetization.md](./monetization.md) and [apps/mobile/docs/entitlements.md](../apps/mobile/docs/entitlements.md). The shipped ~$2/mo Themes SKU is transitional and maps to Pro features until Pro lifetime / Sync products exist.

Manual TestFlight uploads are in progress (bundle id `app.compass.mobile`). Home-screen label is **Compass Inventory** (ASC rejects bare `Compass`); in-app title stays Compass. Automating store uploads for iOS and Android testing is Later.

## Later — Platform

Schema contract for every vertical: [taxonomy.md](./taxonomy.md). Do not add domain columns to core Asset.

- [ ] Store product cutover — `compass_pro_lifetime`, `compass_sync_monthly` / yearly (replace transitional `compass_monthly`)
- [ ] CSV export (free; data ownership)
- [ ] Monetization analytics events (paywall / purchase / restore; no inventory contents)
- [ ] Sync Plus tier (shared collections, advanced cloud history) — only when needed
- [ ] MTG schema + Scryfall / importers / pricing providers (persist attributes when catalog needs them)
- [ ] Taxonomy model, versioning, external taxonomy import, reference entities
- [ ] Domain packs (jewelry, tools, clothing, collectibles, …)
- [ ] Cross-module search
- [ ] Sharing / household spaces
- [ ] Web collection browser
- [ ] Public API for power users
- [ ] Hardware partnerships (NFC labels, storage kits)
- [ ] Automate release builds for tester distribution — iOS → TestFlight (fastlane or GitHub Actions `macos` + App Store Connect API; replace manual Transporter); Android → Play internal testing / closed track (or Firebase App Distribution) via CI signing + Play Developer API

## Branching strategy

| Branch   | Purpose                                      |
|----------|----------------------------------------------|
| `dev`    | Active development integration (CI)          |
| `public` | Default / production-facing release          |

Feature work lands via PRs into `dev`, then promotes to `public` for release.

Production site: [getcompass.space](https://getcompass.space)
