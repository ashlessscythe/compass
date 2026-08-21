import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:nfc_manager/nfc_manager_ios.dart';

/// Reads NFC chip UIDs for container pairing / open.
class NfcTagReader {
  var _sessionOpen = false;

  /// Whether NFC hardware can be used right now.
  Future<NfcAvailability> checkAvailability() {
    if (kIsWeb) {
      return Future.value(NfcAvailability.unsupported);
    }
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      return NfcManager.instance.checkAvailability();
    }
    return Future.value(NfcAvailability.unsupported);
  }

  /// One-shot session: hold a sticker to the phone, return uppercase hex UID.
  ///
  /// Returns null if the user cancels or the session ends without a UID.
  Future<String?> readUid({
    String alertMessage = 'Hold an NFC sticker near the top of the iPhone',
  }) async {
    final availability = await checkAvailability();
    if (availability != NfcAvailability.enabled) {
      throw NfcUnavailableException(availability);
    }

    // Clear a leftover iOS session so the next scan can start.
    await _safeStopSession();

    final completer = Completer<String?>();

    try {
      _sessionOpen = true;
      await NfcManager.instance.startSession(
        pollingOptions: {NfcPollingOption.iso14443},
        alertMessageIos: alertMessage,
        // Keep the session alive until we stop it — avoids racing iOS's
        // auto-invalidate with our stopSession (NFCError 104).
        invalidateAfterFirstReadIos: false,
        onSessionErrorIos: (error) {
          _sessionOpen = false;
          if (completer.isCompleted) {
            return;
          }
          if (error.code ==
              NfcReaderErrorCodeIos
                  .readerSessionInvalidationErrorUserCanceled) {
            completer.complete(null);
          } else {
            completer.completeError(NfcSessionException(error.message));
          }
        },
        onDiscovered: (tag) async {
          final uid = uidFromTag(tag);
          if (!completer.isCompleted) {
            completer.complete(uid);
          }
          await _safeStopSession(
            alertMessageIos: uid == null ? null : 'Tag read',
            errorMessageIos: uid == null ? 'Could not read tag id' : null,
          );
        },
      );
    } on Object catch (error) {
      _sessionOpen = false;
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    }

    try {
      return await completer.future;
    } finally {
      await _safeStopSession();
    }
  }

  Future<void> _safeStopSession({
    String? alertMessageIos,
    String? errorMessageIos,
  }) async {
    if (!_sessionOpen && defaultTargetPlatform != TargetPlatform.iOS) {
      // Still try on iOS — session flag can lag behind Core NFC.
    }
    try {
      await NfcManager.instance.stopSession(
        alertMessageIos: alertMessageIos,
        errorMessageIos: errorMessageIos,
      );
    } on PlatformException catch (error) {
      // iOS: "Tag is not connected" / already invalidated — ignore.
      debugPrint('NFC stopSession ignored: ${error.message}');
    } on Object catch (error) {
      debugPrint('NFC stopSession ignored: $error');
    } finally {
      _sessionOpen = false;
    }
  }

  /// Extract a stable uppercase hex UID from a discovered tag.
  @visibleForTesting
  static String? uidFromTag(NfcTag tag) {
    try {
      Uint8List? bytes;
      final mifare = MiFareIos.from(tag);
      if (mifare != null) {
        bytes = mifare.identifier;
      } else {
        final iso7816 = Iso7816Ios.from(tag);
        if (iso7816 != null) {
          bytes = iso7816.identifier;
        } else {
          final iso15693 = Iso15693Ios.from(tag);
          if (iso15693 != null) {
            bytes = iso15693.identifier;
          }
        }
      }
      if (bytes == null || bytes.isEmpty) {
        final android = NfcTagAndroid.from(tag);
        bytes = android?.id;
      }
      if (bytes == null || bytes.isEmpty) {
        return null;
      }
      return formatUid(bytes);
    } on Object {
      return null;
    }
  }

  /// Uppercase hex without separators (stored in `Container.nfcTagId`).
  @visibleForTesting
  static String formatUid(List<int> bytes) {
    return bytes
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join()
        .toUpperCase();
  }
}

class NfcUnavailableException implements Exception {
  NfcUnavailableException(this.availability);

  final NfcAvailability availability;

  @override
  String toString() => switch (availability) {
        NfcAvailability.disabled => 'NFC is turned off',
        NfcAvailability.unsupported => 'NFC is not available on this device',
        NfcAvailability.enabled => 'NFC is unavailable',
      };
}

class NfcSessionException implements Exception {
  NfcSessionException(this.message);

  final String message;

  @override
  String toString() => message;
}
