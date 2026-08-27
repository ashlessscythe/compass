import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:csv/csv.dart';

/// Builds a Compass-dialect collection CSV (plain UTF-8, editable elsewhere).
class CsvCollectionExporter {
  CsvCollectionExporter({DomainPack? pack}) : _pack = pack;

  final DomainPack? _pack;

  static const _defaultHeaders = [
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

  List<String> get headers {
    final pack = _pack;
    if (pack == null) {
      return _defaultHeaders;
    }
    return pack.csvExport.columns.map((c) => c.header).toList();
  }

  /// Convert [rows] to CSV text with a header row.
  String build(List<CsvExportRow> rows) {
    final table = <List<String>>[
      headers,
      for (final row in rows) _valuesForRow(row),
    ];
    return const ListToCsvConverter().convert(table);
  }

  List<String> _valuesForRow(CsvExportRow row) {
    final pack = _pack;
    if (pack == null) {
      return [
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
      ];
    }

    return [
      for (final column in pack.csvExport.columns)
        _valueForColumn(row, column),
    ];
  }

  String _valueForColumn(CsvExportRow row, DomainPackCsvExportColumn column) {
    final source = column.source;
    if (source == 'asset.name') {
      return row.name;
    }
    if (source == 'asset.quantity') {
      return '${row.quantity}';
    }
    if (source == 'asset.notes') {
      return row.notes ?? '';
    }
    if (source == 'asset.path') {
      return row.path;
    }

    final key = column.attributeKey;
    if (key == null) {
      return '';
    }
    return switch (key) {
      'set' => row.setValue ?? '',
      'collectorNumber' => row.collectorNumber ?? '',
      'finish' => row.finish ?? '',
      'condition' => row.condition ?? '',
      'scryfall.card_id' => row.scryfallId ?? '',
      'layout' => row.layout ?? '',
      _ => '',
    };
  }

  /// Map an [asset] + display [path] into an export row.
  CsvExportRow rowForAsset(Asset asset, String path) {
    final values = asset.metadata.values;
    return CsvExportRow(
      name: asset.name,
      quantity: asset.quantity,
      setValue: _readAttribute(values, 'set', MtgMetadataKeys.setCode),
      collectorNumber: _readAttribute(
        values,
        'collectorNumber',
        MtgMetadataKeys.collectorNumber,
      ),
      finish: _readAttribute(values, 'finish', MtgMetadataKeys.finish),
      condition: _readAttribute(values, 'condition', MtgMetadataKeys.condition),
      scryfallId: MtgMetadataKeys.scryfallIdOf(values),
      layout: _readAttribute(values, 'layout', MtgMetadataKeys.layout),
      notes: _nullIfEmpty(asset.notes),
      path: path,
    );
  }

  String? _readAttribute(
    Map<String, dynamic> values,
    String packKey,
    String legacyKey,
  ) {
    final fromPack = values[packKey];
    if (fromPack is String && fromPack.trim().isNotEmpty) {
      return fromPack.trim();
    }
    return MtgMetadataKeys.stringOf(values, legacyKey);
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
