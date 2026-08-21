import 'dart:convert';

/// One face of a multi-face / split / flip / transform card.
class CardFace {
  const CardFace({
    required this.name,
    this.typeLine,
    this.manaCost,
    this.imageSmallUrl,
    this.imageNormalUrl,
  });

  final String name;
  final String? typeLine;
  final String? manaCost;
  final String? imageSmallUrl;
  final String? imageNormalUrl;

  Map<String, dynamic> toJson() => {
        'name': name,
        if (typeLine != null) 'type_line': typeLine,
        if (manaCost != null) 'mana_cost': manaCost,
        if (imageSmallUrl != null) 'image_small': imageSmallUrl,
        if (imageNormalUrl != null) 'image_normal': imageNormalUrl,
      };

  factory CardFace.fromJson(Map<String, dynamic> json) {
    return CardFace(
      name: (json['name'] as String?) ?? '',
      typeLine: json['type_line'] as String?,
      manaCost: json['mana_cost'] as String?,
      imageSmallUrl: json['image_small'] as String?,
      imageNormalUrl: json['image_normal'] as String?,
    );
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
    this.imageSmallUrl,
    this.imageNormalUrl,
    this.faces = const [],
  });

  final String id;
  final String? oracleId;
  final String name;
  final String setCode;
  final String collectorNumber;
  final String? layout;
  final String? typeLine;
  final String? manaCost;
  final String? imageSmallUrl;
  final String? imageNormalUrl;
  final List<CardFace> faces;
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
