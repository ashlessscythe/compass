import { createHash, randomBytes } from "node:crypto";

import type { SyncUser } from "@prisma/client";

import { getPrisma } from "@/lib/db";

const SESSION_TTL_MS = 1000 * 60 * 60 * 24 * 30; // 30 days

export function hashToken(token: string): string {
  return createHash("sha256").update(token).digest("hex");
}

export function createSessionToken(): string {
  return randomBytes(32).toString("base64url");
}

export async function createSessionForUser(userId: string): Promise<{
  sessionToken: string;
  expiresAt: Date;
}> {
  const sessionToken = createSessionToken();
  const expiresAt = new Date(Date.now() + SESSION_TTL_MS);
  await getPrisma().syncSession.create({
    data: {
      userId,
      tokenHash: hashToken(sessionToken),
      expiresAt,
    },
  });
  return { sessionToken, expiresAt };
}

export async function resolveSession(
  authorization: string | null,
): Promise<SyncUser | null> {
  if (!authorization?.startsWith("Bearer ")) {
    return null;
  }
  const token = authorization.slice("Bearer ".length).trim();
  if (!token) {
    return null;
  }
  const row = await getPrisma().syncSession.findUnique({
    where: { tokenHash: hashToken(token) },
    include: { user: true },
  });
  if (!row || row.expiresAt.getTime() < Date.now()) {
    return null;
  }
  return row.user;
}

export function asIso(d: Date): string {
  return d.toISOString();
}

export function parseIso(value: string): Date | null {
  const d = new Date(value);
  return Number.isNaN(d.getTime()) ? null : d;
}
