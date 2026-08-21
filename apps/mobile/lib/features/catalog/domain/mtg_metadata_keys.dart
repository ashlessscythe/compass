/// Canonical metadata keys for MTG enrichment (Asset.metadata bag).
abstract final class MtgMetadataKeys {
  static const scryfallCardId = 'scryfall.card_id';
  static const legacyScryfallId = 'scryfallId';
  static const setCode = 'set';
  static const collectorNumber = 'collectorNumber';
  static const finish = 'finish';
  static const layout = 'layout';
  static const condition = 'condition';

  /// Prefer canonical key; accept legacy import key.
  static String? scryfallIdOf(Map<String, dynamic> values) {
    final canonical = values[scryfallCardId];
    if (canonical is String && canonical.trim().isNotEmpty) {
      return canonical.trim();
    }
    final legacy = values[legacyScryfallId];
    if (legacy is String && legacy.trim().isNotEmpty) {
      return legacy.trim();
    }
    return null;
  }

  static String? stringOf(Map<String, dynamic> values, String key) {
    final value = values[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }
}

/// Deduped resolve identity for match jobs / network queue.
sealed class CatalogMatchKey {
  const CatalogMatchKey();

  String get dedupeId;

  const factory CatalogMatchKey.scryfallId(String id) = ScryfallIdKey;
  const factory CatalogMatchKey.setCollector({
    required String setCode,
    required String collectorNumber,
  }) = SetCollectorKey;
  const factory CatalogMatchKey.name(String name) = NameKey;
}

final class ScryfallIdKey extends CatalogMatchKey {
  const ScryfallIdKey(this.id);
  final String id;

  @override
  String get dedupeId => 'id:${id.toLowerCase()}';
}

final class SetCollectorKey extends CatalogMatchKey {
  const SetCollectorKey({
    required this.setCode,
    required this.collectorNumber,
  });

  final String setCode;
  final String collectorNumber;

  @override
  String get dedupeId =>
      'set:${setCode.toLowerCase()}|${collectorNumber.toLowerCase()}';
}

final class NameKey extends CatalogMatchKey {
  const NameKey(this.name);
  final String name;

  @override
  String get dedupeId => 'name:${normalizeCardName(name)}';
}

String normalizeCardName(String name) {
  return name
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
      .trim()
      .replaceAll(RegExp(r'\s+'), ' ');
}

CatalogMatchKey? matchKeyFromAsset({
  required String name,
  required Map<String, dynamic> metadata,
}) {
  final id = MtgMetadataKeys.scryfallIdOf(metadata);
  if (id != null) {
    return CatalogMatchKey.scryfallId(id);
  }
  final setCode = MtgMetadataKeys.stringOf(metadata, MtgMetadataKeys.setCode);
  final collector = MtgMetadataKeys.stringOf(
    metadata,
    MtgMetadataKeys.collectorNumber,
  );
  if (setCode != null && collector != null) {
    return CatalogMatchKey.setCollector(
      setCode: setCode,
      collectorNumber: collector,
    );
  }
  final trimmed = name.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return CatalogMatchKey.name(trimmed);
}
