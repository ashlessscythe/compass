import 'package:compass/core/domain/entities/container.dart';
import 'package:compass/core/domain/entities/location.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/locations/application/location_service.dart';
import 'package:compass/features/nfc/infrastructure/nfc_tag_reader.dart';
import 'package:compass/features/search/application/search_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';

/// Application use cases for NFC pair / open.
class NfcService {
  NfcService(this._containers, this._locations, this._reader);

  final ContainerService _containers;
  final LocationService _locations;
  final NfcTagReader _reader;

  Future<Result<NfcAvailability>> availability() async {
    try {
      return Result.success(await _reader.checkAvailability());
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to check NFC', cause: error),
      );
    }
  }

  /// Scan a sticker and bind its UID to [containerId].
  ///
  /// If the tag already belongs to another container, [confirmReassign] is
  /// called with that container's display path. Return false to cancel.
  Future<Result<Container>> pairContainer(
    String containerId, {
    Future<bool> Function(String ownerPath)? confirmReassign,
  }) async {
    try {
      final uid = await _reader.readUid(
        alertMessage: 'Hold the sticker for this container',
      );
      if (uid == null) {
        return const Result.failure(
          Failure.validation(message: 'NFC scan cancelled'),
        );
      }

      final found = await _containers.findByNfcTagId(uid);
      if (found.isFailure) {
        return Result.failure(found.failureOrNull!);
      }
      final owner = found.valueOrNull;
      if (owner != null && owner.id != containerId) {
        final path = await _pathFor(owner);
        final move = confirmReassign == null || await confirmReassign(path);
        if (!move) {
          return const Result.failure(
            Failure.validation(message: 'NFC pair cancelled'),
          );
        }
      }

      return await _containers.pairNfcTag(id: containerId, nfcTagId: uid);
    } on NfcUnavailableException catch (error) {
      return Result.failure(Failure.validation(message: error.toString()));
    } on NfcSessionException catch (error) {
      return Result.failure(Failure.validation(message: error.message));
    } on PlatformException catch (error) {
      return Result.failure(
        Failure.validation(
          message: error.message ?? 'NFC pair failed. Try again.',
        ),
      );
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to pair NFC tag', cause: error),
      );
    }
  }

  Future<Result<Container>> unpairContainer(String containerId) {
    return _containers.clearNfcTag(containerId);
  }

  /// Scan a sticker and return the paired container, if any.
  Future<Result<Container>> openContainerFromScan() async {
    try {
      final uid = await _reader.readUid(
        alertMessage: 'Hold a paired container sticker',
      );
      if (uid == null) {
        return const Result.failure(
          Failure.validation(message: 'NFC scan cancelled'),
        );
      }
      final found = await _containers.findByNfcTagId(uid);
      if (found.isFailure) {
        return Result.failure(found.failureOrNull!);
      }
      final container = found.valueOrNull;
      if (container == null) {
        return const Result.failure(
          Failure.validation(
            message: 'No container is paired with this tag. '
                'Open a container and tap Pair NFC.',
          ),
        );
      }
      return Result.success(container);
    } on NfcUnavailableException catch (error) {
      return Result.failure(Failure.validation(message: error.toString()));
    } on NfcSessionException catch (error) {
      return Result.failure(Failure.validation(message: error.message));
    } on PlatformException catch (error) {
      return Result.failure(
        Failure.validation(
          message: error.message ?? 'NFC scan failed. Try again.',
        ),
      );
    } on Object catch (error) {
      return Result.failure(
        Failure.unexpected(message: 'Failed to scan NFC tag', cause: error),
      );
    }
  }

  Future<String> _pathFor(Container container) async {
    final containersResult = await _containers.listContainers();
    final locationsResult = await _locations.listLocations();
    final containers = containersResult.valueOrNull ?? const <Container>[];
    final locations = locationsResult.valueOrNull ?? const <Location>[];
    return containerPath(
      container,
      {for (final location in locations) location.id: location},
      {for (final item in containers) item.id: item},
    );
  }
}

final nfcTagReaderProvider = Provider<NfcTagReader>((ref) {
  return NfcTagReader();
});

final nfcServiceProvider = Provider<NfcService>((ref) {
  return NfcService(
    ref.watch(containerServiceProvider),
    ref.watch(locationServiceProvider),
    ref.watch(nfcTagReaderProvider),
  );
});
