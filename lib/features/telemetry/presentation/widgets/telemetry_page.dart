
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_state.dart';


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
    debugPrint('TelemetryPage uses bloc -> '
        '${identityHashCode(context.read<TelemetryBloc>())}');
    return Scaffold(
      appBar: AppBar(title: const Text('MowerBot Telemetry'),),
      body: BlocBuilder<TelemetryBloc, TelemetryState>(
          buildWhen: (previous, current) {
            debugPrint('Building TelemetryPage: $current, type: ${current.runtimeType}');
            return true;
          },
          builder: (context, state) {
            return Stack(
              children: [
                switch (state) {
                  TelemetryInitial() =>
                  const Center(child: Text('No telemetry data')),
                  TelemetryLoading() =>
                  const Center(child: CircularProgressIndicator()),
                  TelemetryLoaded(:final telemetry) =>
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Wheel Angle: ${telemetry.wheelAngle.toStringAsFixed(2)}°'),
                          Text('Distance: ${telemetry.distanceTraveled.toStringAsFixed(2)} m'),
                          Text('Speed: ${telemetry.speed.toStringAsFixed(2)} m/s'),
                          Text('Drive Actuator: ${telemetry.actuatorDrive ? "On" : "Off"}'),
                          Text('Start Actuator: ${telemetry.actuatorStart ? "On" : "Off)"}'),
                        ],
                      ),
                  TelemetryError(:final error) =>
                      Center(
                        child: Text('Error: $error',
                            style: TextStyle(color: Colors.red)),
                      ),
                  MegaTelemetryStatus(:final  ok, :final ageMs, :final received) =>
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              textAlign: TextAlign.right,
                                textScaler: TextScaler.linear(0.8),
                                'ESP<->Mega:      $received'),
                            Text(
                                textAlign: TextAlign.right,
                                textScaler: TextScaler.linear(0.8),
                                'Age:         $ageMs min'),
                            Text(
                                textAlign: TextAlign.right,
                                textScaler: TextScaler.linear(0.8),
                                'Status:      ${ok ? "OK" : "Stale"}',
                                style: TextStyle(
                                    color: ok ? Colors.green : Colors.red)),
                          ],
                        ),
                      ),
                  _ => const Center(child: Text('Unknown state') ),
                },
              ]
            );
          }
      ),
    );
  }
}
