import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A minimal joystick-like control that avoids a known crash in the
/// `flutter_joystick` package (null check operator on a null value during
/// delayed drag updates).
///
/// This implementation only supports horizontal mode (used in the app today).
class SafeJoystick extends StatefulWidget {
  final double size;
  final void Function(double x, double y)? onChanged;

  /// Output clamp for x/y.
  final double maxMagnitude;

  const SafeJoystick({
    super.key,
    required this.size,
    required this.mode,
    this.onChanged,
    this.maxMagnitude = 1.0,
  });

  /// Kept for API compatibility with existing call sites.
  final JoystickMode mode;

  @override
  State<SafeJoystick> createState() => _SafeJoystickState();
}

/// Minimal enum to match the `flutter_joystick` API used in the codebase.
/// We only use [horizontal] for steering.
enum JoystickMode { horizontal }

class _SafeJoystickState extends State<SafeJoystick> {
  Offset _knob = Offset.zero; // -1..1 space
  bool _dragging = false;

  void _updateFromLocal(Offset localPosition) {
    final radius = widget.size / 2;
    final center = Offset(radius, radius);
    final delta = localPosition - center;

    // Convert to -1..1 by size.
    final normX = (delta.dx / radius).clamp(-1.0, 1.0);

    // We only need horizontal steering.
    final x = normX.clamp(-widget.maxMagnitude, widget.maxMagnitude);
    final y = 0.0;

    setState(() => _knob = Offset(x, y));
    widget.onChanged?.call(x, y);
  }

  void _end() {
    setState(() {
      _dragging = false;
      _knob = Offset.zero;
    });
    widget.onChanged?.call(0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.size / 2;
    final knobRadius = widget.size * 0.18;

    final knobOffset = Offset(_knob.dx * (radius - knobRadius), 0);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Listener(
        onPointerDown: (_) => setState(() => _dragging = true),
        onPointerUp: (_) => _end(),
        onPointerCancel: (_) => _end(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (d) {
            _dragging = true;
            _updateFromLocal(d.localPosition);
          },
          onPanUpdate: (d) {
            if (!_dragging) return;
            _updateFromLocal(d.localPosition);
          },
          onPanEnd: (_) => _end(),
          onPanCancel: _end,
          child: CustomPaint(
            painter: _JoystickPainter(
              knobOffset: knobOffset,
              radius: radius,
              knobRadius: knobRadius,
              active: _dragging,
            ),
          ),
        ),
      ),
    );
  }
}

class _JoystickPainter extends CustomPainter {
  final Offset knobOffset;
  final double radius;
  final double knobRadius;
  final bool active;

  _JoystickPainter({
    required this.knobOffset,
    required this.radius,
    required this.knobRadius,
    required this.active,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(radius, radius);

    final bgPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.0, radius * 0.04);

    final knobPaint = Paint()
      ..color = active
          ? Colors.white.withValues(alpha: 0.95)
          : Colors.white.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawCircle(center, radius * 0.78, ringPaint);

    final knobCenter = center + knobOffset;
    canvas.drawCircle(knobCenter, knobRadius, knobPaint);
  }

  @override
  bool shouldRepaint(covariant _JoystickPainter oldDelegate) {
    return oldDelegate.knobOffset != knobOffset || oldDelegate.active != active;
  }
}
