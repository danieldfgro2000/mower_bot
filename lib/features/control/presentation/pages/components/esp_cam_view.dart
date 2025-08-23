import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_state.dart';

class EspMjpegView extends StatefulWidget {

  const EspMjpegView({super.key});

  @override
  State<EspMjpegView> createState() => _EspMjpegViewState();
}

class _EspMjpegViewState extends State<EspMjpegView> {
  late final ControlBloc _controlBloc;

  @override
  void initState() {
    super.initState();
    _controlBloc = context.read<ControlBloc>();
    _controlBloc.add(StartVideoStream());
  }

  @override
  void dispose() {
    _controlBloc.add(StopVideoStream());
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ControlBloc, ControlState>(
      builder: (context, state) {
        return switch (state) {
          ControlStateInitial() => const Center(child: Text('No video stream')),
          ControlStateStatus(:final videoFrames) => RunVideoStream(
            frames: videoFrames,
          ),
          _ => const Center(child: Text('No video stream')),
        };
      },
    );
  }
}

class RunVideoStream extends StatelessWidget {
  final Stream<Uint8List> frames;

  const RunVideoStream({super.key, required this.frames});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Uint8List>(
      stream: frames,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: Text('Waiting for video'));
        }
        return Image.memory(
          snapshot.data!,
          gaplessPlayback: true,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(child: Text('Error loading video frame, error: $error, stackTrace: $stackTrace'));
          },
        );
      },
    );
  }
}
