import 'dart:io';

import 'package:compass/features/catalog/infrastructure/card_image_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:path/path.dart' as p;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempRoot;

  setUp(() async {
    tempRoot = await Directory.systemTemp.createTemp('compass_img_cache_');
  });

  tearDown(() async {
    if (await tempRoot.exists()) {
      await tempRoot.delete(recursive: true);
    }
  });

  CardImageCache cacheWith(http.Client client) {
    return CardImageCache(
      client: client,
      documentsDirectory: () async => tempRoot,
    );
  }

  test('ensureImage soft-fails when the network throws', () async {
    final cache = cacheWith(
      MockClient((_) async {
        throw const SocketException('offline');
      }),
    );

    final file = await cache.ensureImage(
      scryfallId: 'abc',
      size: CardImageSize.small,
      url: 'https://example.test/card.jpg',
    );
    expect(file, isNull);
  });

  test('ensureImage soft-fails on non-2xx', () async {
    final cache = cacheWith(
      MockClient((_) async => http.Response('nope', 404)),
    );
    final file = await cache.ensureImage(
      scryfallId: 'abc',
      size: CardImageSize.small,
      url: 'https://example.test/card.jpg',
    );
    expect(file, isNull);
  });

  test('ensureImage writes bytes and returns a cache hit next', () async {
    final bytes = List<int>.filled(16, 3);
    var calls = 0;
    final cache = cacheWith(
      MockClient((_) async {
        calls++;
        return http.Response.bytes(bytes, 200);
      }),
    );

    final first = await cache.ensureImage(
      scryfallId: 'card-1',
      size: CardImageSize.small,
      url: 'https://example.test/small.jpg',
    );
    final second = await cache.ensureImage(
      scryfallId: 'card-1',
      size: CardImageSize.small,
      url: 'https://example.test/small.jpg',
    );

    expect(first, isNotNull);
    expect(await first!.readAsBytes(), bytes);
    expect(second!.path, first.path);
    expect(calls, 1);
  });

  test('ensureImageOrFallback uses small when normal download fails', () async {
    final smallBytes = List<int>.filled(32, 7);
    final cache = cacheWith(
      MockClient((request) async {
        if (request.url.path.contains('normal')) {
          throw const SocketException('offline');
        }
        return http.Response.bytes(smallBytes, 200);
      }),
    );

    final file = await cache.ensureImageOrFallback(
      scryfallId: 'card-1',
      size: CardImageSize.normal,
      url: 'https://example.test/normal.jpg',
      smallUrl: 'https://example.test/small.jpg',
    );

    expect(file, isNotNull);
    expect(await file!.readAsBytes(), smallBytes);
    expect(p.basename(file.path), contains('small'));
  });
}
