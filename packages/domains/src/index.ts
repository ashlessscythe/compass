import type { DomainPack, DomainPackSummary } from "@compass/api";

import mtgV1 from "../packs/mtg/v1.json";
import jewelryV1 from "../packs/jewelry/v1.json";

const packs: Record<string, DomainPack> = {
  mtg: mtgV1 as DomainPack,
  jewelry: jewelryV1 as DomainPack,
};

/** All published domain pack ids. */
export const domainPackIds = Object.keys(packs);

/** Summaries for list endpoints. */
export function listDomainPacks(): DomainPackSummary[] {
  return domainPackIds.map((id) => {
    const pack = packs[id]!;
    return {
      id: pack.id,
      moduleId: pack.moduleId,
      version: pack.version,
      displayName: pack.displayName,
      description: pack.description,
    };
  });
}

/** Full manifest for one pack, or undefined when unknown. */
export function getDomainPack(packId: string): DomainPack | undefined {
  return packs[packId];
}

export { mtgV1, jewelryV1 };
export type { DomainPack, DomainPackSummary } from "@compass/api";
