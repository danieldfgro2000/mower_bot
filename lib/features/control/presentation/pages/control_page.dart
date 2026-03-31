import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_state.dart';
import 'package:mower_bot/features/control/presentation/widgets/joystick_safe_wrapper.dart';

import 'components/esp_cam_view.dart';

class ControlPage extends StatefulWidget {
  static const String routeName = '/control';

  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage>
    with SingleTickerProviderStateMixin {
  double steering = 0; // retain steering value locally
  late AnimationController _blinkController;

  /// Ensures we only call [_onEnter] when the control tab becomes active.
  bool _isActive = false;

  late final RouteInformationProvider _routeInfoProvider;
  late final VoidCallback _routeListener;

  // Fire the actions that should happen when the control tab becomes visible.
  void _onEnter() {
    // NOTE: keep this idempotent; it can still be called when re-entering.
    final bloc = context.read<ControlBloc>();
    bloc.add(StartTelemetryStream());
    bloc.add(ClearError());
    bloc.add(GetVideoStreamUrl());
  }

  void _syncActiveFromRoute() {
    final location = _routeInfoProvider.value.uri.toString();
    final nowActive = location.startsWith(ControlPage.routeName);

    if (nowActive && !_isActive) {
      _isActive = true;
      _onEnter();
    } else if (!nowActive && _isActive) {
      _isActive = false;
    }
  }

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Hook tab-activation detection to the router's route info changes.
    final router = GoRouter.of(context);
    _routeInfoProvider = router.routeInformationProvider;
    _routeListener = _syncActiveFromRoute;
    _routeInfoProvider.addListener(_routeListener);

    // Evaluate immediately (covers initialLocation=/control).
    _syncActiveFromRoute();
  }

  @override
  void dispose() {
    _routeInfoProvider.removeListener(_routeListener);
    _blinkController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final controlBloc = context.read<ControlBloc>();
    const double controlsHeight = 72 + 16 + 100; // arrow + spacing + joystick/stop

    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final screenWidth = constraints.maxWidth;
          return Stack(
            fit: StackFit.expand,
            children: [
              const Positioned.fill(child: EspMjpegWebView()),
              if (ctx.select((ControlBloc b) => b.state.isRecording == true))
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: _recordingBanner(ctx),
                ),
              _recordButton(ctx),
              Positioned.fill(
                top: 0,
                left: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: _driveUnit(ctx, screenWidth),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: _stopButton(ctx, controlBloc),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ctx.select((ControlBloc b) => (b.state.errorMessage != null && b.state.errorMessage!.isNotEmpty))
                  ? Positioned(
                      bottom: controlsHeight + 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          ctx.select((ControlBloc b) => b.state.errorMessage ?? ''),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _stopButton(BuildContext ctx, ControlBloc controlBloc) {
    final isMowerMoving = ctx.select((ControlBloc b) => b.state.isMowerMoving == true);
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 120, height: 120),
      iconSize: 120.0,
      splashColor: Colors.red.shade500,
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.hexagon_rounded,
            color: isMowerMoving ? Colors.red : Colors.grey,
          ),
          Text(
            'STOP',
            style: TextStyle(
              color: isMowerMoving ? Colors.white : Colors.grey.shade300,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          )
        ],
      ),
      onPressed: () {
        controlBloc.add(EmergencyStop());
      },
    );
  }

  Column _driveUnit(BuildContext ctx, double screenWidth) {
    final isMowerMoving = ctx.select((ControlBloc b) => b.state.isMowerMoving == true,);
    final controlBloc = ctx.read<ControlBloc>();

    // Compact control sizes to minimize vertical height
    final arrowBtnSize = math.min(64.0, screenWidth * 0.1);
    final arrowIconSize = math.min(50.0, screenWidth * 0.1);
    final joystickSize = math.min(100.0, screenWidth * 0.3);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(
            width: arrowBtnSize,
            height: arrowBtnSize,
          ),
          iconSize: arrowIconSize,
          icon: Icon(
            color: isMowerMoving ? Colors.green : Colors.grey,
            Icons.keyboard_double_arrow_up_sharp,
          ),
          onPressed: () {
            final next = !isMowerMoving;
            controlBloc.add(SteerCommand(angle: steering));
            controlBloc.add(DriveCommand(isMoving: next));
          },
        ),
        // Use a compact joystick with minimal footprint
        JoystickWithTrackingDot(size: joystickSize),
      ],
    );
  }

  Positioned _recordButton(BuildContext context) {
    final controlBloc = context.read<ControlBloc>();
    final isRecording = context.select(
      (ControlBloc b) => b.state.isRecording == true,
    );
    return Positioned(
      top: 20,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, right: 4),
          child: IconButton(
            tooltip: "Record Path",
            isSelected: isRecording,
            onPressed: () async {
              if (isRecording) {
                final fileName = await _askPathName(context) ??
                    'path_${DateTime.now().millisecondsSinceEpoch}';
                controlBloc.add(StopRecord(fileName: fileName));
              } else {
                controlBloc.add(StartRecord());
              }
            },
            icon: isRecording
                ? FadeTransition(
                    opacity: _blinkController,
                    child: const Icon(Icons.fiber_manual_record, color: Colors.red),
                  )
                : const Icon(Icons.fiber_manual_record, color: Colors.grey),
            iconSize: 48.0,
          ),
        ),
      ),
    );
  }

  Container _recordingBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100.0,
      color: Colors.orange.shade500,
      padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
      child: Text(
        textAlign: TextAlign.center,
        textScaler: TextScaler.linear(1.1),
        'Recording PATH in progress...',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<String?> _askPathName(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Path name'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(
              controller.text.trim().isEmpty ? null : controller.text.trim(),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class JoystickWithTrackingDot extends StatefulWidget {
  final double size;

  const JoystickWithTrackingDot({super.key, required this.size});

  @override
  State<JoystickWithTrackingDot> createState() =>
      _JoystickWithTrackingDotState();
}

class _JoystickWithTrackingDotState extends State<JoystickWithTrackingDot> {
  @override
  Widget build(BuildContext context) {
    final joystickSize = widget.size;
    final angleTrackingDotRadius = joystickSize * 0.06;
    return SizedBox(
      width: joystickSize,
      height: joystickSize,
      child: BlocSelector<ControlBloc, ControlState, double>(
        selector: (s) => s.telemetryData?.wheelAngle ?? 0.0,
        builder: (context, angleDeg) {
          final r = (joystickSize * 0.4) + angleTrackingDotRadius;
          final rad = angleDeg * math.pi / 180.0;
          final theta = math.pi / 2 - rad;
          final dx = r * math.cos(theta);
          final dy = -r * math.sin(theta);
          return Stack(
            alignment: Alignment.center,
            children: [
              SafeJoystick(
                size: joystickSize,
                mode: JoystickMode.horizontal,
                onChanged: (x, y) {
                  context.read<ControlBloc>().add(
                    SteerCommand(angle: x * 45),
                  );
                },
              ),
              IgnorePointer(
                child: Transform.translate(
                  offset: Offset(dx, dy),
                  child: Container(
                    width: angleTrackingDotRadius * 2,
                    height: angleTrackingDotRadius * 2,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
