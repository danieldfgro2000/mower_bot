import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class SafeJoystick extends StatefulWidget {
  final double size;
  final JoystickMode mode;
  final void Function(double x, double y)? onChanged;
  final double maxMagnitude;

  const SafeJoystick({
    super.key,
    required this.size,
    required this.mode,
    this.onChanged,
    this.maxMagnitude = 1.0,
  });

  @override
  State<SafeJoystick> createState() => _SafeJoystickState();
}

class _SafeJoystickState extends State<SafeJoystick> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Joystick(
        mode: widget.mode,
        listener: (details) {
          if (!_ready || details == null) return;
          try {
            final rawX = (details.x as num).toDouble();
            final rawY = (details.y as num).toDouble();
            final clampedX = rawX.clamp(-widget.maxMagnitude, widget.maxMagnitude);
            final clampedY = rawY.clamp(-widget.maxMagnitude, widget.maxMagnitude);
            widget.onChanged?.call(clampedX, clampedY);
          } catch (_) {
            // swallow to prevent crash
          }
        },
      ),
    );
  }
}
