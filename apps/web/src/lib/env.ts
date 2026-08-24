/**
 * Server-side web env. Next.js loads `apps/web/.env*` — put secrets in `.env.local`.
 *
 * Do not import this module from client components. `NEXT_PUBLIC_*` is already
 * inlined; everything else (DATABASE_URL, API keys) must stay on the server.
 *
 * Inventory truth is on-device SQLite. This database also holds Sync replica
 * tables (`sync_*`) when the sync protocol is enabled — see docs/sync-protocol.md.
 */

function optional(name: string): string | undefined {
  const value = process.env[name]?.trim();
  return value ? value : undefined;
}

export const env = {
  siteUrl: optional("NEXT_PUBLIC_SITE_URL"),
  databaseUrl: optional("DATABASE_URL"),
  resendApiKey: optional("RESEND_API_KEY"),
  waitlistNotifyTo: optional("WAITLIST_NOTIFY_TO"),
  compassApiSecret: optional("COMPASS_API_SECRET"),
  /** Apple Services ID or iOS bundle id used as JWT audience. */
  appleClientId: optional("APPLE_CLIENT_ID"),
  /** Enables POST /api/auth/dev for simulator sync testing. */
  syncDevSecret: optional("COMPASS_SYNC_DEV_SECRET"),
} as const;

export const hasDatabase = Boolean(env.databaseUrl);
