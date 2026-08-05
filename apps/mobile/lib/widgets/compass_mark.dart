import 'package:compass/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Minimal geometric compass mark used in branding surfaces.
class CompassMark extends StatelessWidget {
  const CompassMark({
    super.key,
    this.size = 48,
    this.color = AppColors.accent,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _CompassMarkPainter(color: color),
    );
  }
}

class _CompassMarkPainter extends CustomPainter {
  _CompassMarkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final ring = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06;

    final axis = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..strokeCap = StrokeCap.round;

    final north = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas
      ..drawCircle(center, radius * 0.92, ring)
      ..drawLine(
        Offset(center.dx, center.dy - radius * 0.55),
        Offset(center.dx, center.dy + radius * 0.55),
        axis,
      )
      ..drawLine(
        Offset(center.dx - radius * 0.55, center.dy),
        Offset(center.dx + radius * 0.55, center.dy),
        axis,
      );

    // North accent triangle
    final path = Path()
      ..moveTo(center.dx, center.dy - radius * 0.78)
      ..lineTo(center.dx - radius * 0.12, center.dy - radius * 0.42)
      ..lineTo(center.dx + radius * 0.12, center.dy - radius * 0.42)
      ..close();
    canvas
      ..drawPath(path, north)
      ..drawCircle(center, size.width * 0.06, north);
  }

  @override
  bool shouldRepaint(covariant _CompassMarkPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
