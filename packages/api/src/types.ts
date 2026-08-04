/**
 * Shared domain types for Compass.
 * Designed to support multiple asset modules over time.
 */

export type ModuleId =
  | "mtg"
  | "tools"
  | "jewelry"
  | "watches"
  | "clothing"
  | "lego"
  | "electronics"
  | "home"
  | "documents"
  | "camera"
  | "collectibles";

export interface Location {
  id: string;
  name: string;
  parentId: string | null;
  nfcTagId: string | null;
  path: string[];
  createdAt: string;
  updatedAt: string;
}

export interface Asset {
  id: string;
  moduleId: ModuleId;
  name: string;
  locationId: string | null;
  quantity: number;
  metadata: Record<string, unknown>;
  createdAt: string;
  updatedAt: string;
}

export interface WaitlistEntry {
  email: string;
  source?: string;
  createdAt: string;
}

export interface WaitlistResponse {
  ok: boolean;
  message: string;
}

export interface ApiError {
  code: string;
  message: string;
}
