import 'package:equatable/equatable.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';

abstract class TelemetryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

abstract class TelemetryLifecycleEvent extends TelemetryEvent {}

class StartTelemetry extends TelemetryLifecycleEvent {}

class StopTelemetry extends TelemetryLifecycleEvent {}

class TelemetryReceived extends TelemetryEvent {
  final TelemetryDataModel telemetry;

  TelemetryReceived(this.telemetry);

  @override
  List<Object?> get props => [telemetry];
}

enum TelemetryStreamSource { telemetry, status }

class TelemetryStreamFailed extends TelemetryEvent {
  final String error;
  final TelemetryStreamSource source;

  TelemetryStreamFailed(
    this.error, {
    this.source = TelemetryStreamSource.telemetry,
  });

  @override
  List<Object?> get props => [error, source];
}

class MegaTelemetryStatusUpdated extends TelemetryEvent {
  final bool received;
  final int? ageMs;
  final bool ok;

  MegaTelemetryStatusUpdated({
    required this.received,
    required this.ageMs,
    required this.ok,
  });

  @override
  List<Object?> get props => [received, ageMs, ok];
}
