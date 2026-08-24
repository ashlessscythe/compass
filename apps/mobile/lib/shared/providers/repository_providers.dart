import 'package:compass/core/domain/repositories/repositories.dart';
import 'package:compass/features/assets/infrastructure/drift_asset_repository.dart';
import 'package:compass/features/assets/infrastructure/drift_asset_type_repository.dart';
import 'package:compass/features/containers/infrastructure/drift_container_repository.dart';
import 'package:compass/features/locations/infrastructure/drift_location_repository.dart';
import 'package:compass/features/sync/infrastructure/sync_local_store.dart';
import 'package:compass/shared/infrastructure/in_memory_history_repository.dart';
import 'package:compass/shared/infrastructure/in_memory_movement_repository.dart';
import 'package:compass/shared/infrastructure/in_memory_photo_repository.dart';
import 'package:compass/shared/infrastructure/in_memory_relationship_repository.dart';
import 'package:compass/shared/infrastructure/in_memory_tag_repository.dart';
import 'package:compass/shared/providers/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final syncLocalStoreProvider = Provider<SyncLocalStore>((ref) {
  return SyncLocalStore(ref.watch(appDatabaseProvider));
});

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  return DriftAssetRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(syncLocalStoreProvider),
  );
});

final assetTypeRepositoryProvider = Provider<AssetTypeRepository>((ref) {
  return DriftAssetTypeRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(syncLocalStoreProvider),
  );
});

final containerRepositoryProvider = Provider<ContainerRepository>((ref) {
  return DriftContainerRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(syncLocalStoreProvider),
  );
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return DriftLocationRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(syncLocalStoreProvider),
  );
});

final movementRepositoryProvider = Provider<MovementRepository>((ref) {
  final repository = InMemoryMovementRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final relationshipRepositoryProvider = Provider<RelationshipRepository>((ref) {
  final repository = InMemoryRelationshipRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final repository = InMemoryHistoryRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final repository = InMemoryTagRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  final repository = InMemoryPhotoRepository();
  ref.onDispose(repository.dispose);
  return repository;
});
