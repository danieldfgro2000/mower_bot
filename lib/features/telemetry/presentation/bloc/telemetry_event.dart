import 'package:equatable/equatable.dart';

abstract class TelemetryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartTelemetryStream extends TelemetryEvent {}

class TelemetryReceived extends TelemetryEvent {
  final Map<String, dynamic> data;

  TelemetryReceived(this.data);

  @override
  List<Object?> get props => [data];
}

class TelemetryError extends TelemetryEvent {
  final String error;

  TelemetryError(this.error);

  @override
  List<Object?> get props => [error];
}