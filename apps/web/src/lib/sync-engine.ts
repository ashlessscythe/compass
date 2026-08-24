import type { SyncChange, SyncEntityType, SyncOp } from "@compass/api";

import { getPrisma } from "@/lib/db";
import { asIso, parseIso } from "@/lib/sync-auth";

function isEntityType(value: unknown): value is SyncEntityType {
  return (
    value === "location" ||
    value === "container" ||
    value === "asset" ||
    value === "asset_type"
  );
}

function isOp(value: unknown): value is SyncOp {
  return value === "upsert" || value === "delete";
}

export function parseChanges(raw: unknown): SyncChange[] | null {
  if (!Array.isArray(raw)) {
    return null;
  }
  const out: SyncChange[] = [];
  for (const item of raw) {
    if (typeof item !== "object" || item === null) {
      return null;
    }
    const row = item as Record<string, unknown>;
    if (!isEntityType(row.entityType) || !isOp(row.op)) {
      return null;
    }
    if (typeof row.entityId !== "string" || typeof row.updatedAt !== "string") {
      return null;
    }
    if (!parseIso(row.updatedAt)) {
      return null;
    }
    if (
      row.op === "upsert" &&
      (typeof row.payload !== "object" || row.payload === null)
    ) {
      return null;
    }
    out.push({
      entityType: row.entityType,
      entityId: row.entityId,
      op: row.op,
      updatedAt: row.updatedAt,
      payload:
        row.op === "upsert"
          ? (row.payload as Record<string, unknown>)
          : undefined,
    });
  }
  return out;
}

function str(payload: Record<string, unknown>, key: string): string | null {
  const v = payload[key];
  return typeof v === "string" ? v : null;
}

function strOrNull(
  payload: Record<string, unknown>,
  key: string,
): string | null {
  const v = payload[key];
  if (v === null || v === undefined) {
    return null;
  }
  return typeof v === "string" ? v : null;
}

function intOr(payload: Record<string, unknown>, key: string, fallback: number): number {
  const v = payload[key];
  return typeof v === "number" && Number.isFinite(v) ? Math.trunc(v) : fallback;
}

function metadataJson(payload: Record<string, unknown>): string {
  const meta = payload.metadata;
  if (meta && typeof meta === "object") {
    return JSON.stringify(meta);
  }
  if (typeof payload.metadataJson === "string") {
    return payload.metadataJson;
  }
  return "{}";
}

function dateField(
  payload: Record<string, unknown>,
  key: string,
  fallback: Date,
): Date {
  const v = payload[key];
  if (typeof v === "string") {
    const d = parseIso(v);
    if (d) {
      return d;
    }
  }
  return fallback;
}

async function clearTombstone(
  userId: string,
  entityType: SyncEntityType,
  entityId: string,
): Promise<void> {
  await getPrisma().syncTombstone.deleteMany({
    where: { userId, entityType, entityId },
  });
}

async function writeTombstone(
  userId: string,
  entityType: SyncEntityType,
  entityId: string,
  deletedAt: Date,
): Promise<boolean> {
  const existing = await getPrisma().syncTombstone.findUnique({
    where: {
      userId_entityType_entityId: { userId, entityType, entityId },
    },
  });
  if (existing && existing.deletedAt.getTime() > deletedAt.getTime()) {
    return false;
  }
  await getPrisma().syncTombstone.upsert({
    where: {
      userId_entityType_entityId: { userId, entityType, entityId },
    },
    create: { userId, entityType, entityId, deletedAt },
    update: { deletedAt },
  });
  return true;
}

async function applyLocationUpsert(
  userId: string,
  entityId: string,
  updatedAt: Date,
  payload: Record<string, unknown>,
): Promise<boolean> {
  const prisma = getPrisma();
  const existing = await prisma.syncLocation.findUnique({
    where: { userId_id: { userId, id: entityId } },
  });
  if (existing && existing.updatedAt.getTime() > updatedAt.getTime()) {
    return false;
  }
  const name = str(payload, "name") ?? existing?.name;
  if (!name) {
    return false;
  }
  const createdAt = dateField(payload, "createdAt", updatedAt);
  const data = {
    name,
    parentLocationId: strOrNull(payload, "parentLocationId"),
    path: strOrNull(payload, "path"),
    nfcTagId: strOrNull(payload, "nfcTagId"),
    notes: strOrNull(payload, "notes"),
    metadataJson: metadataJson(payload),
    createdAt: existing?.createdAt ?? createdAt,
    updatedAt,
  };
  await prisma.syncLocation.upsert({
    where: { userId_id: { userId, id: entityId } },
    create: { userId, id: entityId, ...data },
    update: data,
  });
  await clearTombstone(userId, "location", entityId);
  return true;
}

