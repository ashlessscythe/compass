import { NextResponse } from "next/server";
import type { WaitlistResponse } from "@compass/api";

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

  if (!email || !emailPattern.test(email)) {
    return json({ ok: false, message: "Please enter a valid email address." }, 400);
  }

  // Production waitlist persistence can be wired to a provider (Resend, Notion, DB).
  // For launch scaffolding we accept and acknowledge valid submissions.
  console.info("[waitlist]", { email, at: new Date().toISOString() });

  return json({
    ok: true,
    message: "You're on the list. We'll be in touch.",
  });
}
