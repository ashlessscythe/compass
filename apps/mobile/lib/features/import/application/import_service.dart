import 'package:compass/core/domain/entities/container.dart' as graph;
import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/display_path.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/assets/application/asset_service.dart';
import 'package:compass/features/catalog/domain/mtg_metadata_keys.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/domains/application/pack_csv_adapter.dart';
import 'package:compass/features/domains/application/domain_pack_registry.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:compass/features/import/domain/csv_import_models.dart';
import 'package:compass/features/import/infrastructure/csv_collection_parser.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImportSummary {
  const ImportSummary({
    required this.createdCount,
    required this.skippedEmptyNames,
    required this.dialectId,
    required this.destinationLabel,
    required this.createdAssetIds,
    this.warnedLargeFile = false,
  });

  final int createdCount;
  final int skippedEmptyNames;
  final String dialectId;

  /// Human label for snackbars (`Binder`, `CSV paths`, …).
  final String destinationLabel;

  final List<String> createdAssetIds;
  final bool warnedLargeFile;

  /// Back-compat alias used by older call sites / tests.
  String get containerName => destinationLabel;
}

class ImportService {
  ImportService(
    this._assetService,
    this._containerService,
    this._locationService, {
    CsvCollectionParser? parser,
    DomainPack? domainPack,
  })  : _parser = parser ?? CsvCollectionParser(),
        _domainPack = domainPack;

  final AssetService _assetService;
  final ContainerService _containerService;
  final LocationService _locationService;
  final CsvCollectionParser _parser;
  final DomainPack? _domainPack;

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

  /// Create assets from [parsed] into [containerId] (Deckbox / Moxfield /
  /// generic). Compass dialect should use [importCompassPaths] instead.
  Future<Result<ImportSummary>> importIntoContainer({
    required CsvParseResult parsed,
    required String containerId,
  }) async {
    if (parsed.dialectId.isCompass) {
      return importCompassPaths(parsed: parsed);
    }

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

    final createdIds = <String>[];
    for (final row in parsed.rows) {
      final result = await _assetService.createAsset(
        name: row.name,
        quantity: row.quantity,
        containerId: container.id,
        locationId: container.locationId,
        notes: _notesFor(row),
        metadata: _metadataFor(row),
        assetTypeId: _assetTypeIdFor(row),
      );
      if (result.isFailure) {
        return Result.failure(result.failureOrNull!);
      }
      createdIds.add(result.valueOrNull!.id);
    }

    return Result.success(
      ImportSummary(
        createdCount: createdIds.length,
        skippedEmptyNames: parsed.skippedEmptyNames,
        dialectId: parsed.dialectId,
        destinationLabel: container.name,
        createdAssetIds: createdIds,
        warnedLargeFile: parsed.rowCount > CsvCollectionParser.warnRowThreshold,
      ),
    );
  }

  /// Place Compass rows using each row's Path (create missing places /
  /// containers as needed). Does not require a destination container.
  Future<Result<ImportSummary>> importCompassPaths({
    required CsvParseResult parsed,
  }) async {
    if (!parsed.dialectId.isCompass) {
      return const Result.failure(
        Failure.validation(
          message: 'Path restore is only for Compass CSV exports.',
        ),
      );
    }

    final locationsResult = await _locationService.listLocations();
    if (locationsResult.isFailure) {
      return Result.failure(locationsResult.failureOrNull!);
    }
    final containersResult = await _containerService.listContainers();
    if (containersResult.isFailure) {
      return Result.failure(containersResult.failureOrNull!);
    }

    final resolver = _PathResolver(
      locationService: _locationService,
      containerService: _containerService,
      locations: List.of(locationsResult.valueOrNull ?? const <Location>[]),
      containers: List.of(
        containersResult.valueOrNull ?? const <graph.Container>[],
      ),
    );

    final createdIds = <String>[];
    for (final row in parsed.rows) {
      final placement = await resolver.resolve(
        assetName: row.name,
        path: row.path,
      );
      if (placement.isFailure) {
        return Result.failure(placement.failureOrNull!);
      }
      final slot = placement.valueOrNull!;
      final result = await _assetService.createAsset(
        name: row.name,
        quantity: row.quantity,
        containerId: slot.containerId,
        locationId: slot.locationId,
        notes: _notesFor(row),
        metadata: _metadataFor(row),
        assetTypeId: _assetTypeIdFor(row),
      );
      if (result.isFailure) {
        return Result.failure(result.failureOrNull!);
      }
      createdIds.add(result.valueOrNull!.id);
    }

    return Result.success(
      ImportSummary(
        createdCount: createdIds.length,
        skippedEmptyNames: parsed.skippedEmptyNames,
        dialectId: parsed.dialectId,
        destinationLabel: 'CSV paths',
        createdAssetIds: createdIds,
        warnedLargeFile: parsed.rowCount > CsvCollectionParser.warnRowThreshold,
      ),
    );
  }

