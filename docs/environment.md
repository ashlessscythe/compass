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

### Mobile (RevenueCat public SDK key)

The Apple public SDK key (`appl_…`) is **not** loaded from `apps/web/.env.local`. Pass it at compile time:

```bash
flutter run -d "iPhone 17 Pro" \
  --dart-define=REVENUECAT_API_KEY=appl_xxx
```

Without this define, the app uses Fake entitlements (Debug tier). Details: [apps/mobile/docs/entitlements.md](../apps/mobile/docs/entitlements.md).

### TestFlight / APK dev sync (temporary)

To test Sync on release builds without a store purchase, bake the same dev secret the server expects. This unlocks Sync entitlements and **Dev sign-in** in IPA/APK (no Debug tier needed). Purchasable Sync (`compass_sync_monthly` / yearly) is the real path; keep the secret only until a public release.

**Server:** set `COMPASS_SYNC_DEV_SECRET` on the deploy env (must match the build). Remove when testing ends.

**iOS:**
```bash
flutter build ipa \
  --dart-define=COMPASS_API_BASE_URL=https://getcompass.space \
  --dart-define=COMPASS_SYNC_DEV_SECRET=your-secret-here \
  --dart-define=COMPASS_SYNC_DEV_DEVICE_ID=test-user-1
```

**Android:**
```bash
flutter build apk --release \
  --dart-define=COMPASS_API_BASE_URL=https://getcompass.space \
  --dart-define=COMPASS_SYNC_DEV_SECRET=your-secret-here \
  --dart-define=COMPASS_SYNC_DEV_DEVICE_ID=test-user-1
```

In app: **Settings → Sync → Dev sign-in → Sync now**.

**Security:** the secret is extractable from the binary. Remove it from **both** build args and production server before a public App Store release. Do not commit the secret to git.

## Production (Vercel + Neon)

Set these in the Vercel project → **Settings → Environment Variables** for Production (and Preview if you use Preview DBs).

| Variable | Required | Notes |
|----------|----------|--------|
| `DATABASE_URL` | Yes | Neon **pooled** URL (`-pooler` host). Used by the Next.js runtime / Prisma Client. |
| `DIRECT_URL` | Yes | Neon **unpooled** URL (no `-pooler`). Used by Prisma migrate. |
| `NEXT_PUBLIC_SITE_URL` | Yes | Canonical site URL, e.g. `https://getcompass.space`. |
| `APPLE_CLIENT_ID` | Yes for Sync | JWT `aud` for Sign in with Apple — iOS bundle id `app.compass.mobile` or your Services ID. |
| `COMPASS_SYNC_DEV_SECRET` | **No** | Temporary only: enables `/api/auth/dev` for TestFlight sync testing. Remove before public release. |
| `COMPASS_API_SECRET` | No | Reserved; unused in v0. |
| `RESEND_API_KEY` / `WAITLIST_NOTIFY_TO` | No | Waitlist email (not wired yet). |

After changing schema, run migrations against Production (CI, Vercel build `db:deploy`, or locally with Production `DIRECT_URL` via dotenv — never commit those values).

### Apple Sign In (Production)

1. Enable **Sign in with Apple** on App ID `app.compass.mobile` in Apple Developer.
2. Set `APPLE_CLIENT_ID` on Vercel to the same audience the app’s identity tokens use.
3. Ship mobile builds with `COMPASS_API_BASE_URL=https://getcompass.space` (or your API host) via CI/`--dart-define` / flavor — not a checked-in secret file.

### What must never be committed

- `apps/web/.env.local`, `.env`, or any file with real `DATABASE_URL` / API keys
- Production Neon passwords, RevenueCat live **secret** (`sk_`) keys, Apple private keys
- `COMPASS_SYNC_DEV_SECRET` on production (disable Dev auth when testing ends)

Safe to commit: `.env.example` with placeholders only (`user:password@localhost`, commented optional keys).

## Cleanup after dev sync testing

1. Remove `COMPASS_SYNC_DEV_SECRET` from Vercel / production env.
2. Ship IPA/APK **without** `--dart-define=COMPASS_SYNC_DEV_SECRET`.
