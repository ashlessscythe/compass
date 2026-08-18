/**
 * Server-side web env. Next.js loads `apps/web/.env*` — put secrets in `.env.local`.
 *
 * Do not import this module from client components. `NEXT_PUBLIC_*` is already
 * inlined; everything else (DATABASE_URL, API keys) must stay on the server.
 *
 * Inventory is not this database. Inventory is on-device SQLite.
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
} as const;

export const hasDatabase = Boolean(env.databaseUrl);
