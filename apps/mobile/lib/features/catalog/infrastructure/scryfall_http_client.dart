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

  /// All printings that share [oracleId], oldest→newest by Scryfall default.
  ///
  /// Follows `has_more` / `next_page`. [pageDelay] spaces pages to stay
  /// inside Scryfall's rate limit (tests pass [Duration.zero]).
  Future<List<CardPrinting>> searchPrints(
    String oracleId, {
    Duration pageDelay = const Duration(milliseconds: 120),
  }) async {
    var uri = Uri.parse('$_apiBase/cards/search').replace(
      queryParameters: {
        'q': 'oracleid:$oracleId',
        'unique': 'prints',
        'order': 'released',
      },
    );
    final results = <CardPrinting>[];
    var first = true;
    while (true) {
      if (!first && pageDelay > Duration.zero) {
        await Future<void>.delayed(pageDelay);
      }
      first = false;
      final response = await _client.get(uri, headers: _headers);
      if (response.statusCode == 404) {
        break;
      }
      _ensureOk(response);
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as List<dynamic>? ?? const [];
      for (final item in data) {
        if (item is! Map) {
          continue;
        }
        final printing = printingFromJson(Map<String, dynamic>.from(item));
        if (printing != null) {
          results.add(printing);
        }
      }
      final hasMore = body['has_more'] == true;
      final next = _stringOf(body['next_page']);
      if (!hasMore || next == null || next.isEmpty) {
        break;
      }
      uri = Uri.parse(next);
    }
    return results;
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

    Map<String, dynamic>? topImages;
    final rawImages = json['image_uris'];
    if (rawImages is Map) {
      topImages = Map<String, dynamic>.from(rawImages);
    }

    final faces = <CardFace>[];
    final rawFaces = json['card_faces'];
    if (rawFaces is List) {
      for (final item in rawFaces) {
        if (item is! Map) {
          continue;
        }
        faces.add(_faceFromJson(Map<String, dynamic>.from(item)));
      }
    }

    // Single-image layouts: synthesize one face from top-level fields.
    if (faces.isEmpty) {
      faces.add(
        CardFace(
          name: _stringOf(json['name']) ?? '',
          typeLine: _stringOf(json['type_line']),
          manaCost: _stringOf(json['mana_cost']),
          oracleText: _stringOf(json['oracle_text']),
          colors: _stringListOf(json['colors']),
          power: _stringOf(json['power']),
          toughness: _stringOf(json['toughness']),
          loyalty: _stringOf(json['loyalty']),
          defense: _stringOf(json['defense']),
          flavorText: _stringOf(json['flavor_text']),
          imageSmallUrl:
              topImages == null ? null : _stringOf(topImages['small']),
          imageNormalUrl:
              topImages == null ? null : _stringOf(topImages['normal']),
        ),
      );
    } else if (topImages != null) {
      // Split / flip often share one card image at the top level.
      final small = _stringOf(topImages['small']);
      final normal = _stringOf(topImages['normal']);
      for (var i = 0; i < faces.length; i++) {
        final face = faces[i];
        if ((face.imageSmallUrl == null || face.imageSmallUrl!.isEmpty) &&
            small != null) {
          faces[i] = face.copyWith(
            imageSmallUrl: small,
            imageNormalUrl: face.imageNormalUrl ?? normal,
          );
        }
      }
    }

    final front = faces.first;
    final imageSmall = topImages == null
        ? front.imageSmallUrl
        : _stringOf(topImages['small']) ?? front.imageSmallUrl;
    final imageNormal = topImages == null
        ? front.imageNormalUrl
        : _stringOf(topImages['normal']) ?? front.imageNormalUrl;
    final colors = _stringListOf(json['colors']);

    return CardPrinting(
      id: id,
      oracleId: _stringOf(json['oracle_id']),
      name: _stringOf(json['name']) ?? front.name,
      setCode: (_stringOf(json['set']) ?? '').toLowerCase(),
      collectorNumber: _stringOf(json['collector_number']) ?? '',
      layout: _stringOf(json['layout']),
      typeLine: _stringOf(json['type_line']) ?? front.typeLine,
      manaCost: _stringOf(json['mana_cost']) ?? front.manaCost,
      oracleText: _stringOf(json['oracle_text']) ?? front.oracleText,
      colors: colors.isNotEmpty ? colors : front.colors,
      colorIdentity: _stringListOf(json['color_identity']),
      cmc: _doubleOf(json['cmc']),
      rarity: _stringOf(json['rarity']),
      artist: _stringOf(json['artist']),
      setName: _stringOf(json['set_name']),
      power: _stringOf(json['power']) ?? front.power,
      toughness: _stringOf(json['toughness']) ?? front.toughness,
      loyalty: _stringOf(json['loyalty']) ?? front.loyalty,
      defense: _stringOf(json['defense']) ?? front.defense,
      imageSmallUrl: imageSmall,
      imageNormalUrl: imageNormal,
      faces: faces,
      details: _detailsFromJson(json),
      fetchedAt: DateTime.now().toUtc(),
    );
  }

  static CardFace _faceFromJson(Map<String, dynamic> face) {
    Map<String, dynamic>? faceUris;
    final rawFaceUris = face['image_uris'];
    if (rawFaceUris is Map) {
      faceUris = Map<String, dynamic>.from(rawFaceUris);
    }
    return CardFace(
      name: _stringOf(face['name']) ?? '',
      typeLine: _stringOf(face['type_line']),
      manaCost: _stringOf(face['mana_cost']),
      oracleText: _stringOf(face['oracle_text']),
      colors: _stringListOf(face['colors']),
      power: _stringOf(face['power']),
      toughness: _stringOf(face['toughness']),
      loyalty: _stringOf(face['loyalty']),
      defense: _stringOf(face['defense']),
      flavorText: _stringOf(face['flavor_text']),
      imageSmallUrl: faceUris == null ? null : _stringOf(faceUris['small']),
      imageNormalUrl: faceUris == null ? null : _stringOf(faceUris['normal']),
    );
  }

  static CardPrintingDetails _detailsFromJson(Map<String, dynamic> json) {
    var prices = <String, String>{};
    final rawPrices = json['prices'];
    if (rawPrices is Map) {
      prices = {
        for (final entry in rawPrices.entries)
          if (entry.value != null) entry.key.toString(): entry.value.toString(),
      };
    }
    var legalities = <String, String>{};
    final rawLegalities = json['legalities'];
    if (rawLegalities is Map) {
      legalities = {
        for (final entry in rawLegalities.entries)
          if (entry.value != null) entry.key.toString(): entry.value.toString(),
      };
    }
    return CardPrintingDetails(
      flavorText: _stringOf(json['flavor_text']),
      keywords: _stringListOf(json['keywords']),
      finishes: _stringListOf(json['finishes']),
      promoTypes: _stringListOf(json['promo_types']),
      frameEffects: _stringListOf(json['frame_effects']),
      producedMana: _stringListOf(json['produced_mana']),
      legalities: legalities,
      promo: json['promo'] == true,
      reprint: json['reprint'] == true,
      variation: json['variation'] == true,
      fullArt: json['full_art'] == true,
      textless: json['textless'] == true,
      oversized: json['oversized'] == true,
      reserved: json['reserved'] == true,
      digital: json['digital'] == true,
      frame: _stringOf(json['frame']),
      borderColor: _stringOf(json['border_color']),
      lang: _stringOf(json['lang']),
      releasedAt: _stringOf(json['released_at']),
      setType: _stringOf(json['set_type']),
      illustrationId: _stringOf(json['illustration_id']),
      usd: prices['usd'],
      usdFoil: prices['usd_foil'],
      eur: prices['eur'],
      tix: prices['tix'],
    );
  }

  static List<String> _stringListOf(Object? value) {
    return CardPrinting.decodeStringList(value);
  }

  static double? _doubleOf(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
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
