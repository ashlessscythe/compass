import 'dart:async';

import 'package:compass/core/domain/entities/asset_type.dart';
import 'package:compass/core/domain/repositories/asset_type_repository.dart';

/// In-memory [AssetTypeRepository] until Drift tables are introduced.
class InMemoryAssetTypeRepository implements AssetTypeRepository {
  final Map<String, AssetType> _store = {};
  final _controller = StreamController<List<AssetType>>.broadcast();

  void _emit() => _controller.add(_store.values.toList(growable: false));

  @override
  Future<List<AssetType>> getAll() async =>
      _store.values.toList(growable: false);

  @override
  Future<AssetType?> getById(String id) async => _store[id];

  @override
  Stream<List<AssetType>> watchAll() async* {
    yield _store.values.toList(growable: false);
    yield* _controller.stream;
  }

  @override
  Future<AssetType> create(AssetType assetType) async {
    _store[assetType.id] = assetType;
    _emit();
    return assetType;
  }

  @override
  Future<AssetType> update(AssetType assetType) async {
    _store[assetType.id] = assetType;
    _emit();
    return assetType;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
    _emit();
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
