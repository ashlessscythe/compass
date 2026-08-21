import 'package:compass/theme/compass_theme_id.dart';
import 'package:flutter/material.dart';

/// Backdrop recipe for a theme id (kept separate from [ThemeData] for tests).
ThemeBackdropSpec backdropForTheme(CompassThemeId id) {
  return switch (id) {
    CompassThemeId.dark ||
    CompassThemeId.light ||
    CompassThemeId.gray =>
      ThemeBackdropSpec.none,
    CompassThemeId.steelMist => const ThemeBackdropSpec(
        kind: ThemeBackdropKind.softGradient,
        colors: [
          Color(0xFF0B1018),
          Color(0xFF1A2A40),
          Color(0xFF0B1018),
        ],
      ),
    CompassThemeId.deepInk => const ThemeBackdropSpec(
        kind: ThemeBackdropKind.softGradient,
        colors: [
          Color(0xFF09080F),
          Color(0xFF1A1430),
          Color(0xFF09080F),
        ],
      ),
    CompassThemeId.auroraQuiet => const ThemeBackdropSpec(
        kind: ThemeBackdropKind.softGradient,
        colors: [
          Color(0xFF0A0E12),
          Color(0xFF12241F),
          Color(0xFF1A1830),
          Color(0xFF0A0E12),
        ],
      ),
    CompassThemeId.fractalSoft => const ThemeBackdropSpec(
        kind: ThemeBackdropKind.fractal,
        colors: [
          Color(0xFF0C0D12),
          Color(0xFF2A3550),
          Color(0x595B8DEF),
        ],
      ),
    CompassThemeId.meshHaze => const ThemeBackdropSpec(
        kind: ThemeBackdropKind.mesh,
        colors: [
          Color(0xFF0B0C10),
          Color(0xFF151A24),
          Color(0x405B8DEF),
        ],
      ),
  };
}
