import 'package:compass/theme/compass_theme_extras.dart';
import 'package:compass/theme/compass_theme_id.dart';
import 'package:flutter/material.dart';

/// Paints ambience behind scaffold content when a skin requests it.
class ThemeBackdrop extends StatelessWidget {
  const ThemeBackdrop({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final extras = Theme.of(context).extension<CompassThemeExtras>();
    final backdrop = extras?.backdrop ?? ThemeBackdropSpec.none;
    if (backdrop.kind == ThemeBackdropKind.none || backdrop.colors.isEmpty) {
      return child;
    }

    return CustomPaint(
      painter: _BackdropPainter(backdrop),
      child: child,
    );
  }
}

class _BackdropPainter extends CustomPainter {
  _BackdropPainter(this.spec);

  final ThemeBackdropSpec spec;

  @override
  void paint(Canvas canvas, Size size) {
    switch (spec.kind) {
      case ThemeBackdropKind.none:
        return;
      case ThemeBackdropKind.softGradient:
        final paint = Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: spec.colors,
          ).createShader(Offset.zero & size);
        canvas.drawRect(Offset.zero & size, paint);
      case ThemeBackdropKind.mesh:
        _paintMesh(canvas, size);
      case ThemeBackdropKind.fractal:
        _paintFractal(canvas, size);
    }
  }

  void _paintMesh(Canvas canvas, Size size) {
    final base = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: spec.colors,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, base);

    final line = Paint()
      ..color = (spec.colors.last).withValues(alpha: 0.08)
      ..strokeWidth = 1;
    const step = 28.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  void _paintFractal(Canvas canvas, Size size) {
    final base = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.2, -0.4),
        radius: 1.2,
        colors: spec.colors,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, base);

    final accent = Paint()
      ..color = spec.colors.last.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    var radius = 40.0;
    final center = Offset(size.width * 0.72, size.height * 0.28);
    while (radius < size.shortestSide) {
      canvas.drawCircle(center, radius, accent);
      radius *= 1.45;
    }
  }

  @override
  bool shouldRepaint(covariant _BackdropPainter oldDelegate) {
    return oldDelegate.spec.kind != spec.kind ||
        oldDelegate.spec.colors != spec.colors;
  }
}
