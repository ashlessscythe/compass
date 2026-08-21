import 'package:flutter/material.dart';

/// Stable ARGB int for prefs / equality.
int colorToArgb(Color color) {
  final a = (color.a * 255.0).round() & 0xff;
  final r = (color.r * 255.0).round() & 0xff;
  final g = (color.g * 255.0).round() & 0xff;
  final b = (color.b * 255.0).round() & 0xff;
  return (a << 24) | (r << 16) | (g << 8) | b;
}

bool colorsEqual(Color? a, Color? b) {
  if (a == null || b == null) {
    return a == b;
  }
  return colorToArgb(a) == colorToArgb(b);
}
