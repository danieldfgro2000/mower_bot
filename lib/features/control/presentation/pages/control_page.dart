import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_state.dart' show TelemetryState, TelemetryDriftState, TelemetryDataState;
import 'package:mower_bot/features/telemetry/presentation/widgets/drift_chart.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final List<double> driftHistory = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mower Control'),),
      body: BlocBuilder<TelemetryBloc, TelemetryState>(
          builder: (context, state) {
            if (state is TelemetryDriftState) {
              driftHistory.add(sqrt(state.driftX * state.driftX + state.driftY * state.driftY));
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (state is TelemetryDataState) ... [
                  Text('Battery: ${state.telemetry.battery.toStringAsFixed(2)}%'),
                  Text('Heading: ${state.telemetry.heading.toStringAsFixed(2)}°'),
                  Text('Speed: ${state.telemetry.encoderSpeed.toStringAsFixed(2)} m/s'),
                  Text('Moving: ${state.telemetry.isMoving ? "Yes" : "No"}'),
                ]
                else if (state is TelemetryDriftState) ... [
                  Text('Drift X: ${state.driftX.toStringAsFixed(2)}'),
                  Text('Drift Y: ${state.driftY.toStringAsFixed(2)}'),
                  Text('Heading Error: ${state.headingError.toStringAsFixed(2)}°'),
                  Expanded(child: DriftChart(driftHistory: driftHistory),)
                ],
              ],
            );
          }
      ),
    );
  }
}
