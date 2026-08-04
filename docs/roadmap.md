# Roadmap

## Now — Foundation

- [x] Monorepo scaffolding
- [x] Marketing website (`apps/web`)
- [x] Shared packages (`api`, `branding`, `ui`)
- [x] Waitlist capture endpoint
- [x] Documentation (vision, architecture, branding)
- [ ] Flutter mobile scaffold initialization
- [ ] Persist waitlist to a durable store

## Next — MTG MVP

- [ ] Local asset + location data model
- [ ] Nested containers (room / shelf / box / binder)
- [ ] Search: item → location path
- [ ] NFC tag association for containers
- [ ] Import from CSV
- [ ] Import adapters for Deckbox and Moxfield
- [ ] Offline-first sync protocol (v0)

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
