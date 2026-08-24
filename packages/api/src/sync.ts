/**
 * Offline-first sync wire types (v0).
 * Protocol: docs/sync-protocol.md
 */

export type SyncEntityType =
  | "location"
  | "container"
  | "asset"
  | "asset_type";

export type SyncOp = "upsert" | "delete";

/** One mutation for push or one row/tombstone for pull. */
export interface SyncChange {
  entityType: SyncEntityType;
  entityId: string;
  op: SyncOp;
  /** ISO-8601 UTC */
  updatedAt: string;
  /** Entity JSON for upsert; omitted for delete. */
  payload?: Record<string, unknown>;
}

export interface SyncPushRequest {
  changes: SyncChange[];
}

export interface SyncPushResponse {
  ok: boolean;
  applied: number;
  /** ISO cursor after push (max updatedAt applied). */
  cursor: string;
}

export interface SyncPullResponse {
  ok: boolean;
  changes: SyncChange[];
  /** ISO cursor to store locally (max timestamp in this batch, or since if empty). */
  cursor: string;
}

export interface SyncStatusResponse {
  ok: boolean;
  userId: string;
  serverTime: string;
}

export interface AppleAuthRequest {
  identityToken: string;
  /** Optional Apple user id / email from credential (first sign-in only). */
  fullName?: string | null;
}

export interface DevAuthRequest {
  secret: string;
  deviceId: string;
}

export interface AuthResponse {
  ok: boolean;
  sessionToken: string;
  userId: string;
  expiresAt: string;
  message?: string;
}

export interface SyncApiError {
  ok: false;
  message: string;
  code?: string;
}
