/// Application-wide constants.
abstract final class AppConstants {
  static const String appName = 'Compass';
  static const String tagline = 'Know where everything is.';
  static const String domain = 'getcompass.space';
  static const String packageName = 'compass';

  /// Seeded generic type so assets can be created without a type picker.
  static const String defaultAssetTypeId = 'asset-type-item';
  static const String defaultAssetTypeName = 'Item';
  static const String defaultModuleId = 'collectibles';

  /// Canonical API base for install/update URLs on getcompass.space.
  static const String domainPackApiBaseUrl =
      'https://getcompass.space/api/domains';
}
