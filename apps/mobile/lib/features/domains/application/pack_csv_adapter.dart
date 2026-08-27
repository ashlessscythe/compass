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
      'import.source': row.dialect.metadataSource,
    };

    void put(String fieldKey, Object? value) {
      if (value == null) {
        return;
      }
      if (value is String && value.isEmpty) {
        return;
      }
      final attributeKey = pack.attributeKeyForCsvField(fieldKey) ?? fieldKey;
      values[attributeKey] = value;
    }

    put('set', row.setValue);
    put('collectorNumber', row.collectorNumber);
    put('finish', row.finish);
    put('scryfallId', row.scryfallId);
    put('layout', row.cardForm);
    put('condition', row.condition);

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
}
