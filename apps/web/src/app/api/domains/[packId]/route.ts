import { getDomainPack } from "@compass/domains";
import { NextResponse } from "next/server";

type RouteContext = {
  params: Promise<{ packId: string }>;
};

export async function GET(_request: Request, context: RouteContext) {
  const { packId } = await context.params;
  const pack = getDomainPack(packId);

  if (!pack) {
    return NextResponse.json(
      { code: "not_found", message: `Unknown domain pack: ${packId}` },
      { status: 404 },
    );
  }

  return NextResponse.json(pack);
}
