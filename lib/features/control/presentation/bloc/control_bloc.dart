import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/control/domain/usecases/get_video_stream_url_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/send_drive_command_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';

import 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final SendDriveCommandUseCase sendCommand;
  final GetVideoStreamUrlUseCase getVideoStreamUrl;
  DateTime? _lastSteerCommandTime;

  ControlBloc(this.sendCommand, this.getVideoStreamUrl)
    : super(ControlState().initial()) {
    on<GetVideoStreamUrl>(_onGetVideoStreamUrl);
    on<DriveCommand>(_onDriveCommand);
    on<RunCommand>(_onRunCommand);
    on<SteerCommand>(_onSteerCommand);
    on<StartRecord>(_onStartRecord);
    on<StopRecord>(_onStopRecord);
    on<EmergencyStop>(_onEmergencyStop);
    on<ClearError>(_onClearError);
  }

  FutureOr<void> _onGetVideoStreamUrl(event, emit) =>
      emit(state.copyWith(videoStreamUrl: getVideoStreamUrl()));

  FutureOr<void> _onDriveCommand(event, emit) async {
    final wasSent = await sendCommand({
      "mega": {
        "command": "drive",
        "isMoving": event.isMoving
      }
    });
    wasSent
      ? emit(state.copyWith(isMowerMoving: event.isMoving))
      : emit(state.copyWith(errorMessage: "Failed to send drive command(Disconnected)"));
  }

  FutureOr<void> _onRunCommand(event, emit) async {
    final wasSent = await sendCommand({
      "mega": {
        "command": "start",
        "start": event.isRunning
      }
    });
    wasSent
      ? emit(state.copyWith(isMowerRunning: event.isRunning))
      : emit(state.copyWith(errorMessage: "Failed to send run command(Disconnected)"));
  }

  FutureOr<void> _onSteerCommand(event, emit) async{
    final now = DateTime.now();
    if (now.difference(_lastSteerCommandTime ?? DateTime(0)).inMilliseconds < 100) return null;
    final wasSent = await sendCommand({
      "mega": {
        "command": "steer",
        "angle": event.angle
      }
    });

    wasSent
      ? _lastSteerCommandTime = now
     : emit(state.copyWith(errorMessage: "Failed to send steer command"));
  }

  FutureOr<void> _onStartRecord(event, emit) async {
    final wasSent = await sendCommand({"cmd": "start_record"});
    wasSent
      ? emit(state.copyWith(isRecording: true, recordedFilePath: null))
      : emit(state.copyWith(errorMessage: "Failed to start recording (Disconnected)"));
  }

  FutureOr<void> _onStopRecord(event, emit) async {
    final wasSent = await sendCommand({"cmd": "stop_record", "fileName": event.fileName});
    wasSent
      ? emit(state.copyWith(isRecording: false, recordedFilePath: event.fileName))
      : emit(state.copyWith(errorMessage: "Failed to stop recording(Disconnected)"));
  }

  FutureOr<void> _onEmergencyStop(event, emit) async {
    final wasSent = await sendCommand({
      "mega": {
        "command": "emergency_stop"
      }
    });

    wasSent
      ? emit(state.copyWith(isMowerMoving: false, isMowerRunning: false))
      : emit(state.copyWith(errorMessage: "Failed to send emergency stop command (Disconnected)"));
  }

  FutureOr<void> _onClearError(event, emit) =>
      emit(state.copyWith(errorMessage: ''));
}
