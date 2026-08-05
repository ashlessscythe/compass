import 'package:compass/core/domain/entities/container.dart';
import 'package:compass/core/domain/repositories/container_repository.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application service for container queries and commands.
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
}

final containerServiceProvider = Provider<ContainerService>((ref) {
  return ContainerService(ref.watch(containerRepositoryProvider));
});

final containersListProvider = FutureProvider<List<Container>>((ref) async {
  final result = await ref.watch(containerServiceProvider).listContainers();
  return result.valueOrNull ?? const [];
});
