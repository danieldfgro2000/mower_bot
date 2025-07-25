import 'package:equatable/equatable.dart';

abstract class TelemetryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class TelemetryReceived extends TelemetryEvent {
  final Map<String, dynamic> data;

  TelemetryReceived(this.data);

  @override
  List<Object?> get props => [data];
}