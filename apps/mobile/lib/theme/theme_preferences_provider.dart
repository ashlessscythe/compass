import 'package:compass/features/entitlements/application/entitlement_providers.dart';
import 'package:compass/features/entitlements/domain/compass_feature.dart';
import 'package:compass/theme/color_utils.dart';
import 'package:compass/theme/compass_theme_id.dart';
import 'package:compass/theme/theme_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeIdKey = 'appearance.theme_id';
const _accentKey = 'appearance.custom_accent';

/// Persisted theme selection (may reference a paid id even when locked).
final themePreferencesProvider =
    NotifierProvider<ThemePreferencesController, ThemePreferences>(
  ThemePreferencesController.new,
);

class ThemePreferencesController extends Notifier<ThemePreferences> {
  @override
  ThemePreferences build() {
    _load();
    return ThemePreferences.defaults;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final id = CompassThemeIdX.tryParse(prefs.getString(_themeIdKey)) ??
        CompassThemeId.dark;
    final accentValue = prefs.getInt(_accentKey);
    state = ThemePreferences(
      themeId: id,
      customAccent: accentValue == null ? null : Color(accentValue),
    );
  }

  Future<void> setThemeId(CompassThemeId id) async {
    state = state.copyWith(themeId: id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeIdKey, id.storageKey);
  }

  Future<void> setCustomAccent(Color? color) async {
    state = state.copyWith(
      customAccent: color,
      clearAccent: color == null,
    );
    final prefs = await SharedPreferences.getInstance();
    if (color == null) {
      await prefs.remove(_accentKey);
    } else {
      await prefs.setInt(_accentKey, colorToArgb(color));
    }
  }
}

/// Effective theme after entitlement gating (paid id falls back while locked).
final effectiveThemePreferencesProvider = Provider<ThemePreferences>((ref) {
  final prefs = ref.watch(themePreferencesProvider);
  final canThemes =
      ref.watch(canUseFeatureProvider(CompassFeature.advancedThemes));
  final canAccent =
      ref.watch(canUseFeatureProvider(CompassFeature.customAccent));
  if (prefs.themeId.requiresPro && !canThemes) {
    return prefs.copyWith(
      themeId: CompassThemeId.dark,
      clearAccent: true,
    );
  }
  if (!canAccent && prefs.customAccent != null) {
    return prefs.copyWith(clearAccent: true);
  }
  return prefs;
});
