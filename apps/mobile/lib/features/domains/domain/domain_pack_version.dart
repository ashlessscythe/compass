/// Semver comparison for domain pack manifest versions.
abstract final class DomainPackVersion {
  static int compare(String a, String b) {
    final partsA = _parse(a);
    final partsB = _parse(b);
    final length = partsA.length > partsB.length ? partsA.length : partsB.length;
    for (var i = 0; i < length; i++) {
      final av = i < partsA.length ? partsA[i] : 0;
      final bv = i < partsB.length ? partsB[i] : 0;
      if (av != bv) {
        return av.compareTo(bv);
      }
    }
    return 0;
  }

  static bool isNewer(String candidate, String current) {
    return compare(candidate, current) > 0;
  }

  static List<int> _parse(String version) {
    return version
        .split('.')
        .map((part) => int.tryParse(part.trim()) ?? 0)
        .toList(growable: false);
  }
}
