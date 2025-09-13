import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/control/domain/usecases/get_video_stream_url_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/send_drive_command_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';

import 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final SendDriveCommandUseCase sendCommand;
  final GetVideoStreamUrlUseCase getVideoStreamUrl;
  DateTime? _lastDriveCommandTime;

  ControlBloc(this.sendCommand, this.getVideoStreamUrl)
    : super(ControlState().initial()) {
    on<GetVideoStreamUrl>(_onGetVideoStreamUrl);
    on<DriveCommand>(_onDriveCommand);
    on<SteerCommand>(_onSteerCommand);
    on<StartRecord>(_onStartRecord);
    on<StopRecord>(_onStopRecord);
    on<EmergencyStop>(_onEmergencyStop);
  }

  FutureOr<void> _onGetVideoStreamUrl(event, emit) =>
      emit(state.copyWith(videoStreamUrl: getVideoStreamUrl()));

  FutureOr<void> _onDriveCommand(event, emit) {
    sendCommand({
      "mega": {
        "command": "drive",
        "isMoving": event.isMoving
      }
    });
  }

  FutureOr<void> _onSteerCommand(event, emit) {
    final now = DateTime.now();
    if (now.difference(_lastDriveCommandTime ?? DateTime(0)).inMilliseconds < 100) return null;
    sendCommand({
      "mega": {
        "command": "steer",
        "angle": event.angle
      }
    });
  }

  FutureOr<void> _onStartRecord(event, emit) =>
      sendCommand({"cmd": "start_record"});

  FutureOr<void> _onStopRecord(event, emit) =>
      sendCommand({"cmd": "stop_record", "fileName": event.fileName});

  FutureOr<void> _onEmergencyStop(event, emit) =>
      sendCommand({"cmd": "emergency_stop"});
}
