import 'package:mocktail/mocktail.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/connection/domain/usecases/check_ctrl_ws_connected_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/connect_to_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/disconnect_ctrl_ws_use_case.dart';
import 'package:mower_bot/core/platform/mower_reachability_service.dart';
import 'package:mower_bot/core/platform/wifi_join_service.dart';
import 'package:mower_bot/core/platform/wifi_scan_permission_service.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';

class MockMowerConnectionRepository extends Mock
    implements MowerConnectionRepository {}

class MockConnectToCtrlWsUseCase extends Mock
    implements ConnectToCtrlWsUseCase {}

class MockDisconnectCtrlWsUseCase extends Mock
    implements DisconnectCtrlWsUseCase {}

class MockCheckCtrlWsConnectedUseCase extends Mock
    implements CheckCtrlWsConnectedUseCase {}

class MockTelemetryBloc extends Mock implements TelemetryBloc {}

class MockWifiScanPermissionService extends Mock
    implements WifiScanPermissionService {}

class MockWifiJoinService extends Mock implements WifiJoinService {}

class MockMowerReachabilityService extends Mock
    implements MowerReachabilityService {}

