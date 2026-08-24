import 'package:flutter/material.dart';

/// Catalog of Compass appearance themes.
enum CompassThemeId {
  dark,
  light,
  gray,
  steelMist,
  deepInk,
  auroraQuiet,
  fractalSoft,
  meshHaze,
}

extension CompassThemeIdX on CompassThemeId {
  String get storageKey => name;

  String get label => switch (this) {
        CompassThemeId.dark => 'Dark',
        CompassThemeId.light => 'Light',
        CompassThemeId.gray => 'Gray',
        CompassThemeId.steelMist => 'Steel mist',
        CompassThemeId.deepInk => 'Deep ink',
        CompassThemeId.auroraQuiet => 'Aurora',
        CompassThemeId.fractalSoft => 'Fractal',
        CompassThemeId.meshHaze => 'Mesh haze',
      };

  bool get isFree => switch (this) {
        CompassThemeId.dark ||
        CompassThemeId.light ||
        CompassThemeId.gray =>
          true,
        _ => false,
      };

  /// Ambience skins need Pro (`advancedThemes`).
  bool get requiresPro => !isFree;

  Brightness get brightness => switch (this) {
        CompassThemeId.light => Brightness.light,
        _ => Brightness.dark,
      };

  static CompassThemeId? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) {
      return null;
    }
    for (final id in CompassThemeId.values) {
      if (id.storageKey == raw) {
        return id;
      }
    }
    return null;
  }

  static const List<CompassThemeId> freeThemes = [
    CompassThemeId.dark,
    CompassThemeId.light,
    CompassThemeId.gray,
  ];

  static const List<CompassThemeId> paidThemes = [
    CompassThemeId.steelMist,
    CompassThemeId.deepInk,
    CompassThemeId.auroraQuiet,
    CompassThemeId.fractalSoft,
    CompassThemeId.meshHaze,
  ];
}

/// How the scaffold paints ambience behind content.
enum ThemeBackdropKind {
  none,
  softGradient,
  mesh,
  fractal,
}

class ThemeBackdropSpec {
  const ThemeBackdropSpec({
    required this.kind,
    this.colors = const [],
  });

  final ThemeBackdropKind kind;
  final List<Color> colors;

  static const none = ThemeBackdropSpec(kind: ThemeBackdropKind.none);
}
