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
}

final containerServiceProvider = Provider<ContainerService>((ref) {
  return ContainerService(ref.watch(containerRepositoryProvider));
});

final containersListProvider = StreamProvider<List<Container>>((ref) {
  return ref.watch(containerRepositoryProvider).watchAll();
});
