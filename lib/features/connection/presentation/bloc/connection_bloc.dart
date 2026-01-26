import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/error/error.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/connection/domain/usecases/check_ctrl_ws_connected_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/connect_to_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/disconnect_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import 'package:wifi_scan/wifi_scan.dart';

import 'package:mower_bot/core/platform/platform_permissions.dart';

import 'connection_event.dart';
import 'connection_state.dart';

class MowerConnectionBloc
    extends Bloc<MowerConnectionEvent, MowerConnectionState> {
  final ConnectToCtrlWsUseCase connectToCtrlWsUseCase;
  final DisconnectCtrlWsUseCase disconnectCtrlWsUseCase;
  final CheckCtrlWsConnectedUseCase checkCtrlWsConnectedUseCase;
  final TelemetryBloc telemetryBloc;
  final MowerConnectionRepository repo;
  final ExceptionHandler _exceptionHandler = ExceptionHandler();
  final ErrorMapper _errorMapper = ErrorMapper();

  StreamSubscription? _errSub;
  StreamSubscription? _connectionStatusSub;

  // Auto-detect scan control
  StreamSubscription<List<WiFiAccessPoint>>? _wifiScanSub;
  Timer? _wifiScanTimeout;

  // Internal events to safely emit from async sources (Timer/Stream).
  // (handled via WifiScanDetectedAp/WifiScanTimedOut/WifiScanFailed events)

  MowerConnectionBloc(
    this.connectToCtrlWsUseCase,
    this.disconnectCtrlWsUseCase,
    this.checkCtrlWsConnectedUseCase,
    this.telemetryBloc,
    this.repo,
  ) : super(const MowerConnectionState()) {
    on<ChangeIp>(_onChangeIp);
    on<ChangePort>(_onChangePort);
    on<ChangeWiFiMode>(_onChangeWiFiMode);
    on<AutoDetectWifiMode>(_onAutoDetectWifiMode);
    on<RetryAutoDetectWifiMode>((event, emit) => add(const AutoDetectWifiMode()));
    on<ConnectToMower>(_onConnect);
    on<DisconnectFromMower>(_onDisconnect);
    on<CheckConnectionStatus>(_onCheckConnection);
    on<ConnectionChanged>(_onConnectionChanged);
    on<ConnectionError>(_onConnectionError);
    on<WifiScanDetectedAp>(_onWifiScanDetectedAp);
    on<WifiScanTimedOut>(_onWifiScanTimedOut);
    on<WifiScanFailed>(_onWifiScanFailed);

    // Initialize connection status listener on startup
    _initializeConnectionStatus();
  }

  void _initializeConnectionStatus() {
    // Check current connection status
    add(CheckConnectionStatus());

    // Tear down any stale subscription and re-subscribe for fresh updates
    _connectionStatusSub ??= repo.ctrlWsConnected()?.listen(
          (connectionStatus) {
        add(ConnectionChanged(connectionStatus: connectionStatus));
        connectionStatus == ConnectionStatus.ctrlWsConnected
            ? telemetryBloc.add(StartTelemetry())
            : telemetryBloc.add(StopTelemetry());
      },
      onDone: () {
        // Stream closed by repo, reset so a future call will re-subscribe
        _connectionStatusSub = null;
        add(CheckConnectionStatus());
      },
      cancelOnError: false,
    );
  }

  void _onChangeIp(event, emit) {
    emit(state.copyWith(ip: event.ipAddress));
  }

  void _onChangePort(event, emit) {
    emit(state.copyWith(port: event.port));
  }

  void _onChangeWiFiMode(ChangeWiFiMode event, Emitter<MowerConnectionState> emit) {
    // Keep it simple: flip mode + set a sensible default IP if none was set yet
    // (or if current IP matches the other mode's common default).
    const clientDefaultIp = '192.168.100.114';
    const apDefaultIp = '192.168.4.1';

    final nextMode = event.mode;
    final currentIp = (state.ip ?? '').trim();

    String? nextIp = state.ip;
    if (nextMode == ESP32WiFiMode.ap) {
      if (currentIp.isEmpty || currentIp == clientDefaultIp) {
        nextIp = apDefaultIp;
      }
    } else {
      if (currentIp.isEmpty || currentIp == apDefaultIp) {
        nextIp = clientDefaultIp;
      }
    }

    emit(state.copyWith(wifiMode: nextMode, ip: nextIp, error: ''));
  }

  FutureOr<void> _onWifiScanDetectedAp(WifiScanDetectedAp event, Emitter<MowerConnectionState> emit) {
    emit(state.copyWith(
      wifiScanStatus: WifiScanStatus.completed,
      wifiMode: ESP32WiFiMode.ap,
      error: '',
    ));
    add(const ChangeWiFiMode(ESP32WiFiMode.ap));
  }

  FutureOr<void> _onWifiScanTimedOut(WifiScanTimedOut event, Emitter<MowerConnectionState> emit) {
    emit(state.copyWith(
      wifiScanStatus: WifiScanStatus.timeout,
      wifiMode: ESP32WiFiMode.client,
    ));
    add(const ChangeWiFiMode(ESP32WiFiMode.client));
  }

  FutureOr<void> _onWifiScanFailed(WifiScanFailed event, Emitter<MowerConnectionState> emit) {
    emit(state.copyWith(
      wifiScanStatus: WifiScanStatus.failed,
      wifiMode: ESP32WiFiMode.client,
      error: event.message,
    ));
  }

  Future<void> _onAutoDetectWifiMode(
    AutoDetectWifiMode event,
    Emitter<MowerConnectionState> emit,
  ) async {
    // Cancel any previous scan attempt.
    await _wifiScanSub?.cancel();
    _wifiScanSub = null;
    _wifiScanTimeout?.cancel();
    _wifiScanTimeout = null;

    emit(state.copyWith(wifiScanStatus: WifiScanStatus.scanning, error: ''));

    final readinessError = await PlatformPermissions.ensureWifiScanReady();
    if (readinessError != null) {
      emit(state.copyWith(
        wifiScanStatus: WifiScanStatus.failed,
        wifiMode: ESP32WiFiMode.client,
        error: readinessError,
      ));
      return;
    }

    // Start scanning if possible.
    final scanStart = await WiFiScan.instance.startScan();
    if (!scanStart) {
      emit(state.copyWith(
        wifiScanStatus: WifiScanStatus.failed,
        wifiMode: ESP32WiFiMode.client,
        error: 'Failed to start Wi‑Fi scan. Make sure Wi‑Fi and Location are enabled.',
      ));
      return;
    }

    final ssidPrefixLower = event.ssidPrefix.toLowerCase();

    void finishAsAp() {
      _wifiScanTimeout?.cancel();
      _wifiScanTimeout = null;
      _wifiScanSub?.cancel();
      _wifiScanSub = null;
      add(const WifiScanDetectedAp());
    }

    void finishAsClientTimeout() {
      _wifiScanSub?.cancel();
      _wifiScanSub = null;
      add(const WifiScanTimedOut());
    }

    // Poll results during the timeout window.
    _wifiScanSub = Stream.periodic(const Duration(seconds: 2))
        .asyncMap((_) => WiFiScan.instance.getScannedResults())
        .listen((results) {
      final found = results.any((ap) {
        final ssid = (ap.ssid).toLowerCase();
        return ssid.isNotEmpty && ssid.startsWith(ssidPrefixLower);
      });
      if (found) finishAsAp();
    }, onError: (e, st) {
      add(WifiScanFailed('Wi‑Fi scan error: $e'));
    });

    _wifiScanTimeout = Timer(event.timeout, finishAsClientTimeout);
  }

  FutureOr<void> _onConnect(event, emit) async {
    emit(state.copyWith(status: ConnectionStatus.connecting));

    // Recreate the connection status listener to avoid being stuck with a completed/closed sub
    await _connectionStatusSub?.cancel();
    _connectionStatusSub = null;
    _initializeConnectionStatus();

    final result = await _exceptionHandler.safeExecute(() async {
      if (state.ip == null || state.ip!.isEmpty) {
        throw ValidationException.required('IP Address');
      }
      if (state.port == null || state.port! <= 0) {
        throw ValidationException.required('Port');
      }

      await connectToCtrlWsUseCase(state.ip!, state.port!);

      // After initiating the connection, double-check current status
      add(CheckConnectionStatus());

      // Set up error listener
      await _errSub?.cancel();
      _errSub = repo.ctrlWsErr().listen((exception) {
        add(ConnectionError(exception));
      });
    });

    if (result == null) {
      // Error occurred and was handled by safeExecute
      final lastException = _exceptionHandler.exceptions.take(1);
      await for (final exception in lastException) {
        final userMessage = _errorMapper.mapExceptionToMessage(exception);
        emit(
            state.copyWith(status: ConnectionStatus.error, error: userMessage));
        break;
      }
    }
  }

  FutureOr<void> _onDisconnect(event, emit) async {
    await _exceptionHandler.safeExecute(() async {
      await _errSub?.cancel();
      // Keep the connection status subscription alive so future connects update status correctly
      await disconnectCtrlWsUseCase();
    });
    emit(state.copyWith(status: ConnectionStatus.disconnected));
  }

  void _onCheckConnection(event, emit) async {
    _exceptionHandler.safeExecuteSync(() {
      final isConnected = checkCtrlWsConnectedUseCase();
      final status = isConnected
          ? ConnectionStatus.ctrlWsConnected
          : ConnectionStatus.disconnected;
      emit(state.copyWith(status: status));
    });
  }

  FutureOr<void> _onConnectionChanged(event, emit) {
    emit(state.copyWith(status: event.connectionStatus, error: ''));
  }

  FutureOr<void> _onConnectionError(event, emit) {
    final exception = event.exception as AppException;
    final userMessage = _errorMapper.mapExceptionToMessage(exception);
    ConnectionStatus status;
    if (exception is NetworkException && exception.code == 'HOST_UNREACHABLE') {
      status = ConnectionStatus.hostUnreachable;
    } else if (exception is NetworkException && exception.code == 'CONNECTION_FAILED') {
      status = ConnectionStatus.error; // could add a distinct status later
    } else if (exception is NetworkException && exception.code == 'TIMEOUT') {
      status = ConnectionStatus.error;
    } else {
      status = ConnectionStatus.error;
    }
    emit(state.copyWith(status: status, error: userMessage));
  }


  @override
  Future<void> close() async {
    await _wifiScanSub?.cancel();
    _wifiScanTimeout?.cancel();
    await _errSub?.cancel();
    await _connectionStatusSub?.cancel();
    super.close();
  }
}
