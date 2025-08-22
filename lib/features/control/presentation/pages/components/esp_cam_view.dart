import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_bloc.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_event.dart';
import 'package:mower_bot/features/control/presentation/bloc/control_state.dart';

class EspMjpegView extends StatelessWidget {
  const EspMjpegView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ControlBloc>().add(StartVideoStream());
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
        );
      },
    );
  }
}
