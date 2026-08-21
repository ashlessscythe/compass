import 'package:compass/theme/app_colors.dart';
import 'package:compass/theme/app_typography.dart';
import 'package:compass/theme/compass_theme_extras.dart';
import 'package:compass/theme/compass_theme_id.dart';
import 'package:compass/theme/theme_backdrop_specs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Material 3 themes for Compass (dark-first).
abstract final class AppTheme {
  static ThemeData from(
    CompassThemeId id, {
    Color? customAccent,
  }) {
    final accent = customAccent ?? AppColors.accent;
    final accentSoft = Color.lerp(accent, Colors.white, 0.28)!;
    final accentDeep = Color.lerp(accent, Colors.black, 0.22)!;
    final backdrop = backdropForTheme(id);

    return switch (id) {
      CompassThemeId.dark => _dark(
          accent: accent,
          accentSoft: accentSoft,
          accentDeep: accentDeep,
          backdrop: backdrop,
          themeId: id,
        ),
      CompassThemeId.light => _light(
          accent: accent,
          accentSoft: accentSoft,
          accentDeep: accentDeep,
          backdrop: backdrop,
          themeId: id,
        ),
      CompassThemeId.gray => _gray(
          accent: accent,
          accentSoft: accentSoft,
          accentDeep: accentDeep,
          themeId: id,
        ),
      CompassThemeId.steelMist => _dark(
          accent: accent,
          accentSoft: accentSoft,
          accentDeep: accentDeep,
          scaffold: const Color(0xFF0B1018),
          surface: const Color(0xFF141B28),
          themeId: id,
          backdrop: backdrop,
        ),
      CompassThemeId.deepInk => _dark(
          accent: accent,
          accentSoft: accentSoft,
          accentDeep: accentDeep,
          scaffold: const Color(0xFF09080F),
          surface: const Color(0xFF15131F),
          themeId: id,
          backdrop: backdrop,
        ),
      CompassThemeId.auroraQuiet => _dark(
          accent: accent,
          accentSoft: accentSoft,
          accentDeep: accentDeep,
          scaffold: const Color(0xFF0A0E12),
          surface: const Color(0xFF12181F),
          themeId: id,
          backdrop: backdrop,
        ),
      CompassThemeId.fractalSoft => _dark(
          accent: accent,
          accentSoft: accentSoft,
          accentDeep: accentDeep,
          scaffold: const Color(0xFF0C0D12),
          surface: const Color(0xFF161822),
          themeId: id,
          backdrop: backdrop,
        ),
      CompassThemeId.meshHaze => _dark(
          accent: accent,
          accentSoft: accentSoft,
          accentDeep: accentDeep,
          scaffold: const Color(0xFF0B0C10),
          surface: const Color(0xFF15171F),
          themeId: id,
          backdrop: backdrop,
        ),
    };
  }

  /// Legacy helpers kept for call sites / tests.
  static ThemeData dark({Color? customAccent}) =>
      from(CompassThemeId.dark, customAccent: customAccent);

  static ThemeData light({Color? customAccent}) =>
      from(CompassThemeId.light, customAccent: customAccent);

  static ThemeData _gray({
    required Color accent,
    required Color accentSoft,
    required Color accentDeep,
    required CompassThemeId themeId,
  }) {
    const scaffold = AppColors.grayBackground;
    const surface = AppColors.grayElevated;
    final colorScheme = ColorScheme.dark(
      primary: accent,
      onPrimary: AppColors.foreground,
      secondary: accentSoft,
      onSecondary: scaffold,
      surface: surface,
      onSurface: const Color(0xFFE8EAEE),
      onSurfaceVariant: const Color(0xFFA8B0BE),
      error: AppColors.danger,
      onError: AppColors.foreground,
      outline: const Color(0x38FFFFFF),
      outlineVariant: const Color(0x22FFFFFF),
    );

    return _base(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackground: scaffold,
      textTheme: AppTypography.darkTextTheme(),
      systemOverlay: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: scaffold,
      ),
      accent: accent,
      extras: CompassThemeExtras(
        themeId: themeId,
        backdrop: ThemeBackdropSpec.none,
      ),
    );
  }

  static ThemeData _dark({
    required Color accent,
    required Color accentSoft,
    required Color accentDeep,
    required CompassThemeId themeId,
    required ThemeBackdropSpec backdrop,
    Color scaffold = AppColors.darkBackground,
    Color surface = AppColors.darkElevated,
  }) {
    final colorScheme = ColorScheme.dark(
      primary: accent,
      onPrimary: AppColors.foreground,
      secondary: accentSoft,
      onSecondary: scaffold,
      surface: surface,
      onSurface: AppColors.foreground,
      onSurfaceVariant: AppColors.foregroundMuted,
      error: AppColors.danger,
      onError: AppColors.foreground,
      outline: AppColors.borderDarkStrong,
      outlineVariant: AppColors.borderDark,
    );

    return _base(
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackground: scaffold,
      textTheme: AppTypography.darkTextTheme(),
      systemOverlay: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: scaffold,
      ),
      accent: accent,
      extras: CompassThemeExtras(themeId: themeId, backdrop: backdrop),
    );
  }

  static ThemeData _light({
    required Color accent,
    required Color accentSoft,
    required Color accentDeep,
    required CompassThemeId themeId,
    required ThemeBackdropSpec backdrop,
  }) {
    final colorScheme = ColorScheme.light(
      primary: accentDeep,
      onPrimary: AppColors.foreground,
      secondary: accent,
      onSurface: AppColors.foregroundOnLight,
      onSurfaceVariant: AppColors.foregroundMutedOnLight,
      error: AppColors.danger,
      onError: AppColors.foreground,
      outline: AppColors.borderLightStrong,
      outlineVariant: AppColors.borderLight,
    );

    return _base(
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.lightBackground,
      textTheme: AppTypography.lightTextTheme(),
      systemOverlay: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.lightBackground,
      ),
      accent: accent,
      extras: CompassThemeExtras(themeId: themeId, backdrop: backdrop),
    );
  }

  static ThemeData _base({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required TextTheme textTheme,
    required SystemUiOverlayStyle systemOverlay,
    required Color accent,
    required CompassThemeExtras extras,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      extensions: [extras],
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground.withValues(alpha: 0.92),
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: systemOverlay,
        titleTextStyle: textTheme.headlineSmall,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scaffoldBackground,
        indicatorColor: accent.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: AppColors.foreground,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
      ),
    );
  }
}
