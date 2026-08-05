import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/domain/repositories/location_repository.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/shared/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application service for location queries and commands.
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
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(ref.watch(locationRepositoryProvider));
});

final locationsListProvider = FutureProvider<List<Location>>((ref) async {
  final result = await ref.watch(locationServiceProvider).listLocations();
  return result.valueOrNull ?? const [];
});
