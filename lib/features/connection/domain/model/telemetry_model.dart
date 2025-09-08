import 'package:equatable/equatable.dart';

class TelemetryModel extends Equatable{
  final bool received;
  final int? ageMs;
  final bool ok;

  const TelemetryModel({
    required this.received,
    this.ageMs,
    required this.ok,
  });

  @override
  List<Object?> get props => [received, ageMs, ok];
}