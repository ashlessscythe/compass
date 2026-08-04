# Compass

**Know where everything is.**

Compass is an offline-first asset management platform that maps your digital inventory to real-world locations.

Unlike traditional inventory software that answers *“Do I own this?”*, Compass answers *“Where is it?”*

The first vertical is **Magic: The Gathering** collections. The architecture is built for future modules — tools, jewelry, electronics, home inventory, collectibles, and more.

---

## Project Vision

Bridge digital inventories and physical storage with an offline-first, NFC-aware location graph. See [docs/vision.md](./docs/vision.md).

---

## Repository Structure

```
compass/
├── apps/
│   ├── web/                 # Next.js 15 marketing site
│   └── mobile/              # Flutter app (scaffold)
├── packages/
│   ├── api/                 # Shared types + API client
│   ├── branding/            # Brand tokens & copy
│   └── ui/                  # Shared UI primitives
├── docs/                    # Vision, architecture, roadmap, branding
├── .github/                 # CI & templates
├── koyeb.yaml               # Koyeb deployment config
└── vercel.json              # Vercel deployment config
```

---

## Tech Stack

| Layer        | Choice                                      |
|--------------|---------------------------------------------|
| Monorepo     | pnpm workspaces + Turborepo                 |
| Web          | Next.js 15, React 19, TypeScript            |
| Styling      | Tailwind CSS, shadcn/ui, Framer Motion      |
| Icons        | Lucide                                      |
| Fonts        | Geist, Inter, Space Grotesk                 |
| Mobile       | Flutter (scaffold)                          |
| Deploy       | Vercel, Koyeb (Docker)                      |

---

## Getting Started

### Prerequisites

- Node.js 20+
- [pnpm](https://pnpm.io) 9+

### Install

```bash
pnpm install
```

### Develop

```bash
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000).

### Other commands

```bash
pnpm build        # Build all packages / apps
pnpm lint         # Lint
pnpm typecheck    # TypeScript checks
pnpm format       # Prettier
```

---

## Roadmap

High level:

1. **Foundation** — monorepo, marketing site, shared packages
2. **MTG MVP** — locations, search, NFC, imports
3. **Platform** — additional modules, sync, web app surfaces

Details: [docs/roadmap.md](./docs/roadmap.md)

### Branches

| Branch   | Role                                         |
|----------|----------------------------------------------|
| `dev`    | Active development (CI runs here)            |
| `public` | Default / production-facing                  |

Site: [getcompass.space](https://getcompass.space)

---

## Deployment

### Vercel

1. Import the GitHub repository in Vercel.
2. Set **Root Directory** to `apps/web`.
3. Framework preset: **Next.js**.
4. Install command: `pnpm install` (from repo root — Vercel detects pnpm via `packageManager`).
5. Build command: `pnpm build` (or leave default for Next.js in `apps/web`).
6. Set env `NEXT_PUBLIC_SITE_URL` to `https://getcompass.space`.

Root `vercel.json` is provided for monorepo-aware installs when deploying from the repository root.

### Koyeb

1. Create a new app from this repository.
2. Use the Dockerfile at `apps/web/Dockerfile` with Docker context `.` (repo root).
3. Or apply `koyeb.yaml`.
4. Expose port `3000`.
5. Set `NEXT_PUBLIC_SITE_URL` to `https://getcompass.space` (or your Koyeb preview URL).

```bash
# Local Docker smoke test
docker build -f apps/web/Dockerfile -t compass-web .
docker run --rm -p 3000:3000 compass-web
```

---

## Documentation

- [Vision](./docs/vision.md)
- [Architecture](./docs/architecture.md)
- [Roadmap](./docs/roadmap.md)
- [Branding](./docs/branding.md)

---

## Contributing

1. Branch from `dev`.
2. Use focused commits and descriptive PR titles.
3. Ensure `pnpm lint`, `pnpm typecheck`, and `pnpm build` pass.
4. Open a PR into `dev` using the template in `.github/`.
5. Promote stable work from `dev` to `public` for production.

Bug reports welcome via GitHub Issues.

---

## License

[MIT](./LICENSE) © Tony
