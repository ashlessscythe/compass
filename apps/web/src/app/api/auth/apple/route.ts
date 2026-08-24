import { NextResponse } from "next/server";
import type { AuthResponse } from "@compass/api";

import { verifyAppleIdentityToken } from "@/lib/apple-auth";
import { getPrisma } from "@/lib/db";
import { env, hasDatabase } from "@/lib/env";
import { asIso, createSessionForUser } from "@/lib/sync-auth";

function json(body: AuthResponse, status = 200) {
  return NextResponse.json(body, { status });
}

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

  if (!env.appleClientId) {
    return json(
      {
        ok: false,
        sessionToken: "",
        userId: "",
        expiresAt: "",
        message: "Apple Sign In is not configured.",
      },
      503,
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

  const identityToken =
    typeof payload === "object" &&
    payload !== null &&
    "identityToken" in payload &&
    typeof (payload as { identityToken: unknown }).identityToken === "string"
      ? (payload as { identityToken: string }).identityToken.trim()
      : "";

  if (!identityToken) {
    return json(
      {
        ok: false,
        sessionToken: "",
        userId: "",
        expiresAt: "",
        message: "identityToken is required.",
      },
      400,
    );
  }

  try {
    const apple = await verifyAppleIdentityToken(identityToken);
    const prisma = getPrisma();
    const user = await prisma.syncUser.upsert({
      where: { appleSub: apple.sub },
      create: { appleSub: apple.sub },
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
    console.error("[auth/apple] failed", error);
    return json(
      {
        ok: false,
        sessionToken: "",
        userId: "",
        expiresAt: "",
        message: "Unable to verify Apple identity token.",
      },
      401,
    );
  }
}
