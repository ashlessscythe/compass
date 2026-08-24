# Environment variables (web + sync)

Secrets never go in git. Committed template: [`apps/web/.env.example`](../apps/web/.env.example). Local secrets: `apps/web/.env.local` (gitignored). Protocol details: [sync-protocol.md](./sync-protocol.md).

## Local development

```bash
cp apps/web/.env.example apps/web/.env.local
# Edit DATABASE_URL, DIRECT_URL, and optional sync keys.
pnpm --filter @compass/web db:migrate   # uses dotenv -e .env.local
pnpm --filter @compass/web dev
```

Prisma CLI does **not** load `.env.local` by itself. Prefer `pnpm db:migrate` / `pnpm db:deploy` from `apps/web`, or:

```bash
pnpm exec dotenv -e .env.local -- prisma migrate deploy
```

### Mobile (simulator sync)

```bash
flutter run -d "iPhone 17 Pro" \
  --dart-define=COMPASS_API_BASE_URL=http://localhost:3000 \
  --dart-define=COMPASS_SYNC_DEV_SECRET=local-dev-only \
  --dart-define=COMPASS_SYNC_DEV_DEVICE_ID=test-user-1
```

Match `COMPASS_SYNC_DEV_SECRET` to the value in `.env.local`. Use a fixed `COMPASS_SYNC_DEV_DEVICE_ID` to share one cloud user across reinstalls (see [sync-protocol.md](./sync-protocol.md)).

Do **not** bake secrets into committed xcconfigs or source. Pass them only via `--dart-define` / CI secrets.

## Production (Vercel + Neon)

Set these in the Vercel project → **Settings → Environment Variables** for Production (and Preview if you use Preview DBs).

| Variable | Required | Notes |
|----------|----------|--------|
| `DATABASE_URL` | Yes | Neon **pooled** URL (`-pooler` host). Used by the Next.js runtime / Prisma Client. |
| `DIRECT_URL` | Yes | Neon **unpooled** URL (no `-pooler`). Used by Prisma migrate. |
| `NEXT_PUBLIC_SITE_URL` | Yes | Canonical site URL, e.g. `https://getcompass.space`. |
| `APPLE_CLIENT_ID` | Yes for Sync | JWT `aud` for Sign in with Apple — iOS bundle id `app.compass.mobile` or your Services ID. |
| `COMPASS_SYNC_DEV_SECRET` | **No** | Leave **unset** in Production so `/api/auth/dev` returns 404. Local/simulator only. |
| `COMPASS_API_SECRET` | No | Reserved; unused in v0. |
| `RESEND_API_KEY` / `WAITLIST_NOTIFY_TO` | No | Waitlist email (not wired yet). |

After changing schema, run migrations against Production (CI, Vercel build `db:deploy`, or locally with Production `DIRECT_URL` via dotenv — never commit those values).

### Apple Sign In (Production)

1. Enable **Sign in with Apple** on App ID `app.compass.mobile` in Apple Developer.
2. Set `APPLE_CLIENT_ID` on Vercel to the same audience the app’s identity tokens use.
3. Ship mobile builds with `COMPASS_API_BASE_URL=https://getcompass.space` (or your API host) via CI/`--dart-define` / flavor — not a checked-in secret file.

### What must never be committed

- `apps/web/.env.local`, `.env`, or any file with real `DATABASE_URL` / API keys
- Production Neon passwords, RevenueCat live keys, Apple private keys
- `COMPASS_SYNC_DEV_SECRET` in Production env (disable Dev auth)

Safe to commit: `.env.example` with placeholders only (`user:password@localhost`, commented optional keys).
