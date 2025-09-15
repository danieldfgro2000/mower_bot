import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_state.dart';

import 'components/esp_cam_view.dart';

class ControlPage extends StatefulWidget {
  static const String routeName = '/control';

  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ControlBloc>().add(StartTelemetryStream());
    context.read<ControlBloc>().add(ClearError());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned.fill(top: 0, left: 0, child: EspMjpegWebView()),

        BlocSelector<ControlBloc, ControlState, bool>(
          selector: (s) => s.isRecording == true,
          builder: (context, isRecording) =>
              isRecording
                  ? _recordingBanner(context)
                  : const SizedBox.shrink(),
        ),

        _recordButton(context),

        BlocBuilder<ControlBloc, ControlState>(
          builder: (context, state) => Positioned.fill(
            top: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _driveUnit(context, screenWidth),
                      Spacer(),
                      _engineUnit(context, screenWidth),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        BlocSelector<ControlBloc, ControlState, String?>(
          selector: (s) => s.errorMessage,
          builder: (context, errorMessage) =>
              errorMessage == null || errorMessage.isEmpty
              ? const SizedBox.shrink()
              : Positioned.fill(
                  top: 100,
                  left: 0,
                  child: IgnorePointer(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Column _engineUnit(BuildContext context, double screenWidth) {
    final isRunning = context.select(
      (ControlBloc b) => b.state.isMowerRunning == true,
    );
    final isMoving = context.select(
      (ControlBloc b) => b.state.isMowerMoving == true,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          iconSize: screenWidth * 0.1,
          splashColor: Colors.blue.shade500,
          icon: Icon(
            Icons.motorcycle_rounded,
            color: isRunning ? Colors.green : Colors.grey,
          ),
          onPressed: () => context.read<ControlBloc>().add(
            RunCommand(isRunning: !isRunning),
          ),
        ),
        IconButton(
          iconSize: screenWidth * 0.2,
          splashColor: Colors.red.shade500,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            Icons.emergency,
            color: isMoving || isRunning ? Colors.red : Colors.grey,
          ),
          onPressed: () => context.read<ControlBloc>().add(EmergencyStop()),
        ),
      ],
    );
  }

  Column _driveUnit(BuildContext context, double screenWidth) {
    final isMoving = context.select(
      (ControlBloc b) => b.state.isMowerMoving == true,
    );
    final controlBloc = context.read<ControlBloc>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: screenWidth * 0.1,
          icon: Icon(
            color: isMoving ? Colors.green : Colors.grey,
            Icons.keyboard_double_arrow_up_sharp,
          ),
          onPressed: () => controlBloc.add(
            DriveCommand(isMoving: !controlBloc.state.isMowerMoving!),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: JoystickWithTrackingDot(screenWidth: screenWidth),
        ),
      ],
    );
  }

  Positioned _recordButton(BuildContext context) {
    final controlBloc = context.read<ControlBloc>();
    final isRecording = context.select(
      (ControlBloc b) => b.state.isRecording == true,
    );
    return Positioned(
      top: 40,
      right: 20,
      child: IconButton(
        tooltip: "Record Path",
        isSelected: isRecording,
        onPressed: () async => isRecording
            ? controlBloc.add(
                StopRecord(
                  fileName:
                      await _askPathName(context) ??
                      'path_${DateTime.now().millisecondsSinceEpoch}.txt',
                ),
              )
            : controlBloc.add(StartRecord()),
        icon: isRecording
            ? FadeTransition(
                opacity: _blinkController,
                child: const Icon(Icons.fiber_manual_record, color: Colors.red),
              )
            : const Icon(Icons.fiber_manual_record, color: Colors.grey),
        iconSize: 48.0,
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
      builder: (_) => AlertDialog(
        title: const Text('Path name'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(
              context,
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
  final double screenWidth;

  const JoystickWithTrackingDot({super.key, required this.screenWidth});

  @override
  State<JoystickWithTrackingDot> createState() =>
      _JoystickWithTrackingDotState();
}

class _JoystickWithTrackingDotState extends State<JoystickWithTrackingDot> {
  @override
  Widget build(BuildContext context) {
    final joystickSize = widget.screenWidth / 6;
    final angleTrackingDotRadius = widget.screenWidth / 60;
    return SizedBox(
      width: joystickSize,
      height: joystickSize,
      child: BlocSelector<ControlBloc, ControlState, double>(
        selector: (s) => s.telemetryData?.wheelAngle ?? 0.0,
        builder: (context, angleDeg) {
          print("Redraw angle tracking dot: $angleDeg");
          final r = (joystickSize / 2) + angleTrackingDotRadius;
          final rad = angleDeg * math.pi / 180.0;
          final theta = math.pi / 2 - rad;
          final dx = r * math.cos(theta);
          final dy = -r * math.sin(theta);
          return Stack(
            alignment: Alignment.center,
            children: [
              Joystick(
                mode: JoystickMode.horizontal,
                listener: (details) => context.read<ControlBloc>().add(
                  SteerCommand(angle: details.x * 45),
                ),
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
