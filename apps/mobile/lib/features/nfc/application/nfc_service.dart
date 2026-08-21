import 'package:compass/core/domain/entities/container.dart';
import 'package:compass/core/errors/failures.dart';
import 'package:compass/core/utils/result.dart';
import 'package:compass/features/containers/application/container_service.dart';
import 'package:compass/features/nfc/infrastructure/nfc_tag_reader.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nfc_manager/nfc_manager.dart';

/// Application use cases for NFC pair / open.
class NfcService {
  NfcService(this._containers, this._reader);

  final ContainerService _containers;
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
  Future<Result<Container>> pairContainer(String containerId) async {
    try {
      final uid = await _reader.readUid(
        alertMessage: 'Hold the sticker for this container',
      );
      if (uid == null) {
        return const Result.failure(
          Failure.validation(message: 'NFC scan cancelled'),
        );
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
}

final nfcTagReaderProvider = Provider<NfcTagReader>((ref) {
  return NfcTagReader();
});

final nfcServiceProvider = Provider<NfcService>((ref) {
  return NfcService(
    ref.watch(containerServiceProvider),
    ref.watch(nfcTagReaderProvider),
  );
});
