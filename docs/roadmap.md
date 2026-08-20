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

iOS UI craft for the location graph is through UX-6 (stills). Sequence and exit criteria: [mobile-ux.md](./mobile-ux.md). Next product work: NFC, Scryfall enrichment.

## Next — MTG MVP

- [x] Local asset + location data model (on-device SQLite; see architecture)
- [x] Nested containers (location = place, container = vessel)
- [x] Search: item → location path
- [x] iOS UX pass (first run → confirm delete → move → chrome → sheets → stills)
- [ ] NFC tag association for containers
- [x] Import from CSV (Deckbox / Moxfield / generic headers → container; Settings → Import CSV)
- [x] Import adapters for Deckbox and Moxfield (header dialects on the shared CSV surface)
- [ ] Scryfall catalog for MTG images/stats (configurable; cache locally)
- [ ] Offline-first sync protocol (v0)

Pricing / entitlements (free local vs paid sync) are **undecided** — see [architecture.md](./architecture.md). Do not block the local iOS MVP on billing.

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

## Branching strategy

| Branch   | Purpose                                      |
|----------|----------------------------------------------|
| `dev`    | Active development integration (CI)          |
| `public` | Default / production-facing release          |

Feature work lands via PRs into `dev`, then promotes to `public` for release.

Production site: [getcompass.space](https://getcompass.space)
