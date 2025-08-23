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
  StreamSubscription<Uint8List>? _videoStreamSubscription;

  ControlBloc(
    this.sendCommand,
    this._observerVideoFramesUseCase,
    this._startVideoStreamUseCase,
    this._stopVideoStreamUseCase,
  ) : super(ControlStateInitial()) {
    on<StartVideoStream>(_onStartVideoStream);
    on<VideoFrameReceived>(_onVideoFrameReceived);
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
    await _startVideoStreamUseCase(50);
    _videoStreamSubscription = _observerVideoFramesUseCase().listen((frame) {
      final bytes = Uint8List.fromList(frame);
      final ok = bytes.length > 3 && bytes[0] == 0xFF && bytes[1] == 0xD8;
      if (ok) add(VideoFrameReceived(frame));
    }, onError: (e) => VideoStreamError(e));
  }

  void _onVideoFrameReceived(VideoFrameReceived event, emit) {
    emit(ControlStateStatus(videoFrames: _observerVideoFramesUseCase()));
  }

  Future<void> _onStopVideoStream(event, emit) async {
    await _stopVideoStreamUseCase();
    _videoStreamSubscription?.cancel();
    _videoStreamSubscription = null;
  }
}
