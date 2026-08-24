import { NextResponse } from "next/server";
import type { SyncPullResponse } from "@compass/api";

import { hasDatabase } from "@/lib/env";
import { pullChanges } from "@/lib/sync-engine";
import { parseIso, resolveSession } from "@/lib/sync-auth";

export async function GET(request: Request) {
  if (!hasDatabase) {
    return NextResponse.json(
      {
        ok: false,
        changes: [],
        cursor: "",
        message: "Database not configured.",
      },
      { status: 503 },
    );
  }

  const user = await resolveSession(request.headers.get("authorization"));
  if (!user) {
    return NextResponse.json(
      { ok: false, changes: [], cursor: "", message: "Unauthorized." },
      { status: 401 },
    );
  }

  const url = new URL(request.url);
  const sinceRaw = url.searchParams.get("since") ?? "1970-01-01T00:00:00.000Z";
  const since = parseIso(sinceRaw);
  if (!since) {
    return NextResponse.json(
      { ok: false, changes: [], cursor: "", message: "Invalid since." },
      { status: 400 },
    );
  }

  try {
    const result = await pullChanges(user.id, since);
    const body: SyncPullResponse = {
      ok: true,
      changes: result.changes,
      cursor: result.cursor,
    };
    return NextResponse.json(body);
  } catch (error) {
    console.error("[sync/pull] failed", error);
    return NextResponse.json(
      { ok: false, changes: [], cursor: "", message: "Pull failed." },
      { status: 500 },
    );
  }
}
