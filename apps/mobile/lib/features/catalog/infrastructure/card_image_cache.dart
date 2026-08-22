import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum CardImageSize { small, normal }

/// On-disk image cache keyed by Scryfall card id (+ optional face index).
///
/// Hits survive airplane mode. Misses attempt HTTP once and soft-fail (no throw)
/// so list/detail UI can show placeholders offline.
class CardImageCache {
  CardImageCache({
    http.Client? client,
    Future<Directory> Function()? documentsDirectory,
  })  : _client = client ?? http.Client(),
        _documentsDirectory =
            documentsDirectory ?? getApplicationDocumentsDirectory;

  final http.Client _client;
  final Future<Directory> Function() _documentsDirectory;

  Future<Directory> _dir() async {
    final root = await _documentsDirectory();
    final dir = Directory(p.join(root.path, 'cache', 'scryfall', 'images'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> fileFor(
    String scryfallId,
    CardImageSize size, {
    int faceIndex = 0,
  }) async {
    final dir = await _dir();
    final suffix = size == CardImageSize.small ? 'small' : 'normal';
    final face = faceIndex == 0 ? '' : '_f$faceIndex';
    return File(p.join(dir.path, '$scryfallId${face}_$suffix.jpg'));
  }

  Future<File?> cachedFile(
    String scryfallId,
    CardImageSize size, {
    int faceIndex = 0,
  }) async {
    final file = await fileFor(scryfallId, size, faceIndex: faceIndex);
    if (await file.exists()) {
      return file;
    }
    // Legacy face-0 filenames without _f0.
    if (faceIndex == 0) {
      final dir = await _dir();
      final suffix = size == CardImageSize.small ? 'small' : 'normal';
      final legacy = File(p.join(dir.path, '${scryfallId}_$suffix.jpg'));
      if (await legacy.exists()) {
        return legacy;
      }
    }
    return null;
  }

  /// Return a cached file, or download [url] into the cache.
  ///
  /// Disk / network / IO failures return `null` (never throw) so airplane mode
  /// and headless tests are safe.
  Future<File?> ensureImage({
    required String scryfallId,
    required CardImageSize size,
    required String? url,
    int faceIndex = 0,
  }) async {
    try {
      final existing = await cachedFile(scryfallId, size, faceIndex: faceIndex);
      if (existing != null) {
        return existing;
      }
      if (url == null || url.isEmpty) {
        return null;
      }
      final response = await _client.get(Uri.parse(url));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }
      final file = await fileFor(scryfallId, size, faceIndex: faceIndex);
      await file.writeAsBytes(response.bodyBytes, flush: true);
      return file;
    } on Object {
      return null;
    }
  }

  /// Prefer [size]; if missing and size is normal, fall back to cached small.
  Future<File?> ensureImageOrFallback({
    required String scryfallId,
    required CardImageSize size,
    required String? url,
    String? smallUrl,
    int faceIndex = 0,
  }) async {
    final primary = await ensureImage(
      scryfallId: scryfallId,
      size: size,
      url: url,
      faceIndex: faceIndex,
    );
    if (primary != null || size == CardImageSize.small) {
      return primary;
    }
    return ensureImage(
      scryfallId: scryfallId,
      size: CardImageSize.small,
      url: smallUrl,
      faceIndex: faceIndex,
    );
  }

  Future<void> clear() async {
    final root = await _documentsDirectory();
    final dir = Directory(p.join(root.path, 'cache', 'scryfall', 'images'));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}
