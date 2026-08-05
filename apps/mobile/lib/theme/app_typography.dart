import 'package:compass/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens for Compass.
///
/// Display: Space Grotesk · Body/UI: Inter
abstract final class AppTypography {
  static TextTheme darkTextTheme() => _build(Brightness.dark);

  static TextTheme lightTextTheme() => _build(Brightness.light);

  static TextTheme _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primary = isDark ? AppColors.foreground : AppColors.foregroundOnLight;
    final muted =
        isDark ? AppColors.foregroundMuted : AppColors.foregroundMutedOnLight;

    final display = GoogleFonts.spaceGroteskTextTheme();
    final body = GoogleFonts.interTextTheme();

    return body.copyWith(
      displayLarge: display.displayLarge?.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.5,
        fontSize: 48,
        height: 1.1,
      ),
      displayMedium: display.displayMedium?.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
        letterSpacing: -1,
        fontSize: 36,
        height: 1.15,
      ),
      displaySmall: display.displaySmall?.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        fontSize: 28,
        height: 1.2,
      ),
      headlineLarge: display.headlineLarge?.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
        fontSize: 24,
        height: 1.25,
      ),
      headlineMedium: display.headlineMedium?.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
        fontSize: 20,
        height: 1.3,
      ),
      headlineSmall: display.headlineSmall?.copyWith(
        color: primary,
        fontWeight: FontWeight.w500,
        fontSize: 18,
        height: 1.3,
      ),
      titleLarge: body.titleLarge?.copyWith(
        color: primary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      titleMedium: body.titleMedium?.copyWith(
        color: primary,
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      titleSmall: body.titleSmall?.copyWith(
        color: muted,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      bodyLarge: body.bodyLarge?.copyWith(
        color: primary,
        fontSize: 16,
        height: 1.5,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        color: muted,
        fontSize: 14,
        height: 1.5,
      ),
      bodySmall: body.bodySmall?.copyWith(
        color: muted,
        fontSize: 12,
        height: 1.4,
      ),
      labelLarge: body.labelLarge?.copyWith(
        color: primary,
        fontWeight: FontWeight.w500,
        fontSize: 14,
        letterSpacing: 0.1,
      ),
      labelMedium: body.labelMedium?.copyWith(
        color: muted,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      labelSmall: body.labelSmall?.copyWith(
        color: muted,
        fontWeight: FontWeight.w500,
        fontSize: 11,
      ),
    );
  }
}
