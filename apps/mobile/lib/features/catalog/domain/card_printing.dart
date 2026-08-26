import 'dart:convert';

/// One face of a multi-face / split / flip / transform card.
class CardFace {
  const CardFace({
    required this.name,
    this.typeLine,
    this.manaCost,
    this.oracleText,
    this.colors = const [],
    this.power,
    this.toughness,
    this.loyalty,
    this.defense,
    this.flavorText,
    this.imageSmallUrl,
    this.imageNormalUrl,
  });

  factory CardFace.fromJson(Map<String, dynamic> json) {
    return CardFace(
      name: (json['name'] as String?) ?? '',
      typeLine: json['type_line'] as String?,
      manaCost: json['mana_cost'] as String?,
      oracleText: json['oracle_text'] as String?,
      colors: CardPrinting.decodeStringList(json['colors']),
      power: json['power'] as String?,
      toughness: json['toughness'] as String?,
      loyalty: json['loyalty'] as String?,
      defense: json['defense'] as String?,
      flavorText: json['flavor_text'] as String?,
      imageSmallUrl: json['image_small'] as String?,
      imageNormalUrl: json['image_normal'] as String?,
    );
  }

  final String name;
  final String? typeLine;
  final String? manaCost;
  final String? oracleText;
  final List<String> colors;
  final String? power;
  final String? toughness;
  final String? loyalty;
  final String? defense;
  final String? flavorText;
  final String? imageSmallUrl;
  final String? imageNormalUrl;

  String? get combatStats => CardPrinting.combatStatsOf(
        power: power,
        toughness: toughness,
        loyalty: loyalty,
        defense: defense,
      );

  CardFace copyWith({
    String? name,
    String? typeLine,
    String? manaCost,
    String? oracleText,
    List<String>? colors,
    String? power,
    String? toughness,
    String? loyalty,
    String? defense,
    String? flavorText,
    String? imageSmallUrl,
    String? imageNormalUrl,
  }) {
    return CardFace(
      name: name ?? this.name,
      typeLine: typeLine ?? this.typeLine,
      manaCost: manaCost ?? this.manaCost,
      oracleText: oracleText ?? this.oracleText,
      colors: colors ?? this.colors,
      power: power ?? this.power,
      toughness: toughness ?? this.toughness,
      loyalty: loyalty ?? this.loyalty,
      defense: defense ?? this.defense,
      flavorText: flavorText ?? this.flavorText,
      imageSmallUrl: imageSmallUrl ?? this.imageSmallUrl,
      imageNormalUrl: imageNormalUrl ?? this.imageNormalUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        if (typeLine != null) 'type_line': typeLine,
        if (manaCost != null) 'mana_cost': manaCost,
        if (oracleText != null) 'oracle_text': oracleText,
        if (colors.isNotEmpty) 'colors': colors,
        if (power != null) 'power': power,
        if (toughness != null) 'toughness': toughness,
        if (loyalty != null) 'loyalty': loyalty,
        if (defense != null) 'defense': defense,
        if (flavorText != null) 'flavor_text': flavorText,
        if (imageSmallUrl != null) 'image_small': imageSmallUrl,
        if (imageNormalUrl != null) 'image_normal': imageNormalUrl,
      };
}

/// Overflow Scryfall fields kept off first-class columns.
class CardPrintingDetails {
  const CardPrintingDetails({
    this.flavorText,
    this.keywords = const [],
    this.finishes = const [],
    this.promoTypes = const [],
    this.frameEffects = const [],
    this.producedMana = const [],
    this.legalities = const {},
    this.promo = false,
    this.reprint = false,
    this.variation = false,
    this.fullArt = false,
    this.textless = false,
    this.oversized = false,
    this.reserved = false,
    this.digital = false,
    this.frame,
    this.borderColor,
    this.lang,
    this.releasedAt,
    this.setType,
    this.illustrationId,
    this.usd,
    this.usdFoil,
    this.eur,
    this.tix,
  });

