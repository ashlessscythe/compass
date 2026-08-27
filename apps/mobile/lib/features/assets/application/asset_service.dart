import 'package:compass/core/constants/app_constants.dart';
import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/entities/metadata.dart';
import 'package:compass/core/domain/repositories/asset_repository.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/id_generator.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssetService {
  AssetService(this._repository);

  final AssetRepository _repository;

  Future<Result<List<Asset>>> listAssets() async {
    try {
      final assets = await _repository.getAll();
      return Result.success(assets);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to list assets', cause: error),
      );
    }
  }

  Future<Result<Asset?>> getAsset(String id) async {
    try {
      return Result.success(await _repository.getById(id));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to get asset', cause: error),
      );
    }
  }

  Future<Result<Asset>> createAsset({
    required String name,
    String? containerId,
    String? locationId,
    int quantity = 1,
    String? notes,
    Metadata metadata = Metadata.empty,
    String? assetTypeId,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return const Result.failure(
        Failure.validation(message: 'Name is required'),
      );
    }
    if (quantity < 1) {
      return const Result.failure(
        Failure.validation(message: 'Quantity must be at least 1'),
      );
    }

    try {
      final now = DateTime.now().toUtc();
      final asset = Asset(
        id: IdGenerator.v4(),
        name: trimmed,
        assetTypeId: assetTypeId ?? AppConstants.defaultAssetTypeId,
        createdAt: now,
        updatedAt: now,
        quantity: quantity,
        containerId: containerId,
        locationId: locationId,
        notes: notes,
        metadata: metadata,
      );
      return Result.success(await _repository.create(asset));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to create asset', cause: error),
      );
    }
  }

  Future<Result<Asset>> renameAsset({
    required String id,
    required String name,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return const Result.failure(
        Failure.validation(message: 'Name is required'),
      );
    }

    try {
      final existing = await _repository.getById(id);
      if (existing == null) {
        return Result.failure(Failure.notFound(entity: 'Asset', id: id));
      }
      final updated = existing.copyWith(
        name: trimmed,
        updatedAt: DateTime.now().toUtc(),
      );
      return Result.success(await _repository.update(updated));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to rename asset', cause: error),
      );
    }
  }

  Future<Result<void>> deleteAsset(String id) async {
    try {
      await _repository.delete(id);
      return const Result.success(null);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to delete asset', cause: error),
      );
    }
  }

  Future<Result<Asset>> moveAsset({
    required String id,
    required String containerId,
  }) async {
    try {
      final existing = await _repository.getById(id);
      if (existing == null) {
        return Result.failure(Failure.notFound(entity: 'Asset', id: id));
      }
      if (existing.containerId == containerId) {
        return Result.success(existing);
      }

      final updated = existing.copyWith(
        containerId: containerId,
        locationId: null,
        updatedAt: DateTime.now().toUtc(),
      );
      return Result.success(await _repository.update(updated));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to move asset', cause: error),
      );
    }
  }

  Future<Result<Asset>> updateMetadata({
    required String id,
    required Metadata metadata,
  }) async {
    try {
      final existing = await _repository.getById(id);
      if (existing == null) {
        return Result.failure(Failure.notFound(entity: 'Asset', id: id));
      }
      final updated = existing.copyWith(
        metadata: metadata,
        updatedAt: DateTime.now().toUtc(),
      );
      return Result.success(await _repository.update(updated));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to update asset metadata',
          cause: error,
        ),
      );
    }
  }

  Future<Result<Asset>> updatePackAttributes({
    required String id,
    required Metadata metadata,
    String? assetTypeId,
  }) async {
    try {
      final existing = await _repository.getById(id);
      if (existing == null) {
        return Result.failure(Failure.notFound(entity: 'Asset', id: id));
      }
      final updated = existing.copyWith(
        metadata: metadata,
        assetTypeId: assetTypeId ?? existing.assetTypeId,
        updatedAt: DateTime.now().toUtc(),
      );
      return Result.success(await _repository.update(updated));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to update asset details',
          cause: error,
        ),
      );
    }
  }
}

final assetServiceProvider = Provider<AssetService>((ref) {
  return AssetService(ref.watch(assetRepositoryProvider));
});

final assetsListProvider = StreamProvider<List<Asset>>((ref) {
  return ref.watch(assetRepositoryProvider).watchAll();
});
