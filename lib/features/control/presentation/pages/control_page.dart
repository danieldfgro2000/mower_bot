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
    context.read<ControlBloc>().add(ClearError());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControlBloc, ControlState>(
      builder: (context, state) => Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned.fill(top: 0, left: 0, child: EspMjpegWebView()),
                if (state.isRecording == true)
                  _recordingBanner(context),
                _recordButton(context),
                Positioned.fill(
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
                            _driveUnit(context),
                            Spacer(),
                            _engineUnit(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.errorMessage != null)
                  Positioned.fill(
                    top: 100,
                    left: 0,
                    child: IgnorePointer(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Column _engineUnit(BuildContext context) {
    final isRunning = context.select((ControlBloc b) => b.state.isMowerRunning == true);
    final isMoving = context.select((ControlBloc b) => b.state.isMowerMoving == true);
    return Column(
      children: [
        IconButton(
          iconSize: 50.0,
          splashColor: Colors.blue.shade500,
          icon: Icon(
            Icons.motorcycle_rounded,
            color: isRunning ? Colors.green : Colors.grey,
          ),
          onPressed: () =>
            context.read<ControlBloc>().add(
              RunCommand(isRunning: !isRunning),
            ),
        ),
        IconButton(
          iconSize: 150.0,
          splashColor: Colors.red.shade500,
          icon: Icon(
            Icons.emergency,
            color: isMoving || isRunning ? Colors.red : Colors.grey,
          ),
          onPressed: () => context.read<ControlBloc>().add(EmergencyStop()),
        ),
      ],
    );
  }

  Column _driveUnit(BuildContext context) {
    final isMoving = context.select((ControlBloc b) => b.state.isMowerMoving == true);
    final controlBloc = context.read<ControlBloc>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 72.0,
          icon: Icon(
            color: isMoving ? Colors.green : Colors.grey,
            Icons.keyboard_double_arrow_up_sharp,
          ),
          onPressed: () => controlBloc.add(
            DriveCommand(isMoving: !controlBloc.state.isMowerMoving!),
          ),
        ),
        SizedBox(
          height: 150.0,
          width: 150.0,
          child: Center(
            child: Joystick(
              mode: JoystickMode.horizontal,
              listener: (details) =>
                  controlBloc.add(SteerCommand(angle: details.x * 45)),
            ),
          ),
        ),
      ],
    );
  }

  Positioned _recordButton(BuildContext context) {
    final controlBloc = context.read<ControlBloc>();
    final isRecording = context.select((ControlBloc b) => b.state.isRecording == true);
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
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
