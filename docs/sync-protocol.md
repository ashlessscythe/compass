# Offline-first sync protocol (v0)

Local SQLite remains the source of truth. Cloud Postgres is a Sync-paid **replica** for backup and multi-device catch-up. See [architecture.md](./architecture.md) and [monetization.md](./monetization.md).

## Goals

1. Writes always succeed offline against on-device Drift.
2. When online and Sync-entitled, devices push pending mutations and pull remote changes.
3. Conflicts resolve with **last-write-wins** on `updatedAt` (UTC ISO timestamps).
4. Sync expiry never locks local inventory; only cloud push/pull stops.
5. Catalog caches, themes, and Scryfall art are **not** synced.

## Scope (v0)

**Synced:** `location`, `container`, `asset`, `asset_type`.

**Not synced:** `card_printings`, `catalog_meta`, theme prefs, Scryfall JPG cache, photos, tags, history.

## Change unit

```text
{
  entityType: "location" | "container" | "asset" | "asset_type",
  entityId: string,
  op: "upsert" | "delete",
  updatedAt: string,  // ISO-8601 UTC
  payload?: object    // required for upsert; entity JSON
}
```

Deletes are hard-deleted locally after an outbox `delete` is recorded. The cloud keeps a **tombstone** so other devices remove the row on pull.

## Endpoints

| Method | Path | Role |
|--------|------|------|
| `POST` | `/api/auth/apple` | Exchange Apple identity token → session |
| `POST` | `/api/auth/dev` | Dev-only session when `COMPASS_SYNC_DEV_SECRET` is set |
| `POST` | `/api/sync/push` | Apply client changes (LWW by `updatedAt`) |
| `GET` | `/api/sync/pull?since=` | Changes + tombstones after cursor |
| `GET` | `/api/sync/status` | Auth check + server clock |

All sync routes require `Authorization: Bearer <sessionToken>`.

## Push

For each change, scoped to the authenticated user:

- **upsert:** if no row, or incoming `updatedAt` >= stored `updatedAt`, write row and clear any tombstone for that entity.
- **delete:** remove entity row (if present) and upsert a tombstone with `deletedAt = updatedAt` when incoming time wins.

Unauthenticated requests return 401. Entitlement is enforced on the client (`canUse(cloudSync)`); server trusts a valid session in v0 (RevenueCat server check is Later).

## Pull

Return upserts for user-scoped rows with `updatedAt > since`, plus tombstones with `deletedAt > since`. Client applies LWW into SQLite (skip if local `updatedAt` is newer), hard-deletes on tombstones, recomputes location `path` after location applies, and advances `sync_state.cursor` to the max timestamp received.

## Client outbox

Every local create/update/delete on graph repositories enqueues a change in the same SQLite transaction. Remote applies **do not** enqueue. On first successful sign-in, if the device has never completed a sync, the engine enqueues a full local snapshot before push.

## Multi-device testing (Dev auth)

Dev sign-in scopes the cloud user by `dev:{deviceId}`. App delete clears SharedPreferences, so a new random `deviceId` creates a **new** empty SyncUser.

To simulate the **same** user on a fresh install, pass a fixed id:

```bash
flutter run -d "iPhone 17 Pro" \
  --dart-define=COMPASS_API_BASE_URL=http://localhost:3000 \
  --dart-define=COMPASS_SYNC_DEV_SECRET=local-dev-only \
  --dart-define=COMPASS_SYNC_DEV_DEVICE_ID=test-user-1
```

Both “devices” that use `test-user-1` share one `sync_users` row (`dev:test-user-1`) and the same graph replica. Sign in → Sync now on the empty device to pull.

Production Apple Sign In already uses a stable `apple_sub` across devices — no fixed id needed.

### TestFlight / release builds

When `COMPASS_SYNC_DEV_SECRET` is baked into the app at build time (`--dart-define`), Sync entitlements unlock and Dev sign-in works in release IPA/APK. See [environment.md](./environment.md) for build commands and cleanup.

## Auth

- **Production:** Sign in with Apple. Server verifies the identity token against Apple’s JWKS (`aud` = Apple Services ID / bundle id).
- **Dev / simulator:** `POST /api/auth/dev` with shared secret + stable device id when `COMPASS_SYNC_DEV_SECRET` is configured.

Sessions are opaque tokens stored hashed server-side with an expiry.

## Environment

Local and Production variable checklist (Vercel, Apple, Neon, Dev auth off in prod): [environment.md](./environment.md).

## Retention after Sync cancel

Cloud replica data is retained for **30 days** after Sync entitlement lapses. After that, the account’s sync tables may be purged. Local SQLite is unaffected. (Automated purge is Later; policy is documented here for product copy.)

## Explicitly out of v0

Firebase, SQLite file upload, photo object storage, Sync Plus / sharing, web collection browser, App Store Sync SKU cutover, manual conflict UI, CRDTs.
