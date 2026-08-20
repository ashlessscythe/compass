import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/domain/repositories/location_repository.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/display_path.dart';
import 'package:compass/core/utils/id_generator.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationService {
  LocationService(this._repository);

  final LocationRepository _repository;

  Future<Result<List<Location>>> listLocations() async {
    try {
      final locations = await _repository.getAll();
      return Result.success(locations);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to list locations', cause: error),
      );
    }
  }

  Future<Result<Location?>> getLocation(String id) async {
    try {
      return Result.success(await _repository.getById(id));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to get location', cause: error),
      );
    }
  }

  Future<Result<Location>> createLocation({
    required String name,
    String? parentLocationId,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return const Result.failure(
        Failure.validation(message: 'Name is required'),
      );
    }

    try {
      final now = DateTime.now().toUtc();
      final parent = parentLocationId == null
          ? null
          : await _repository.getById(parentLocationId);
      final location = Location(
        id: IdGenerator.v4(),
        name: trimmed,
        createdAt: now,
        updatedAt: now,
        parentLocationId: parentLocationId,
        path: DisplayPath.join(parent?.path, trimmed),
      );
      return Result.success(await _repository.create(location));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to create location', cause: error),
      );
    }
  }

  Future<Result<Location>> renameLocation({
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
        return Result.failure(Failure.notFound(entity: 'Location', id: id));
      }
      final parent = existing.parentLocationId == null
          ? null
          : await _repository.getById(existing.parentLocationId!);
      final updated = existing.copyWith(
        name: trimmed,
        path: DisplayPath.join(parent?.path, trimmed),
        updatedAt: DateTime.now().toUtc(),
      );
      await _repository.update(updated);
      await _recomputeDescendantPaths(updated);
      return Result.success(updated);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to rename location', cause: error),
      );
    }
  }

  Future<Result<void>> deleteLocation(String id) async {
    try {
      await _repository.delete(id);
      return const Result.success(null);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to delete location', cause: error),
      );
    }
  }

  Future<Result<Location>> moveLocation({
    required String id,
    String? parentLocationId,
  }) async {
    try {
      final existing = await _repository.getById(id);
      if (existing == null) {
        return Result.failure(Failure.notFound(entity: 'Location', id: id));
      }

      if (parentLocationId == id) {
        return const Result.failure(
          Failure.validation(
            message: 'A place cannot be moved under itself',
          ),
        );
      }

      Location? parent;
      if (parentLocationId != null) {
        parent = await _repository.getById(parentLocationId);
        if (parent == null) {
          return Result.failure(
            Failure.notFound(entity: 'Location', id: parentLocationId),
          );
        }
        final all = await _repository.getAll();
        if (_isLocationDescendant(
          all,
          ancestorId: id,
          candidateId: parentLocationId,
        )) {
          return const Result.failure(
            Failure.validation(
              message:
                  'A place cannot be moved under one of its nested places',
            ),
          );
        }
      }

      if (existing.parentLocationId == parentLocationId) {
        return Result.success(existing);
      }

      final updated = existing.copyWith(
        parentLocationId: parentLocationId,
        path: DisplayPath.join(parent?.path, existing.name),
        updatedAt: DateTime.now().toUtc(),
      );
      await _repository.update(updated);
      await _recomputeDescendantPaths(updated);
      return Result.success(updated);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to move location', cause: error),
      );
    }
  }

  Future<void> _recomputeDescendantPaths(Location parent) async {
    final all = await _repository.getAll();
    final children = all.where((location) {
      return location.parentLocationId == parent.id;
    });
    for (final child in children) {
      final next = child.copyWith(
        path: DisplayPath.join(parent.path, child.name),
        updatedAt: DateTime.now().toUtc(),
      );
      if (next.path != child.path) {
        await _repository.update(next);
      }
      await _recomputeDescendantPaths(next);
    }
  }
}

bool _isLocationDescendant(
  List<Location> all, {
  required String ancestorId,
  required String candidateId,
}) {
  final byId = {for (final location in all) location.id: location};
  var current = byId[candidateId];
  while (current?.parentLocationId != null) {
    if (current!.parentLocationId == ancestorId) {
      return true;
    }
    current = byId[current.parentLocationId];
  }
  return false;
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(ref.watch(locationRepositoryProvider));
});

final locationsListProvider = StreamProvider<List<Location>>((ref) {
  return ref.watch(locationRepositoryProvider).watchAll();
});
