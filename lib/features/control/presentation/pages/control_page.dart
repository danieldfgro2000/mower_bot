import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mower Control'),
        centerTitle: true,
        backgroundColor: isRecording ? Colors.orange : null,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isRecording)
                Container(
                  width: double.infinity,
                  color: Colors.orange,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Recording in progress...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
             const SizedBox(height: 20.0),
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
              const SizedBox(height: 20.0),
              SizedBox(
                height: 200.0,
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
              const SizedBox(height: 20.0),
              SwitchListTile(
                title: const Text('Move forward'),
                subtitle: const Text('Engage mower drive'),
                value: isMoving,
                onChanged: (value) {
                  setState(() => isMoving = value);
                  controlBloc.add(
                    DriveCommand(steering: steering, isMoving: isMoving),
                  );
                },
              ),

              const SizedBox(height: 20.0),
              SwitchListTile(
                title: Row(
                  children: [
                    const Text('Path recording'),
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
                subtitle: const Text('Start/stop recording mower path'),
                value: isRecording,
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
            ],
          ),
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
