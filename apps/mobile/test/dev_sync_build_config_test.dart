import 'package:compass/core/constants/sync_build_config.dart';
import 'package:compass/features/entitlements/domain/compass_feature.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dev sync build gates', () {
    test('eligible features are cloud sync and backup only', () {
      expect(
        isDevSyncEligibleFeature(CompassFeature.cloudSync),
        isTrue,
      );
      expect(
        isDevSyncEligibleFeature(CompassFeature.cloudBackup),
        isTrue,
      );
      expect(
        isDevSyncEligibleFeature(CompassFeature.bulkRefresh),
        isFalse,
      );
      expect(
        isDevSyncEligibleFeature(CompassFeature.advancedThemes),
        isFalse,
      );
    });

    test('devSyncGrantsFeature is false without compile-time secret', () {
      expect(isDevSyncBuild, isFalse);
      expect(devSyncGrantsFeature(CompassFeature.cloudSync), isFalse);
    });
  });
}
