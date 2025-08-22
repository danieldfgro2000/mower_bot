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

    return OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;

        return Scaffold(
          appBar: isPortrait
              ? AppBar(
                  title: const Text('Mower Control'),
                  centerTitle: true,
                  backgroundColor: isRecording ? Colors.orange : null,
                )
              : null,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  EspMjpegView(),
                  Positioned.fill(
                    top: 0,
                    left: 0,
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all( 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isRecording)
                              Container(
                                width: double.infinity,
                                color: Colors.orange,
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  textScaler: TextScaler.linear(0.8),
                                  'Recording in progress...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 100.0,
                                  width: 100.0,
                                  child: Center(
                                    child: Joystick(
                                      mode: JoystickMode.horizontal,
                                      listener: (details) {
                                        steering = details.x * 30;
                                        controlBloc.add(
                                          DriveCommand(
                                            steering: steering,
                                            isMoving: isMoving,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                IntrinsicWidth(
                                  child: SwitchListTile(
                                    activeColor: Colors.green,
                                    title: const Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textScaler: TextScaler.linear(0.8),
                                        'Move forward'),
                                    subtitle: const Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textScaler: TextScaler.linear(0.6),
                                        'Engage mower drive'),
                                    value: isMoving,
                                    dense: true,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onChanged: (value) {
                                      setState(() => isMoving = value);
                                      controlBloc.add(
                                        DriveCommand(
                                          steering: steering,
                                          isMoving: isMoving,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                IntrinsicWidth(
                                  child: SwitchListTile(
                                    activeColor: Colors.red,
                                    title: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textScaler: TextScaler.linear(0.8),
                                            'Record Path'),
                                        const SizedBox(width: 10.0),
                                        if (isRecording)
                                          FadeTransition(
                                            opacity: _blinkController,
                                            child: const Icon(
                                              Icons.fiber_manual_record,
                                              color: Colors.red,
                                            ),
                                          ),
                                      ],
                                    ),
                                    subtitle: const Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textScaler: TextScaler.linear(0.6),
                                      'Start/stop',
                                    ),
                                    value: isRecording,
                                    dense: true,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onChanged: (value) async {
                                      setState(() => isRecording = value);
                                      value
                                          ? controlBloc.add(StartRecord())
                                          : controlBloc.add(
                                        StopRecord(
                                          fileName:
                                          await _askPathName(context) ??
                                              'path_${DateTime.now().millisecondsSinceEpoch}.txt',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.dangerous, size: 36.0),
                                  onPressed: () => controlBloc.add(EmergencyStop()),
                                  label: const Text('STOP'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24.0,
                                      horizontal: 24.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        );
      },
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