  /// Parse then import in one step.
  Future<Result<ImportSummary>> importCsv({
    required String content,
    String? containerId,
  }) async {
    final parsed = parseCsv(content);
    if (parsed.isFailure) {
      return Result.failure(parsed.failureOrNull!);
    }
    final result = parsed.valueOrNull!;
    if (result.dialectId.isCompass) {
      return importCompassPaths(parsed: result);
    }
    if (containerId == null || containerId.isEmpty) {
      return const Result.failure(
        Failure.validation(message: 'Choose a destination container.'),
      );
    }
    return importIntoContainer(
      parsed: result,
      containerId: containerId,
    );
  }

  Metadata _metadataFor(ImportRow row) {
    final pack = _domainPack;
    if (pack != null) {
      return Metadata(
        values: PackCsvAdapter(pack).metadataValuesForRow(row),
      );
    }
    final values = <String, dynamic>{
      'import.source': row.dialectId.metadataSource,
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
    if (row.cardForm != null) {
      values[MtgMetadataKeys.layout] = row.cardForm;
    }
    if (row.condition != null) {
      values[MtgMetadataKeys.condition] = row.condition;
    }
    return Metadata(values: values);
  }

  String? _assetTypeIdFor(ImportRow row) {
    final pack = _domainPack;
    if (pack == null) {
      return null;
    }
    final fromCategory =
        PackCsvAdapter(pack).assetTypeIdForCategory(row.field('category'));
    return fromCategory ?? pack.defaultAssetTypeId;
  }

  String? _notesFor(ImportRow row) {
    if (_domainPack != null) {
      return null;
    }
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

class _Placement {
  const _Placement({this.locationId, this.containerId});

  final String? locationId;
  final String? containerId;
}

/// Resolves Compass Path strings onto the location/container graph.
class _PathResolver {
  _PathResolver({
    required LocationService locationService,
    required ContainerService containerService,
    required List<Location> locations,
    required List<graph.Container> containers,
  })  : _locationService = locationService,
        _containerService = containerService,
        _locations = locations,
        _containers = containers;

  final LocationService _locationService;
  final ContainerService _containerService;
  final List<Location> _locations;
  final List<graph.Container> _containers;

  Future<Result<_Placement>> resolve({
    required String assetName,
    required String? path,
  }) async {
    final segments = _segmentsFor(path: path, assetName: assetName);
    if (segments.isEmpty) {
      return const Result.failure(
        Failure.validation(
          message: 'Compass CSV rows need a Path (or a place name).',
        ),
      );
    }

    final match = _longestLocationPrefix(segments);
    if (match != null) {
      final remaining = segments.sublist(match.segmentCount);
      if (remaining.isEmpty) {
        return Result.success(_Placement(locationId: match.location.id));
      }
      return _ensureContainerChain(
        locationId: match.location.id,
        names: remaining,
      );
    }

    // Fresh path: nested places for all but last, last segment = container
    // when there are 2+ segments; single segment = place only.
    if (segments.length == 1) {
      final location = await _ensureLocation(
        name: segments.first,
        parentLocationId: null,
      );
      if (location.isFailure) {
        return Result.failure(location.failureOrNull!);
      }
      return Result.success(_Placement(locationId: location.valueOrNull!.id));
    }

    Location? parent;
    for (var i = 0; i < segments.length - 1; i++) {
      final created = await _ensureLocation(
        name: segments[i],
        parentLocationId: parent?.id,
      );
      if (created.isFailure) {
        return Result.failure(created.failureOrNull!);
      }
      parent = created.valueOrNull;
    }
    return _ensureContainerChain(
      locationId: parent!.id,
      names: [segments.last],
    );
  }

  Future<Result<_Placement>> _ensureContainerChain({
    required String locationId,
    required List<String> names,
  }) async {
    String? parentContainerId;
    graph.Container? current;
    for (final name in names) {
      final ensured = await _ensureContainer(
        name: name,
        locationId: locationId,
        parentContainerId: parentContainerId,
      );
      if (ensured.isFailure) {
        return Result.failure(ensured.failureOrNull!);
      }
      current = ensured.valueOrNull;
      parentContainerId = current!.id;
    }
    return Result.success(
      _Placement(locationId: locationId, containerId: current?.id),
    );
  }

  Future<Result<Location>> _ensureLocation({
    required String name,
    required String? parentLocationId,
  }) async {
    for (final item in _locations) {
      if (item.name == name && item.parentLocationId == parentLocationId) {
        return Result.success(item);
      }
    }
    final created = await _locationService.createLocation(
      name: name,
      parentLocationId: parentLocationId,
    );
    if (created.isSuccess) {
      _locations.add(created.valueOrNull!);
    }
    return created;
  }

  Future<Result<graph.Container>> _ensureContainer({
    required String name,
    required String locationId,
    required String? parentContainerId,
  }) async {
    for (final item in _containers) {
      if (item.name == name &&
          item.locationId == locationId &&
          item.parentContainerId == parentContainerId) {
        return Result.success(item);
      }
    }
    final created = await _containerService.createContainer(
      name: name,
      locationId: locationId,
      parentContainerId: parentContainerId,
    );
    if (created.isSuccess) {
      _containers.add(created.valueOrNull!);
    }
    return created;
  }

  ({Location location, int segmentCount})? _longestLocationPrefix(
    List<String> segments,
  ) {
    ({Location location, int segmentCount})? best;
    for (final location in _locations) {
      final path = location.path?.trim();
      if (path == null || path.isEmpty) {
        continue;
      }
      final locSegments = _splitPath(path);
      if (!_isPrefix(locSegments, segments)) {
        continue;
      }
      if (best == null || locSegments.length > best.segmentCount) {
        best = (location: location, segmentCount: locSegments.length);
      }
    }
    return best;
  }

  static List<String> _segmentsFor({
    required String? path,
    required String assetName,
  }) {
    final raw = path?.trim();
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    final segments = _splitPath(raw);
    if (segments.isNotEmpty &&
        segments.last.toLowerCase() == assetName.trim().toLowerCase()) {
      return segments.sublist(0, segments.length - 1);
    }
    return segments;
  }

  static List<String> _splitPath(String path) {
    return [
      for (final part in path.split(DisplayPath.separator))
        if (part.trim().isNotEmpty) part.trim(),
    ];
  }

  static bool _isPrefix(List<String> prefix, List<String> full) {
    if (prefix.length > full.length) {
      return false;
    }
    for (var i = 0; i < prefix.length; i++) {
      if (prefix[i] != full[i]) {
        return false;
      }
    }
    return true;
  }
}

final importServiceProvider = Provider.family<ImportService, String>((ref, moduleId) {
  final pack = ref.watch(domainPackRegistryProvider).valueOrNull?.packForModule(
        moduleId,
      );
  final parser = pack == null
      ? CsvCollectionParser()
      : PackCsvAdapter(pack).createParser();
  return ImportService(
    ref.watch(assetServiceProvider),
    ref.watch(containerServiceProvider),
    ref.watch(locationServiceProvider),
    parser: parser,
    domainPack: pack,
  );
});
