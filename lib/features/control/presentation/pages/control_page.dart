import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';

import 'components/esp_cam_view.dart';

class ControlPage extends StatefulWidget {
  static const String routeName = '/control';

  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage>
    with SingleTickerProviderStateMixin {
  double steering = 0;
  bool isMoving = false;
  bool isRecording = false;
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
  Widget build(BuildContext context) {
    final controlBloc = context.read<ControlBloc>();
    const double controlsHeight = 72 + 16 + 100; // arrow + spacing + joystick/stop

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned.fill(top: 0, left: 0, child: EspMjpegWebView()),
            if (isRecording) _recordingBanner(context),
            _recordButton(controlBloc, context),
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
                      SizedBox(
                        height: controlsHeight,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: _driveUnit(controlBloc),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: controlsHeight,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: _stopButton(controlBloc),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _stopButton(ControlBloc controlBloc) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 100, height: 100),
      iconSize: 100.0,
      splashColor: Colors.red.shade500,
      icon: Icon(
        Icons.stop_circle_rounded,
        color: isMoving ? Colors.red : Colors.grey,
      ),
      onPressed: () {
        setState(() => isMoving = false);
        controlBloc.add(EmergencyStop());
      },
    );
  }

  Column _driveUnit(ControlBloc controlBloc) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 72, height: 72),
          iconSize: 72.0,
          icon: Icon(
            color: isMoving ? Colors.green : Colors.grey,
            Icons.keyboard_double_arrow_up_sharp,
          ),
          onPressed: () {
            setState(() => isMoving = !isMoving);
            controlBloc.add(
              DriveCommand(steering: steering, isMoving: isMoving),
            );
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100.0,
          width: 100.0,
          child: Center(
            child: Joystick(
              mode: JoystickMode.horizontal,
              listener: (details) {
                steering = details.x * 30;
                controlBloc.add(
                  DriveCommand(steering: steering, isMoving: isMoving),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Positioned _recordButton(ControlBloc controlBloc, BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 4, right: 4), // match HomePage menu button top padding
          child: IconButton(
            tooltip: "Record Path",
            isSelected: isRecording,
            onPressed: () async => isRecording
                ? {
                    setState(() => isRecording = false),
                    controlBloc.add(
                      StopRecord(
                        fileName: await _askPathName(context) ??
                            'path_${DateTime.now().millisecondsSinceEpoch}.txt',
                      ),
                    ),
                  }
                : {
                    setState(() => isRecording = true),
                    controlBloc.add(StartRecord()),
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
      builder: (_) => AlertDialog(
        title: const Text('Path name'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
