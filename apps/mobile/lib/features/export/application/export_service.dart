import 'dart:io';

import 'package:compass/core/domain/entities/container.dart' as graph;
import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/features/domains/application/pack_csv_adapter.dart';
import 'package:compass/features/export/infrastructure/csv_collection_exporter.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ExportSummary {
  const ExportSummary({
    required this.assetCount,
    required this.filePath,
    required this.fileName,
  });

  final int assetCount;
  final String filePath;
  final String fileName;
}

class ExportService {
  ExportService(
    this._assetService,
    this._locationService,
    this._containerService, {
    CsvCollectionExporter? exporter,
  }) : _exporter = exporter ?? CsvCollectionExporter();

  final AssetService _assetService;
  final LocationService _locationService;
  final ContainerService _containerService;
  final CsvCollectionExporter _exporter;

  /// Build CSV text for all assets (does not write a file).
  Future<Result<String>> buildCsv() async {
    final prepared = await _prepareRows();
    if (prepared.isFailure) {
      return Result.failure(prepared.failureOrNull!);
    }
    return Result.success(_exporter.build(prepared.valueOrNull!));
  }

  /// Write a Compass-dialect CSV to a temp file and return its path.
  Future<Result<ExportSummary>> exportToTempFile() async {
    final prepared = await _prepareRows();
    if (prepared.isFailure) {
      return Result.failure(prepared.failureOrNull!);
    }
    final rows = prepared.valueOrNull!;
    final csv = _exporter.build(rows);

    try {
      final dir = await getTemporaryDirectory();
      final stamp = _dateStamp(DateTime.now().toUtc());
      final fileName = 'compass-export-$stamp.csv';
      final file = File(p.join(dir.path, fileName));
      await file.writeAsString(csv, flush: true);
      return Result.success(
        ExportSummary(
          assetCount: rows.length,
          filePath: file.path,
          fileName: fileName,
        ),
      );
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to write export file',
          cause: error,
        ),
      );
    }
  }

  Future<Result<List<CsvExportRow>>> _prepareRows() async {
    final assetsResult = await _assetService.listAssets();
    if (assetsResult.isFailure) {
      return Result.failure(assetsResult.failureOrNull!);
    }
    final locationsResult = await _locationService.listLocations();
    if (locationsResult.isFailure) {
      return Result.failure(locationsResult.failureOrNull!);
    }
    final containersResult = await _containerService.listContainers();
    if (containersResult.isFailure) {
      return Result.failure(containersResult.failureOrNull!);
    }

    final assets = assetsResult.valueOrNull ?? const [];
    final locationById = {
      for (final item in locationsResult.valueOrNull ?? const <Location>[])
        item.id: item,
    };
    final containerById = {
      for (final item
          in containersResult.valueOrNull ?? const <graph.Container>[])
        item.id: item,
    };

    final rows = [
      for (final asset in assets)
        _exporter.rowForAsset(
          asset,
          assetPath(asset, locationById, containerById),
        ),
    ];
    return Result.success(rows);
  }

  static String _dateStamp(DateTime utc) {
    final y = utc.year.toString().padLeft(4, '0');
    final m = utc.month.toString().padLeft(2, '0');
    final d = utc.day.toString().padLeft(2, '0');
    return '$y$m$d';
  }
}

final exportServiceProvider = Provider<ExportService>((ref) {
  final pack = ref.watch(mtgDomainPackProvider);
  final exporter = pack == null
      ? CsvCollectionExporter()
      : PackCsvAdapter(pack).createExporter();
  return ExportService(
    ref.watch(assetServiceProvider),
    ref.watch(locationServiceProvider),
    ref.watch(containerServiceProvider),
    exporter: exporter,
  );
});
