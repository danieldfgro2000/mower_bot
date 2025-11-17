import 'package:equatable/equatable.dart';

class TelemetryAgeModel extends Equatable{
  final bool received;
  final int? ageMs;
  final bool ok;

  const TelemetryAgeModel({
    required this.received,
    this.ageMs,
    required this.ok,
  });

  @override
  List<Object?> get props => [received, ageMs, ok];
}