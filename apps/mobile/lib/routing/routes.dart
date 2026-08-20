/// Named route path constants.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String importCsv = '/settings/import';
  static const String about = '/about';
  static const String locationDetail = '/locations/:id';
  static const String containerDetail = '/containers/:id';
  static const String assetDetail = '/assets/:id';

  static String locationPath(String id) => '/locations/$id';
  static String containerPath(String id) => '/containers/$id';
  static String assetPath(String id) => '/assets/$id';
}
