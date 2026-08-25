import 'package:compass/features/entitlements/domain/compass_feature.dart';

/// Compile-time sync / API configuration (`--dart-define=...`).
///
/// When [compassSyncDevSecret] is non-empty, the build is a temporary dev-sync
/// test binary: Sync entitlements unlock and Dev sign-in works in release.
const compassApiBaseUrl = String.fromEnvironment('COMPASS_API_BASE_URL');

const compassSyncDevSecret = String.fromEnvironment('COMPASS_SYNC_DEV_SECRET');

const compassSyncDevDeviceId =
    String.fromEnvironment('COMPASS_SYNC_DEV_DEVICE_ID');

bool get isDevSyncBuild => compassSyncDevSecret.isNotEmpty;

bool get isDevSyncAuthEnabled =>
    isDevSyncBuild && compassApiBaseUrl.isNotEmpty;

/// Sync features unlocked when [isDevSyncBuild] is true.
bool isDevSyncEligibleFeature(CompassFeature feature) {
  return feature == CompassFeature.cloudSync ||
      feature == CompassFeature.cloudBackup;
}

/// Whether a dev-sync test build grants [feature] without a store Sync SKU.
bool devSyncGrantsFeature(CompassFeature feature) {
  return isDevSyncBuild && isDevSyncEligibleFeature(feature);
}
