import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_loader.dart';
import 'package:compass/features/domains/infrastructure/domain_pack_seeder.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _activeModuleKey = 'compass.active_module_id';

/// In-memory registry of installed domain packs (bundled + seeded on init).
class DomainPackRegistry {
  DomainPackRegistry({
    required DomainPackLoader loader,
    required DomainPackSeeder seeder,
  })  : _loader = loader,
        _seeder = seeder;

  final DomainPackLoader _loader;
  final DomainPackSeeder _seeder;
  final Map<String, DomainPack> _packsById = {};

  Future<void> initialize() async {
    final packs = await _loader.loadAllBundled();
    for (final pack in packs) {
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
  final registry = DomainPackRegistry(
    loader: DomainPackLoader(),
    seeder: DomainPackSeeder(db),
  );
  await registry.initialize();
  return registry;
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
