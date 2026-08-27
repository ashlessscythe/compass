import type { AttributeValueType, ModuleId } from "./types";

export interface DomainPackAssetType {
  id: string;
  name: string;
  moduleId: ModuleId;
  description?: string | null;
  parentId?: string | null;
}

export interface DomainPackAttributeDefinition {
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

export interface DomainPackControlledValue {
  id: string;
  vocabularyKey: string;
  canonicalKey: string;
  label: string;
  parentId?: string | null;
}

export interface DomainPackCsvField {
  key: string;
  required?: boolean;
  attributeKey?: string;
  headerAliases: string[];
}

export interface DomainPackCsvDialect {
  id: string;
  detectHeaders: string[];
}

export interface DomainPackCsvImport {
  fields: DomainPackCsvField[];
  dialects: DomainPackCsvDialect[];
}

export type DomainPackCsvExportSource =
  | "asset.name"
  | "asset.quantity"
  | "asset.notes"
  | "asset.path";

export interface DomainPackCsvExportColumn {
  header: string;
  source?: DomainPackCsvExportSource;
  attributeKey?: string;
}

export interface DomainPackCsvExport {
  columns: DomainPackCsvExportColumn[];
}

export interface DomainPackCatalogProvider {
  id: string;
  matchKeys: string[];
}

export interface DomainPackProviders {
  catalog?: DomainPackCatalogProvider;
}

export interface DomainPack {
  id: string;
  moduleId: ModuleId;
  version: string;
  displayName: string;
  description: string;
  defaultAssetTypeId: string;
  assetTypes: DomainPackAssetType[];
  attributeDefinitions: DomainPackAttributeDefinition[];
  controlledValues: DomainPackControlledValue[];
  csvImport: DomainPackCsvImport;
  csvExport: DomainPackCsvExport;
  providers: DomainPackProviders;
}

export interface DomainPackSummary {
  id: string;
  moduleId: ModuleId;
  version: string;
  displayName: string;
  description: string;
}
