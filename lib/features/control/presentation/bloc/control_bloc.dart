import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/control/domain/usecases/observer_video_frames_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/start_video_stream_use_case.dart';
import 'package:mower_bot/features/control/domain/usecases/stop_video_stream_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';

import 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final Function(Map<String, dynamic>) sendCommand;
  final ObserverVideoFramesUseCase _observerVideoFramesUseCase;
  final StartVideoStreamUseCase _startVideoStreamUseCase;
  final StopVideoStreamUseCase _stopVideoStreamUseCase;

  ControlBloc(
    this.sendCommand,
    this._observerVideoFramesUseCase,
    this._startVideoStreamUseCase,
    this._stopVideoStreamUseCase,
  ) : super(ControlStateInitial()) {
    on<StartVideoStream>(_onStartVideoStream);
    on<StopVideoStream>(_onStopVideoStream);
    on<DriveCommand>((event, emit) {
      sendCommand({
        "cmd": "drive",
        "steering": event.steering,
        "isMoving": event.isMoving,
      });
    });
    on<StartRecord>((event, emit) => sendCommand({"cmd": "start_record"}));
    on<StopRecord>(
      (event, emit) =>
          sendCommand({"cmd": "stop_record", "fileName": event.fileName}),
    );
    on<EmergencyStop>((event, emit) => sendCommand({"cmd": "emergency_stop"}));
  }

  Future<void> _onStartVideoStream(event, emit) async {
    await _startVideoStreamUseCase(25);
    final frames  = _observerVideoFramesUseCase()
        .where((bytes) => bytes.length > 2 && bytes[0] == 0xff && bytes[1] == 0xd8);
    emit(ControlStateStatus(videoFrames: frames));
  }

  Future<void> _onStopVideoStream(event, emit) async {
    await _stopVideoStreamUseCase();
    emit(ControlStateInitial());
  }
}
