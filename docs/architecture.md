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

### Location graph

Locations form a tree (room → shelf → box → sleeve). Each location may have:

- `nfcTagId` for tap-to-open
- hierarchical `path` for search and breadcrumbs
- parent/child relationships for nesting

### Assets

Assets belong to a `moduleId` (e.g. `mtg`, `tools`) and optionally a `locationId`. Module-specific fields live in `metadata` so the core schema stays universal.

### Modules

Vertical modules provide:

- Catalog schemas and validation
- Import adapters (Deckbox, Moxfield, CSV, …)
- Domain-specific search facets
- UI presentations for item detail

The location engine, NFC layer, and sync protocol remain shared.

## Offline-first strategy

1. Local-first writes on device
2. Conflict-aware sync when online
3. Read models optimized for “find by name → show path”
4. NFC deep links resolve against local data first

## Web application

`apps/web` currently ships the marketing site:

- App Router, TypeScript, Tailwind, shadcn/ui
- Waitlist API route (`/api/waitlist`)
- SEO: metadata, Open Graph, Twitter cards, robots, sitemap

Future web surfaces (account, collection browser) can grow in the same app or as additional apps under `apps/`.

## Mobile application

`apps/mobile` is a Flutter client built with Clean Architecture (feature-first):

- **presentation / application / domain / infrastructure** layers
- Core domain: Asset, Container, Location, AssetType, Movement, Relationship, History, Tag, Metadata, Photo
- Drift (SQLite) with migration infrastructure; Riverpod DI; GoRouter; Material 3 (dark-first)
- Module-specific fields stay in Metadata — the core app is not MTG-specific

See `apps/mobile/README.md` for setup and run instructions.

## Tooling

- **pnpm** workspaces
- **Turborepo** task orchestration
- **TypeScript** across packages
- **ESLint + Prettier** for the web stack
- **Vercel** for web hosting
- **Koyeb** via Docker for alternative deployment
