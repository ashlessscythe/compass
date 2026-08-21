import 'package:compass/theme/compass_theme_id.dart';
import 'package:flutter/material.dart';

/// Carried on [ThemeData] for scaffold ambience painting.
@immutable
class CompassThemeExtras extends ThemeExtension<CompassThemeExtras> {
  const CompassThemeExtras({
    required this.themeId,
    required this.backdrop,
  });

  final CompassThemeId themeId;
  final ThemeBackdropSpec backdrop;

  @override
  CompassThemeExtras copyWith({
    CompassThemeId? themeId,
    ThemeBackdropSpec? backdrop,
  }) {
    return CompassThemeExtras(
      themeId: themeId ?? this.themeId,
      backdrop: backdrop ?? this.backdrop,
    );
  }

  @override
  CompassThemeExtras lerp(ThemeExtension<CompassThemeExtras>? other, double t) {
    if (other is! CompassThemeExtras) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}
