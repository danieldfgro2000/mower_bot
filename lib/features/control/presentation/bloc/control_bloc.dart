import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
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
  final MowerConnectionRepository repo;
  StreamSubscription? _videoWsConnectedSub;
  static const String _kMjpegUrl = 'http://10.127.98.175';

  ControlBloc(
    this.sendCommand,
    this._observerVideoFramesUseCase,
    this._startVideoStreamUseCase,
    this._stopVideoStreamUseCase,
    this.repo,
  ) : super(ControlState().initial()) {
    on<CheckConnectionStatus>(_onCheckConnectionStatus);
    on<ConnectionChanged>(_onConnectionChanged);
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

  void _onCheckConnectionStatus(event, emit) {
    _videoWsConnectedSub = repo.videoWsConnected().listen((isConnected) {
      add(ConnectionChanged(isVideoWsConnected: isConnected));
    });
  }

  void _onConnectionChanged(event, emit) {
    emit(state.copyWith(isVideoWsConnected: event.isVideoWsConnected));
    if(event.isVideoWsConnected == true) {
      add(StartVideoStream());
    } else if(event.isVideoWsConnected == false) {
      add(StopVideoStream());
    }
  }

  Future<void> _onStartVideoStream(event, emit) async {
    // await _startVideoStreamUseCase(25);
    // final frames  = _observerVideoFramesUseCase()
    //     .where((bytes) => bytes.length > 2 && bytes[0] == 0xff && bytes[1] == 0xd8);
    // frames.listen((bytes) {
    // });
    // emit(state.copyWith(videoFrames: frames));

    emit(state.copyWith(
      isVideoEnabled: true,
      mjpegUrl: _kMjpegUrl,
    ));
  }

  Future<void> _onStopVideoStream(event, emit) async {
    // await _stopVideoStreamUseCase();
    // emit(ControlState().initial());

    emit(state.copyWith(
      isVideoEnabled: false,
      mjpegUrl: null,
    ));
  }
}
