import 'dart:convert';

import 'package:compass/features/catalog/domain/card_printing.dart';
import 'package:http/http.dart' as http;

/// Thin Scryfall REST + bulk-data client.
class ScryfallHttpClient {
  ScryfallHttpClient({http.Client? client, this.userAgent = defaultUserAgent})
      : _client = client ?? http.Client();

  static const defaultUserAgent = 'CompassInventory/0.1 (getcompass.space)';
  static const _apiBase = 'https://api.scryfall.com';

  final http.Client _client;
  final String userAgent;

  Map<String, String> get _headers => {
        'User-Agent': userAgent,
        'Accept': 'application/json',
      };

  Future<CardPrinting?> fetchById(String id) async {
    final response = await _client.get(
      Uri.parse('$_apiBase/cards/$id'),
      headers: _headers,
    );
    if (response.statusCode == 404) {
      return null;
    }
    _ensureOk(response);
    return printingFromJson(
      Map<String, dynamic>.from(
        jsonDecode(response.body) as Map,
      ),
    );
  }

  Future<CardPrinting?> fetchBySetCollector({
    required String setCode,
    required String collectorNumber,
  }) async {
    final set = Uri.encodeComponent(setCode.toLowerCase());
    final number = Uri.encodeComponent(collectorNumber);
    final response = await _client.get(
      Uri.parse('$_apiBase/cards/$set/$number'),
      headers: _headers,
    );
    if (response.statusCode == 404) {
      return null;
    }
    _ensureOk(response);
    return printingFromJson(
      Map<String, dynamic>.from(
        jsonDecode(response.body) as Map,
      ),
    );
  }

  Future<CardPrinting?> fetchByExactName(String name) async {
    final uri = Uri.parse('$_apiBase/cards/named').replace(
      queryParameters: {'exact': name},
    );
    final response = await _client.get(uri, headers: _headers);
    if (response.statusCode == 404) {
      return null;
    }
    _ensureOk(response);
    return printingFromJson(
      Map<String, dynamic>.from(
        jsonDecode(response.body) as Map,
      ),
    );
  }

  /// Returns download URI + type for `default_cards` bulk file.
  Future<({String type, Uri downloadUri, int? size})> defaultCardsBulk() async {
    final response = await _client.get(
      Uri.parse('$_apiBase/bulk-data'),
      headers: _headers,
    );
    _ensureOk(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as List<dynamic>? ?? const [];
    for (final item in data) {
      if (item is! Map) {
        continue;
      }
      final map = Map<String, dynamic>.from(item);
      if (map['type'] != 'default_cards') {
        continue;
      }
      final downloadUri = _stringOf(map['jsonl_download_uri']) ??
          _stringOf(map['download_uri']);
      if (downloadUri == null || downloadUri.isEmpty) {
        throw StateError(
          'Scryfall default_cards missing jsonl_download_uri/download_uri',
        );
      }
      final size = map['compressed_size'] is int
          ? map['compressed_size'] as int
          : map['size'] is int
              ? map['size'] as int
              : null;
      return (
        type: 'default_cards',
        downloadUri: Uri.parse(downloadUri),
        size: size,
      );
    }
    throw StateError('Scryfall bulk-data missing default_cards');
  }

  Future<List<int>> downloadBytes(
    Uri uri, {
    void Function(int received, int? total)? onBytes,
  }) async {
    final request = http.Request('GET', uri)..headers.addAll(_headers);
    final streamed = await _client.send(request);
    if (streamed.statusCode < 200 || streamed.statusCode >= 300) {
      throw StateError('Scryfall download failed (${streamed.statusCode})');
    }
    final total = streamed.contentLength;
    final bytes = <int>[];
    var received = 0;
    await for (final chunk in streamed.stream) {
      bytes.addAll(chunk);
      received += chunk.length;
      onBytes?.call(received, total);
    }
    return bytes;
  }

  void close() => _client.close();

  void _ensureOk(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError(
        'Scryfall error ${response.statusCode}: ${response.body}',
      );
    }
  }

  static CardPrinting? printingFromJson(Map<String, dynamic> json) {
    final id = _stringOf(json['id']);
    if (id == null || id.isEmpty) {
      return null;
    }

    Map<String, dynamic>? images;
    final rawImages = json['image_uris'];
    if (rawImages is Map) {
      images = Map<String, dynamic>.from(rawImages);
    }

    Map<String, dynamic>? faceImages;
    final faces = json['card_faces'];
    if (images == null && faces is List && faces.isNotEmpty) {
      final first = faces.first;
      if (first is Map) {
        final face = Map<String, dynamic>.from(first);
        final faceUris = face['image_uris'];
        if (faceUris is Map) {
          faceImages = Map<String, dynamic>.from(faceUris);
        }
      }
    }
    final uris = images ?? faceImages;

    return CardPrinting(
      id: id,
      oracleId: _stringOf(json['oracle_id']),
      name: _stringOf(json['name']) ?? '',
      setCode: (_stringOf(json['set']) ?? '').toLowerCase(),
      collectorNumber: _stringOf(json['collector_number']) ?? '',
      typeLine: _stringOf(json['type_line']),
      manaCost: _stringOf(json['mana_cost']),
      imageSmallUrl: uris == null ? null : _stringOf(uris['small']),
      imageNormalUrl: uris == null ? null : _stringOf(uris['normal']),
      fetchedAt: DateTime.now().toUtc(),
    );
  }

  static String? _stringOf(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }
    return value.toString();
  }
}
