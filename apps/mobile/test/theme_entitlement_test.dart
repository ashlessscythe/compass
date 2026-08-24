import 'package:compass/features/entitlements/application/entitlement_providers.dart';
import 'package:compass/features/entitlements/domain/compass_feature.dart';
import 'package:compass/features/entitlements/domain/product_catalog.dart';
import 'package:compass/features/entitlements/infrastructure/fake_entitlement_service.dart';
import 'package:compass/theme/compass_theme_id.dart';
import 'package:compass/theme/theme_backdrop_specs.dart';
import 'package:compass/theme/theme_preferences.dart';
import 'package:compass/theme/theme_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('free themes do not require Pro', () {
    expect(CompassThemeId.dark.isFree, isTrue);
    expect(CompassThemeId.light.isFree, isTrue);
    expect(CompassThemeId.gray.isFree, isTrue);
    expect(CompassThemeId.steelMist.requiresPro, isTrue);
  });

  test('paid skins declare gradient or pattern backdrops', () {
    final mist = backdropForTheme(CompassThemeId.steelMist);
    expect(mist.kind, ThemeBackdropKind.softGradient);
    expect(mist.colors, isNotEmpty);
    expect(
      backdropForTheme(CompassThemeId.fractalSoft).kind,
      ThemeBackdropKind.fractal,
    );
  });

  test('legacy compass entitlement maps to Pro features', () {
    final features = ProductFeatureMap.featuresForProduct(
      ProductIds.legacyCompassEntitlement,
    );
    expect(features, contains(CompassFeature.advancedThemes));
    expect(features, contains(CompassFeature.customAccent));
    expect(features, contains(CompassFeature.bulkRefresh));
    expect(features, isNot(contains(CompassFeature.cloudSync)));
  });

  test('Sync tier does not grant Pro features', () {
    final features =
        ProductFeatureMap.featuresForTier(EntitlementTier.sync);
    expect(features, contains(CompassFeature.cloudBackup));
    expect(features, isNot(contains(CompassFeature.advancedThemes)));
  });

  test('theme preferences persist theme id and accent', () async {
    final container = ProviderContainer(
      overrides: [
        entitlementServiceProvider.overrideWithValue(
          FakeEntitlementService(initialTier: EntitlementTier.pro),
        ),
        activeFeaturesProvider.overrideWith(_ProFeatures.new),
      ],
    );
    addTearDown(container.dispose);

    final controller = container.read(themePreferencesProvider.notifier);
    await controller.setThemeId(CompassThemeId.light);
    await controller.setCustomAccent(const Color(0xFF112233));

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('appearance.theme_id'), 'light');
    expect(prefs.getInt('appearance.custom_accent'), isNotNull);

    expect(
      container.read(themePreferencesProvider).themeId,
      CompassThemeId.light,
    );
  });

  test('effective theme falls back when paid id locked', () {
    final locked = ProviderContainer(
      overrides: [
        entitlementServiceProvider.overrideWithValue(FakeEntitlementService()),
        activeFeaturesProvider.overrideWith(_FreeFeatures.new),
        themePreferencesProvider.overrideWith(_SeededThemePrefs.new),
      ],
    );
    addTearDown(locked.dispose);
    expect(
      locked.read(effectiveThemePreferencesProvider).themeId,
      CompassThemeId.dark,
    );

    final unlocked = ProviderContainer(
      overrides: [
        entitlementServiceProvider.overrideWithValue(
          FakeEntitlementService(initialTier: EntitlementTier.pro),
        ),
        activeFeaturesProvider.overrideWith(_ProFeatures.new),
        themePreferencesProvider.overrideWith(_SeededThemePrefs.new),
      ],
    );
    addTearDown(unlocked.dispose);
    expect(
      unlocked.read(effectiveThemePreferencesProvider).themeId,
      CompassThemeId.auroraQuiet,
    );
  });
}

class _SeededThemePrefs extends ThemePreferencesController {
  @override
  ThemePreferences build() {
    return const ThemePreferences(themeId: CompassThemeId.auroraQuiet);
  }
}

class _ProFeatures extends ActiveFeaturesController {
  @override
  Set<CompassFeature> build() => ProductFeatureMap.proFeatures;
}

class _FreeFeatures extends ActiveFeaturesController {
  @override
  Set<CompassFeature> build() => const {};
}
