import { NextResponse } from "next/server";
import type { SyncStatusResponse } from "@compass/api";

import { hasDatabase } from "@/lib/env";
import { asIso, resolveSession } from "@/lib/sync-auth";

export async function GET(request: Request) {
  if (!hasDatabase) {
    return NextResponse.json(
      { ok: false, userId: "", serverTime: "", message: "Database not configured." },
      { status: 503 },
    );
  }

  const user = await resolveSession(request.headers.get("authorization"));
  if (!user) {
    return NextResponse.json(
      { ok: false, userId: "", serverTime: "", message: "Unauthorized." },
      { status: 401 },
    );
  }

  const body: SyncStatusResponse = {
    ok: true,
    userId: user.id,
    serverTime: asIso(new Date()),
  };
  return NextResponse.json(body);
}
