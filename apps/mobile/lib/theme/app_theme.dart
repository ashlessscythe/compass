import 'package:compass/theme/app_colors.dart';
import 'package:compass/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Material 3 themes for Compass (dark-first).
abstract final class AppTheme {
  static ThemeData dark() {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.foreground,
      secondary: AppColors.accentSoft,
      onSecondary: AppColors.darkBackground,
      surface: AppColors.darkElevated,
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
      scaffoldBackground: AppColors.darkBackground,
      textTheme: AppTypography.darkTextTheme(),
      systemOverlay: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.darkBackground,
      ),
    );
  }

  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.accentDeep,
      onPrimary: AppColors.foreground,
      secondary: AppColors.accent,
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
    );
  }

  static ThemeData _base({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required TextTheme textTheme,
    required SystemUiOverlayStyle systemOverlay,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
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
        indicatorColor: AppColors.accent.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
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
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
      ),
    );
  }
}
