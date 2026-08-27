/// Versioned domain pack manifest (MTG first).
class DomainPack {
  const DomainPack({
    required this.id,
    required this.moduleId,
    required this.version,
    required this.displayName,
    required this.description,
    this.tagline,
    required this.defaultAssetTypeId,
    required this.assetTypes,
    required this.attributeDefinitions,
    required this.controlledValues,
    required this.csvImport,
    required this.csvExport,
    required this.providers,
  });

  factory DomainPack.fromJson(Map<String, dynamic> json) {
    return DomainPack(
      id: json['id'] as String,
      moduleId: json['moduleId'] as String,
      version: json['version'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      tagline: json['tagline'] as String?,
      defaultAssetTypeId: json['defaultAssetTypeId'] as String,
      assetTypes: (json['assetTypes'] as List<dynamic>)
          .map((e) => DomainPackAssetType.fromJson(e as Map<String, dynamic>))
          .toList(),
      attributeDefinitions: (json['attributeDefinitions'] as List<dynamic>)
          .map(
            (e) => DomainPackAttributeDefinition.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
      controlledValues: (json['controlledValues'] as List<dynamic>)
          .map(
            (e) => DomainPackControlledValue.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      csvImport: DomainPackCsvImport.fromJson(
        json['csvImport'] as Map<String, dynamic>,
      ),
      csvExport: DomainPackCsvExport.fromJson(
        json['csvExport'] as Map<String, dynamic>,
      ),
      providers: DomainPackProviders.fromJson(
        json['providers'] as Map<String, dynamic>,
      ),
    );
  }

  final String id;
  final String moduleId;
  final String version;
  final String displayName;
  final String description;
  final String? tagline;
  final String defaultAssetTypeId;
  final List<DomainPackAssetType> assetTypes;
  final List<DomainPackAttributeDefinition> attributeDefinitions;
  final List<DomainPackControlledValue> controlledValues;
  final DomainPackCsvImport csvImport;
  final DomainPackCsvExport csvExport;
  final DomainPackProviders providers;

  String? attributeKeyForCsvField(String fieldKey) {
    for (final field in csvImport.fields) {
      if (field.key == fieldKey) {
        return field.attributeKey;
      }
    }
    return null;
  }

  DomainPackAttributeDefinition? definitionForKey(String key) {
    for (final def in attributeDefinitions) {
      if (def.key == key) {
        return def;
      }
    }
    return null;
  }

  String? labelForCanonicalKey(String? canonicalKey) {
    if (canonicalKey == null || canonicalKey.isEmpty) {
      return null;
    }
    for (final value in controlledValues) {
      if (value.canonicalKey == canonicalKey) {
        return value.label;
      }
    }
    return null;
  }
}

class DomainPackAssetType {
  const DomainPackAssetType({
    required this.id,
    required this.name,
    required this.moduleId,
    this.description,
    this.parentId,
  });

  factory DomainPackAssetType.fromJson(Map<String, dynamic> json) {
    return DomainPackAssetType(
      id: json['id'] as String,
      name: json['name'] as String,
      moduleId: json['moduleId'] as String,
      description: json['description'] as String?,
      parentId: json['parentId'] as String?,
    );
  }

  final String id;
  final String name;
  final String moduleId;
  final String? description;
  final String? parentId;
}

class DomainPackAttributeDefinition {
  const DomainPackAttributeDefinition({
    required this.id,
    required this.key,
    required this.valueType,
    this.assetTypeId,
    this.moduleId,
    this.displayName,
    this.unit,
    this.vocabularyKey,
    this.required = false,
  });

  factory DomainPackAttributeDefinition.fromJson(Map<String, dynamic> json) {
    return DomainPackAttributeDefinition(
      id: json['id'] as String,
      key: json['key'] as String,
      valueType: json['valueType'] as String,
      assetTypeId: json['assetTypeId'] as String?,
      moduleId: json['moduleId'] as String?,
      displayName: json['displayName'] as String?,
      unit: json['unit'] as String?,
      vocabularyKey: json['vocabularyKey'] as String?,
      required: json['required'] as bool? ?? false,
    );
  }

  final String id;
  final String key;
  final String valueType;
  final String? assetTypeId;
  final String? moduleId;
  final String? displayName;
  final String? unit;
  final String? vocabularyKey;
  final bool required;
}

class DomainPackControlledValue {
  const DomainPackControlledValue({
    required this.id,
    required this.vocabularyKey,
    required this.canonicalKey,
    required this.label,
    this.parentId,
  });

  factory DomainPackControlledValue.fromJson(Map<String, dynamic> json) {
    return DomainPackControlledValue(
      id: json['id'] as String,
      vocabularyKey: json['vocabularyKey'] as String,
      canonicalKey: json['canonicalKey'] as String,
      label: json['label'] as String,
      parentId: json['parentId'] as String?,
    );
  }

  final String id;
  final String vocabularyKey;
  final String canonicalKey;
  final String label;
  final String? parentId;
}

class DomainPackCsvImport {
  const DomainPackCsvImport({
    required this.fields,
    required this.dialects,
  });

  factory DomainPackCsvImport.fromJson(Map<String, dynamic> json) {
    return DomainPackCsvImport(
      fields: (json['fields'] as List<dynamic>)
          .map((e) => DomainPackCsvField.fromJson(e as Map<String, dynamic>))
          .toList(),
      dialects: (json['dialects'] as List<dynamic>)
          .map((e) => DomainPackCsvDialect.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<DomainPackCsvField> fields;
  final List<DomainPackCsvDialect> dialects;

  Set<String> headerAliasesFor(String fieldKey) {
    for (final field in fields) {
      if (field.key == fieldKey) {
        return field.headerAliases.map((h) => h.toLowerCase()).toSet();
      }
    }
    return {};
  }
}

class DomainPackCsvField {
  const DomainPackCsvField({
    required this.key,
    required this.headerAliases,
    this.required = false,
    this.attributeKey,
  });

  factory DomainPackCsvField.fromJson(Map<String, dynamic> json) {
    return DomainPackCsvField(
      key: json['key'] as String,
      headerAliases: (json['headerAliases'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      required: json['required'] as bool? ?? false,
      attributeKey: json['attributeKey'] as String?,
    );
  }

  final String key;
  final List<String> headerAliases;
  final bool required;
  final String? attributeKey;
}

class DomainPackCsvDialect {
  const DomainPackCsvDialect({
    required this.id,
    required this.detectHeaders,
  });

  factory DomainPackCsvDialect.fromJson(Map<String, dynamic> json) {
    return DomainPackCsvDialect(
      id: json['id'] as String,
      detectHeaders: (json['detectHeaders'] as List<dynamic>)
          .map((e) => (e as String).toLowerCase())
          .toList(),
    );
  }

  final String id;
  final List<String> detectHeaders;
}

class DomainPackCsvExport {
  const DomainPackCsvExport({required this.columns});

  factory DomainPackCsvExport.fromJson(Map<String, dynamic> json) {
    return DomainPackCsvExport(
      columns: (json['columns'] as List<dynamic>)
          .map(
            (e) => DomainPackCsvExportColumn.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  final List<DomainPackCsvExportColumn> columns;
}

class DomainPackCsvExportColumn {
  const DomainPackCsvExportColumn({
    required this.header,
    this.source,
    this.attributeKey,
  });

  factory DomainPackCsvExportColumn.fromJson(Map<String, dynamic> json) {
    return DomainPackCsvExportColumn(
      header: json['header'] as String,
      source: json['source'] as String?,
      attributeKey: json['attributeKey'] as String?,
    );
  }

  final String header;
  final String? source;
  final String? attributeKey;
}

class DomainPackProviders {
  const DomainPackProviders({this.catalog});

  factory DomainPackProviders.fromJson(Map<String, dynamic> json) {
    final catalogJson = json['catalog'];
    return DomainPackProviders(
      catalog: catalogJson == null
          ? null
          : DomainPackCatalogProvider.fromJson(
              catalogJson as Map<String, dynamic>,
            ),
    );
  }

  final DomainPackCatalogProvider? catalog;
}

class DomainPackCatalogProvider {
  const DomainPackCatalogProvider({
    required this.id,
    required this.matchKeys,
  });

  factory DomainPackCatalogProvider.fromJson(Map<String, dynamic> json) {
    return DomainPackCatalogProvider(
      id: json['id'] as String,
      matchKeys: (json['matchKeys'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  final String id;
  final List<String> matchKeys;
}
