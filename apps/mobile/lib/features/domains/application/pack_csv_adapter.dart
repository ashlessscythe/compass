import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:compass/features/export/infrastructure/csv_collection_exporter.dart';
import 'package:compass/features/import/domain/csv_import_models.dart';
import 'package:compass/features/import/infrastructure/csv_collection_parser.dart';

/// Resolves CSV import/export from a [DomainPack] manifest.
class PackCsvAdapter {
  const PackCsvAdapter(this.pack);

  final DomainPack pack;

  CsvCollectionParser createParser() {
    return CsvCollectionParser(packImport: pack.csvImport);
  }

  CsvCollectionExporter createExporter() {
    return CsvCollectionExporter(pack: pack);
  }

  /// Metadata keys for imported CSV fields (uses pack attribute mapping).
  Map<String, dynamic> metadataValuesForRow(ImportRow row) {
    final values = <String, dynamic>{
      'import.source': row.dialectId.metadataSource,
    };

    for (final field in pack.csvImport.fields) {
      if (field.key == 'name' || field.key == 'quantity' || field.key == 'path') {
        continue;
      }
      final raw = row.fieldValues[field.key];
      if (raw == null || raw.isEmpty) {
        continue;
      }
      final attributeKey = pack.attributeKeyForCsvField(field.key) ?? field.key;
      values[attributeKey] = raw;
    }

    return values;
  }

  String? labelForAttributeValue(String attributeKey, String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    final def = pack.definitionForKey(attributeKey);
    if (def?.vocabularyKey == null) {
      return raw;
    }
    final canonical = raw.contains('.') ? raw : null;
    if (canonical != null) {
      return pack.labelForCanonicalKey(canonical) ?? raw;
    }
    return raw;
  }

  /// Resolve asset type id from a category CSV value, or null for default.
  String? assetTypeIdForCategory(String? categoryRaw) {
    if (categoryRaw == null || categoryRaw.trim().isEmpty) {
      return null;
    }
    final normalized = categoryRaw.trim().toLowerCase().replaceAll(' ', '_');
    for (final type in pack.assetTypes) {
      if (type.id.toLowerCase() == normalized ||
          type.name.toLowerCase() == categoryRaw.trim().toLowerCase()) {
        return type.id;
      }
    }
    return null;
  }
}
