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
│   └── mobile/              # Flutter app (Clean Architecture foundation)
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
| Mobile       | Flutter (foundation)                        |
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

This is a **pnpm monorepo**. The lockfile (`pnpm-lock.yaml`) lives at the **repository root**. Deployments must build from the root (or install from the root) so the lockfile is visible.

### Vercel (recommended)

1. Import the GitHub repository (`public` branch).
2. Keep **Root Directory** as the repository root (`.`) — do **not** set it to `apps/web` alone unless you also install from the monorepo root.
3. Framework preset: **Next.js** (or Other + custom commands).
4. Install command: `pnpm install`
5. Build command: `pnpm --filter @compass/web build`
6. Set env `NEXT_PUBLIC_SITE_URL` to `https://getcompass.space`.

Root `vercel.json` already encodes these commands.

If you prefer Root Directory `apps/web`, enable including files outside the root directory and use:

- Install: `cd ../.. && pnpm install`
- Build: `cd ../.. && pnpm --filter @compass/web build`

### Koyeb

The “Missing lockfile” error happens when **Work directory** is set to `apps/web` with the buildpack builder — Koyeb then hides the root `pnpm-lock.yaml`.

**Use the Docker builder from the repo root:**

1. Create/update the service from this repository (`public` branch).
2. Builder: **Dockerfile** (not buildpack).
3. Dockerfile path: `Dockerfile` (repo root).
4. Docker context: `.` (repo root).
5. **Leave Work directory empty / unset** (must be the repository root).
6. Port: `3000`.
7. Env: `NEXT_PUBLIC_SITE_URL=https://getcompass.space`.

`koyeb.yaml` matches this setup.

```bash
# Local Docker smoke test
docker build -t compass-web .
docker run --rm -p 3000:3000 compass-web
```

---

## Documentation

- [Vision](./docs/vision.md)
- [Architecture](./docs/architecture.md)
- [Roadmap](./docs/roadmap.md)
- [Branding](./docs/branding.md)
- [Flutter / mobile setup](./docs/mobile-setup.md)

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
