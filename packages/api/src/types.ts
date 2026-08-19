/**
 * Shared domain types for Compass.
 * Vertical fields never live on Asset — see docs/taxonomy.md.
 */

export type ModuleId =
  | "mtg"
  | "tools"
  | "jewelry"
  | "watches"
  | "clothing"
  | "shoes"
  | "lego"
  | "electronics"
  | "home"
  | "documents"
  | "camera"
  | "books"
  | "collectibles";

export type EntityKind =
  | "asset"
  | "asset_type"
  | "controlled_value"
  | "taxonomy_node"
  | "location"
  | "container";

export type AttributeValueType =
  | "string"
  | "integer"
  | "decimal"
  | "boolean"
  | "date"
  | "date_range"
  | "enum"
  | "multi_select"
  | "reference"
  | "measurement"
  | "currency"
  | "url"
  | "identifier";

export interface Location {
  id: string;
  name: string;
  parentId: string | null;
  nfcTagId: string | null;
  path: string[];
  createdAt: string;
  updatedAt: string;
}

export interface Container {
  id: string;
  name: string;
  parentContainerId: string | null;
  locationId: string | null;
  nfcTagId: string | null;
  notes: string | null;
  createdAt: string;
  updatedAt: string;
}

/** Generic tracked item. Domain fields belong in attributes / metadata. */
export interface Asset {
  id: string;
  name: string;
  assetTypeId: string;
  quantity: number;
  locationId: string | null;
  containerId: string | null;
  notes: string | null;
  /**
   * Interim bag for module-specific values until attribute tables persist.
   * Prefer canonical keys (e.g. material.gold.14k), not alias strings.
   */
  metadata: Record<string, unknown>;
  createdAt: string;
  updatedAt: string;
}

export interface AssetType {
  id: string;
  name: string;
  moduleId: ModuleId;
  parentId: string | null;
  description: string | null;
  createdAt: string;
  updatedAt: string;
}

export interface AttributeDefinition {
  id: string;
  key: string;
  valueType: AttributeValueType;
  assetTypeId?: string | null;
  moduleId?: ModuleId | null;
  displayName?: string | null;
  unit?: string | null;
  vocabularyKey?: string | null;
  required?: boolean;
}

/**
 * One typed value on one asset.
 * Enums and references store a canonical key, not a display alias.
 */
export interface AttributeValue {
  id: string;
  assetId: string;
  definitionId: string;
  value: unknown;
  unit?: string | null;
  controlledValueId?: string | null;
}

export interface ControlledValue {
  id: string;
  vocabularyKey: string;
  /** Stable id such as `material.gold.14k`. */
  canonicalKey: string;
  label: string;
  parentId?: string | null;
}

export interface ExternalIdentifier {
  id: string;
  entityId: string;
  entityKind: EntityKind;
  source: string;
  externalId: string;
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
