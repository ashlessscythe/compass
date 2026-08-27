import 'dart:convert';

import 'package:compass/features/domains/domain/domain_pack.dart';
import 'package:flutter/services.dart';

/// Loads bundled domain pack JSON from Flutter assets.
class DomainPackLoader {
  static const bundledPackAssets = {
    'mtg': 'assets/domains/mtg/v1.json',
    'jewelry': 'assets/domains/jewelry/v1.json',
  };

  Future<DomainPack> loadBundled(String packId) async {
    final assetPath = bundledPackAssets[packId];
    if (assetPath == null) {
      throw StateError('Unknown bundled domain pack: $packId');
    }
    final raw = await rootBundle.loadString(assetPath);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return DomainPack.fromJson(json);
  }

  Future<List<DomainPack>> loadAllBundled() async {
    final packs = <DomainPack>[];
    for (final packId in bundledPackAssets.keys) {
      packs.add(await loadBundled(packId));
    }
    return packs;
  }
}
