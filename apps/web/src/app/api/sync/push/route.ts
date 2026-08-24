import { NextResponse } from "next/server";
import type { SyncPushResponse } from "@compass/api";

import { hasDatabase } from "@/lib/env";
import { applyPushChanges, parseChanges } from "@/lib/sync-engine";
import { resolveSession } from "@/lib/sync-auth";

export async function POST(request: Request) {
  if (!hasDatabase) {
    return NextResponse.json(
      { ok: false, applied: 0, cursor: "", message: "Database not configured." },
      { status: 503 },
    );
  }

  const user = await resolveSession(request.headers.get("authorization"));
  if (!user) {
    return NextResponse.json(
      { ok: false, applied: 0, cursor: "", message: "Unauthorized." },
      { status: 401 },
    );
  }

  let payload: unknown;
  try {
    payload = await request.json();
  } catch {
    return NextResponse.json(
      { ok: false, applied: 0, cursor: "", message: "Invalid JSON." },
      { status: 400 },
    );
  }

  const changes =
    typeof payload === "object" &&
    payload !== null &&
    "changes" in payload
      ? parseChanges((payload as { changes: unknown }).changes)
      : null;

  if (!changes) {
    return NextResponse.json(
      { ok: false, applied: 0, cursor: "", message: "Invalid changes." },
      { status: 400 },
    );
  }

  try {
    const result = await applyPushChanges(user.id, changes);
    const body: SyncPushResponse = {
      ok: true,
      applied: result.applied,
      cursor: result.cursor,
    };
    return NextResponse.json(body);
  } catch (error) {
    console.error("[sync/push] failed", error);
    return NextResponse.json(
      { ok: false, applied: 0, cursor: "", message: "Push failed." },
      { status: 500 },
    );
  }
}
