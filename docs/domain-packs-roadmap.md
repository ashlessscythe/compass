# Domain packs roadmap

How Compass ships verticals (MTG first) as installable **domain packs** without widening core Asset. Schema contract: [taxonomy.md](./taxonomy.md). Main product sequence: [roadmap.md](./roadmap.md).

**Goal:** Make today's MTG app behave like a domain pack — JSON spec on the website, bundled on device, full import → locate → match → display → export loop — before jewelry, tools, or other domains.

Pack definitions live as **versioned JSON in git** (`packages/domains/packs/`). The website API read-through serves the same files (no Postgres). Mobile bundles a copy for offline use.

---

## Phases

| Phase | Build | Exit criteria |
|-------|--------|---------------|
| **DP-0** | Pack contract + MTG `v1.json` + site API + docs | `/api/domains/mtg` and `/docs/domains/mtg` return/render the manifest |
| **DP-1** | Domain picker UI + routing | Cold launch → picker → MTG card → domain home; Get more opens site |
| **DP-2** | Pack seed on device | Drift install state + attribute defs + `mtg_card` type from pack |
| **DP-3** | Pack-driven import/export | Deckbox/Moxfield/generic CSV via pack mappings; round-trip export |
| **DP-4** | Pack-driven display + catalog | Asset detail, Match, Scryfall keyed off pack provider + attribute keys |

**After DP-4:** jewelry stub pack, remote pack download, schema-driven create forms, second domain on picker.

---

## DP-5 — Jewelry domain pack (2-domain picker)

**In**

- `packages/domains/packs/jewelry/v1.json` — type hierarchy, attributes, vocab, Compass + spreadsheet CSV dialects
- Pack-driven CSV pipeline (no MTG hardcoding in parser/exporter)
- Module-scoped import/export and domain home asset counts
- Generic asset detail attribute panel (no catalog provider)
- Second bundled pack on domain picker

**Out**

- Camera / reverse image / eBay / Etsy providers (DP-6 skeleton)
- Schema-driven create forms
- Remote pack install

**Tollgate**

- [x] Picker shows MTG + Jewelry; each domain home uses pack tagline
- [x] Jewelry Compass + spreadsheet CSV import/export round-trip
- [x] Module-scoped export (MTG rows excluded from jewelry export and vice versa)
- [x] `/api/domains/jewelry` and `/docs/domains/jewelry` on site
- [x] Third pack drop-in = JSON + registry + bundled asset only

**After DP-5:** tools pack, visual match providers, schema-driven create forms, remote pack download.

---

## DP-5.1 — Pack attribute editing (jewelry first)

**In**

- Owning-pack resolution for catalog gating (no Scryfall UI on non-catalog domains)
- Pack-driven attribute editor on asset detail (string, decimal, currency, enum)
- Category enum updates asset subtype id on save

**Out**

- Schema-driven fields on create (name-only prompt remains)
- Web attribute editing
- Jewelry catalog providers (DP-6)

**Tollgate**

- [ ] Jewelry asset detail shows all pack attributes with Edit / Save
- [ ] Saved values persist and export in CSV
- [ ] Jewelry container list has no Match button; MTG unchanged
- [ ] MTG assets still resolve Scryfall catalog UI

**After DP-5.1:** tools pack, create-time schema forms (DP-6), remote pack install (DP-5.2).

---

## DP-5.2 — Remote pack install (Compass URLs)

**In**

- Site docs show copyable install URL per pack (`/api/domains/{packId}`)
- App Settings → Domain packs: paste URL to install or update
- Cached manifest JSON in SQLite for offline use after first fetch
- Registry merges bundled + cached remote manifests by semver

**Out**

- Third-party pack hosts
- In-app catalog browser
- Uninstall / hide bundled packs

**Tollgate**

- [ ] `/docs/domains/{pack}` shows Copy URL callout
- [ ] Settings → Domain packs installs from Compass API URL
- [ ] Update re-fetches manifest and re-seeds when version increases
- [ ] Cached pack loads offline after first install

**After DP-5.2:** tools pack, schema-driven create forms (DP-6).

---

## DP-0 — Pack contract + site hosting

**In**

- `packages/domains/packs/mtg/v1.json` — types, attributes, vocab, CSV import/export, Scryfall provider
- `@compass/api` types: `DomainPack`, CSV mappings, providers
- `GET /api/domains`, `GET /api/domains/[packId]`
- `/docs/domains`, `/docs/domains/mtg`

**Out**

- Postgres pack registry
- Remote pack install

**Tollgate**

- [x] MTG pack JSON validates against shared types
- [x] API returns pack; docs page lists attributes and CSV columns

---

## DP-1 — Domain picker

**In**

- Splash → `/domains` picker ("Select your domain")
- Installed pack cards (MTG bundled)
- Get more → `https://getcompass.space/docs/domains`
- `/domains/mtg` domain home (current location graph, MTG branding)
- Persist last active module

**Out**

- Per-domain location graphs (one shared graph)
- Remote pack install

**Tollgate**

- [x] Fresh install: picker shows MTG; tap opens domain home
- [x] Back from domain home returns to picker
- [x] Get more opens site docs

---

## DP-2 — Pack seed on device

**In**

- Drift v8: `installed_domain_packs`, `attribute_definitions`, `controlled_values`
- Seed `mtg_card` asset type + defs from bundled JSON on `beforeOpen`
- Idempotent upsert by pack version

**Out**

- `taxonomy_nodes` / `attribute_values` tables
- Syncing pack tables to cloud

**Tollgate**

- [x] After upgrade, `mtg_card` type and attribute defs exist in SQLite
- [x] Existing generic `Item` type unchanged

---

## DP-3 — Pack-driven import/export

**In**

- `DomainPackRegistry` consumed by import/export
- CSV header aliases and metadata keys from pack `csvImport` / `csvExport`
- Imports set `assetTypeId` from pack

**Out**

- Metadata → `attribute_values` migration

**Tollgate**

- [x] Deckbox + Moxfield fixtures import unchanged behavior
- [x] Export round-trip preserves set, collector, finish, Scryfall id

---

## DP-4 — Pack-driven display + catalog

**In**

- Asset detail uses pack `providers.catalog` for Scryfall UI
- Match key order from pack
- Finish/condition labels from controlled vocab where keyed

**Out**

- Pricing providers (TCGplayer, Cardmarket)
- Schema-driven create forms

**Tollgate**

- [x] MTG asset detail: match, art, printings sheet still work
- [x] Catalog off: location path still works

---

## UX milestones (DP-UX)

Separate from [mobile-ux.md](./mobile-ux.md) graph polish. Domain picker is a new surface, not a rewrite of UX-1..6.

| ID | Focus |
|----|--------|
| DP-UX-1 | Domain picker layout + card affordances |
| DP-UX-2 | Domain home chrome (back to picker, MTG identity) |
| DP-UX-3 | Domain-scoped import/export entry points |

Recapture stills when DP-UX-3 tollgate passes.

---

## Pack hosting model

| Layer | Storage |
|-------|---------|
| Source of truth | `packages/domains/packs/*.json` in git |
| Web API | Import from `@compass/domains` — no DB |
| Mobile runtime | Bundled asset copy |
| Mobile install state | Drift `installed_domain_packs` only |

Later (post DP-4): mobile may check API for newer `version`; DB registry only if admin/marketplace needs it.
