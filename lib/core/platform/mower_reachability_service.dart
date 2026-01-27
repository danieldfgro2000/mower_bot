import 'dart:async';
import 'dart:io';

/// Simple reachability check used as a "Wi‑Fi handshake" gate.
///
/// We just need to know the mower is reachable over the current network before
/// we attempt the websocket.
class MowerReachabilityService {
  /// Returns true if any of the probes succeeds within [totalTimeout].
  ///
  /// Default behavior:
  /// - Try to open a TCP socket to `{ip}:{port}`.
  /// - If it fails, retry until timeout.
  Future<bool> waitUntilReachable(
    String ip, {
    int port = 85,
    Duration totalTimeout = const Duration(seconds: 15),
    Duration perAttemptTimeout = const Duration(seconds: 2),
    Duration retryDelay = const Duration(milliseconds: 500),
  }) async {
    final deadline = DateTime.now().add(totalTimeout);

    while (DateTime.now().isBefore(deadline)) {
      final ok = await _probeTcp(ip, port, timeout: perAttemptTimeout);
      if (ok) return true;
      await Future<void>.delayed(retryDelay);
    }

    return false;
  }

  Future<bool> _probeTcp(String ip, int port, {required Duration timeout}) async {
    Socket? socket;
    try {
      socket = await Socket.connect(ip, port).timeout(timeout);
      return true;
    } catch (_) {
      return false;
    } finally {
      try {
        socket?.destroy();
      } catch (_) {
        // ignore
      }
    }
  }
}
