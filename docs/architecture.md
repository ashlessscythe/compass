# Architecture

## Monorepo layout

```
compass/
├── apps/
│   ├── web/          # Next.js marketing site (+ future web app surfaces)
│   └── mobile/       # Flutter client (Clean Architecture foundation)
├── packages/
│   ├── api/          # Shared domain types + API client contracts
│   ├── branding/     # Brand tokens, copy, module list
│   └── ui/           # Shared UI primitives (mark, utilities)
├── docs/             # Product & engineering documentation
└── .github/          # CI workflows and templates
```

## System overview

```
┌─────────────────┐     ┌─────────────────┐
│  apps/web       │     │  apps/mobile    │
│  Next.js        │     │  Flutter        │
└────────┬────────┘     └────────┬────────┘
         │                       │
         └───────────┬───────────┘
                     │
              ┌──────▼──────┐
              │ packages/api│  Shared contracts
              └──────┬──────┘
                     │
         ┌───────────┴───────────┐
         │                       │
   ┌─────▼─────┐          ┌──────▼──────┐
   │ Local DB  │◄─ sync ─►│ Cloud API   │
   │ (offline) │          │ (future)    │
   └───────────┘          └─────────────┘
```

## Core domain model

Mobile is the source of truth for this split. `packages/api` mirrors the generic Asset / AssetType / Container / attribute contracts; the Cloud API is not implemented yet.

How verticals attach without widening Asset: [taxonomy.md](./taxonomy.md).

### Location

An immovable place (home, office, room). Nested via `parentLocationId`.

Each location may have:

- `nfcTagId` for tap-to-open
- hierarchical `path` for search and breadcrumbs
- parent/child relationships for nesting

### Container

A nestable vessel that sits at a location (shelf, box, binder, sleeve). Nested via `parentContainerId`, optionally `locationId`. May also have `nfcTagId`.

Room → shelf → box → sleeve is **not** all locations. Room is a Location; shelf / box / sleeve are Containers.

### Asset

A generic tracked item: `name`, `assetTypeId`, `quantity`, optional `containerId` / `locationId`, notes. Photos, tags, and history are separate entities.

The core Asset entity must **not** contain vertical fields (set, foil, material, carat, serial number, …). `AssetType.moduleId` (`mtg`, `tools`, `jewelry`, …) plus a type hierarchy (`parentId`) is how a card, a wrench, or a ring share one table.

Module-specific data lives in `Metadata` today. The target model is typed attribute definitions/values, controlled vocabularies, and external identifiers — see [taxonomy.md](./taxonomy.md).

### Modules

Vertical modules (later, installable domain packs) provide:

- Asset types and attribute schemas
- Controlled vocabularies and reference data
- Import adapters (Deckbox, Moxfield, CSV, …)
- External catalog / pricing providers (see MTG / Scryfall below)
- Domain-specific search facets and UI

The location engine, NFC layer, and sync protocol remain shared.

Do **not** add MTG (or any vertical) columns to core tables. Expand via `AssetType` + attributes (or `Metadata` until those tables persist), plus module-owned UI and adapters.

## Persistence

Source of truth is **on-device SQLite**, not the cloud.

- Intended: Drift at `apps/mobile/lib/database/`. Native file is `compass.sqlite` in the app documents directory.
- Schema v3: `locations`, `containers`, `asset_types` (optional `parent_id`), `assets` (`quantity`). Remaining entities (tags, photos, attributes, vocabularies, external ids) stay in-memory / in `metadata_json` until a consumer needs tables.
- v1 was an empty foundation DB; v2 introduced the location graph. Existing simulator installs add columns on upgrade; delete the app if a local file is wedged.
- Seeded `AssetType`: id `asset-type-item`, name `Item`, module `collectibles`. MTG types come later.
- Location `path` is stored and recomputed on rename/move. Container and asset paths are derived at read time (`Office / Desk / Binder / Lightning Bolt`).
- Name search is case-insensitive SQL `LIKE` (no FTS5 yet).
- Cloud API is a **sync replica**, not required for “where is it?”
- **Website Postgres** (waitlist, marketing/account tables) is a separate database from inventory. Prisma schema: `apps/web/prisma/schema.prisma`. Migrations: `apps/web/prisma/migrations/`. Secrets: `apps/web/.env.local` (`DATABASE_URL` pooled, `DIRECT_URL` unpooled). Template: `apps/web/.env.example`. Local: `pnpm --filter @compass/web db:migrate`. Deploy runs `prisma migrate deploy` (Vercel build command; Docker entrypoint).

## Offline-first strategy

1. Local-first writes on device
2. Conflict-aware sync when online (future; not gated to a plan yet — see Pricing)
3. Read models optimized for “find by name → show path”
4. NFC deep links resolve against local data first
5. External catalogs (Scryfall, etc.) are **enrichment**. Core location workflows must work with them disabled or unreachable; cache fetched images/stats locally when enabled.

## Pricing / sync (undecided)

No free vs paid plan is defined. “Premium” in branding means craft, not a subscription.

Do not assume sync, backup, household sharing, or the web collection browser are paid unlocks until this is decided.

Open questions:

- Does free stay local-only forever?
- Is cloud sync / backup a paid tier?
- Is household sharing paid?
- Is the web collection browser paid?

A reasonable default if we lock this later: **free = full local app; paid = sync + household + web.** That keeps the iOS MVP unblocked.

## MTG catalog (Scryfall)

For `moduleId = mtg` assets, **Scryfall** is the default (configurable) source for card images and stats (set, collector number, mana, type line, oracle text, etc.).

Rules:

- Configurable: user can disable network catalog lookup, swap provider later, or run without it
- Store identifiers as external ids (source + id). Until that table persists, they live in `Asset.metadata` (e.g. Scryfall oracle/card id). Do not put printings into core schema.
- Images and stats are cached on device after fetch so search-by-location still works offline
- Compass answers *where* the card is; Scryfall answers *what it looks like / what it does*

## Web application

`apps/web` currently ships the marketing site:

- App Router, TypeScript, Tailwind, shadcn/ui
- Waitlist API route (`/api/waitlist`)
- Env: `apps/web/.env.example` (committed) → copy to `apps/web/.env.local` (secrets)
- Prisma + Postgres for website data (`WaitlistEntry`); not mobile inventory
- SEO: metadata, Open Graph, Twitter cards, robots, sitemap

Future web surfaces (account, collection browser) can grow in the same app or as additional apps under `apps/`.

## Mobile application

`apps/mobile` is a Flutter client built with Clean Architecture (feature-first):

- **presentation / application / domain / infrastructure** layers
- Core domain: Asset, Container, Location, AssetType, Movement, Relationship, History, Tag, Metadata, Photo
- Drift (SQLite) schema v3: Location, Container, AssetType, Asset; Riverpod DI; GoRouter; Material 3 (dark-first)
- Module-specific fields stay in Metadata / attributes — the core app is not MTG-specific. Contract: [taxonomy.md](./taxonomy.md).
- Home search answers “where is it?” from local data

See `apps/mobile/README.md` for setup and run instructions. iOS UX order and tollgates: [mobile-ux.md](./mobile-ux.md).

## Tooling

- **pnpm** workspaces
- **Turborepo** task orchestration
- **TypeScript** across packages
- **ESLint + Prettier** for the web stack
- **Vercel** for web hosting
- **Koyeb** via Docker for alternative deployment
