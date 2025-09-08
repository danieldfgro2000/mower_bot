import 'package:equatable/equatable.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';

abstract class TelemetryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartTelemetry extends TelemetryEvent {}

class StopTelemetry extends TelemetryEvent {}

class TelemetryReceived extends TelemetryEvent {
  final TelemetryDataModel telemetry;

  TelemetryReceived(this.telemetry);

  @override
  List<Object?> get props => [telemetry];
}

class MegaTelemetryStatusUpdated extends TelemetryEvent {
  final bool received;
  final int ageMs;
  final bool ok;

  MegaTelemetryStatusUpdated({
    required this.received,
    required this.ageMs,
    required this.ok,
  });

  @override
  List<Object?> get props => [received, ageMs, ok];
}
