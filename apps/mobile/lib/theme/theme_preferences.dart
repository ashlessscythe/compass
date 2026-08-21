import 'package:compass/theme/compass_theme_id.dart';
import 'package:flutter/material.dart';

/// Persisted appearance choice.
@immutable
class ThemePreferences {
  const ThemePreferences({
    required this.themeId,
    this.customAccent,
  });

  final CompassThemeId themeId;

  /// Subscriber-only accent override. Null = brand steel.
  final Color? customAccent;

  static const defaults = ThemePreferences(themeId: CompassThemeId.dark);

  ThemePreferences copyWith({
    CompassThemeId? themeId,
    Color? customAccent,
    bool clearAccent = false,
  }) {
    return ThemePreferences(
      themeId: themeId ?? this.themeId,
      customAccent: clearAccent ? null : (customAccent ?? this.customAccent),
    );
  }
}