  factory CardPrintingDetails.fromJson(Map<String, dynamic> json) {
    return CardPrintingDetails(
      flavorText: json['flavor_text'] as String?,
      keywords: CardPrinting.decodeStringList(json['keywords']),
      finishes: CardPrinting.decodeStringList(json['finishes']),
      promoTypes: CardPrinting.decodeStringList(json['promo_types']),
      frameEffects: CardPrinting.decodeStringList(json['frame_effects']),
      producedMana: CardPrinting.decodeStringList(json['produced_mana']),
      legalities: _stringMapOf(json['legalities']),
      promo: json['promo'] == true,
      reprint: json['reprint'] == true,
      variation: json['variation'] == true,
      fullArt: json['full_art'] == true,
      textless: json['textless'] == true,
      oversized: json['oversized'] == true,
      reserved: json['reserved'] == true,
      digital: json['digital'] == true,
      frame: json['frame'] as String?,
      borderColor: json['border_color'] as String?,
      lang: json['lang'] as String?,
      releasedAt: json['released_at'] as String?,
      setType: json['set_type'] as String?,
      illustrationId: json['illustration_id'] as String?,
      usd: json['usd'] as String?,
      usdFoil: json['usd_foil'] as String?,
      eur: json['eur'] as String?,
      tix: json['tix'] as String?,
    );
  }

  final String? flavorText;
  final List<String> keywords;
  final List<String> finishes;
  final List<String> promoTypes;
  final List<String> frameEffects;
  final List<String> producedMana;
  final Map<String, String> legalities;
  final bool promo;
  final bool reprint;
  final bool variation;
  final bool fullArt;
  final bool textless;
  final bool oversized;
  final bool reserved;
  final bool digital;
  final String? frame;
  final String? borderColor;
  final String? lang;
  final String? releasedAt;
  final String? setType;
  final String? illustrationId;
  final String? usd;
  final String? usdFoil;
  final String? eur;
  final String? tix;

  bool get isPromoLike => promo || promoTypes.isNotEmpty;

  Map<String, dynamic> toJson() => {
        if (flavorText != null) 'flavor_text': flavorText,
        if (keywords.isNotEmpty) 'keywords': keywords,
        if (finishes.isNotEmpty) 'finishes': finishes,
        if (promoTypes.isNotEmpty) 'promo_types': promoTypes,
        if (frameEffects.isNotEmpty) 'frame_effects': frameEffects,
        if (producedMana.isNotEmpty) 'produced_mana': producedMana,
        if (legalities.isNotEmpty) 'legalities': legalities,
        if (promo) 'promo': promo,
        if (reprint) 'reprint': reprint,
        if (variation) 'variation': variation,
        if (fullArt) 'full_art': fullArt,
        if (textless) 'textless': textless,
        if (oversized) 'oversized': oversized,
        if (reserved) 'reserved': reserved,
        if (digital) 'digital': digital,
        if (frame != null) 'frame': frame,
        if (borderColor != null) 'border_color': borderColor,
        if (lang != null) 'lang': lang,
        if (releasedAt != null) 'released_at': releasedAt,
        if (setType != null) 'set_type': setType,
        if (illustrationId != null) 'illustration_id': illustrationId,
        if (usd != null) 'usd': usd,
        if (usdFoil != null) 'usd_foil': usdFoil,
        if (eur != null) 'eur': eur,
        if (tix != null) 'tix': tix,
      };

  static Map<String, String> _stringMapOf(Object? value) {
    if (value is! Map) {
      return const {};
    }
    return {
      for (final entry in value.entries)
        if (entry.key != null && entry.value != null)
          entry.key.toString(): entry.value.toString(),
    };
  }
}

/// Domain snapshot of a card printing (catalog metadata, not inventory).
class CardPrinting {
  const CardPrinting({
    required this.id,
    required this.name,
    required this.setCode,
    required this.collectorNumber,
    required this.fetchedAt,
    this.oracleId,
    this.layout,
    this.typeLine,
    this.manaCost,
    this.oracleText,
    this.colors = const [],
    this.colorIdentity = const [],
    this.cmc,
    this.rarity,
    this.artist,
    this.setName,
    this.power,
    this.toughness,
    this.loyalty,
    this.defense,
    this.imageSmallUrl,
    this.imageNormalUrl,
    this.faces = const [],
    this.details,
  });

  final String id;
  final String? oracleId;
  final String name;
  final String setCode;
  final String collectorNumber;
  final String? layout;
  final String? typeLine;
  final String? manaCost;
  final String? oracleText;
  final List<String> colors;
  final List<String> colorIdentity;
  final double? cmc;
  final String? rarity;
  final String? artist;
  final String? setName;
  final String? power;
  final String? toughness;
  final String? loyalty;
  final String? defense;
  final String? imageSmallUrl;
  final String? imageNormalUrl;
  final List<CardFace> faces;
  final CardPrintingDetails? details;
  final DateTime fetchedAt;

