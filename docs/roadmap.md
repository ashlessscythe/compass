# Roadmap

## Now — Foundation

- [x] Monorepo scaffolding
- [x] Marketing website (`apps/web`)
- [x] Shared packages (`api`, `branding`, `ui`)
- [x] Waitlist capture endpoint
- [x] Documentation (vision, architecture, branding)
- [x] Flutter mobile scaffold initialization
- [x] Persist waitlist to a durable store

The Flutter client (`apps/mobile`) ships Clean Architecture layers, domain entities, Riverpod, GoRouter, and an on-device Drift location graph (places, containers, assets) with name search.

## Next — MTG MVP

- [x] Local asset + location data model (on-device SQLite; see architecture)
- [x] Nested containers (location = place, container = vessel)
- [x] Search: item → location path
- [ ] NFC tag association for containers
- [ ] Import from CSV
- [ ] Import adapters for Deckbox and Moxfield
- [ ] Scryfall catalog for MTG images/stats (configurable; cache locally)
- [ ] Offline-first sync protocol (v0)

Pricing / entitlements (free local vs paid sync) are **undecided** — see [architecture.md](./architecture.md). Do not block the local iOS MVP on billing.

## Later — Platform

- [ ] Additional modules (tools, jewelry, electronics, home, …)
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
