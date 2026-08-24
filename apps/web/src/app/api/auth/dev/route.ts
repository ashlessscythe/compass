import { NextResponse } from "next/server";
import type { AuthResponse } from "@compass/api";

import { getPrisma } from "@/lib/db";
import { env, hasDatabase } from "@/lib/env";
import { asIso, createSessionForUser } from "@/lib/sync-auth";

function json(body: AuthResponse, status = 200) {
  return NextResponse.json(body, { status });
}

/** Dev/simulator auth when COMPASS_SYNC_DEV_SECRET is set. */
export async function POST(request: Request) {
  if (!hasDatabase) {
    return json(
      {
        ok: false,
        sessionToken: "",
        userId: "",
        expiresAt: "",
        message: "Database is not configured.",
      },
      503,
    );
  }

  if (!env.syncDevSecret) {
    return json(
      {
        ok: false,
        sessionToken: "",
        userId: "",
        expiresAt: "",
        message: "Dev sync auth is disabled.",
      },
      404,
    );
  }

  let payload: unknown;
  try {
    payload = await request.json();
  } catch {
    return json(
      {
        ok: false,
        sessionToken: "",
        userId: "",
        expiresAt: "",
        message: "Invalid JSON body.",
      },
      400,
    );
  }

  const secret =
    typeof payload === "object" &&
    payload !== null &&
    "secret" in payload &&
    typeof (payload as { secret: unknown }).secret === "string"
      ? (payload as { secret: string }).secret
      : "";
  const deviceId =
    typeof payload === "object" &&
    payload !== null &&
    "deviceId" in payload &&
    typeof (payload as { deviceId: unknown }).deviceId === "string"
      ? (payload as { deviceId: string }).deviceId.trim().slice(0, 128)
      : "";

  if (secret !== env.syncDevSecret || !deviceId) {
    return json(
      {
        ok: false,
        sessionToken: "",
        userId: "",
        expiresAt: "",
        message: "Invalid secret or deviceId.",
      },
      401,
    );
  }

  const devKey = `dev:${deviceId}`;
  try {
    const prisma = getPrisma();
    const user = await prisma.syncUser.upsert({
      where: { devKey },
      create: { devKey },
      update: {},
    });
    const session = await createSessionForUser(user.id);
    return json({
      ok: true,
      sessionToken: session.sessionToken,
      userId: user.id,
      expiresAt: asIso(session.expiresAt),
    });
  } catch (error) {
    console.error("[auth/dev] failed", error);
    return json(
      {
        ok: false,
        sessionToken: "",
        userId: "",
        expiresAt: "",
        message: "Unable to create dev session.",
      },
      500,
    );
  }
}
