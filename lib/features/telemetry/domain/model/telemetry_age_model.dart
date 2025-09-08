import 'package:equatable/equatable.dart';

class TelemetryDataModel extends Equatable{
  final bool received;
  final int ageMs;
  final bool ok;

  const TelemetryDataModel({
    required this.received,
    required this.ageMs,
    required this.ok,
  });

  @override
  List<Object?> get props => [
    received,
    ageMs,
    ok,
  ];
}