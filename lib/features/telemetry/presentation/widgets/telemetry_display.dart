import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_state.dart';

import 'drift_chart.dart';

class TelemetryPage extends StatefulWidget {

  static const String routeName = '/telemetry';
  const TelemetryPage({super.key});

  @override
  State<TelemetryPage> createState() => _TelemetryPageState();
}

class _TelemetryPageState extends State<TelemetryPage> {
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
                  Text('Heading: ${state.telemetry.angle.toStringAsFixed(2)}°'),
                  Text('Speed: ${state.telemetry.speed.toStringAsFixed(2)} m/s'),
                  Text('Moving: ${state.telemetry.drive ? "Yes" : "No"}'),
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
