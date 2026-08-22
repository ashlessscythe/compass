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

iOS UI craft for the location graph is through UX-6 (stills). Themes + subscription shipped. Sequence and exit criteria: [mobile-ux.md](./mobile-ux.md). Next product work: offline-first sync.

## Next — MTG MVP

- [x] Local asset + location data model (on-device SQLite; see architecture)
- [x] Nested containers (location = place, container = vessel)
- [x] Search: item → location path
- [x] iOS UX pass (first run → confirm delete → move → chrome → sheets → stills)
- [x] NFC tag association for containers (chip UID; Home → Scan NFC)
- [x] Import from CSV (Deckbox / Moxfield / generic headers → container; Settings → Import CSV)
- [x] Import adapters for Deckbox and Moxfield (header dialects on the shared CSV surface)
- [x] Scryfall catalog for MTG images/stats (CardMetadataProvider; local SQLite + bulk; thumbs / full art)
- [x] Themes + subscription (Dark/Light/Gray free; ambience skins, custom accent, container refetch ~$2/mo via RevenueCat)
- [ ] Offline-first sync protocol (v0)

Pricing: first paid surface is **appearance + bulk refetch** — see [architecture.md](./architecture.md) and [apps/mobile/docs/entitlements.md](../apps/mobile/docs/entitlements.md). Sync / household / web remain undecided and are not gated on the Themes sub.

Manual TestFlight uploads are in progress (bundle id `app.compass.mobile`). Home-screen label is **Compass Inventory** (ASC rejects bare `Compass`); in-app title stays Compass. Automating uploads is Later.

## Later — Platform

Schema contract for every vertical: [taxonomy.md](./taxonomy.md). Do not add domain columns to core Asset.

- [ ] MTG schema + Scryfall / importers / pricing providers (persist attributes when catalog needs them)
- [ ] Taxonomy model, versioning, external taxonomy import, reference entities
- [ ] Domain packs (jewelry, tools, clothing, collectibles, …)
- [ ] Cross-module search
- [ ] Sharing / household spaces
- [ ] Web collection browser
- [ ] Public API for power users
- [ ] Hardware partnerships (NFC labels, storage kits)
- [ ] Automate iOS build → TestFlight (fastlane or GitHub Actions `macos` + App Store Connect API; replace manual Transporter)

## Branching strategy

| Branch   | Purpose                                      |
|----------|----------------------------------------------|
| `dev`    | Active development integration (CI)          |
| `public` | Default / production-facing release          |

Feature work lands via PRs into `dev`, then promotes to `public` for release.

Production site: [getcompass.space](https://getcompass.space)