  bool get isMultiFace => faces.length > 1;

  /// True when local cache likely predates face storage (v4→v5) or only
  /// captured a single composite face for a multi-face layout.
  bool get needsFaceHydration {
    if (faces.length > 1) {
      return false;
    }
    if (faces.isEmpty) {
      return true;
    }
    final layoutHint =
        layout != null && _multiFaceLayouts.contains(layout!.toLowerCase());
    final nameHint = name.contains(' // ');
    final typeHint = typeLine?.contains(' // ') ?? false;
    return layoutHint || nameHint || typeHint;
  }

  /// True when the row was cached before gameplay / printing details existed.
  bool get needsDetailsHydration => details == null;

  bool get needsCatalogHydration =>
      needsFaceHydration || needsDetailsHydration;

  static const _multiFaceLayouts = {
    'transform',
    'modal_dfc',
    'double_faced_token',
    'art_series',
    'reversible_card',
    'split',
    'flip',
    'adventure',
  };

  CardFace? faceAt(int index) {
    if (faces.isEmpty || index < 0 || index >= faces.length) {
      return null;
    }
    return faces[index];
  }

  String? imageUrlForFace(int index, {required bool normal}) {
    final face = faceAt(index);
    if (face != null) {
      final fromFace = normal ? face.imageNormalUrl : face.imageSmallUrl;
      if (fromFace != null && fromFace.isNotEmpty) {
        return fromFace;
      }
    }
    if (index == 0) {
      return normal ? imageNormalUrl : imageSmallUrl;
    }
    return null;
  }

  String? combatStatsForFace(int index) {
    final face = faceAt(index);
    return face?.combatStats ??
        combatStatsOf(
          power: power,
          toughness: toughness,
          loyalty: loyalty,
          defense: defense,
        );
  }

  static String? combatStatsOf({
    String? power,
    String? toughness,
    String? loyalty,
    String? defense,
  }) {
    if (power != null &&
        power.isNotEmpty &&
        toughness != null &&
        toughness.isNotEmpty) {
      return '$power/$toughness';
    }
    if (loyalty != null && loyalty.isNotEmpty) {
      return 'Loyalty $loyalty';
    }
    if (defense != null && defense.isNotEmpty) {
      return 'Defense $defense';
    }
    return null;
  }

  static String encodeFaces(List<CardFace> faces) {
    if (faces.isEmpty) {
      return '[]';
    }
    return jsonEncode(faces.map((f) => f.toJson()).toList(growable: false));
  }

  static List<CardFace> decodeFaces(String? raw) {
    if (raw == null || raw.isEmpty || raw == '[]') {
      return const [];
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return const [];
      }
      return [
        for (final item in decoded)
          if (item is Map)
            CardFace.fromJson(Map<String, dynamic>.from(item)),
      ];
    } on Object {
      return const [];
    }
  }

  static String encodeStringList(List<String> values) => jsonEncode(values);

  static List<String> decodeStringList(Object? raw) {
    if (raw == null) {
      return const [];
    }
    if (raw is List) {
      return [
        for (final item in raw)
          if (item != null && item.toString().isNotEmpty) item.toString(),
      ];
    }
    if (raw is String) {
      if (raw.isEmpty || raw == '[]') {
        return const [];
      }
      try {
        return decodeStringList(jsonDecode(raw));
      } on Object {
        return const [];
      }
    }
    return const [];
  }

  static String encodeDetails(CardPrintingDetails details) {
    return jsonEncode(details.toJson());
  }

  static CardPrintingDetails? decodeDetails(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return null;
      }
      return CardPrintingDetails.fromJson(Map<String, dynamic>.from(decoded));
    } on Object {
      return null;
    }
  }
}

/// Status of the on-device card catalog.
class CatalogStatus {
  const CatalogStatus({
    required this.printingCount,
    this.lastUpdatedAt,
    this.bulkType,
  });

  final int printingCount;
  final DateTime? lastUpdatedAt;
  final String? bulkType;

  bool get isInstalled => printingCount > 0;
}

/// Progress while downloading / importing bulk catalog data.
class CatalogSyncProgress {
  const CatalogSyncProgress({
    required this.phase,
    this.fraction,
    this.detail,
  });

  final String phase;
  final double? fraction;
  final String? detail;
}
