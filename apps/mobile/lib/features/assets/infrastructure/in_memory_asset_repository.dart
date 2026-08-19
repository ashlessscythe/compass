import 'dart:async';

import 'package:compass/core/domain/entities/asset.dart';
import 'package:compass/core/domain/repositories/asset_repository.dart';

/// In-memory [AssetRepository] until Drift tables are introduced.
class InMemoryAssetRepository implements AssetRepository {
  final Map<String, Asset> _store = {};
  final _controller = StreamController<List<Asset>>.broadcast();

  void _emit() => _controller.add(_store.values.toList(growable: false));

  @override
  Future<List<Asset>> getAll() async =>
      _store.values.toList(growable: false);

  @override
  Future<Asset?> getById(String id) async => _store[id];

  @override
  Stream<List<Asset>> watchAll() async* {
    yield _store.values.toList(growable: false);
    yield* _controller.stream;
  }

  @override
  Future<Asset> create(Asset asset) async {
    _store[asset.id] = asset;
    _emit();
    return asset;
  }

  @override
  Future<Asset> update(Asset asset) async {
    _store[asset.id] = asset;
    _emit();
    return asset;
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
    _emit();
  }

  @override
  Future<List<Asset>> searchByName(String query) async {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) {
      return const [];
    }
    return _store.values
        .where((asset) => asset.name.toLowerCase().contains(needle))
        .toList(growable: false);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
