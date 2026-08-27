import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:compass/features/domains/domain/domain_pack_version.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_manifest_repository.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_remote_loader.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_seeder.dart';

enum DomainPackInstallOutcome { installed, updated, unchanged }

class InstalledDomainPackInfo {
  const InstalledDomainPackInfo({
    required this.packId,
    required this.displayName,
    required this.version,
    required this.moduleId,
    required this.sourceUrl,
    required this.isBundled,
  });

  final String packId;
  final String displayName;
  final String version;
  final String moduleId;
  final String? sourceUrl;
  final bool isBundled;
}

class DomainPackInstallService {
  DomainPackInstallService({
    required DomainPackRemoteLoader remoteLoader,
    required DomainPackSeeder seeder,
    required DomainPackManifestRepository manifestRepository,
    required Set<String> bundledPackIds,
    required String Function(String packId) sourceUrlForPackId,
  })  : _remoteLoader = remoteLoader,
        _seeder = seeder,
        _manifestRepository = manifestRepository,
        _bundledPackIds = bundledPackIds,
        _sourceUrlForPackId = sourceUrlForPackId;

  final DomainPackRemoteLoader _remoteLoader;
  final DomainPackSeeder _seeder;
  final DomainPackManifestRepository _manifestRepository;
  final Set<String> _bundledPackIds;
  final String Function(String packId) _sourceUrlForPackId;

  Future<Result<List<InstalledDomainPackInfo>>> listInstalled({
    required Map<String, DomainPack> packsById,
  }) async {
    try {
      final rows = await _manifestRepository.listInstalledRows();
      final infos = <InstalledDomainPackInfo>[];
      for (final row in rows) {
        final pack = packsById[row.packId];
        infos.add(
          InstalledDomainPackInfo(
            packId: row.packId,
            displayName: pack?.displayName ?? row.packId,
            version: row.version,
            moduleId: row.moduleId,
            sourceUrl: row.sourceUrl,
            isBundled: _bundledPackIds.contains(row.packId),
          ),
        );
      }
      return Result.success(infos);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to list installed domain packs',
          cause: error,
        ),
      );
    }
  }

  Future<Result<DomainPackInstallOutcome>> installOrUpdateFromUrl(
    String url,
  ) async {
    final fetched = await _remoteLoader.fetchPackFromUrl(url);
    if (fetched.isFailure) {
      return Result.failure(fetched.failureOrNull!);
    }
    final data = fetched.valueOrNull!;
    return _persistPack(
      pack: data.pack,
      sourceUrl: url.trim(),
      manifestJson: data.rawJson,
    );
  }

  Future<Result<DomainPackInstallOutcome>> updatePack(String packId) async {
    final row = await _manifestRepository.rowForPackId(packId);
    final sourceUrl = row?.sourceUrl ?? _sourceUrlForPackId(packId);
    return installOrUpdateFromUrl(sourceUrl);
  }

  Future<Result<List<({String packId, DomainPackInstallOutcome outcome})>>>
      updateAll() async {
    final rows = await _manifestRepository.listInstalledRows();
    final results =
        <({String packId, DomainPackInstallOutcome outcome})>[];
    for (final row in rows) {
      final sourceUrl = row.sourceUrl ?? _sourceUrlForPackId(row.packId);
      final result = await installOrUpdateFromUrl(sourceUrl);
      if (result.isFailure) {
        return Result.failure(result.failureOrNull!);
      }
      results.add((packId: row.packId, outcome: result.valueOrNull!));
    }
    return Result.success(results);
  }

  Future<Result<DomainPackInstallOutcome>> _persistPack({
    required DomainPack pack,
    required String sourceUrl,
    required String manifestJson,
  }) async {
    try {
      final existing = await _manifestRepository.rowForPackId(pack.id);
      final outcome = existing == null
          ? DomainPackInstallOutcome.installed
          : DomainPackVersion.isNewer(pack.version, existing.version)
              ? DomainPackInstallOutcome.updated
              : DomainPackInstallOutcome.unchanged;

      await _manifestRepository.upsertManifest(
        pack: pack,
        sourceUrl: sourceUrl,
        manifestJson: manifestJson,
      );
      await _seeder.seedIfNeeded(pack);
      return Result.success(outcome);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to install domain pack',
          cause: error,
        ),
      );
    }
  }
}
