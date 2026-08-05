import 'package:compass/core/domain/repositories/repositories.dart';
import 'package:compass/features/assets/infrastructure/in_memory_asset_repository.dart';
import 'package:compass/features/assets/infrastructure/in_memory_asset_type_repository.dart';
import 'package:compass/features/containers/infrastructure/in_memory_container_repository.dart';
import 'package:compass/features/locations/infrastructure/in_memory_location_repository.dart';
import 'package:compass/shared/infrastructure/in_memory_history_repository.dart';
import 'package:compass/shared/infrastructure/in_memory_movement_repository.dart';
import 'package:compass/shared/infrastructure/in_memory_photo_repository.dart';
import 'package:compass/shared/infrastructure/in_memory_relationship_repository.dart';
import 'package:compass/shared/infrastructure/in_memory_tag_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  final repository = InMemoryAssetRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final assetTypeRepositoryProvider = Provider<AssetTypeRepository>((ref) {
  final repository = InMemoryAssetTypeRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final containerRepositoryProvider = Provider<ContainerRepository>((ref) {
  final repository = InMemoryContainerRepository();
  ref.onDispose(repository.dispose);
  return repository;
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final repository = InMemoryLocationRepository();
  ref.onDispose(repository.dispose);
  return repository;
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