async function applyContainerUpsert(
  userId: string,
  entityId: string,
  updatedAt: Date,
  payload: Record<string, unknown>,
): Promise<boolean> {
  const prisma = getPrisma();
  const existing = await prisma.syncContainer.findUnique({
    where: { userId_id: { userId, id: entityId } },
  });
  if (existing && existing.updatedAt.getTime() > updatedAt.getTime()) {
    return false;
  }
  const name = str(payload, "name") ?? existing?.name;
  if (!name) {
    return false;
  }
  const createdAt = dateField(payload, "createdAt", updatedAt);
  const data = {
    name,
    parentContainerId: strOrNull(payload, "parentContainerId"),
    locationId: strOrNull(payload, "locationId"),
    nfcTagId: strOrNull(payload, "nfcTagId"),
    notes: strOrNull(payload, "notes"),
    metadataJson: metadataJson(payload),
    createdAt: existing?.createdAt ?? createdAt,
    updatedAt,
  };
  await prisma.syncContainer.upsert({
    where: { userId_id: { userId, id: entityId } },
    create: { userId, id: entityId, ...data },
    update: data,
  });
  await clearTombstone(userId, "container", entityId);
  return true;
}

async function applyAssetUpsert(
  userId: string,
  entityId: string,
  updatedAt: Date,
  payload: Record<string, unknown>,
): Promise<boolean> {
  const prisma = getPrisma();
  const existing = await prisma.syncAsset.findUnique({
    where: { userId_id: { userId, id: entityId } },
  });
  if (existing && existing.updatedAt.getTime() > updatedAt.getTime()) {
    return false;
  }
  const name = str(payload, "name") ?? existing?.name;
  const assetTypeId = str(payload, "assetTypeId") ?? existing?.assetTypeId;
  if (!name || !assetTypeId) {
    return false;
  }
  const createdAt = dateField(payload, "createdAt", updatedAt);
  const data = {
    name,
    assetTypeId,
    quantity: intOr(payload, "quantity", existing?.quantity ?? 1),
    containerId: strOrNull(payload, "containerId"),
    locationId: strOrNull(payload, "locationId"),
    notes: strOrNull(payload, "notes"),
    metadataJson: metadataJson(payload),
    createdAt: existing?.createdAt ?? createdAt,
    updatedAt,
  };
  await prisma.syncAsset.upsert({
    where: { userId_id: { userId, id: entityId } },
    create: { userId, id: entityId, ...data },
    update: data,
  });
  await clearTombstone(userId, "asset", entityId);
  return true;
}

async function applyAssetTypeUpsert(
  userId: string,
  entityId: string,
  updatedAt: Date,
  payload: Record<string, unknown>,
): Promise<boolean> {
  const prisma = getPrisma();
  const existing = await prisma.syncAssetType.findUnique({
    where: { userId_id: { userId, id: entityId } },
  });
  if (existing && existing.updatedAt.getTime() > updatedAt.getTime()) {
    return false;
  }
  const name = str(payload, "name") ?? existing?.name;
  const moduleId = str(payload, "moduleId") ?? existing?.moduleId;
  if (!name || !moduleId) {
    return false;
  }
  const createdAt = dateField(payload, "createdAt", updatedAt);
  const data = {
    name,
    moduleId,
    parentId: strOrNull(payload, "parentId"),
    description: strOrNull(payload, "description"),
    metadataJson: metadataJson(payload),
    createdAt: existing?.createdAt ?? createdAt,
    updatedAt,
  };
  await prisma.syncAssetType.upsert({
    where: { userId_id: { userId, id: entityId } },
    create: { userId, id: entityId, ...data },
    update: data,
  });
  await clearTombstone(userId, "asset_type", entityId);
  return true;
}

async function deleteEntityRow(
  userId: string,
  entityType: SyncEntityType,
  entityId: string,
): Promise<void> {
  const prisma = getPrisma();
  switch (entityType) {
    case "location":
      await prisma.syncLocation.deleteMany({ where: { userId, id: entityId } });
      break;
    case "container":
      await prisma.syncContainer.deleteMany({ where: { userId, id: entityId } });
      break;
    case "asset":
      await prisma.syncAsset.deleteMany({ where: { userId, id: entityId } });
      break;
    case "asset_type":
      await prisma.syncAssetType.deleteMany({ where: { userId, id: entityId } });
      break;
  }
}

