import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/repositories/asset_repository.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application service for asset queries and commands.
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
      final asset = await _repository.getById(id);
      return Result.success(asset);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to get asset', cause: error),
      );
    }
  }
}

final assetServiceProvider = Provider<AssetService>((ref) {
  return AssetService(ref.watch(assetRepositoryProvider));
});

final assetsListProvider = FutureProvider<List<Asset>>((ref) async {
  final result = await ref.watch(assetServiceProvider).listAssets();
  return result.valueOrNull ?? const [];
});
