import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/control/domain/usecases/get_video_stream_url_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  final GetVideoStreamUrlUseCase getVideoStreamUrl;

  CameraCubit(this.getVideoStreamUrl) : super(const CameraState());

  void refresh() {
    emit(CameraState(streamUrl: getVideoStreamUrl()));
  }
}
