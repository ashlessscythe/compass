import { listDomainPacks } from "@compass/domains";
import { NextResponse } from "next/server";

export async function GET() {
  return NextResponse.json({ packs: listDomainPacks() });
}