export async function applyPushChanges(
  userId: string,
  changes: SyncChange[],
): Promise<{ applied: number; cursor: string }> {
  let applied = 0;
  let maxMs = 0;

  for (const change of changes) {
    const updatedAt = parseIso(change.updatedAt);
    if (!updatedAt) {
      continue;
    }
    maxMs = Math.max(maxMs, updatedAt.getTime());
    let ok = false;
    if (change.op === "delete") {
      const wrote = await writeTombstone(
        userId,
        change.entityType,
        change.entityId,
        updatedAt,
      );
      if (wrote) {
        await deleteEntityRow(userId, change.entityType, change.entityId);
        ok = true;
      }
    } else if (change.payload) {
      switch (change.entityType) {
        case "location":
          ok = await applyLocationUpsert(
            userId,
            change.entityId,
            updatedAt,
            change.payload,
          );
          break;
        case "container":
          ok = await applyContainerUpsert(
            userId,
            change.entityId,
            updatedAt,
            change.payload,
          );
          break;
        case "asset":
          ok = await applyAssetUpsert(
            userId,
            change.entityId,
            updatedAt,
            change.payload,
          );
          break;
        case "asset_type":
          ok = await applyAssetTypeUpsert(
            userId,
            change.entityId,
            updatedAt,
            change.payload,
          );
          break;
      }
    }
    if (ok) {
      applied += 1;
    }
  }

  const cursor =
    maxMs > 0 ? asIso(new Date(maxMs)) : asIso(new Date(0));
  return { applied, cursor };
}

function parseMeta(json: string): Record<string, unknown> {
  try {
    const v = JSON.parse(json) as unknown;
    return typeof v === "object" && v !== null
      ? (v as Record<string, unknown>)
      : {};
  } catch {
    return {};
  }
}

export async function pullChanges(
  userId: string,
  since: Date,
): Promise<{ changes: SyncChange[]; cursor: string }> {
  const prisma = getPrisma();
  const changes: SyncChange[] = [];
  let maxMs = since.getTime();

  const [locations, containers, assets, assetTypes, tombstones] =
    await Promise.all([
      prisma.syncLocation.findMany({
        where: { userId, updatedAt: { gt: since } },
      }),
      prisma.syncContainer.findMany({
        where: { userId, updatedAt: { gt: since } },
      }),
      prisma.syncAsset.findMany({
        where: { userId, updatedAt: { gt: since } },
      }),
      prisma.syncAssetType.findMany({
        where: { userId, updatedAt: { gt: since } },
      }),
      prisma.syncTombstone.findMany({
        where: { userId, deletedAt: { gt: since } },
      }),
    ]);

  for (const row of locations) {
    maxMs = Math.max(maxMs, row.updatedAt.getTime());
    changes.push({
      entityType: "location",
      entityId: row.id,
      op: "upsert",
      updatedAt: asIso(row.updatedAt),
      payload: {
        id: row.id,
        name: row.name,
        parentLocationId: row.parentLocationId,
        path: row.path,
        nfcTagId: row.nfcTagId,
        notes: row.notes,
        metadata: parseMeta(row.metadataJson),
        createdAt: asIso(row.createdAt),
        updatedAt: asIso(row.updatedAt),
      },
    });
  }

  for (const row of containers) {
    maxMs = Math.max(maxMs, row.updatedAt.getTime());
    changes.push({
      entityType: "container",
      entityId: row.id,
      op: "upsert",
      updatedAt: asIso(row.updatedAt),
      payload: {
        id: row.id,
        name: row.name,
        parentContainerId: row.parentContainerId,
        locationId: row.locationId,
        nfcTagId: row.nfcTagId,
        notes: row.notes,
        metadata: parseMeta(row.metadataJson),
        createdAt: asIso(row.createdAt),
        updatedAt: asIso(row.updatedAt),
      },
    });
  }

  for (const row of assets) {
    maxMs = Math.max(maxMs, row.updatedAt.getTime());
    changes.push({
      entityType: "asset",
      entityId: row.id,
      op: "upsert",
      updatedAt: asIso(row.updatedAt),
      payload: {
        id: row.id,
        name: row.name,
        assetTypeId: row.assetTypeId,
        quantity: row.quantity,
        containerId: row.containerId,
        locationId: row.locationId,
        notes: row.notes,
        metadata: parseMeta(row.metadataJson),
        createdAt: asIso(row.createdAt),
        updatedAt: asIso(row.updatedAt),
      },
    });
  }

  for (const row of assetTypes) {
    maxMs = Math.max(maxMs, row.updatedAt.getTime());
    changes.push({
      entityType: "asset_type",
      entityId: row.id,
      op: "upsert",
      updatedAt: asIso(row.updatedAt),
      payload: {
        id: row.id,
        name: row.name,
        moduleId: row.moduleId,
        parentId: row.parentId,
        description: row.description,
        metadata: parseMeta(row.metadataJson),
        createdAt: asIso(row.createdAt),
        updatedAt: asIso(row.updatedAt),
      },
    });
  }

  for (const row of tombstones) {
    maxMs = Math.max(maxMs, row.deletedAt.getTime());
    if (!isEntityType(row.entityType)) {
      continue;
    }
    changes.push({
      entityType: row.entityType,
      entityId: row.entityId,
      op: "delete",
      updatedAt: asIso(row.deletedAt),
    });
  }

  return { changes, cursor: asIso(new Date(maxMs)) };
}
