import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/import/domain/csv_import_models.dart';
import 'package:compass/features/import/infrastructure/csv_collection_parser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImportSummary {
  const ImportSummary({
    required this.createdCount,
    required this.skippedEmptyNames,
    required this.dialect,
    required this.containerName,
    this.warnedLargeFile = false,
  });

  final int createdCount;
  final int skippedEmptyNames;
  final CsvDialect dialect;
  final String containerName;
  final bool warnedLargeFile;
}

class ImportService {
  ImportService(
    this._assetService,
    this._containerService, {
    CsvCollectionParser? parser,
  }) : _parser = parser ?? CsvCollectionParser();

  final AssetService _assetService;
  final ContainerService _containerService;
  final CsvCollectionParser _parser;

  /// Parse CSV text without writing.
  Result<CsvParseResult> parseCsv(String content) {
    try {
      return Result.success(_parser.parse(content));
    } on CsvParseException catch (error) {
      return Result.failure(Failure.validation(message: error.message));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to parse CSV', cause: error),
      );
    }
  }

  /// Create assets from [parsed] into [containerId].
  Future<Result<ImportSummary>> importIntoContainer({
    required CsvParseResult parsed,
    required String containerId,
  }) async {
    final containerResult = await _containerService.getContainer(containerId);
    if (containerResult.isFailure) {
      return Result.failure(containerResult.failureOrNull!);
    }
    final container = containerResult.valueOrNull;
    if (container == null) {
      return Result.failure(
        Failure.notFound(entity: 'Container', id: containerId),
      );
    }

    var created = 0;
    for (final row in parsed.rows) {
      final result = await _assetService.createAsset(
        name: row.name,
        quantity: row.quantity,
        containerId: container.id,
        locationId: container.locationId,
        notes: _notesFor(row),
        metadata: _metadataFor(row),
      );
      if (result.isFailure) {
        return Result.failure(result.failureOrNull!);
      }
      created++;
    }

    return Result.success(
      ImportSummary(
        createdCount: created,
        skippedEmptyNames: parsed.skippedEmptyNames,
        dialect: parsed.dialect,
        containerName: container.name,
        warnedLargeFile: parsed.rowCount > CsvCollectionParser.warnRowThreshold,
      ),
    );
  }

  /// Parse then import in one step.
  Future<Result<ImportSummary>> importCsv({
    required String content,
    required String containerId,
  }) async {
    final parsed = parseCsv(content);
    if (parsed.isFailure) {
      return Result.failure(parsed.failureOrNull!);
    }
    return importIntoContainer(
      parsed: parsed.valueOrNull!,
      containerId: containerId,
    );
  }

  Metadata _metadataFor(ImportRow row) {
    final values = <String, dynamic>{
      'import.source': row.dialect.metadataSource,
    };
    if (row.setValue != null) {
      values['set'] = row.setValue;
    }
    if (row.collectorNumber != null) {
      values['collectorNumber'] = row.collectorNumber;
    }
    if (row.finish != null) {
      values['finish'] = row.finish;
    }
    if (row.scryfallId != null) {
      values[MtgMetadataKeys.scryfallCardId] = row.scryfallId;
    }
    return Metadata(values: values);
  }

  String? _notesFor(ImportRow row) {
    final parts = <String>[];
    if (row.setValue != null) {
      parts.add(row.setValue!);
    }
    if (row.collectorNumber != null) {
      parts.add('#${row.collectorNumber}');
    }
    if (row.finish != null) {
      parts.add(row.finish!);
    }
    if (parts.isEmpty) {
      return null;
    }
    return parts.join(' · ');
  }
}

final importServiceProvider = Provider<ImportService>((ref) {
  return ImportService(
    ref.watch(assetServiceProvider),
    ref.watch(containerServiceProvider),
  );
});
