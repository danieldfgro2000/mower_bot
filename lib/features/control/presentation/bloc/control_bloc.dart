import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/control/domain/usecases/observer_video_frames_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';

import 'control_state.dart';

class ControlBloc extends Bloc<ControlEvent, ControlState> {
  final Function(Map<String, dynamic>) sendCommand;
  final ObserverVideoFramesUseCase _observerVideoFramesUseCase;
  StreamSubscription<Uint8List>? _videoStreamSubscription;

  ControlBloc(this.sendCommand, this._observerVideoFramesUseCase)
    : super(ControlStateInitial()) {
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
    _videoStreamSubscription = _observerVideoFramesUseCase().listen(
      (frame) => add(VideoFrameReceived(frame)),
      onError: (e) => VideoStreamError(e),
    );
  }

  void _onStopVideoStream(event, emit) {
    _videoStreamSubscription?.cancel();
    _videoStreamSubscription = null;
  }
}
