import 'package:compass/core/domain/entities/container.dart';
import 'package:compass/core/domain/repositories/container_repository.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/id_generator.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContainerService {
  ContainerService(this._repository);

  final ContainerRepository _repository;

  Future<Result<List<Container>>> listContainers() async {
    try {
      final containers = await _repository.getAll();
      return Result.success(containers);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to list containers', cause: error),
      );
    }
  }

  Future<Result<Container?>> getContainer(String id) async {
    try {
      return Result.success(await _repository.getById(id));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to get container', cause: error),
      );
    }
  }

  Future<Result<Container>> createContainer({
    required String name,
    String? locationId,
    String? parentContainerId,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return const Result.failure(
        Failure.validation(message: 'Name is required'),
      );
    }

    try {
      var resolvedLocationId = locationId;
      if (resolvedLocationId == null && parentContainerId != null) {
        final parent = await _repository.getById(parentContainerId);
        resolvedLocationId = parent?.locationId;
      }

      final now = DateTime.now().toUtc();
      final container = Container(
        id: IdGenerator.v4(),
        name: trimmed,
        createdAt: now,
        updatedAt: now,
        parentContainerId: parentContainerId,
        locationId: resolvedLocationId,
      );
      return Result.success(await _repository.create(container));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to create container',
          cause: error,
        ),
      );
    }
  }

  Future<Result<Container>> renameContainer({
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
        return Result.failure(Failure.notFound(entity: 'Container', id: id));
      }
      final updated = existing.copyWith(
        name: trimmed,
        updatedAt: DateTime.now().toUtc(),
      );
      return Result.success(await _repository.update(updated));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to rename container',
          cause: error,
        ),
      );
    }
  }

  Future<Result<void>> deleteContainer(String id) async {
    try {
      await _repository.delete(id);
      return const Result.success(null);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to delete container',
          cause: error,
        ),
      );
    }
  }

  /// Move under [parentContainerId], or to the root of [locationId].
  Future<Result<Container>> moveContainer({
    required String id,
    String? locationId,
    String? parentContainerId,
  }) async {
    if (locationId == null && parentContainerId == null) {
      return const Result.failure(
        Failure.validation(
          message: 'Choose a place or container to move into',
        ),
      );
    }

    try {
      final existing = await _repository.getById(id);
      if (existing == null) {
        return Result.failure(Failure.notFound(entity: 'Container', id: id));
      }

      if (parentContainerId == id) {
        return const Result.failure(
          Failure.validation(
            message: 'A container cannot be moved under itself',
          ),
        );
      }

      var resolvedLocationId = locationId;
      if (parentContainerId != null) {
        final parent = await _repository.getById(parentContainerId);
        if (parent == null) {
          return Result.failure(
            Failure.notFound(entity: 'Container', id: parentContainerId),
          );
        }
        final all = await _repository.getAll();
        if (_isContainerDescendant(
          all,
          ancestorId: id,
          candidateId: parentContainerId,
        )) {
          return const Result.failure(
            Failure.validation(
              message: 'A container cannot be moved under one of '
                  'its nested containers',
            ),
          );
        }
        resolvedLocationId = parent.locationId;
      }

      if (existing.parentContainerId == parentContainerId &&
          existing.locationId == resolvedLocationId) {
        return Result.success(existing);
      }

      final updated = existing.copyWith(
        parentContainerId: parentContainerId,
        locationId: resolvedLocationId,
        updatedAt: DateTime.now().toUtc(),
      );
      await _repository.update(updated);
      await _reassignDescendantLocations(updated);
      return Result.success(updated);
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to move container',
          cause: error,
        ),
      );
    }
  }

  /// Bind an NFC chip UID to this container (clears the same UID elsewhere).
  Future<Result<Container>> pairNfcTag({
    required String id,
    required String nfcTagId,
  }) async {
    final tag = nfcTagId.trim().toUpperCase();
    if (tag.isEmpty) {
      return const Result.failure(
        Failure.validation(message: 'NFC tag id is required'),
      );
    }

    try {
      final existing = await _repository.getById(id);
      if (existing == null) {
        return Result.failure(Failure.notFound(entity: 'Container', id: id));
      }

      final owner = await _repository.getByNfcTagId(tag);
      if (owner != null && owner.id != id) {
        await _repository.update(
          owner.copyWith(
            nfcTagId: null,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
      }

      if (existing.nfcTagId == tag) {
        return Result.success(existing);
      }

      final updated = existing.copyWith(
        nfcTagId: tag,
        updatedAt: DateTime.now().toUtc(),
      );
      return Result.success(await _repository.update(updated));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to pair NFC tag',
          cause: error,
        ),
      );
    }
  }

  Future<Result<Container>> clearNfcTag(String id) async {
    try {
      final existing = await _repository.getById(id);
      if (existing == null) {
        return Result.failure(Failure.notFound(entity: 'Container', id: id));
      }
      if (existing.nfcTagId == null) {
        return Result.success(existing);
      }
      final updated = existing.copyWith(
        nfcTagId: null,
        updatedAt: DateTime.now().toUtc(),
      );
      return Result.success(await _repository.update(updated));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to clear NFC tag',
          cause: error,
        ),
      );
    }
  }

  Future<Result<Container?>> findByNfcTagId(String nfcTagId) async {
    try {
      final tag = nfcTagId.trim().toUpperCase();
      if (tag.isEmpty) {
        return const Result.success(null);
      }
      return Result.success(await _repository.getByNfcTagId(tag));
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(
          message: 'Failed to look up NFC tag',
          cause: error,
        ),
      );
    }
  }

  Future<void> _reassignDescendantLocations(Container parent) async {
    final all = await _repository.getAll();
    final children = all.where((item) => item.parentContainerId == parent.id);
    for (final child in children) {
      final next = child.copyWith(
        locationId: parent.locationId,
        updatedAt: DateTime.now().toUtc(),
      );
      if (next.locationId != child.locationId) {
        await _repository.update(next);
      }
      await _reassignDescendantLocations(next);
    }
  }
}

bool _isContainerDescendant(
  List<Container> all, {
  required String ancestorId,
  required String candidateId,
}) {
  final byId = {for (final item in all) item.id: item};
  var current = byId[candidateId];
  while (current?.parentContainerId != null) {
    if (current!.parentContainerId == ancestorId) {
      return true;
    }
    current = byId[current.parentContainerId];
  }
  return false;
}

final containerServiceProvider = Provider<ContainerService>((ref) {
  return ContainerService(ref.watch(containerRepositoryProvider));
});

final containersListProvider = StreamProvider<List<Container>>((ref) {
  return ref.watch(containerRepositoryProvider).watchAll();
});
