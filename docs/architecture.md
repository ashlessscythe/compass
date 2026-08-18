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

Mobile is the source of truth for this split. `packages/api` currently has a flatter Location + Asset shape (no Container); align it when the Cloud API is real.

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

A generic tracked item: `name`, `assetTypeId`, optional `containerId` / `locationId`. Module-specific fields live in `metadata` so the core schema stays universal.

`AssetType.moduleId` (`mtg`, `tools`, …) is how a card, a wrench, or a ring share one table.

### Modules

Vertical modules provide:

- Catalog schemas and validation
- Import adapters (Deckbox, Moxfield, CSV, …)
- External catalog providers (see MTG / Scryfall below)
- Domain-specific search facets
- UI presentations for item detail

The location engine, NFC layer, and sync protocol remain shared.

Do **not** add MTG (or any vertical) columns to core tables. Expand via `AssetType.moduleId` + `Metadata`, plus module-owned UI and adapters.

## Persistence

Source of truth is **on-device SQLite**, not the cloud.

- Intended: Drift at `apps/mobile/lib/database/`. Native file is `compass.sqlite` in the app documents directory.
- Today: Drift ships **empty** (migration hooks only). Repositories are in-memory maps, so inventory does not survive process restart.
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
- Store identifiers in `Asset.metadata` (e.g. Scryfall oracle/card id); do not put printings into core schema
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
- Drift (SQLite) with migration infrastructure; Riverpod DI; GoRouter; Material 3 (dark-first)
- Module-specific fields stay in Metadata — the core app is not MTG-specific
- Foundation milestone: empty schema, in-memory repositories until tables land

See `apps/mobile/README.md` for setup and run instructions.

## Tooling

- **pnpm** workspaces
- **Turborepo** task orchestration
- **TypeScript** across packages
- **ESLint + Prettier** for the web stack
- **Vercel** for web hosting
- **Koyeb** via Docker for alternative deployment
