import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';

class ControlBloc extends  Bloc<ControlEvent, void> {
  final Function(Map<String, dynamic>) sendCommand;

  ControlBloc(this.sendCommand) : super(null) {
    on<DriveCommand>((event, emit) {
      sendCommand({
        "cmd": "drive",
        "steering": event.steering,
        "isMoving": event.isMoving,
      });
    });
    on<StartRecord>((event, emit) =>
      sendCommand({"cmd": "start_record"}));
    on<StopRecord>((event, emit) =>
      sendCommand({
        "cmd": "stop_record",
        "fileName": event.fileName,
      }));
    on<EmergencyStop>((event, emit) =>
      sendCommand({"cmd": "emergency_stop"}));
  }
}