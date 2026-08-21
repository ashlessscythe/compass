import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum CardImageSize { small, normal }

/// On-disk image cache keyed by Scryfall card id (+ optional face index).
class CardImageCache {
  CardImageCache({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<Directory> _dir() async {
    final root = await getApplicationDocumentsDirectory();
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

  Future<File?> ensureImage({
    required String scryfallId,
    required CardImageSize size,
    required String? url,
    int faceIndex = 0,
  }) async {
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
  }

  Future<void> clear() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, 'cache', 'scryfall', 'images'));
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}
