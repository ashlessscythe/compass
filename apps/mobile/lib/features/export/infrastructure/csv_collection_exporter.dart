import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:csv/csv.dart';

/// Builds a Compass-dialect collection CSV (plain UTF-8, editable elsewhere).
class CsvCollectionExporter {
  static const headers = [
    'Name',
    'Quantity',
    'Set',
    'Collector Number',
    'Finish',
    'Condition',
    'Scryfall ID',
    'Layout',
    'Notes',
    'Path',
  ];

  /// Convert [rows] to CSV text with a header row.
  String build(List<CsvExportRow> rows) {
    final table = <List<String>>[
      headers,
      for (final row in rows)
        [
          row.name,
          '${row.quantity}',
          row.setValue ?? '',
          row.collectorNumber ?? '',
          row.finish ?? '',
          row.condition ?? '',
          row.scryfallId ?? '',
          row.layout ?? '',
          row.notes ?? '',
          row.path,
        ],
    ];
    return const ListToCsvConverter().convert(table);
  }

  /// Map an [asset] + display [path] into an export row.
  CsvExportRow rowForAsset(Asset asset, String path) {
    final values = asset.metadata.values;
    return CsvExportRow(
      name: asset.name,
      quantity: asset.quantity,
      setValue: MtgMetadataKeys.stringOf(values, MtgMetadataKeys.setCode),
      collectorNumber: MtgMetadataKeys.stringOf(
        values,
        MtgMetadataKeys.collectorNumber,
      ),
      finish: MtgMetadataKeys.stringOf(values, MtgMetadataKeys.finish),
      condition: MtgMetadataKeys.stringOf(values, MtgMetadataKeys.condition),
      scryfallId: MtgMetadataKeys.scryfallIdOf(values),
      layout: MtgMetadataKeys.stringOf(values, MtgMetadataKeys.layout),
      notes: _nullIfEmpty(asset.notes),
      path: path,
    );
  }
}

class CsvExportRow {
  const CsvExportRow({
    required this.name,
    required this.quantity,
    required this.path,
    this.setValue,
    this.collectorNumber,
    this.finish,
    this.condition,
    this.scryfallId,
    this.layout,
    this.notes,
  });

  final String name;
  final int quantity;
  final String? setValue;
  final String? collectorNumber;
  final String? finish;
  final String? condition;
  final String? scryfallId;
  final String? layout;
  final String? notes;
  final String path;
}

String? _nullIfEmpty(String? value) {
  if (value == null) {
    return null;
  }
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}
