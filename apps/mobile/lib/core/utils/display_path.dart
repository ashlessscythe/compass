abstract final class DisplayPath {
  static const String separator = ' / ';

  static String join(String? parentPath, String name) {
    final parent = parentPath?.trim();
    if (parent == null || parent.isEmpty) {
      return name;
    }
    return '$parent$separator$name';
  }
}
