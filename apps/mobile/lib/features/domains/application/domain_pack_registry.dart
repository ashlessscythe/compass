import 'package:compass/features/domains/application/domain_pack_install_service.dart';
import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:compass/features/domains/domain/domain_pack_version.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_loader.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_manifest_repository.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_remote_loader.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_seeder.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _activeModuleKey = 'compass.active_module_id';

/// In-memory registry of installed domain packs (bundled + cached remote).
class DomainPackRegistry {
  DomainPackRegistry({
    required DomainPackLoader loader,
    required DomainPackSeeder seeder,
    required DomainPackManifestRepository manifestRepository,
  })  : _loader = loader,
        _seeder = seeder,
        _manifestRepository = manifestRepository;

  final DomainPackLoader _loader;
  final DomainPackSeeder _seeder;
  final DomainPackManifestRepository _manifestRepository;
  final Map<String, DomainPack> _packsById = {};

  Future<void> initialize() async {
    _packsById.clear();
    final bundled = await _loader.loadAllBundled();

    for (final pack in bundled) {
      final raw = await _loader.loadBundledRaw(pack.id);
      await _manifestRepository.backfillBundledIfMissing(
        pack: pack,
        sourceUrl: _loader.sourceUrlForPackId(pack.id),
        manifestJson: raw,
      );
    }

    final cached = await _manifestRepository.loadCachedPacks();
    final merged = <String, DomainPack>{
      for (final pack in bundled) pack.id: pack,
    };
    for (final pack in cached) {
      final existing = merged[pack.id];
      if (existing == null ||
          DomainPackVersion.isNewer(pack.version, existing.version)) {
        merged[pack.id] = pack;
      }
    }

    for (final pack in merged.values) {
      await _seeder.seedIfNeeded(pack);
      _packsById[pack.id] = pack;
    }
  }

  List<DomainPack> get installedPacks =>
      _packsById.values.toList(growable: false);

  DomainPack? packForModule(String moduleId) {
    for (final pack in _packsById.values) {
      if (pack.moduleId == moduleId) {
        return pack;
      }
    }
    return null;
  }

  DomainPack? packById(String packId) => _packsById[packId];

  DomainPack? get mtgPack => _packsById['mtg'];
}

final domainPackRegistryProvider = FutureProvider<DomainPackRegistry>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final loader = DomainPackLoader();
  final registry = DomainPackRegistry(
    loader: loader,
    seeder: DomainPackSeeder(db),
    manifestRepository: DomainPackManifestRepository(db),
  );
  await registry.initialize();
  return registry;
});

final domainPackInstallServiceProvider = Provider<DomainPackInstallService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final loader = DomainPackLoader();
  return DomainPackInstallService(
    remoteLoader: DomainPackRemoteLoader(),
    seeder: DomainPackSeeder(db),
    manifestRepository: DomainPackManifestRepository(db),
    bundledPackIds: DomainPackLoader.bundledPackAssets.keys.toSet(),
    sourceUrlForPackId: loader.sourceUrlForPackId,
  );
});

final installedDomainPacksProvider = Provider<AsyncValue<List<DomainPack>>>((ref) {
  return ref.watch(domainPackRegistryProvider).when(
        data: (registry) => AsyncValue.data(registry.installedPacks),
        loading: () => const AsyncValue.loading(),
        error: AsyncValue.error,
      );
});

final activeModuleIdProvider =
    StateNotifierProvider<ActiveModuleNotifier, String?>((ref) {
  return ActiveModuleNotifier();
});

class ActiveModuleNotifier extends StateNotifier<String?> {
  ActiveModuleNotifier() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_activeModuleKey);
  }

  Future<void> setModule(String? moduleId) async {
    state = moduleId;
    final prefs = await SharedPreferences.getInstance();
    if (moduleId == null) {
      await prefs.remove(_activeModuleKey);
    } else {
      await prefs.setString(_activeModuleKey, moduleId);
    }
  }
}

final activeDomainPackProvider = Provider<AsyncValue<DomainPack?>>((ref) {
  final moduleId = ref.watch(activeModuleIdProvider);
  final registryAsync = ref.watch(domainPackRegistryProvider);
  return registryAsync.when(
    data: (registry) {
      if (moduleId == null) {
        return const AsyncValue.data(null);
      }
      return AsyncValue.data(registry.packForModule(moduleId));
    },
    loading: () => const AsyncValue.loading(),
    error: AsyncValue.error,
  );
});

/// Resolved MTG pack for import/export/catalog wiring.
final mtgDomainPackProvider = Provider<DomainPack?>((ref) {
  return ref.watch(domainPackRegistryProvider).valueOrNull?.mtgPack;
});

/// Reload registry after remote install or update.
void invalidateDomainPackRegistry(WidgetRef ref) {
  ref.invalidate(domainPackRegistryProvider);
}
