import 'package:compass/theme/app_theme.dart';
import 'package:compass/theme/theme_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Resolved [ThemeData] from effective preferences + entitlement gate.
final appThemeDataProvider = Provider<ThemeData>((ref) {
  final prefs = ref.watch(effectiveThemePreferencesProvider);
  return AppTheme.from(
    prefs.themeId,
    customAccent: prefs.customAccent,
  );
});
