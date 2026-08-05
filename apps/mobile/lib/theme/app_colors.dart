import 'package:flutter/material.dart';

/// Compass color tokens — dark-first, cool steel accent.
///
/// Aligned with `packages/branding` for cross-platform consistency.
abstract final class AppColors {
  // Dark surfaces
  static const Color darkBackground = Color(0xFF0A0B0D);
  static const Color darkElevated = Color(0xFF12141A);
  static const Color darkMuted = Color(0xFF1A1D26);

  // Light surfaces
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightElevated = Color(0xFFFFFFFF);
  static const Color lightMuted = Color(0xFFEBEEF3);

  // Foreground
  static const Color foreground = Color(0xFFF4F5F7);
  static const Color foregroundMuted = Color(0xFF9AA3B2);
  static const Color foregroundSubtle = Color(0xFF6B7385);
  static const Color foregroundOnLight = Color(0xFF0A0B0D);
  static const Color foregroundMutedOnLight = Color(0xFF5C6575);

  // Accent (cool steel / blue)
  static const Color accent = Color(0xFF5B8DEF);
  static const Color accentSoft = Color(0xFF7AA2F7);
  static const Color accentDeep = Color(0xFF3B6FD4);

  // Semantic
  static const Color success = Color(0xFF3DDC97);
  static const Color warning = Color(0xFFF5A524);
  static const Color danger = Color(0xFFF31260);

  // Borders
  static const Color borderDark = Color(0x14FFFFFF);
  static const Color borderDarkStrong = Color(0x24FFFFFF);
  static const Color borderLight = Color(0x140A0B0D);
  static const Color borderLightStrong = Color(0x240A0B0D);
}
