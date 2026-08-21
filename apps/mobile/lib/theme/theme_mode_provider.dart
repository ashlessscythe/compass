import 'package:compass/theme/compass_theme_id.dart';
import 'package:compass/theme/theme_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Legacy [ThemeMode] bridge for existing tests. Prefer theme preferences.
final themeModeProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final id = ref.watch(effectiveThemePreferencesProvider).themeId;
    return switch (id) {
      CompassThemeId.light => ThemeMode.light,
      _ => ThemeMode.dark,
    };
  }

  ThemeMode get mode => state;

  set mode(ThemeMode value) {
    final id = switch (value) {
      ThemeMode.light => CompassThemeId.light,
      ThemeMode.system || ThemeMode.dark => CompassThemeId.dark,
    };
    ref.read(themePreferencesProvider.notifier).setThemeId(id);
  }

  void toggle() {
    mode = switch (state) {
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.system => ThemeMode.dark,
    };
  }
}
