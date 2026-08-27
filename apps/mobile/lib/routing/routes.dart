/// Named route path constants.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String domains = '/domains';
  static const String domainHome = '/domains/:moduleId';
  static const String domainSettings = '/domains/:moduleId/settings';
  static const String domainImport = '/domains/:moduleId/import';
  static const String domainExport = '/domains/:moduleId/export';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String importCsv = '/settings/import';
  static const String exportCsv = '/settings/export';
  static const String themes = '/settings/themes';
  static const String about = '/about';
  static const String locationDetail = '/locations/:id';
  static const String containerDetail = '/containers/:id';
  static const String assetDetail = '/assets/:id';

  static String domainHomePath(String moduleId) => '/domains/$moduleId';
  static String domainSettingsPath(String moduleId) =>
      '/domains/$moduleId/settings';
  static String domainImportPath(String moduleId) =>
      '/domains/$moduleId/import';
  static String domainExportPath(String moduleId) =>
      '/domains/$moduleId/export';
  static String locationPath(String id) => '/locations/$id';
  static String containerPath(String id) => '/containers/$id';
  static String assetPath(String id) => '/assets/$id';
}
