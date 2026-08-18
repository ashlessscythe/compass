import { NextResponse } from "next/server";
import type { WaitlistResponse } from "@compass/api";

import { getPrisma } from "@/lib/db";
import { hasDatabase } from "@/lib/env";

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

function json(body: WaitlistResponse, status = 200) {
  return NextResponse.json(body, { status });
}

export async function POST(request: Request) {
  let payload: unknown;

  try {
    payload = await request.json();
  } catch {
    return json({ ok: false, message: "Invalid JSON body." }, 400);
  }

  const email =
    typeof payload === "object" &&
    payload !== null &&
    "email" in payload &&
    typeof (payload as { email: unknown }).email === "string"
      ? (payload as { email: string }).email.trim().toLowerCase()
      : "";

  const source =
    typeof payload === "object" &&
    payload !== null &&
    "source" in payload &&
    typeof (payload as { source: unknown }).source === "string"
      ? (payload as { source: string }).source.trim().slice(0, 64)
      : undefined;

  if (!email || !emailPattern.test(email)) {
    return json({ ok: false, message: "Please enter a valid email address." }, 400);
  }

  if (!hasDatabase) {
    return json(
      { ok: false, message: "Waitlist storage is not configured." },
      503,
    );
  }

  try {
    await getPrisma().waitlistEntry.upsert({
      where: { email },
      create: { email, source: source || undefined },
      update: {},
    });
  } catch (error) {
    console.error("[waitlist] persist failed", error);
    return json(
      { ok: false, message: "Unable to join the waitlist right now." },
      500,
    );
  }

  return json({
    ok: true,
    message: "You're on the list. We'll be in touch.",
  });
}
