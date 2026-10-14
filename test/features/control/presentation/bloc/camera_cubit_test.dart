import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mower_bot/features/control/domain/usecases/get_video_stream_url_use_case.dart';
import 'package:mower_bot/features/control/presentation/bloc/camera_cubit.dart';

class _MockGetVideoStreamUrlUseCase extends Mock
    implements GetVideoStreamUrlUseCase {}

void main() {
  test('refresh replaces and clears camera availability', () {
    final getVideo = _MockGetVideoStreamUrlUseCase();
    String? endpoint = 'http://camera-a';
    when(() => getVideo()).thenAnswer((_) => endpoint);
    final cubit = CameraCubit(getVideo);
    addTearDown(cubit.close);

    cubit.refresh();
    expect(cubit.state.streamUrl, 'http://camera-a');
    expect(cubit.state.isAvailable, isTrue);

    endpoint = 'http://camera-b';
    cubit.refresh();
    expect(cubit.state.streamUrl, 'http://camera-b');

    endpoint = null;
    cubit.refresh();
    expect(cubit.state.streamUrl, isNull);
    expect(cubit.state.isAvailable, isFalse);
  });
}
