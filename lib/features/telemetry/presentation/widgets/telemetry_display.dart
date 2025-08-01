
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
      appBar: AppBar(title: const Text('MowerBot Telemetry'),),
      body: BlocBuilder<TelemetryBloc, TelemetryState>(
          builder: (context, state) {
            if (state is TelemetryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TelemetryLoaded) {
              final t = state.telemetry;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Wheel Angle: ${t.wheelAngle.toStringAsFixed(2)}°'),
                  Text('Distance: ${t.distanceTraveled.toStringAsFixed(2)} m'),
                  Text('Speed: ${t.speed.toStringAsFixed(2)} m/s'),
                  Text('Drive Actuator: ${t.actuatorDrive ? "On" : "Off"}'),
                  Text('Start Actuator: ${t.actuatorStart ? "On" : "Off)"}'),
                ],
              );
            } else if (state is TelemetryError) {
              return Center(
                child: Text('Error: ${state.error}',
                    style: TextStyle(color: Colors.red)),
              );
            }
            return Center(
              child: Text('No telemetry data available',
                  style: TextStyle(color: Colors.grey)),
            );
          }
            // return Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     if (state is TelemetryDataState) ... [
            //       Text('Battery: ${state.telemetry.battery.toStringAsFixed(2)}%'),
            //       Text('Heading: ${state.telemetry.angle.toStringAsFixed(2)}°'),
            //       Text('Speed: ${state.telemetry.speed.toStringAsFixed(2)} m/s'),
            //       Text('Moving: ${state.telemetry.drive ? "Yes" : "No"}'),
            //     ]
            //     else if (state is TelemetryDriftState) ... [
            //       Text('Drift X: ${state.driftX.toStringAsFixed(2)}'),
            //       Text('Drift Y: ${state.driftY.toStringAsFixed(2)}'),
            //       Text('Heading Error: ${state.headingError.toStringAsFixed(2)}°'),
            //       Expanded(child: DriftChart(driftHistory: driftHistory),)
            //     ],
            //   ],
            // );

      ),
    );
  }
}
