import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mower_bot/core/error/error.dart';
import 'package:mower_bot/features/connection/domain/repositories/connection_repository.dart';
import 'package:mower_bot/features/connection/domain/usecases/check_ctrl_ws_connected_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/connect_to_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/connection/domain/usecases/disconnect_ctrl_ws_use_case.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_bloc.dart';
import 'package:mower_bot/features/telemetry/presentation/bloc/telemetry_event.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:mower_bot/core/platform/mower_reachability_service.dart';
import 'package:mower_bot/core/platform/wifi_join_service.dart';
import 'package:mower_bot/core/platform/wifi_scan_permission_service.dart';

import 'connection_event.dart';
import 'connection_state.dart';

class MowerConnectionBloc
    extends Bloc<MowerConnectionEvent, MowerConnectionState> {
  final ConnectToCtrlWsUseCase connectToCtrlWsUseCase;
  final DisconnectCtrlWsUseCase disconnectCtrlWsUseCase;
  final CheckCtrlWsConnectedUseCase checkCtrlWsConnectedUseCase;
  final TelemetryBloc telemetryBloc;
  final MowerConnectionRepository repo;
  final WifiScanPermissionService wifiScanPermissionService;
  final WifiJoinService wifiJoinService;
  final MowerReachabilityService reachabilityService;
  final ExceptionHandler _exceptionHandler = ExceptionHandler();
  final ErrorMapper _errorMapper = ErrorMapper();

  StreamSubscription? _errSub;
  StreamSubscription? _connectionStatusSub;

  // Auto-detect scan control
  StreamSubscription<List<WiFiAccessPoint>>? _wifiScanSub;
  Timer? _wifiScanTimeout;

  /// Monotonic id to guard against stale scan callbacks firing after a new scan starts.
  int _wifiScanGeneration = 0;

  // Internal events to safely emit from async sources (Timer/Stream).
  // (handled via WifiScanDetectedAp/WifiScanTimedOut/WifiScanFailed events)

  // Guards against overlapping auto-connect sequences (scan->join->reachability->ws)
  bool _autoConnectInFlight = false;

  MowerConnectionBloc(
    this.connectToCtrlWsUseCase,
    this.disconnectCtrlWsUseCase,
    this.checkCtrlWsConnectedUseCase,
    this.telemetryBloc,
    this.repo,
    this.wifiScanPermissionService,
    this.wifiJoinService,
    this.reachabilityService,
  ) : super(const MowerConnectionState()) {
    on<ChangeIp>(_onChangeIp);
    on<ChangePort>(_onChangePort);
    on<ChangeWiFiMode>(_onChangeWiFiMode);
    on<ChangeApSsid>(_onChangeApSsid);
    on<ChangeApPassword>(_onChangeApPassword);
    on<AutoDetectWifiMode>(_onAutoDetectWifiMode);
    on<WifiScanPermissionInfoAccepted>(_onWifiScanPermissionInfoAccepted);
    on<WifiScanPermissionInfoDeclined>(_onWifiScanPermissionInfoDeclined);
    on<ConnectToMower>(_onConnect);
    on<DisconnectFromMower>(_onDisconnect);
    on<CheckConnectionStatus>(_onCheckConnection);
    on<ConnectionChanged>(_onConnectionChanged);
    on<ConnectionError>(_onConnectionError);
    on<WifiScanDetectedAp>(_onWifiScanDetectedAp);
    on<WifiScanFoundSsid>(_onWifiScanFoundSsid);
    on<WifiScanTimedOut>(_onWifiScanTimedOut);
    on<WifiScanFailed>(_onWifiScanFailed);
    on<AutoConnectToMower>(_onAutoConnect);
    on<AutoJoinWifiResult>(_onAutoJoinWifiResult);
    on<ReachabilityResult>(_onReachabilityResult);

    // Initialize connection status listener on startup
    _initializeConnectionStatus();
  }

  void _initializeConnectionStatus() {
    add(CheckConnectionStatus());

    // Tear down any stale subscription and re-subscribe for fresh updates
    _connectionStatusSub ??= repo.ctrlWsConnected()?.listen(
      (connectionStatus) {
        if (isClosed) return;
        add(ConnectionChanged(connectionStatus: connectionStatus));
        connectionStatus == ConnectionStatus.ctrlWsConnected
            ? telemetryBloc.add(StartTelemetry())
            : telemetryBloc.add(StopTelemetry());
      },
      onDone: () {
        if (isClosed) return;
        // Stream closed by repo, reset so a future call will re-subscribe
        _connectionStatusSub = null;
        add(CheckConnectionStatus());
      },
      cancelOnError: false,
    );
  }

  void _onChangeIp(event, emit) => emit(state.copyWith(ip: event.ipAddress));

  void _onChangePort(event, emit) => emit(state.copyWith(port: event.port));

  void _onChangeApSsid(ChangeApSsid event, emit) => emit(state.copyWith(apSsid: event.ssid));

  void _onChangeApPassword(ChangeApPassword event, emit) => emit(state.copyWith(apPassword: event.password));

  void _onChangeWiFiMode(ChangeWiFiMode event, emit) =>
    emit(state.copyWith(wifiMode: event.mode, wifiScanStatus: WifiScanStatus.completed));

  FutureOr<void> _onWifiScanDetectedAp(WifiScanDetectedAp event, emit) {
    // IMPORTANT: Don't dispatch ChangeWiFiMode here because other parts of the app
    // may treat that as a signal to initiate WS connection immediately.
    // We only want to do: scan -> (auto) join Wi‑Fi -> wait handshake -> WS.
    emit(state.copyWith(
      wifiScanStatus: WifiScanStatus.completed,
      wifiMode: ESP32WiFiMode.ap,
      error: '',
      // Ensure defaults are present for the auto-join step.
      ip: '192.168.4.1',
      port: 85,
      // Persist SSID if the scan provided it.
      detectedApSsid: (event.ssid ?? state.detectedApSsid),
    ));

    // Kick off join + handshake + ws.
    add(const AutoConnectToMower());
  }

  void _onWifiScanFoundSsid(WifiScanFoundSsid event, emit,) =>
      emit(state.copyWith(detectedApSsid: event.ssid));

  bool _isAutoConnectBlocked() => _autoConnectInFlight ||
      state.connectionStatus == ConnectionStatus.connecting ||
      state.connectionStatus == ConnectionStatus.ctrlWsConnected;

  Future<void> _onAutoConnect(
    AutoConnectToMower event,
    Emitter<MowerConnectionState> emit,
  ) async {
    if (_isAutoConnectBlocked()) return;

    _autoConnectInFlight = true;
    try {
      if (state.wifiMode != ESP32WiFiMode.ap) {
        add(ConnectToMower());
        return;
      }

      emit(state.copyWith(status: ConnectionStatus.connecting));

      final joined = await _hasJoinedToApWifi(emit);
      if (emit.isDone) return;
      if (joined) {
        add(ConnectToMower());
        return;
      }

      final reachable = await _isApReachable(emit);
      if (emit.isDone) return;
      if (!reachable) {
        _emitHostUnreachable(emit);
        return;
      }

      add(ConnectToMower());
    } catch (e) {
      if (emit.isDone) return;
      final userMessage = _errorMapper
          .mapExceptionToMessage(WebSocketException(message: e.toString()));
      emit(state.copyWith(status: ConnectionStatus.error, error: userMessage));
    } finally { _autoConnectInFlight = false; }
  }

  Future<bool> _hasJoinedToApWifi(Emitter<MowerConnectionState> emit) async =>
    Platform.isAndroid
      ? await wifiJoinService.connectToSsid(state.apSsid, password: state.apPassword)
      : false;

  Future<bool> _isApReachable(Emitter<MowerConnectionState> emit) async =>
    await reachabilityService.waitUntilReachable(state.apSsid);

  void _emitHostUnreachable(Emitter<MowerConnectionState> emit) =>
    emit(state.copyWith(
      status: ConnectionStatus.hostUnreachable,
      error: 'Mower not reachable yet. Make sure you are connected to the mower Wi-Fi and try again.',
    ));

  Future<void> _onAutoJoinWifiResult(
    AutoJoinWifiResult event,
    Emitter<MowerConnectionState> emit,
  ) async {
    // If auto-join failed, do not continue to probe/ws.
    if (!event.connected) {
      final ssid = event.ssid;
      emit(state.copyWith(
        status: ConnectionStatus.hostUnreachable,
        error: ssid == null || ssid.trim().isEmpty
            ? 'Not connected to the mower Wi‑Fi yet. Please join it and try again.'
            : 'Not connected to $ssid yet. Please join the mower Wi‑Fi and try again.',
      ));
      return;
    }

    // // Step 2) Probe reachability before attempting websocket.
    final ip = (state.ip ?? '192.168.4.1').trim();
    // final port = state.port ?? 85;

    final reachable = await reachabilityService.waitUntilReachable(ip);
    if (emit.isDone) return;

    if (!reachable) {
      emit(state.copyWith(
        status: ConnectionStatus.hostUnreachable,
        error: 'Mower not reachable yet. Make sure you are connected to the mower Wi‑Fi and try again.'
      ));
      return;
    }
    add(ConnectToMower());
  }

  Future<void> _onReachabilityResult(
    ReachabilityResult event,
    Emitter<MowerConnectionState> emit,
  ) async {
    if (!event.reachable) {
      emit(state.copyWith(
        status: ConnectionStatus.hostUnreachable,
        error: 'Mower not reachable yet. Make sure you are connected to the mower Wi‑Fi and try again.',
      ));
      return;
    }

    // Network handshake OK -> do the actual websocket connect using existing logic.
    add(ConnectToMower());
  }

  FutureOr<void> _onWifiScanTimedOut(WifiScanTimedOut event, Emitter<MowerConnectionState> emit) {
    emit(state.copyWith(
      error: "No mower Wi‑Fi network found. Make sure the mower is powered on and in range, then try again.",
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

  Future<void> _onWifiScanPermissionInfoAccepted(
    WifiScanPermissionInfoAccepted event,
    Emitter<MowerConnectionState> emit,
  ) async {
    final status = await wifiScanPermissionService.requestPermission();
    if (status != PermissionStatus.granted) {
      final permanentlyDenied = await wifiScanPermissionService.isPermanentlyDenied();
      emit(state.copyWith(
        wifiScanStatus: WifiScanStatus.failed,
        wifiMode: ESP32WiFiMode.client,
        error: permanentlyDenied
            ? 'Location permission permanently denied. Enable it in Settings to scan for the mower network.'
            : 'Location permission denied. Cannot scan for the mower network.',
      ));
      return;
    }
    add( const AutoDetectWifiMode());
  }

  void _onWifiScanPermissionInfoDeclined(
    WifiScanPermissionInfoDeclined event,
    Emitter<MowerConnectionState> emit,
  ) {
    emit(state.copyWith(
      wifiScanStatus: WifiScanStatus.failed,
      wifiMode: ESP32WiFiMode.client,
      error: 'Wi‑Fi scan requires Location permission. You can continue without scan or enable it later.',
    ));
  }

  Future<void> _cleanupScan() async {
    _wifiScanTimeout?.cancel();
    _wifiScanTimeout = null;
    await _wifiScanSub?.cancel();
    _wifiScanSub = null;
  }

  Future<void> _onAutoDetectWifiMode(
    AutoDetectWifiMode event,
    Emitter<MowerConnectionState> emit,
  ) async {
    _cleanupScan();

    final scanGen = ++_wifiScanGeneration;

    emit(state.copyWith(wifiScanStatus: WifiScanStatus.scanning, error: ''));

    final readinessError = await wifiScanPermissionService.checkReady();

    if (readinessError == 'Location permission required.') {
      emit(state.copyWith(
        wifiScanStatus: WifiScanStatus.needsPermission,
        wifiMode: ESP32WiFiMode.client,
        error: '',
      ));
      return;
    }

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

    void finishAsAp(String ssid) {
      if (isClosed) return;
      if (scanGen != _wifiScanGeneration) return; // stale
      _cleanupScan();
      add(WifiScanDetectedAp(ssid: ssid));
    }

    void finishAsClientTimeout() {
      if (isClosed) return;
      if (scanGen != _wifiScanGeneration) return; // stale
      _cleanupScan();
      add(const WifiScanTimedOut());
    }

    // Poll results during the timeout window.
    _wifiScanSub = Stream<void>.multi((controller) async {
      // Immediate first attempt
      controller.add(null);
      var delay = const Duration(milliseconds: 500);
      while (!controller.isClosed) {
        await Future<void>.delayed(delay);
        if (controller.isClosed) break;
        controller.add(null);
        final nextMs = (delay.inMilliseconds * 2).clamp(500, 2000);
        delay = Duration(milliseconds: nextMs);
      }
    })
        .asyncMap((_) => WiFiScan.instance.getScannedResults())
        .listen((results) {
      if (isClosed) return;
      if (scanGen != _wifiScanGeneration) return; // stale

      final match = results.cast<WiFiAccessPoint?>().firstWhere(
            (ap) {
              final ssid = ((ap?.ssid) ?? '').toLowerCase();
              return ssid.isNotEmpty && ssid.startsWith(ssidPrefixLower);
            },
            orElse: () => null,
          );

      if (match != null) {
        // Keep UI updated with the SSID, but also pass it to the AP-finish event.
        add(WifiScanFoundSsid(match.ssid));
        finishAsAp(match.ssid);
      }
    }, onError: (e, st) {
      if (isClosed) return;
      if (scanGen != _wifiScanGeneration) return;
      _cleanupScan();
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
      print('CheckConnectionStatus: isConnected=$isConnected, status=$status');
      emit(state.copyWith(status: status));
    });
  }

  FutureOr<void> _onConnectionChanged(event, emit) {
    print('Connection status changed: ${event.connectionStatus}');
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
