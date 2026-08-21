import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Scryfall-style 3D Y-axis card flip between two (or more) face widgets.
class FlippingCardArt extends StatefulWidget {
  const FlippingCardArt({
    required this.faceIndex,
    required this.faces,
    super.key,
    this.onTap,
    this.borderRadius = 12,
  });

  /// Currently selected face (drives the flip when it changes).
  final int faceIndex;

  /// One child per face; typically card art images.
  final List<Widget> faces;

  /// Optional tap-to-flip (parent usually advances [faceIndex]).
  final VoidCallback? onTap;

  final double borderRadius;

  @override
  State<FlippingCardArt> createState() => _FlippingCardArtState();
}

class _FlippingCardArtState extends State<FlippingCardArt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _turn;
  var _visibleIndex = 0;

  @override
  void initState() {
    super.initState();
    _visibleIndex = widget.faceIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _turn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.addListener(_onTick);
  }

  void _onTick() {
    // Swap the painted face at the midpoint so the "back" is upright.
    if (_controller.value >= 0.5 &&
        _visibleIndex != widget.faceIndex &&
        mounted) {
      setState(() => _visibleIndex = widget.faceIndex);
    }
  }

  @override
  void didUpdateWidget(covariant FlippingCardArt oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.faceIndex != oldWidget.faceIndex &&
        widget.faces.length > 1 &&
        !_controller.isAnimating) {
      _controller.forward(from: 0);
    } else if (widget.faceIndex != _visibleIndex && !_controller.isAnimating) {
      _visibleIndex = widget.faceIndex;
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTick)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.faces.isEmpty) {
      return const SizedBox.shrink();
    }
    if (widget.faces.length == 1) {
      return _frame(child: widget.faces.first);
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _turn,
        builder: (context, _) {
          final t = _turn.value;
          // 0 → π; after midpoint the face has swapped so keep reading 0→π/2.
          final angle = t < 0.5 ? t * math.pi : (1 - t) * math.pi;
          // Slight scale punch like Scryfall's playful flip.
          final scale = 1.0 + 0.04 * math.sin(t * math.pi);

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.00135)
              ..rotateY(angle)
              ..scale(scale),
            child: _frame(
              child: widget.faces[
                  _visibleIndex.clamp(0, widget.faces.length - 1)],
            ),
          );
        },
      ),
    );
  }

  Widget _frame({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: child,
    );
  }
}
