import 'package:equatable/equatable.dart';
import 'package:mower_bot/features/telemetry/domain/model/telemetry_data_model.dart';
import '../../../../core/diffable_state.dart';

class ControlState extends Equatable implements DiffableState {
  final bool? isConnected;
  final bool? isMowerMoving;
  final bool? isMowerRunning;
  final String? errorMessage;
  final String? commandMessage;
  final TelemetryDataModel? telemetryData;
  final double commandedSteeringAngle;

  const ControlState({
    this.isConnected,
    this.isMowerMoving,
    this.isMowerRunning,
    this.errorMessage,
    this.commandMessage,
    this.telemetryData,
    this.commandedSteeringAngle = 0,
  });

  double? get observedSteeringAngle => telemetryData?.wheelAngle;

  ControlState initial() => const ControlState(
    isConnected: false,
    isMowerMoving: false,
    isMowerRunning: false,
    errorMessage: null,
    commandMessage: null,
    telemetryData: null,
    commandedSteeringAngle: 0,
  );

  @override
  List<Object?> get props => [
    isConnected,
    isMowerMoving,
    isMowerRunning,
    errorMessage,
    commandMessage,
    telemetryData,
    commandedSteeringAngle,
  ];

  ControlState copyWith({
    bool? isConnected,
    bool? isMowerMoving,
    bool? isMowerRunning,
    String? errorMessage,
    String? commandMessage,
    TelemetryDataModel? telemetryData,
    double? commandedSteeringAngle,
    bool clearErrorMessage = false,
    bool clearCommandMessage = false,
    bool clearTelemetryData = false,
  }) => ControlState(
    isConnected: isConnected ?? this.isConnected,
    isMowerMoving: isMowerMoving ?? this.isMowerMoving,
    isMowerRunning: isMowerRunning ?? this.isMowerRunning,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    commandMessage: clearCommandMessage
        ? null
        : commandMessage ?? this.commandMessage,
    telemetryData: clearTelemetryData
        ? null
        : telemetryData ?? this.telemetryData,
    commandedSteeringAngle:
        commandedSteeringAngle ?? this.commandedSteeringAngle,
  );

  @override
  Map<String, dynamic> toDiffMap() => {
    'isConnected': isConnected,
    'isMowerMoving': isMowerMoving,
    'isMowerRunning': isMowerRunning,
    'errorMessage': errorMessage,
    'commandMessage': commandMessage,
    'observedSteeringAngle': observedSteeringAngle,
    'commandedSteeringAngle': commandedSteeringAngle,
    'telemetry.speed': telemetryData?.speed,
  };
}
